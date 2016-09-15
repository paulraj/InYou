//
//  PersonalityController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/5/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

class PersonalityData: NSObject {
    
    var personalitySummary = ""
    var personalitySummaryStatus = ""
    var personalityAnalyzed = false
    
    var personalityTraits = ""
    
    var lifeSatisfaction = ""
    var intelligenceQuotient = ""
    var emotionalQuotient = ""
    var friendlinessScore = ""
    var trustScore = ""
    
    var feelByAge = ""
    var creativity = ""
    var innovation = ""
    var imagination = ""
    var learningStyle = ""
    var thinkingStyle = ""
    var academicPerformance = ""
    var carreerPerformance = ""
    var careerArea = ""
    var strengths: [String] = []
    
    var personalityType = ""
    var independentScore = ""
    var independent = ""
    var workhorse = ""
    var thinkingStyleDegree = ""
    var marketingIq = ""
    var businessMinded = ""
    var insecure = ""
    var conscientious = ""
    var rewardBias = ""
    var impulsive = ""
    var familyOriented = ""
    var familyOrientedScore = ""
    var achievementDriven = ""
    var happiness = ""
    var socialSkills = ""
    var powerDriven = ""
    var cold = ""
    var adjustment = ""
    var depression = ""
    
    var receptivitiSummary: [String] = []
    var receptivitiDescription: [String] = []
    
    var personalRelationship = ""
    var health = ""
    
    var traits: PersonalityTraits?
    var values: Values?
    var needs: Needs?
    
    override init() {
        traits = PersonalityTraits()
        values = Values()
        needs = Needs()
    }
    
    required init(coder aDecoder: NSCoder) {
        if let personalitySummary = aDecoder.decodeObjectForKey("personalitySummary") as? String {
            self.personalitySummary = personalitySummary
        }
        if let personalitySummary = aDecoder.decodeObjectForKey("personalityAnalyzed") as? String {
            self.personalitySummary = personalitySummary
        }
        /*if let data = aDecoder.decodeObjectForKey("traits") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let traits = unarc.decodeObjectForKey("root") as! PersonalityTraits
            self.traits = traits
        }
        if let data = aDecoder.decodeObjectForKey("values") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let values = unarc.decodeObjectForKey("root") as! Values
            self.values = values
        }
        if let data = aDecoder.decodeObjectForKey("needs") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let needs = unarc.decodeObjectForKey("root") as! Needs
            self.needs = needs
        }
        */
        if let peronalityTraits = aDecoder.decodeObjectForKey("peronalityTraits") as? String {
            self.personalityTraits = peronalityTraits
        }
        if let lifeSatisfaction = aDecoder.decodeObjectForKey("lifeSatisfaction") as? String {
            self.lifeSatisfaction = lifeSatisfaction
        }
        if let intelligenceQuotient = aDecoder.decodeObjectForKey("intelligenceQuotient") as? String {
            self.intelligenceQuotient = intelligenceQuotient
        }
        if let emotionalQuotient = aDecoder.decodeObjectForKey("emotionalQuotient") as? String {
            self.emotionalQuotient = emotionalQuotient
        }
        if let friendlinessScore = aDecoder.decodeObjectForKey("frindlinessScore") as? String {
            self.friendlinessScore = friendlinessScore
        }
        if let trustScore = aDecoder.decodeObjectForKey("trustScore") as? String {
            self.trustScore = trustScore
        }
        if let creativity = aDecoder.decodeObjectForKey("creativity") as? String {
            self.creativity = creativity
        }
        self.innovation = aDecoder.decodeObjectForKey("innovation") as! String
        self.imagination = aDecoder.decodeObjectForKey("imagination") as! String
        self.learningStyle = aDecoder.decodeObjectForKey("learningStyle") as! String
        self.thinkingStyle = aDecoder.decodeObjectForKey("thinkingStyle") as! String
        
        self.academicPerformance = aDecoder.decodeObjectForKey("academicPerformance") as! String
        self.carreerPerformance = aDecoder.decodeObjectForKey("carreerPerformance") as! String
        self.personalRelationship = aDecoder.decodeObjectForKey("personalRelationship") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(personalitySummary, forKey: "personalitySummary")
        aCoder.encodeObject(personalitySummary, forKey: "personalityAnalyzed")
        
        //aCoder.encodeObject(isLoggedIn, forKey: "isLoggedIn")
        aCoder.encodeObject(personalityTraits, forKey: "personalityTraits")
        aCoder.encodeObject(lifeSatisfaction, forKey: "lifeSatisfaction")
        aCoder.encodeObject(intelligenceQuotient, forKey: "intelligenceQuotient")
        aCoder.encodeObject(emotionalQuotient, forKey: "emotionalQuotient")
        aCoder.encodeObject(friendlinessScore, forKey: "friendlinessScore")
        aCoder.encodeObject(trustScore, forKey: "trustScore")
        aCoder.encodeObject(creativity, forKey: "creativity")
        aCoder.encodeObject(innovation, forKey: "innovation")
        aCoder.encodeObject(learningStyle, forKey: "learningStyle")
        aCoder.encodeObject(thinkingStyle, forKey: "thinkingStyle")
        aCoder.encodeObject(academicPerformance, forKey: "academicPerformance")
        aCoder.encodeObject(carreerPerformance, forKey: "carreerPerformance")
        aCoder.encodeObject(personalRelationship, forKey: "personalRelationship")
        
        /*
        if let traits = self.traits {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(traits), forKey: "traits")
        }
        
        if let values = self.values {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(values), forKey: "values")
        }
        
        if let needs = self.needs {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(needs), forKey: "needs")
        }*/
    }
}

