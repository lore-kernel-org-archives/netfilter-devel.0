From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: install nf_nat.h and nf_conntrack_tuple.h
 to INSTALL_HDR_PATH
Date: Mon, 12 Sep 2011 10:38:39 +0200
Message-ID: <20110912083839.GA2017@1984>
References: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38276 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1ILIio (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:38:44 -0400
Content-Disposition: inline
In-Reply-To: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anthony,

Thanks for taking the time to fix this. Some comments:

On Thu, Sep 08, 2011 at 08:16:17PM -0400, Anthony G. Basile wrote:
> diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
> index a1b410c..e9ee3eb 100644
> --- a/include/linux/netfilter/Kbuild
> +++ b/include/linux/netfilter/Kbuild
> @@ -5,6 +5,8 @@ header-y += nf_conntrack_ftp.h
>  header-y += nf_conntrack_sctp.h
>  header-y += nf_conntrack_tcp.h
>  header-y += nf_conntrack_tuple_common.h
> +header-y += nf_conntrack_tuple.h

I think exporting nf_conntrack_tuple.h is too much, let me suggest
some alternative.

> +header-y += nf_nat.h
>  header-y += nfnetlink.h
>  header-y += nfnetlink_compat.h
>  header-y += nfnetlink_conntrack.h
> diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
> new file mode 100644
> index 0000000..73c1946
> --- /dev/null
> +++ b/include/linux/netfilter/nf_nat.h
> @@ -0,0 +1,52 @@
> +#ifndef _NF_NAT_H
> +#define _NF_NAT_H
> +#include <linux/netfilter_ipv4.h>
> +#include <linux/netfilter/nf_conntrack_tuple.h>
> +
> +#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
> +
> +enum nf_nat_manip_type {
> +	IP_NAT_MANIP_SRC,
> +	IP_NAT_MANIP_DST
> +};
> +
> +/* SRC manip occurs POST_ROUTING or LOCAL_IN */
> +#define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
> +			     (hooknum) != NF_INET_LOCAL_IN)
> +
> +#define IP_NAT_RANGE_MAP_IPS 1
> +#define IP_NAT_RANGE_PROTO_SPECIFIED 2
> +#define IP_NAT_RANGE_PROTO_RANDOM 4
> +#define IP_NAT_RANGE_PERSISTENT 8
> +
> +/* NAT sequence number modifications */
> +struct nf_nat_seq {
> +	/* position of the last TCP sequence number modification (if any) */
> +	u_int32_t correction_pos;
> +
> +	/* sequence number offset before and after last modification */
> +	int16_t offset_before, offset_after;
> +};
> +
> +/* Single range specification. */
> +struct nf_nat_range {
> +	/* Set to OR of flags above. */
> +	unsigned int flags;
> +
> +	/* Inclusive: network order. */
> +	__be32 min_ip, max_ip;
> +
> +	/* Inclusive: network order */
> +	union nf_conntrack_man_proto min, max;

Better replace union nf_conntrack_man_proto by __be16, we don't break
binary compatibility and we don't need to export the whole tuple
definitions.
