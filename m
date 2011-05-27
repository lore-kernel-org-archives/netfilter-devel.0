From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.11
Date: Fri, 27 May 2011 10:32:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105271025100.2853@frira.zrqbmnf.qr>
References: <4DDE857E.40807@trash.net> <4DDE8814.7090201@trash.net> <20110526200020.GA5988@lutz.bln.innominate.local> <alpine.LNX.2.01.1105262210150.30203@frira.zrqbmnf.qr> <20110527075811.GA3103@lutz.bln.innominate.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60506 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1E0IcV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 04:32:21 -0400
In-Reply-To: <20110527075811.GA3103@lutz.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-05-27 09:58, Lutz Jaenicke wrote:

>> >> That's supposed to read 1.4.11 of course :)
>> >
>> >Hmm. For reasons I do not (yet?) understand I do not get the
>> >tag with "git pull" and configure.ac stays at 1.4.10 in
>> >"master".
>> >
>> >What am I doing wrong?
>> 
>> That there is no tag, or even commit a potential tag could refer to.
>> Someone must have forgotten push.
>
>Maybe. If I perform a "git clone" the tag is in the packed refs.
>The tag itself (also see gitweb) includes the modification of config.ac
>to reflect the bumped version number...

`git remote update` only requests the branch heads, and since the 
v1.4.11 tag is not reachable through any branch (again - ugh), it does 
not get downloaded.

`git fetch origin --tags` retrieves it, but of course that does not fix 
the underlying problem that a tag should be reachable[*] through a head.


[*] Since ancient versions are out of focus, no heads are 
usually provided for these (e.g. v1.4.9.1); the fact that v1.4.9 is 
reachable is merely a sideeffect.