class PersonalityTraits: NSObject {
    
    var personalityTraitKey = ""
    var personalityTraitValue = ""
    
    var openness: Openness?
    var conscientiousness: Conscientiousness?
    var extraversion: Extraversion?
    var agreeableness: Agreeableness?
    var neuroticism: Neuroticism?
    
    override init() {
        openness = Openness()
        conscientiousness = Conscientiousness()
        extraversion = Extraversion()
        agreeableness = Agreeableness()
        neuroticism = Neuroticism()
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let personalityTraitKey = aDecoder.decodeObjectForKey("personalityTraitKey") as? String {
            self.personalityTraitKey = personalityTraitKey
        }
        if let personalityTraitValue = aDecoder.decodeObjectForKey("personalityTraitValue") as? String {
            self.personalityTraitValue = personalityTraitValue
        }
        if let data = aDecoder.decodeObjectForKey("openness") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let openness = unarc.decodeObjectForKey("root") as! Openness
            self.openness = openness
        }
        if let data = aDecoder.decodeObjectForKey("conscientiousness") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let conscientiousness = unarc.decodeObjectForKey("root") as! Conscientiousness
            self.conscientiousness = conscientiousness
        }
        if let data = aDecoder.decodeObjectForKey("extraversion") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let extraversion = unarc.decodeObjectForKey("root") as! Extraversion
            self.extraversion = extraversion
        }
        if let data = aDecoder.decodeObjectForKey("agreeableness") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let agreeableness = unarc.decodeObjectForKey("root") as! Agreeableness
            self.agreeableness = agreeableness
        }
        if let data = aDecoder.decodeObjectForKey("neuroticism") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let neuroticism = unarc.decodeObjectForKey("root") as! Neuroticism
            self.neuroticism = neuroticism
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(personalityTraitKey, forKey: "personalityTraitKey")
        aCoder.encodeObject(personalityTraitValue, forKey: "personalityTraitValue")
        
        if let openness = self.openness {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(openness), forKey: "openness")
        }
        if let conscientiousness = self.conscientiousness {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(conscientiousness), forKey: "conscientiousness")
        }
        if let extraversion = self.extraversion {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(extraversion), forKey: "extraversion")
        }
        if let agreeableness = self.agreeableness {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(agreeableness), forKey: "agreeableness")
        }
        if let neuroticism = self.neuroticism {
            aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(neuroticism), forKey: "neuroticism")
        }
    }
    */
}

class Openness: NSObject {
    
    var opennessKey = ""
    var opennessValue = 0.0
    
    var adventurousness = 0.0
    var artisticInterests = 0.0
    var emotionality = 0.0
    var imagination = 0.0
    var intellect = 0.0
    var liberalism = 0.0
    
    override init() {
   
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let opennessKey = aDecoder.decodeObjectForKey("opennessKey") as? String {
            self.opennessKey = opennessKey
        }
        if let opennessValue = aDecoder.decodeObjectForKey("opennessValue") as? Double {
            self.opennessValue = opennessValue
        }
        if let adventurousness = aDecoder.decodeObjectForKey("adventurousness") as? String {
            self.adventurousness = adventurousness
        }
        if let artisticInterests = aDecoder.decodeObjectForKey("artisticInterests") as? String {
            self.artisticInterests = artisticInterests
        }
        if let emotionality = aDecoder.decodeObjectForKey("emotionality") as? String {
            self.emotionality = emotionality
        }
        if let imagination = aDecoder.decodeObjectForKey("imagination") as? String {
            self.imagination = imagination
        }
        if let intellect = aDecoder.decodeObjectForKey("intellect") as? String {
            self.intellect = intellect
        }
        if let liberalism = aDecoder.decodeObjectForKey("liberalism") as? String {
            self.liberalism = liberalism
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(opennessKey, forKey: "opennessKey")
        aCoder.encodeObject(opennessValue, forKey: "opennessValue")
        
        aCoder.encodeObject(adventurousness, forKey: "adventurousness")
        aCoder.encodeObject(artisticInterests, forKey: "artisticInterests")
        aCoder.encodeObject(emotionality, forKey: "emotionality")
        aCoder.encodeObject(imagination, forKey: "imagination")
        aCoder.encodeObject(intellect, forKey: "intellect")
        aCoder.encodeObject(liberalism, forKey: "liberalism")
    }
    */
}

class Conscientiousness: NSObject {
    
