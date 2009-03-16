From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: (pull) pending patches
Date: Mon, 16 Mar 2009 11:54:52 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903161153030.26752@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr> <49BE0FF3.5090906@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZCPKy4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:54:56 -0400
In-Reply-To: <49BE0FF3.5090906@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-16 09:38, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
>> index f0a2369..b5f8028 100644
>> --- a/extensions/libipt_DNAT.c
>> +++ b/extensions/libipt_DNAT.c
>> @@ -6,8 +6,9 @@
>>  #include <getopt.h>
>>  #include <xtables.h>
>>  #include <iptables.h> /* get_kernel_version */
>> +#include <limits.h> /* INT_MAX in ip_tables.h */
>>  #include <linux/netfilter_ipv4/ip_tables.h>
>> -#include <linux/netfilter/nf_nat.h>
>> +#include <net/netfilter/nf_nat.h>
>
>I thought that kernel headers under net/ are not ever exported to
>userspace ?

You are correct, of course. But ipt_SAME.h (which is exported) wants
struct nf_nat_range, and this is defined in nf_nat.h.
