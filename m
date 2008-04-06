From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
Date: Sun, 06 Apr 2008 18:18:54 +0200
Message-ID: <47F8F7EE.7010009@trash.net>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr> <47F8EAA6.1040406@trash.net> <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr> <47F8F39B.8060003@trash.net> <alpine.LNX.1.10.0804061803420.16851@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38295 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYDFQSq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:18:46 -0400
In-Reply-To: <alpine.LNX.1.10.0804061803420.16851@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Sunday 2008-04-06 18:00, Patrick McHardy wrote:
>>
>>>  hmkay? What you are seeing is that the offending line uses 8(+4) spaces
>>>  instead of a tab.
>>
>> I'm aware of that, so please fix your setup not to break
>> whitespace.
> 
> Blame me for missing out checkpatch alright, but don't say I touched
> that line or broke the tab into 12 spaces there, because that just is
> not the case.

I didn't, I'm saying the patches you've sent me are broken.
The reason is probably "format=flawed", but thats up to
you to figure out.

