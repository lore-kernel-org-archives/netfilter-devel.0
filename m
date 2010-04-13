From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 13 Apr 2010 14:29:35 +0200
Message-ID: <4BC463AF.1000106@trash.net>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-5-git-send-email-jengelh@medozas.de> <4BC44009.4080206@trash.net> <alpine.LSU.2.01.1004131247580.11306@obet.zrqbmnf.qr> <4BC44CB8.4080405@trash.net> <alpine.LSU.2.01.1004131311330.16098@obet.zrqbmnf.qr> <4BC4525A.8000507@trash.net> <alpine.LSU.2.01.1004131342040.21259@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48525 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0DMM3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:29:37 -0400
In-Reply-To: <alpine.LSU.2.01.1004131342040.21259@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-04-13 13:15, Patrick McHardy wrote:
>> Developers can change it in the source code. Please remove the
>> parameter and hard code it.
>>
>> I'll then apply this patch if we can get rid of the ruleset
>> duplication for each CPU.
> 
> The following changes since commit e26c28e8bffe12b27df5b828404afed9e1949191:
>   Bart De Schuymer (1):
>         netfilter: bridge-netfilter: update a comment in br_forward.c about ip_fragment()
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (6):
>       netfilter: ipv6: move POSTROUTING invocation before fragmentation
>       netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
>       netfilter: xtables: inclusion of xt_TEE
>       netfilter: xtables2: make ip_tables reentrant
>       netfilter: xt_TEE: have cloned packet travel through Xtables too
>       netfilter: xtables: remove old comments about reentrancy

Again, please repost patches on updates. I want to see what I'm
applying/pulling.
