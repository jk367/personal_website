---
title: "Music"
date: 2024-07-30T11:23:36+02:00
draft: false
---

I make electronic music under the name j.m. kettle. I've been making music since 2016, mostly electronic but sometimes venture into other genres. I try not to box myself into one genre but play music with a constant emotional throughline, which is the inspiration of my party, stop1, which I throw every 6ish weeks in brooklyn.   

I've played at Hellphone, Trans Pecos, The Stranger, Wiggle Room, Leftbank (Tbilisi), and Pluto's Records (Tbilisi). 

## Mixes
<div class="soundcloud-lazy" data-src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1959695677&color=%23ff5500&auto_play=false&hide_related=true&show_comments=false&show_user=true&show_reposts=false&show_teaser=false">
    <div class="soundcloud-placeholder">
        <p>Loading...</p>
    </div>
</div>

## Tracks
<div class="soundcloud-lazy" data-src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1959698237&color=%23ff5500&auto_play=false&hide_related=true&show_comments=false&show_user=true&show_reposts=false&show_teaser=false">
    <div class="soundcloud-placeholder">
        <p>Loading...</p>
    </div>
</div>

<style>
.soundcloud-placeholder {
    width: 100%;
    height: 450px;
    background-color: #f0f0f0;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #ddd;
}

.soundcloud-placeholder p {
    color: #666;
    font-style: italic;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const lazyEmbeds = document.querySelectorAll('.soundcloud-lazy');
    
    const loadSoundCloud = (embed) => {
        const iframe = document.createElement('iframe');
        iframe.src = embed.dataset.src;
        iframe.width = '100%';
        iframe.height = '450';
        iframe.frameBorder = 'no';
        iframe.scrolling = 'no';
        iframe.allow = 'autoplay';
        
        embed.innerHTML = '';
        embed.appendChild(iframe);
    };
    
    // Use Intersection Observer to detect when elements come into view
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting && !entry.target.classList.contains('loaded')) {
                loadSoundCloud(entry.target);
                entry.target.classList.add('loaded');
                observer.unobserve(entry.target);
            }
        });
    }, {
        rootMargin: '100px' // Start loading 100px before it comes into view
    });
    
    lazyEmbeds.forEach(embed => {
        observer.observe(embed);
    });
});
</script>
