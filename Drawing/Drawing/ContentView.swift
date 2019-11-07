//
//  ContentView.swift
//  Drawing
//
//  Created by Angel Vázquez on 04/11/19.
//  Copyright © 2019 Ángel Vázquez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TriangleView()) {
                    Image(systemName: "1.circle")
                    Text("Triangle")
                }
                
                NavigationLink(destination: ArcView()) {
                    Image(systemName: "2.circle")
                    Text("Arc")
                }
                
                NavigationLink(destination: PetalView()) {
                    Image(systemName: "3.circle")
                    Text("Flower")
                }
                
                NavigationLink(destination: ImagePaintView()) {
                    Image(systemName: "4.circle")
                    Text("ImagePaint border")
                }
                
                NavigationLink(destination: ColorCyclingView()) {
                    Image(systemName: "5.circle")
                    Text("Color cycling circle with Metal")
                }
                
                Group {
                    NavigationLink(destination: MultiplyBlendModeView()) {
                        Image(systemName: "6.circle")
                        Text("Multiply blend mode")
                    }
                    
                    NavigationLink(destination: ScreenBlendModeView()) {
                        Image(systemName: "7.circle")
                        Text("Screen blend mode")
                    }
                    
                    NavigationLink(destination: SaturationBlurBlendModeView()) {
                        Image(systemName: "8.circle")
                        Text("Saturation and blur")
                    }
                    
                    NavigationLink(destination: TrapezoidView()) {
                        Image(systemName: "9.circle")
                        Text("Animating shapes")
                    }
                }
            }
            .navigationBarTitle("Drawing")
        }
    }
}

struct TrapezoidView: View {
    
    @State private var insetAmount: CGFloat = 50
    
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    self.insetAmount = CGFloat.random(in: 10...90)
                }
            }
    }
}

struct Trapezoid: Shape {
    
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct SaturationBlurBlendModeView: View {
    
    @State private var amount: CGFloat = 0.0

    
    var body: some View {
        VStack {
            Image("chicken")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .saturation(Double(amount))
                .blur(radius: (1 - amount) * 20)
            
            Slider(value: $amount)
                           .padding()
        }
        .navigationBarTitle("Saturation and blur", displayMode: .inline)
    }
}

struct ScreenBlendModeView: View {
    
    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(Color.blue)
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Screen blend mode", displayMode: .inline)
    }
}


struct MultiplyBlendModeView: View {
    var body: some View {
        Image("chicken")
            .colorMultiply(.red)
            .navigationBarTitle("Multiply blend mode", displayMode: .inline)
    }
}

struct ColorCyclingView: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycle)
        }
        .navigationBarTitle("Color Cycling Circle", displayMode: .inline)
    }
}

struct ImagePaintView: View {
    var body: some View {
        Capsule()
            .strokeBorder(ImagePaint(image: Image("images"), scale: 0.1), lineWidth: 20)
            .frame(width: 300, height: 200)
            .navigationBarTitle("ImagePaint border", displayMode: .inline)
    }
}

struct TriangleView: View {
    var body: some View {
        Triangle()
            .fill(Color.red)
            .frame(width: 300, height: 300)
            .navigationBarTitle("Triangle", displayMode: .inline)
    }
}

struct ArcView: View {
    var body: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .strokeBorder(Color.blue, lineWidth: 40)
            .frame(width: 300, height: 300)
            .navigationBarTitle("Arc", displayMode: .inline)
    }
}

struct PetalView: View {
    
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(Color.red, style: FillStyle(eoFill: true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40).padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100).padding([.horizontal, .bottom])
        }
        .navigationBarTitle("Flower", displayMode: .inline)
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Arc: InsettableShape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2 - insetAmount,
                    startAngle: modifiedStart,
                    endAngle: modifiedEnd,
                    clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    
    // How much to move this petal away from the center
    var petalOffset: Double = -20
    
    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Count from 0 up to 2π, moving up π/8 each time
        for number in stride(from: 0, through: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            // Rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // Move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            // Create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            // apply our rotation/position transform to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // add it to the main path
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
