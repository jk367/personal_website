---
title: "About"
---

# About<button id="globalToggle">Expand All Sections</button>

## Bio <button class="sectionToggle" data-section="bio">Expand bio</button>

<div class="section" id="bioSection" style="display:none;">

I generally don't like to be categorized as one thing, but right now I mainly run a startup.

I grew up in NYC, went to Brooklyn Tech, then went to Columbia and Sciences Po. In college I studied a lot of different things, mostly a combination of economics, computer science, and sociology.  

After I graduated, I moved to Georgia, the country, for 7 months to be a math teacher. 

I returned to NYC in January of 2024. I was a freelance photographer for 2 months, then I started a company with my old professor. 

Since then I have been running the startup out of NYC, planning on moving to SF soon. 

</div>

## Previous Work <button class="sectionToggle" data-section="work">Expand work</button> 

<div class="section" id="workSection" style="display:none;">

### 2016-Present <button id="expandAllJobs">Expand All Jobs</button>
<details>
<summary><strong>Co-Founder/CEO - CloudCap - 2024 to Present</strong></summary>

In March of 2024, I had a chance encounter with my old computer science professor and we started a company. I'm in charge of sales, fundraising, product development. Running a company is hard, but also mentally rewarding. I think people should start companies or join early stage companies when they're young, it's a lot more fun than bigger shops.
</details>

<details>
<summary><strong>Freelance Photographer - 2022 - Present</strong></summary>

I really like taking photos, mostly of people and mostly at night. Sometimes people pay me. I work exclusively in Black and White, don't do birthdays, and prefer some creative freedom when doing portraits. If you want to book me for a portrait session it's $300 for 2 hours, not including studio, and if you want me to work your party it's $400 for the night. Friend prices are lower, generally free. It's just for fun. 
</details>

<details>
<summary><strong>Freelance Writer - 2019 - Present</strong></summary>

I consider myself mainly a writer, I've been writing, mostly for myself, since I was 13. I write poetry, fiction, and non-fiction. Sometimes I write for publications. If you want me to write for you it's $100 per article. 
</details>

<details>
<summary><strong>DJ - 2018 - Present</strong></summary>

I like music and throwing parties. I've been throwing parties for a long time and at some point wanted to do it full time. I realized it's not for me, but still DJ from time to time. I do it for fun now because I like collecting records. If you want to book me for your party, I charge $200 a night. 
<ul>
<li>Favorite BPM - 133.33</li>
<li>Favorite Club - Tie between Berghain & Bassiani.</li>
<li>Favorite Record - Strings of Life by Derrick May</li>
<li>Favorite DJ - Can't pick,  a few: NDRX, NEWA, Kancheli, Luigi di Venere, KR!Z, Luke Slater, Buttechno</li>
<li>Favorite Party - Bassiani Season closing 2023</li>
</ul>
</details>

<details>
<summary><strong>Math Teacher - Georgian American School Tbilisi - 2023 - 2024</strong></summary>

When I graduated college in 2023, I really wanted to move to Georgia. Combination of the club scene, food, and personal connection. I found a job at the Georgian American School via a family friend. I taught 4th through 12th grade. It was kinda chaotic, but probably the best 7 months of my life. I taught Math and Computer Science. 
</details>

<details>
<summary><strong>Quant Analyst Intern - BlackRock - Summer 2023</strong></summary>

In my junior year I was an intern at BlackRock. I was in the Risk Management division doing Model Risk. Did a lot of NLP work other math related to finance. BlackRock is actually a great place to work. My colleagues were really hard working, intelligent, and nice. Didn't accept the offer because I wanted to live abroad.
</details>

<details>
<summary><strong>Consultant Intern - Plural Strategy - Summer 2022</strong></summary>

In my sophomore summer I worked for Plural Strategy. I did a lot of PowerPoint and Excel. I was in the NYC office. It wasn't for me, but my colleagues and boss (Matt) were very nice. 
</details>

<details>
<summary><strong>Hedge Fund Intern - Precision Global (defunct) - Summer 2021</strong></summary>

