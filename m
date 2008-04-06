From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct
 nf_conntrack_l3proto
Date: Sun, 6 Apr 2008 18:14:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804061803420.16851@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr> <47F8EAA6.1040406@trash.net> <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr>
 <47F8F39B.8060003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45758 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYDFQOV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:14:21 -0400
In-Reply-To: <47F8F39B.8060003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-04-06 18:00, Patrick McHardy wrote:
>
> Well, I've asked for checkpatch-clean patches multiple times
> now (at least the things that don't have good justification for
> breaking, this does probably never apply to whitespace).

Yes I'm going to fix it..

>>  Besides, I did not even touch that "Return true if possible" line.
>>
>>  git blame tells me:
>>
>>  9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 27)       /*
>>  9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 28)        * Try to
>>  fill i
>>  9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 29)          * hdr.
>>  Retur
>>  9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 30)        */
>>
>>  hmkay? What you are seeing is that the offending line uses 8(+4) spaces
>>  instead of a tab.
>
> I'm aware of that, so please fix your setup not to break
> whitespace.

Blame me for missing out checkpatch alright, but don't say I touched
that line or broke the tab into 12 spaces there, because that just is
not the case.

>>  If it does not apply, well, that is _so_ sad. I always announce the
>>  upstream commit id or tree so people have a clue what it's against, and
>>  there's even my git tree out there (//dev.computergmbh.de/linux master)
>>  where, should even that fail, people can fetch and use gitk/git-forest to
>>  see where my commits got stacked on.
>
> You expect me to fetch your tree to figure out why your patches
> don't apply? How about testing yourself before wasting other
> peoples time?

I am sorry. It is just that it is impossible to imagine how this
cannot apply given that I am directly basing off your very own branch
(ac022ce41, nf_nat: add SCTP protocol support) as published on
git.kernel.org and 9fb9cbb1's status.
Since I do not have access to your very local working tree, I
unfortunately cannot see where the merge is going wrong. Perhaps you
invite me to a VNC session?

sorry for the inconvenience,
Jan
