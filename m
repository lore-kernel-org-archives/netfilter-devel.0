From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ebtables: Add filter for matching on a string
Date: Thu, 21 Dec 2017 09:17:27 +0100
Message-ID: <20171221081727.pih6bxkhky62vodf@salvia>
References: <20171221000135.5755-1-bernie.harris@alliedtelesis.co.nz>
 <20171221000852.kqda4lumixcgwzmf@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de
To: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbdLUIRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 03:17:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 291BFB6B8F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:17:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BAC51150D1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:17:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171221000852.kqda4lumixcgwzmf@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again,

On Thu, Dec 21, 2017 at 01:08:52AM +0100, Pablo Neira Ayuso wrote:
> > diff --git a/net/bridge/netfilter/ebt_string.c b/net/bridge/netfilter/ebt_string.c
> > new file mode 100644
> > index 000000000000..66770506d3a3
> > --- /dev/null
> > +++ b/net/bridge/netfilter/ebt_string.c
> > @@ -0,0 +1,65 @@
> > +/*
> > + * string
> > + *
> > + * Author:
> > + * Bernie Harris bernie.harris@alliedtelesis.co.nz
> > + *
> > + * October 2017
> > + *
> > + */
> > +#include <linux/module.h>
> > +#include <linux/netfilter/x_tables.h>
> > +#include <linux/netfilter_bridge/ebtables.h>
> > +#include <linux/netfilter_bridge/ebt_string.h>
> > +
> > +static bool
> > +ebt_string_mt(const struct sk_buff *skb, struct xt_action_param *par)
> > +{
> > +	const struct ebt_string_info *info = par->matchinfo;
> > +	unsigned char buf[MAX_STRING_OCTETS + 1];
> > +	unsigned char *match_start;
> > +	int i;
> > +	int offset = skb_network_offset(skb) + info->offset;
> > +
> > +	if (offset + info->length >= skb->len)
> > +		return false;
> > +
> > +	match_start = skb_header_pointer(skb, offset, info->length, buf);
> > +
> > +	for (i = 0; i < info->length; i++) {
> > +		if (*(match_start + i) != info->string[i])
> > +			return false;
> > +	}
> 
> I would prefer something that converges with net/netfilter/xt_string.c

This oneliner that I'm attaching plus code in ebtables userspace (see
iptables/extensions/libxt_string.c for rerefence) to add support for
the string match in ebtables should suffice.

Thanks.
