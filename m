From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/3] netfilter: nf_conntrack: add direction support
 for zones
Date: Wed, 12 Aug 2015 19:48:05 +0200
Message-ID: <20150812174805.GA31037@salvia>
References: <cover.1439059434.git.daniel@iogearbox.net>
 <b251daed7eaaaf751e0bf0104389e57876d5a1ba.1439059435.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58591 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbHLRlz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:41:55 -0400
Content-Disposition: inline
In-Reply-To: <b251daed7eaaaf751e0bf0104389e57876d5a1ba.1439059435.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Daniel,

I have applied 1/3 so you don't need to resend, but I still need one
more change in this patch, see below.

On Sat, Aug 08, 2015 at 09:40:02PM +0200, Daniel Borkmann wrote:
> diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> index acad6c5..3bf4cb0 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> @@ -53,6 +53,7 @@ enum ctattr_type {
>  	CTA_MARK_MASK,
>  	CTA_LABELS,
>  	CTA_LABELS_MASK,
> +	CTA_TUPLE_ZONE,

I remember to have suggested to place this in ctattr_tuple:

http://www.spinics.net/lists/netfilter-devel/msg37593.html

The zone is part of the tuple in an optional fashion, so it should
appear there. The direction is already implicit based on
CTA_TUPLE_ORIG or CTA_TUPLE_REPLY.

>  	__CTA_MAX
>  };
>  #define CTA_MAX (__CTA_MAX - 1)
> @@ -260,4 +261,19 @@ enum ctattr_expect_stats {
>  };
>  #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
>  
> +enum ctattr_zone {
> +	CTA_ZONE_UNSPEC,
> +	CTA_ZONE_DIR,
> +	__CTA_ZONE_MAX,
> +};
> +#define CTA_ZONE_MAX (__CTA_ZONE_MAX - 1)
> +
> +enum ctattr_zone_dir {
> +	CTA_ZONE_DIR_UNSPEC,
> +	CTA_ZONE_DIR_ORIG,
> +	CTA_ZONE_DIR_REPL,
> +	__CTA_ZONE_DIR_MAX
> +};
> +#define CTA_ZONE_DIR_MAX (__CTA_ZONE_DIR_MAX - 1)

With the change above we can skip this CTA_ZONE_DIR.

> +
>  #endif /* _IPCONNTRACK_NETLINK_H */
[...]
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 28c8b2b..5d81b99 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -143,7 +143,20 @@ static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_ZONES
>  static void ct_show_zone(struct seq_file *s, const struct nf_conn *ct)
>  {
> -	seq_printf(s, "zone=%u ", nf_ct_zone(ct)->id);
> +	const struct nf_conntrack_zone *zone = nf_ct_zone(ct);
> +
> +	seq_printf(s, "zone=%u ", zone->id);
> +
> +	switch (zone->dir) {
> +	case NF_CT_ZONE_DIR_ORIG:
> +		seq_puts(s, "zone-dir=ORIGINAL ");
> +		break;
> +	case NF_CT_ZONE_DIR_REPL:
> +		seq_puts(s, "zone-dir=REPLY ");
> +		break;

I'd suggest the output shows the zone on the corresponding tuple, eg.
in case it only applies to the original tuple:

udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone=1 \
               src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1

We have a more compact output IMO.

Please, don't forget that you also have to update
libnetfilter_conntrack and conntrack to get this feature available
from there. I'll take this patchset to the kernel so you have the time
to update the userspace side later on without blocking this further.

Thanks.