    var conscientiousnessKey = ""
    var conscientiousnessValue = 0.0
    
    var achievementStriving = 0.0
    var cautiousness = 0.0
    var dutifulness = 0.0
    var orderliness = 0.0
    var selfDiscipline = 0.0
    var selfEfficacy = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let conscientiousnessKey = aDecoder.decodeObjectForKey("conscientiousnessKey") as? String {
            self.conscientiousnessKey = conscientiousnessKey
        }
        if let conscientiousnessValue = aDecoder.decodeObjectForKey("conscientiousnessValue") as? Double {
            self.conscientiousnessValue = conscientiousnessValue
        }
        if let achievementStriving = aDecoder.decodeObjectForKey("achievementStriving") as? String {
            self.achievementStriving = achievementStriving
        }
        if let cautiousness = aDecoder.decodeObjectForKey("cautiousness") as? String {
            self.cautiousness = cautiousness
        }
        if let dutifulness = aDecoder.decodeObjectForKey("dutifulness") as? String {
            self.dutifulness = dutifulness
        }
        if let orderliness = aDecoder.decodeObjectForKey("orderliness") as? String {
            self.orderliness = orderliness
        }
        if let selfDiscipline = aDecoder.decodeObjectForKey("selfDiscipline") as? String {
            self.selfDiscipline = selfDiscipline
        }
        if let selfEfficacy = aDecoder.decodeObjectForKey("selfEfficacy") as? String {
            self.selfEfficacy = selfEfficacy
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(conscientiousnessKey, forKey: "conscientiousnessKey")
        aCoder.encodeObject(conscientiousnessValue, forKey: "conscientiousnessValue")
        
        aCoder.encodeObject(achievementStriving, forKey: "achievementStriving")
        aCoder.encodeObject(cautiousness, forKey: "cautiousness")
        aCoder.encodeObject(dutifulness, forKey: "dutifulness")
        aCoder.encodeObject(orderliness, forKey: "orderliness")
        aCoder.encodeObject(selfDiscipline, forKey: "selfDiscipline")
        aCoder.encodeObject(selfEfficacy, forKey: "selfEfficacy")
    }
    */
}

class Agreeableness: NSObject {
    
    var agreeablenessKey = ""
    var agreeablenessValue = 0.0
    
    var altruism = 0.0
    var cooperation = 0.0
    var modesty = 0.0
    var morality = 0.0
    var sympathy = 0.0
    var trust = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let agreeablenessKey = aDecoder.decodeObjectForKey("agreeablenessKey") as? String {
            self.agreeablenessKey = agreeablenessKey
        }
        if let agreeablenessValue = aDecoder.decodeObjectForKey("agreeablenessValue") as? Double {
            self.agreeablenessValue = agreeablenessValue
        }
        if let altruism = aDecoder.decodeObjectForKey("altruism") as? String {
            self.altruism = altruism
        }
        if let cooperation = aDecoder.decodeObjectForKey("cooperation") as? String {
            self.cooperation = cooperation
        }
        if let modesty = aDecoder.decodeObjectForKey("modesty") as? String {
            self.modesty = modesty
        }
        if let morality = aDecoder.decodeObjectForKey("morality") as? String {
            self.morality = morality
        }
        if let sympathy = aDecoder.decodeObjectForKey("sympathy") as? String {
            self.sympathy = sympathy
        }
        if let trust = aDecoder.decodeObjectForKey("trust") as? String {
            self.trust = trust
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(agreeablenessKey, forKey: "agreeablenessKey")
        aCoder.encodeObject(agreeablenessValue, forKey: "agreeablenessValue")
        
        aCoder.encodeObject(altruism, forKey: "altruism")
        aCoder.encodeObject(cooperation, forKey: "cooperation")
        aCoder.encodeObject(modesty, forKey: "modesty")
        aCoder.encodeObject(morality, forKey: "morality")
        aCoder.encodeObject(sympathy, forKey: "sympathy")
        aCoder.encodeObject(trust, forKey: "trust")
    }
    */
}

class Neuroticism: NSObject {
    
