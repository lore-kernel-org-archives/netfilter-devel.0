From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: src: remove dependency on libiptc headers
Date: Thu, 31 Jul 2008 09:02:41 +0200
Message-ID: <48916391.8080407@netfilter.org>
References: <alpine.LNX.1.10.0807300839010.6568@fbirervta.pbzchgretzou.qr> <48907080.8020207@trash.net> <alpine.LNX.1.10.0807300951200.30006@fbirervta.pbzchgretzou.qr> <489075F9.9040504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57985 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbYGaHDB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:03:01 -0400
In-Reply-To: <489075F9.9040504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Wednesday 2008-07-30 09:45, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>> commit 8219a9d65fe583de06c2ff4e84d1ea299955184b
>>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>>> Date:   Wed Jul 30 08:36:33 2008 -0400
>>>>
>>>> src: remove dependency on libiptc headers
>>>>
>>>> struct xt_rateest_match_info {
>>>> -    char            name1[IFNAMSIZ];
>>>> -    char            name2[IFNAMSIZ];
>>>> +    char            name1[16];
>>>> +    char            name2[16];
>>> Seems unrelated and I don't want to apply this change.
>>> Please remove the IFNAMSIZ changes.
>>
>> Then I would have to add linux/if.h everywhere.
> 
> Fine with me. Going towards more magic values is never
> a good idea :)

Better include net/if.h which is include in a normal development setup
(libc6-dev package in debian).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
