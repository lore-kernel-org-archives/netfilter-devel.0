From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 02/32]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4
Date: Tue, 25 Mar 2008 16:26:58 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803251626000.9368@fbirervta.pbzchgretzou.qr>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain> <20080325141453.10539.53690.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39206 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYCYP07 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:26:59 -0400
In-Reply-To: <20080325141453.10539.53690.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-03-25 15:14, Patrick McHardy wrote:
> +
> +static inline void nf_ct_dump_tuple(const struct nf_conntrack_tuple *t)
> +{
> +	switch (t->src.l3num) {
> +	case AF_INET:
> +		nf_ct_dump_tuple_ip(t);
> +		break;
> +	case AF_INET6:
> +		nf_ct_dump_tuple_ipv6(t);
> +		break;
> +	}
> +}
> +
> +#define NF_CT_DUMP_TUPLE(tp)	nf_ct_dump_tuple(tp)

I think it would be wiser just to remove this macro and
convert all kernel users to lowercase -- there are only
kernel users I guess, since include/net/ is not exported
to userspace AFAICS.