    var neuroticismKey = ""
    var neuroticismValue = 0.0
    
    var anger = 0.0
    var anxiety = 0.0
    var depression = 0.0
    var immoderation = 0.0
    var selfConsciousness = 0.0
    var vulnerability = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let neuroticismKey = aDecoder.decodeObjectForKey("neuroticismKey") as? String {
            self.neuroticismKey = neuroticismKey
        }
        if let neuroticismValue = aDecoder.decodeObjectForKey("neuroticismValue") as? Double {
            self.neuroticismValue = neuroticismValue
        }
        if let anger = aDecoder.decodeObjectForKey("anger") as? String {
            self.anger = anger
        }
        if let depression = aDecoder.decodeObjectForKey("depression") as? String {
            self.depression = depression
        }
        if let anxiety = aDecoder.decodeObjectForKey("anxiety") as? String {
            self.anxiety = anxiety
        }
        if let immoderation = aDecoder.decodeObjectForKey("immoderation") as? String {
            self.immoderation = immoderation
        }
        if let selfConsciousness = aDecoder.decodeObjectForKey("selfConsciousness") as? String {
            self.selfConsciousness = selfConsciousness
        }
        if let vulnerability = aDecoder.decodeObjectForKey("vulnerability") as? String {
            self.vulnerability = vulnerability
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(neuroticismKey, forKey: "neuroticismKey")
        aCoder.encodeObject(neuroticismValue, forKey: "neuroticismValue")
        
        aCoder.encodeObject(anger, forKey: "anger")
        aCoder.encodeObject(depression, forKey: "depression")
        aCoder.encodeObject(anxiety, forKey: "anxiety")
        aCoder.encodeObject(immoderation, forKey: "immoderation")
        aCoder.encodeObject(selfConsciousness, forKey: "selfConsciousness")
        aCoder.encodeObject(vulnerability, forKey: "vulnerability")
    }
    */
    
}

class Extraversion: NSObject {
    
    var extraversionKey = ""
    var extraversionValue = 0.0
    
    var activityLevel = 0.0
    var assertiveness = 0.0
    var cheerfulness = 0.0
    var excitementSeeking = 0.0
    var friendliness = 0.0
    var gregariousness = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let extraversionKey = aDecoder.decodeObjectForKey("extraversionKey") as? String {
            self.extraversionKey = extraversionKey
        }
        if let extraversionValue = aDecoder.decodeObjectForKey("extraversionValue") as? Double {
            self.extraversionValue = extraversionValue
        }
        if let activityLevel = aDecoder.decodeObjectForKey("activityLevel") as? String {
            self.activityLevel = activityLevel
        }
        if let assertiveness = aDecoder.decodeObjectForKey("assertiveness") as? String {
            self.assertiveness = assertiveness
        }
        if let cheerfulness = aDecoder.decodeObjectForKey("cheerfulness") as? String {
            self.cheerfulness = cheerfulness
        }
        if let excitementSeeking = aDecoder.decodeObjectForKey("excitementSeeking") as? String {
            self.excitementSeeking = excitementSeeking
        }
        if let friendliness = aDecoder.decodeObjectForKey("friendliness") as? String {
            self.friendliness = friendliness
        }
        if let gregariousness = aDecoder.decodeObjectForKey("gregariousness") as? String {
            self.gregariousness = gregariousness
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(extraversionKey, forKey: "extraversionKey")
        aCoder.encodeObject(extraversionValue, forKey: "extraversionValue")
        
        aCoder.encodeObject(activityLevel, forKey: "activityLevel")
        aCoder.encodeObject(assertiveness, forKey: "assertiveness")
        aCoder.encodeObject(cheerfulness, forKey: "cheerfulness")
        aCoder.encodeObject(excitementSeeking, forKey: "excitementSeeking")
        aCoder.encodeObject(friendliness, forKey: "friendliness")
        aCoder.encodeObject(gregariousness, forKey: "gregariousness")
    }
    */
    
}

class Values: NSObject {
    
    var valueKey = ""
    var valueValue = 0.0
    
