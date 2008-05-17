From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Sat, 17 May 2008 09:59:20 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805170919540.15590@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr> <4829B177.9000501@trash.net> <alpine.LNX.1.10.0805131734130.448@fbirervta.pbzchgretzou.qr>
 <482B1335.30200@trash.net> <alpine.LNX.1.10.0805141935320.5292@fbirervta.pbzchgretzou.qr> <482C49CB.8060306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57975 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYEQH7V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 May 2008 03:59:21 -0400
In-Reply-To: <482C49CB.8060306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 16:33, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> There was confusion (in the git layer) how to handle the svn path
>> reordering that took place over time, which Yasuyuki did a great job
>> of clearing up. But making it a good git repository does not stop
>> after importing and, probably git-tagging the SVN branches^W tags^W
>> twigs. I mean hey, try to work with it like with the standards that
>> git and linux set, like
>> 
>> $ git shortlog v1.4.0..HEAD --
>> fatal: bad revision 'v1.4.0..HEAD'
>> 
>> Oh shoot, the tags are not the usual ones. Well, deducting a point
>> and continuing the quest:
>> 
>> $ git shortlog svn_t_iptables_1_4_0..HEAD --
>> fatal: bad revision 'svn_t_iptables_1_4_0..HEAD'
>
> There is no 1.4.0 tag in SVN, so there's none in git.

Who would have thought! And there are still the branches,
which are not actually branches. See now why importing just is not
enough.

>> $ git shortlog svn_t_iptables_1_4_0rc1..HEAD -- | grep -v '^ '
>> /C=EU/ST=EU/CN=Pablo Neira Ayuso/... (4):
>> /C=EU/ST=EU/CN=Patrick McHardy/... (107):
>> /C=JP/ST=JP/CN=Yasuyuki Kozakai/... (29):
>> 
>> Hm yeah X.509, not exactly git but.. *sigh*. Even so, the
>> contributors should get their share in the release shortlog which,
>> ignoring that moving to git was just recent, would also happen too
>> seldom if things continue their way in that 6 month cycle.
>
> Not sure what you're trying to say, what does the release cycle
> have to do with anything?

Not specifically related to git, but it is the second thing I am
really unhappy about because it creates a long turnaround time for
users to actually receive the software.
