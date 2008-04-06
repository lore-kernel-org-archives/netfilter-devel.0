From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct
 nf_conntrack_l3proto
Date: Sun, 6 Apr 2008 17:35:35 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr> <47F8EAA6.1040406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50359 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYDFPfh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:35:37 -0400
In-Reply-To: <47F8EAA6.1040406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-04-06 17:22, Patrick McHardy wrote:
>>  -                struct nf_conntrack_tuple *tuple);
>>  +    bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
>>  +                         struct nf_conntrack_tuple *tuple);
>> 
>
> This doesn't apply because of whitespace damage:
>
>          * Try to fill in the third arg: nhoff is offset of l3 proto
>            * hdr.  Return true if possible. 
>
> ^^^^^^^^^^ spaces that are not present in the tree
>
> I even tried the files taken from Maildir/, so its not mailer related.
>
> Besides that it *still* uses spaced for indentation. I didn't
> mean you should run it through your own checkpatch.pl version that
> doesn't complain about whitespace but through the one contained in
> the kernel tree.
>
Just when I was done I noticed I still had to run checkpatch (the
original version), I did it for one or two patches (involved
an awkward git rebase) then got so upset that I decided to send
the cp update instead.

Besides, I did not even touch that "Return true if possible" line.
git blame tells me:

9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 27)       /*
9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 28)        * Try to fill i
9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 29)          * hdr.  Retur
9fb9cbb1 (Yasuyuki Kozakai  2005-11-09 16:38:16 -0800 30)        */

hmkay? What you are seeing is that the offending line uses 8(+4) spaces 
instead of a tab.
If it does not apply, well, that is _so_ sad. I always announce the 
upstream commit id or tree so people have a clue what it's against, and 
there's even my git tree out there (//dev.computergmbh.de/linux master) 
where, should even that fail, people can fetch and use gitk/git-forest 
to see where my commits got stacked on.
I need a kitkat now..