During the Summer of Covid I worked for a small hedge fund, I did research and generally internship tasks like making the website and listening on company calls. It was exciting and fun. The trades were mostly based in Asia so my hours were a bit crazy. 
</details>

<details>
<summary><strong>Operations Intern - Impact Jeunes - Summer 2019</strong></summary>

In my freshman year summer, I lived in Marseille and worked for an NGO. I was in a pretty rough part of town, Felix Pyat, and taught math/English to immigrants. I also helped with operations within the organization. No one in Marseille speaks English, so I learned almost all my French there.
</details>

<details>
<summary><strong>Math Tutor - Mathnasium - 2017-2018</strong></summary>

In high school, I went to Mathnasium for tutoring and eventually became a tutor myself. I mostly taught younger kids. I had a great time. 
</details>

<details>
<summary><strong>Campaign Intern - Ede Fox - Summer 2017</strong></summary>

Junior year in High school I canvassed for a city council race. I walked a lot and talked to a lot of people. We lost the election. Good experience though, I was really tan by the end of it. 
</details>

<details>
<summary><strong>Waiter - Brooklyn Ramen Restaurant (defunct) - Summer 2016</strong></summary>

When I was 16, I wanted more money to buy books, so I worked as a waiter for 2 weeks. I was a really bad waiter and was fired. 
</details>

</div>

## Contact 
If you want to get in touch, you can email me at jameskettle2018 [@] gmail dot com

<style>
    button {
        background-color: white;
        color: black;
        border: 1px solid black;
        padding: 1px 5px;
        font-family: Garamond, serif;
        font-size: 16px;
        transition: background-color 0.3s ease, color 0.3s ease;
        cursor: pointer;
        margin: 0 2px 5px 2px;
    }

    button:hover {
        background-color: black;
        color: white;
    }

    .button-group {
        display: flex;
        justify-content: center;
        margin-top: 15px;
        margin-bottom: 15px;
    }

#globalToggle {
    margin-left: 20px;
}

.section {
    margin-top: 10px;
    margin-bottom: 20px;
}

details {
    margin-bottom: 15px;
}

summary {
    cursor: pointer;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const globalToggle = document.getElementById('globalToggle');
    const sectionToggles = document.querySelectorAll('.sectionToggle');
    const expandAllJobs = document.getElementById('expandAllJobs');
    
    globalToggle.addEventListener('click', toggleAllSections);
    sectionToggles.forEach(button => {
        button.addEventListener('click', (event) => toggleSection(event.target.dataset.section));
    });
    expandAllJobs.addEventListener('click', toggleAllJobs);
});

function toggleAllSections() {
    const allSections = document.querySelectorAll('.section');
    const isExpanded = document.getElementById('globalToggle').textContent === 'Collapse All Sections';
    
    allSections.forEach(section => {
        section.style.display = isExpanded ? 'none' : 'block';
    });
    
    document.getElementById('globalToggle').textContent = isExpanded ? 'Expand All Sections' : 'Collapse All Sections';
    document.querySelectorAll('.sectionToggle').forEach(button => {
        button.textContent = isExpanded ? `Expand ${button.dataset.section}` : `Collapse ${button.dataset.section}`;
    });
}

function toggleSection(sectionId) {
    const section = document.getElementById(`${sectionId}Section`);
    const button = document.querySelector(`.sectionToggle[data-section="${sectionId}"]`);
    const isExpanded = button.textContent === `Collapse ${sectionId}`;
    
    section.style.display = isExpanded ? 'none' : 'block';
    button.textContent = isExpanded ? `Expand ${sectionId}` : `Collapse ${sectionId}`;
}

function toggleAllJobs() {
    const allJobs = document.querySelectorAll('#workSection details');
    const isExpanded = document.getElementById('expandAllJobs').textContent === 'Collapse All Jobs';
    
    allJobs.forEach(job => {
        job.open = !isExpanded;
    });
    
    document.getElementById('expandAllJobs').textContent = isExpanded ? 'Expand All Jobs' : 'Collapse All Jobs';
}
</script>