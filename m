From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.3.1
Date: Wed, 25 Mar 2009 13:50:16 +0100
Message-ID: <49CA2888.5070801@netfilter.org>
References: <49C8DB3B.909@netfilter.org> <200903242112.56886.steven@springl.ukfsn.org> <alpine.LSU.2.00.0903242224390.26397@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steven Jan Springl <steven@springl.ukfsn.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47971 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753517AbZCYMuo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:50:44 -0400
In-Reply-To: <alpine.LSU.2.00.0903242224390.26397@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-03-24 22:12, Steven Jan Springl wrote:
> 
>> Is there a problem with mss in this release?
>> If I specify rule:
>> -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1000:1500 -j ACCEPT
>> I get error:
>>         Invalid mss '1000' specified.
>>
>> It appears that mss values less than 65536 are rejected, while values of 65536 
>> or greater are accepted. Is this not the wrong way around?
> 
> Indeed. There is an uncommon coding pattern (compared to the rest of 
> the iptables sources) in the function at hand. Patch below.
> 
> usually:
> 	if (!strtoui(...))
> 		you_fail;
> 	return ok;
> libxt_tcpmss:
> 	if (strtoui(...))
> 		return ok;
> 	you_fail;
> 
> Pullable from the usual location at git://dev.medozas.de/iptables
> 
> Updating 6e70f46..ed7925b
> Fast forward
>  extensions/libxt_tcpmss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> parent 6e70f46f2a146bb7c657f71724c999147a5925dc (v1.4.3.1)
> commit ed7925b77010dd17531ea0424b49d2b72af4add9
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Mar 24 22:26:25 2009 +0100
> 
> libxt_tcpmss: fix an inversion while parsing --mss
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied. Thanks. I guess that will have to release another 1.4.3.2 soon.
We needed more -rc before the final release I guess. I'm going to wait a
bit more to catch up more problems and then proceed.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
