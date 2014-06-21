
from DebugObject import DebugObject
from panda3d.core import PTAMat4, TextNode

from direct.gui.OnscreenText import OnscreenText
from FastText import FastText


class LightManager(DebugObject):

    def __init__(self):
        DebugObject.__init__(self, "LightManager")
        self.maxVisibleLights = 256
        self.lights = []
        self.numVisibleLights = 0
        self.cullBounds = None

        self.dataVector = PTAMat4.empty_array(self.maxVisibleLights)
        self.smatVector = PTAMat4.empty_array(self.maxVisibleLights)

        # # Debug text to show how many lights are currently visible
        self.lightsVisibleDebugText = FastText()
        self.lightsVisibleDebugText.setPos(base.getAspectRatio() - 0.1, 0.9)
        self.lightsVisibleDebugText.setRightAligned(True)
        self.lightsVisibleDebugText.setColor(1,1,1)
        self.lightsVisibleDebugText.setSize(0.04)


    def addLight(self, light):
        # if len(self.lights) >= self.maxLights:
        #     self.error("Too many lights! You cannot attach any more")
        #     return False
        self.lights.append(light)

    def setCullBounds(self, bounds):
        self.cullBounds = bounds

    def update(self):

        self.numVisibleLights = 0

        for light in self.lights:

            if self.numVisibleLights >= self.maxVisibleLights:
                # too many lights
                self.error(
                    "Too many lights! Can't display more than", self.maxVisibleLights)
                break


            # check if visible
            if not self.cullBounds.contains(light.getBounds()):
                continue

            if light.needsUpdate():
                # self.debug("Updating light",light)
                light.performUpdate()

            if light.needsShadowUpdate():
                # self.debug("Updating shadow for light",light)
                light.performShadowUpdate()

            # todo: visibility check
            lightData = light.getData()
            self.dataVector[self.numVisibleLights] = lightData.getDataMat()
            self.smatVector[self.numVisibleLights] = lightData.getProjMat()

            self.numVisibleLights += 1

        self.lightsVisibleDebugText.setText('Visible Lights: ' + str(self.numVisibleLights))