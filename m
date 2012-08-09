From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] extensions: add IPv6 MASQUERADE extension
Date: Thu, 9 Aug 2012 23:22:59 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208092319250.25804@stinky-local.trash.net>
References: <1344543073-11660-1-git-send-email-kaber@trash.net>
 <1344543073-11660-3-git-send-email-kaber@trash.net>
 <alpine.LNX.2.01.1208092310250.10514@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33006 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2HIVXB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:23:01 -0400
In-Reply-To: <alpine.LNX.2.01.1208092310250.10514@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 9 Aug 2012, Jan Engelhardt wrote:

>
> On Thursday 2012-08-09 22:11, kaber@trash.net wrote:
>> +static void MASQUERADE_help(void)
>> +{
>> +	printf(
>> +"MASQUERADE target options:\n"
>> +" --to-ports <port>[-<port>]\n"
>> +"				Port (range) to map to.\n"
>> +" --random\n"
>> +"				Randomize source port.\n");
>> +}
>> +
>> +static const struct xt_option_entry MASQUERADE_opts[] = {
>> +	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
>> +	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
>> +	XTOPT_TABLEEND,
>> +};
>
> You could use .type = XTTYPE_PORTRC (port range)...
> though arguably iptables already did a bad job at selecting
> a suitable syntax for ranges.

I kept the syntax similar to the IPv4 targets. I think its going to be
confusing to remember which one takes which syntax.

>> +/* Parses ports */
>
> I don't think such a comment is needed ;)

Removed.

>> +static struct xtables_target masquerade_tg_reg = {
>> +	.name		= "MASQUERADE",
>> +	.version	= XTABLES_VERSION,
>> +	.family		= NFPROTO_IPV6,
>> +	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
>> +	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
>> +	.help		= MASQUERADE_help,
>> +	.x6_parse	= MASQUERADE_parse,
>> +	.print		= MASQUERADE_print,
>> +	.save		= MASQUERADE_save,
>> +	.x6_options	= MASQUERADE_opts,
>> +};
>
> Is it perhaps feasible to rename libipt_DNAT.c to libxt_DNAT.c
> and thus have the v4 and v6 parts in the same file? In userspace
> we do not have to fear depending on ipv6.ko like for kernel modules.

I did that at first, but they use different structures 
(nf_nat_ipv4_multi_range_compat vs. nf_nat_range), so there's actually
almost no code which can be shared.
