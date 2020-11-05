//
//  Haptics.swift
//  Choons
//
//  Created by Ahmed Khalaf on 17/10/20.
//

import CoreHaptics

@available(iOS 13.0, *)
@available(OSX 10.15, *)
public class Haptics {
  
  private var hapticEngine: CHHapticEngine?

  private init() {
    prepareHaptics()
  }

  //MARK: - Public
  
  public static let shared = Haptics()

  public func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    
    do {
      self.hapticEngine = try CHHapticEngine()
      try hapticEngine?.start()
    } catch {
      print("There was an error creating the engine: \(error.localizedDescription)")
    }
  }
  
  public func complexSuccess() {
    
    // make sure that the device supports haptics
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()
    
    // create one intense, sharp tap
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)
    
    // convert those events into a pattern and play it immediately
    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try hapticEngine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      print("Failed to play pattern: \(error.localizedDescription).")
    }
  }
}
