From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter : add NAT support for shifted portmap ranges
Date: Fri, 12 Jan 2018 01:21:19 +0100
Message-ID: <20180112002119.ta4eodm6uuad27wu@salvia>
References: <728b1f75-3f1b-c137-b2ca-8e0d50c07bce@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Thierry Du Tre (TCH)" <thierry.dutre@technicolor.com>,
        netfilter-devel@vger.kernel.org
To: Thierry Du Tre <thierry@dtsystems.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753998AbeALAVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 19:21:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 869BE4DE721
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 01:21:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74061DA84B
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 01:21:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <728b1f75-3f1b-c137-b2ca-8e0d50c07bce@dtsystems.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thierry,

On Thu, Jan 11, 2018 at 07:42:27PM +0100, Thierry Du Tre wrote:
> This is a patch proposal to support shifted ranges in portmaps.
> 
> (i.e. tcp/udp incoming port 5000-5100 on WAN redirected to LAN
> 192.168.1.5:2000-2100)
> 
> 
> Currently DNAT only works for single port or identical port ranges.
> 
> (i.e. ports 5000-5100 on WAN interface redirected to a LAN host while
> original destination port is not altered)
> 
> When different port ranges are configured, either 'random' mode should be
> used, or else all incoming connections are mapped onto the first port in the
> redirect range. (in described example WAN:5000-5100 will all be mapped to
> 192.168.1.5:2000)
> 
> 
> This patch introduces a new mode indicated by flag NF_NAT_RANGE_PROTO_OFFSET
> which uses a base port value to calculate an offset with the destination
> port present in the incoming stream. That offset is then applied as index
> within the redirect port range (index modulo rangewidth to handle range
> overflow).
> 
> 
> In described example the base port would be 5000. An incoming stream with
> destination port 5004 would result in an offset value 4 which means that the
> NAT'ed stream will be using destination port 2004.
> 
> 
> Other possibilities include deterministic mapping of larger or multiple
> ranges to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN port
> 5*xx to port 51xx)
> 
> 
> This patch does not change any current behavior. It just adds new NAT proto
> range functionality which must be selected via the specific flag when
> intended to use.
> 
> 
> A patch for iptables (libipt_DNAT.c) will also be proposed which makes this
> functionality immediately available.
> 
> 
> Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>
> 
> ---
> Changes in v2:
> 	- added new revision for SNAT and DNAT targets to support the new base port variable in struct nf_nat_range2
> 	- replaced all occurences of struct nf_nat_range with struct nf_nat_range2
> 
>  include/net/netfilter/ipv4/nf_nat_masquerade.h |  2 +-
>  include/net/netfilter/ipv6/nf_nat_masquerade.h |  2 +-
>  include/net/netfilter/nf_nat.h                 |  2 +-
>  include/net/netfilter/nf_nat_l3proto.h         |  4 +-
>  include/net/netfilter/nf_nat_l4proto.h         |  8 +--
>  include/net/netfilter/nf_nat_redirect.h        |  2 +-
>  include/uapi/linux/netfilter/nf_nat.h          | 12 ++++-
>  net/ipv4/netfilter/ipt_MASQUERADE.c            |  2 +-
>  net/ipv4/netfilter/nf_nat_h323.c               |  4 +-
>  net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       |  4 +-
>  net/ipv4/netfilter/nf_nat_masquerade_ipv4.c    |  4 +-
>  net/ipv4/netfilter/nf_nat_pptp.c               |  2 +-
>  net/ipv4/netfilter/nf_nat_proto_gre.c          |  2 +-
>  net/ipv4/netfilter/nf_nat_proto_icmp.c         |  2 +-
>  net/ipv4/netfilter/nft_masq_ipv4.c             |  2 +-
>  net/ipv6/netfilter/ip6t_MASQUERADE.c           |  2 +-
>  net/ipv6/netfilter/nf_nat_l3proto_ipv6.c       |  4 +-
>  net/ipv6/netfilter/nf_nat_masquerade_ipv6.c    |  4 +-
>  net/ipv6/netfilter/nf_nat_proto_icmpv6.c       |  2 +-
>  net/ipv6/netfilter/nft_masq_ipv6.c             |  2 +-
>  net/ipv6/netfilter/nft_redir_ipv6.c            |  2 +-
>  net/netfilter/nf_nat_core.c                    | 27 +++++-----
>  net/netfilter/nf_nat_helper.c                  |  2 +-
>  net/netfilter/nf_nat_proto_common.c            |  9 ++--
>  net/netfilter/nf_nat_proto_dccp.c              |  2 +-
>  net/netfilter/nf_nat_proto_sctp.c              |  2 +-
>  net/netfilter/nf_nat_proto_tcp.c               |  2 +-
>  net/netfilter/nf_nat_proto_udp.c               |  4 +-
>  net/netfilter/nf_nat_proto_unknown.c           |  2 +-
>  net/netfilter/nf_nat_redirect.c                |  6 +--
>  net/netfilter/nf_nat_sip.c                     |  2 +-
>  net/netfilter/nft_nat.c                        |  2 +-
>  net/netfilter/xt_NETMAP.c                      |  8 +--
>  net/netfilter/xt_REDIRECT.c                    |  2 +-
>  net/netfilter/xt_nat.c                         | 72 +++++++++++++++++++++++---
>  35 files changed, 143 insertions(+), 69 deletions(-)
> 
> diff --git a/include/net/netfilter/ipv4/nf_nat_masquerade.h b/include/net/netfilter/ipv4/nf_nat_masquerade.h
> index ebd8694..cd24be4 100644
> --- a/include/net/netfilter/ipv4/nf_nat_masquerade.h
> +++ b/include/net/netfilter/ipv4/nf_nat_masquerade.h
> @@ -6,7 +6,7 @@
>  unsigned int
>  nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
> -		       const struct nf_nat_range *range,
> +		       const struct nf_nat_range2 *range,
>  		       const struct net_device *out);

I think you can get a much smaller patch if you rename the existing
"struct nf_nat_range" to "struct nf_nat_range_old", then the idea is
to dump the old representation into the new one, something like:

        struct nf_nat_range range = {};

        memcpy(&range, range_old, sizeof(range_old));
