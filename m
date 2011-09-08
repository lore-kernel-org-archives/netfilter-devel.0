From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables branch management
Date: Thu, 8 Sep 2011 16:41:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109081610030.6362@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr> <20110905175425.GC32733@1984> <4E68935B.3000401@trash.net> <alpine.LNX.2.01.1109081243320.11934@frira.zrqbmnf.qr> <4E68BAA8.5010501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53343 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1IHOlm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:41:42 -0400
In-Reply-To: <4E68BAA8.5010501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-09-08 14:52, Patrick McHardy wrote:
>> 
>> Nothing wrong, it just has not been done consistently or at all in the 
>> past. I believe it does not hurt to go ahead with this, also since I am 
>> statistically taking care of most submissions these days anyway.
>
>What has been done in the past doesn't really matter, we can of course
>agree to have a stable branch when needed. But I don't see the point of
>having a stable branch as long as it doesn't contain any fixes.

Oh we are nicely accumulating fixes & trivials already - do not worry 
about that. Just let me pull this off, all it means is that
there is another branch head on iptables.git, and something convenient 
for the release manager to tag should the need arise for a .y release. 
Users already seem to like the idea[1].
[1] http://marc.info/?l=netfilter-devel&m=131499886708085&w=2
