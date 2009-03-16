From: Patrick McHardy <kaber@trash.net>
Subject: Re: (pull) pending patches
Date: Mon, 16 Mar 2009 14:39:11 +0100
Message-ID: <49BE567F.1020704@trash.net>
References: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr> <49BE0FF3.5090906@netfilter.org> <alpine.LSU.2.00.0903161153030.26752@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPNjQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:39:16 -0400
In-Reply-To: <alpine.LSU.2.00.0903161153030.26752@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-03-16 09:38, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
>>> index f0a2369..b5f8028 100644
>>> --- a/extensions/libipt_DNAT.c
>>> +++ b/extensions/libipt_DNAT.c
>>> @@ -6,8 +6,9 @@
>>>  #include <getopt.h>
>>>  #include <xtables.h>
>>>  #include <iptables.h> /* get_kernel_version */
>>> +#include <limits.h> /* INT_MAX in ip_tables.h */
>>>  #include <linux/netfilter_ipv4/ip_tables.h>
>>> -#include <linux/netfilter/nf_nat.h>
>>> +#include <net/netfilter/nf_nat.h>
>> I thought that kernel headers under net/ are not ever exported to
>> userspace ?
> 
> You are correct, of course. But ipt_SAME.h (which is exported) wants
> struct nf_nat_range, and this is defined in nf_nat.h.

We used to have ip_nat_range(_compat) for compatibility for that reason
IIRC. The kernel doesn't need anymore, so I think userspace should carry
a copy as long as ipt_SAME is still supported.
