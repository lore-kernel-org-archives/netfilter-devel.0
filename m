From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: TEE/reentrancy 20100407
Date: Fri, 09 Apr 2010 16:53:09 +0200
Message-ID: <4BBF3F55.4050308@trash.net>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <alpine.LSU.2.01.1004091139330.17365@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60511 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0DIOxK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:53:10 -0400
In-Reply-To: <alpine.LSU.2.01.1004091139330.17365@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-04-07 20:50, Jan Engelhardt wrote:
>> Jan Engelhardt (6):
>>      netfilter: ipv6: move POSTROUTING invocation before fragmentation
>>      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
>>      netfilter: xtables: inclusion of xt_TEE
>>      netfilter: xtables2: make ip_tables reentrant
>>      netfilter: xt_TEE: have cloned packet travel through Xtables too
>>      netfilter: xtables: remove old comments about reentrancy
> 
> Is this submission ok?

Not sure, I'm currently busy with other things. I'll review these
patches this weekend.
