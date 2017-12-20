From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter : add NAT support for shifted portmap ranges
Date: Wed, 20 Dec 2017 23:16:13 +0100
Message-ID: <20171220221613.4qnsjny2gackyykb@salvia>
References: <3d98278c-6c33-72e1-163d-2f6270060620@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Thierry Du Tre <thierry@dtsystems.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755691AbdLTWQT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 17:16:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD35AEAA77
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 23:16:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C8A3F7306
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 23:16:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <3d98278c-6c33-72e1-163d-2f6270060620@dtsystems.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 20, 2017 at 01:28:09PM +0100, Thierry Du Tre wrote:
> This is a patch proposal to support shifted ranges in portmaps.
> (i.e. tcp/udp incoming port 5000-5100 on WAN redirected to LAN
> 192.168.1.5:2000-2100)
> 
> Currently DNAT only works for single port or identical port ranges.
> (i.e. ports 5000-5100 on WAN interface redirected to a LAN host while
> original destination port is not altered)
> When different port ranges are configured, either 'random' mode should be
> used, or else all incoming connections are mapped onto the first port in the
> redirect range. (in described example WAN:5000-5100 will all be mapped to
> 192.168.1.5:2000)

This behaviour you describe above also applies to the current
portmapping we do, right?

One more comment below.

> This patch introduces a new mode indicated by flag NF_NAT_RANGE_PROTO_OFFSET
> which uses a base port value to calculate an offset with the destination
> port present in the incoming stream. That offset is then applied as index
> within the redirect port range (index modulo rangewidth to handle range
> overflow).
> 
> In described example the base port would be 5000. An incoming stream with
> destination port 5004 would result in an offset value 4 which means that the
> NAT'ed stream will be using destination port 2004.
> 
> Other possibilities include deterministic mapping of larger or multiple
> ranges to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN port
> 5*xx to port 51xx)
> 
> This patch does not change any current behavior. It just adds new NAT proto
> range functionality which must be selected via the specific flag when
> intended to use.
> 
> A patch for iptables (libipt_DNAT.c) will also be proposed which makes this
> functionality immediately available.
> 
> Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>
> 
> ---
>  include/uapi/linux/netfilter/nf_nat.h | 5 ++++-
>  net/netfilter/nf_nat_core.c           | 7 ++++---
>  net/netfilter/nf_nat_proto_common.c   | 5 ++++-
>  net/netfilter/xt_nat.c                | 1 +
>  4 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_nat.h
> b/include/uapi/linux/netfilter/nf_nat.h
> index a33000d..5b3952b 100644
> --- a/include/uapi/linux/netfilter/nf_nat.h
> +++ b/include/uapi/linux/netfilter/nf_nat.h
> @@ -10,6 +10,7 @@
>  #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
>  #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
>  #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
> +#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
> 
>  #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
>  	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
> @@ -17,7 +18,7 @@
>  #define NF_NAT_RANGE_MASK					\
>  	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
>  	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
> -	 NF_NAT_RANGE_PROTO_RANDOM_FULLY)
> +	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
> 
>  struct nf_nat_ipv4_range {
>  	unsigned int			flags;
> @@ -25,6 +26,7 @@ struct nf_nat_ipv4_range {
>  	__be32				max_ip;
>  	union nf_conntrack_man_proto	min;
>  	union nf_conntrack_man_proto	max;
> +	union nf_conntrack_man_proto	base;
>  };

This one is exposed to userspace, therefore, this will break backward
compatibility in iptables.

You will need to add a revision in xt_nat, and some compat code all
over the place.