    var conservation = 0.0
    var opennessToChange = 0.0
    var hedonism = 0.0
    var selfEnhancement = 0.0
    var selfTranscendence = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let valueKey = aDecoder.decodeObjectForKey("valueKey") as? String {
            self.valueKey = valueKey
        }
        if let valueValue = aDecoder.decodeObjectForKey("valueValue") as? Double {
            self.valueValue = valueValue
        }
        if let conservation = aDecoder.decodeObjectForKey("conservation") as? String {
            self.conservation = conservation
        }
        if let opennessToChange = aDecoder.decodeObjectForKey("opennessToChange") as? String {
            self.opennessToChange = opennessToChange
        }
        if let hedonism = aDecoder.decodeObjectForKey("hedonism") as? String {
            self.hedonism = hedonism
        }
        if let selfEnhancement = aDecoder.decodeObjectForKey("selfEnhancement") as? String {
            self.selfEnhancement = selfEnhancement
        }
        if let selfTranscendence = aDecoder.decodeObjectForKey("selfTranscendence") as? String {
            self.selfTranscendence = selfTranscendence
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(valueKey, forKey: "valueKey")
        aCoder.encodeObject(valueValue, forKey: "valueValue")
        
        aCoder.encodeObject(conservation, forKey: "conservation")
        aCoder.encodeObject(opennessToChange, forKey: "opennessToChange")
        aCoder.encodeObject(hedonism, forKey: "hedonism")
        aCoder.encodeObject(selfEnhancement, forKey: "selfEnhancement")
        aCoder.encodeObject(selfTranscendence, forKey: "selfTranscendence")
    }
    */
}


class Needs: NSObject {
    
    var needKey = ""
    var needValue = 0.0
    
    var challenge = 0.0
    var closeness = 0.0
    var curiosity = 0.0
    var excitement = 0.0
    var harmony = 0.0
    
    var ideal = 0.0
    var liberty = 0.0
    var love = 0.0
    var practicality = 0.0
    var selfExpression = 0.0
    var stability = 0.0
    var structure = 0.0
    
    override init() {
        
    }
    /*
    required init(coder aDecoder: NSCoder) {
        if let needKey = aDecoder.decodeObjectForKey("needKey") as? String {
            self.needKey = needKey
        }
        if let needValue = aDecoder.decodeObjectForKey("needValue") as? Double {
            self.needValue = needValue
        }
        
        if let challenge = aDecoder.decodeObjectForKey("challenge") as? String {
            self.challenge = challenge
        }
        if let closeness = aDecoder.decodeObjectForKey("closeness") as? String {
            self.closeness = closeness
        }
        if let curiosity = aDecoder.decodeObjectForKey("curiosity") as? String {
            self.curiosity = curiosity
        }
        if let excitement = aDecoder.decodeObjectForKey("excitement") as? String {
            self.excitement = excitement
        }
        if let harmony = aDecoder.decodeObjectForKey("harmony") as? String {
            self.harmony = harmony
        }
        
        if let ideal = aDecoder.decodeObjectForKey("ideal") as? String {
            self.ideal = ideal
        }
        if let liberty = aDecoder.decodeObjectForKey("liberty") as? String {
            self.liberty = liberty
        }
        if let love = aDecoder.decodeObjectForKey("love") as? String {
            self.love = love
        }
        if let practicality = aDecoder.decodeObjectForKey("practicality") as? String {
            self.practicality = practicality
        }
        if let selfExpression = aDecoder.decodeObjectForKey("selfExpression") as? String {
            self.selfExpression = selfExpression
        }
        if let practicality = aDecoder.decodeObjectForKey("practicality") as? String {
            self.practicality = practicality
        }
        if let structure = aDecoder.decodeObjectForKey("structure") as? String {
            self.structure = structure
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(needKey, forKey: "needKey")
        aCoder.encodeObject(needValue, forKey: "needValue")
        
        aCoder.encodeObject(challenge, forKey: "challenge")
        aCoder.encodeObject(closeness, forKey: "closeness")
        aCoder.encodeObject(curiosity, forKey: "curiosity")
        aCoder.encodeObject(excitement, forKey: "excitement")
        aCoder.encodeObject(harmony, forKey: "harmony")
        
        aCoder.encodeObject(ideal, forKey: "ideal")
        aCoder.encodeObject(liberty, forKey: "liberty")
        aCoder.encodeObject(love, forKey: "love")
        aCoder.encodeObject(practicality, forKey: "practicality")
        aCoder.encodeObject(selfExpression, forKey: "selfExpression")
        
        aCoder.encodeObject(stability, forKey: "stability")
        aCoder.encodeObject(structure, forKey: "structure")
    }
    */
}

class SocialProfile: NSObject {
    var bio = ""
    var type = ""
    var username = ""
    var id = ""
    var url = ""
    var profileImage = UIImage()
    var images: [UIImage!] = []
    var followers = 0
    var following = 0
    
}