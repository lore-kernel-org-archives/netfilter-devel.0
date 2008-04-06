From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
Date: Sun, 06 Apr 2008 18:00:27 +0200
Message-ID: <47F8F39B.8060003@trash.net>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr> <47F8EAA6.1040406@trash.net> <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37878 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYDFQAV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:00:21 -0400
In-Reply-To: <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>> This doesn't apply because of whitespace damage:
>>
>>          * Try to fill in the third arg: nhoff is offset of l3 proto
>>            * hdr.  Return true if possible.
>> ^^^^^^^^^^ spaces that are not present in the tree
>>
>> I even tried the files taken from Maildir/, so its not mailer related.
>>
>> Besides that it *still* uses spaced for indentation. I didn't
>> mean you should run it through your own checkpatch.pl version that
>> doesn't complain about whitespace but through the one contained in
>> the kernel tree.
>>
> Just when I was done I noticed I still had to run checkpatch (the
> original version), I did it for one or two patches (involved
> an awkward git rebase) then got so upset that I decided to send
> the cp update instead.

Well, I've asked for checkpatch-clean patches multiple times
now (at least the things that don't have good justification for
breaking, this does probably never apply to whitespace). If that
is too much to ask then I'm simply going to silently drop your
patches in the future.

> Besides, I did not even touch that "Return true if possible" line.
 >
> git blame tells me:
> 
> 9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 27)       /*
> 9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 28)        * Try 
> to fill i
> 9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 29)          * 
> hdr.  Retur
> 9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 30)        */
> 
> hmkay? What you are seeing is that the offending line uses 8(+4) spaces 
> instead of a tab.

I'm aware of that, so please fix your setup not to break
whitespace.

> If it does not apply, well, that is _so_ sad. I always announce the 
> upstream commit id or tree so people have a clue what it's against, and 
> there's even my git tree out there (//dev.computergmbh.de/linux master) 
> where, should even that fail, people can fetch and use gitk/git-forest 
> to see where my commits got stacked on.

You expect me to fetch your tree to figure out why your patches
don't apply? How about testing yourself before wasting other
peoples time?





