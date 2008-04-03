From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 14/24] [NETFILTER]: Use bool in nf_conntrack_l4proto
Date: Thu, 03 Apr 2008 17:00:19 +0200
Message-ID: <47F4F103.5070007@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <3fe7a3dd723a0f2c303559ef46e3d7d67702db57.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYDCPAY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:00:24 -0400
In-Reply-To: <3fe7a3dd723a0f2c303559ef46e3d7d67702db57.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack_l4proto.h   |   13 ++--
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   25 ++++----
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   27 ++++-----
>  net/netfilter/nf_conntrack_proto_generic.c     |   20 +++---
>  net/netfilter/nf_conntrack_proto_gre.c         |   25 ++++----
>  net/netfilter/nf_conntrack_proto_sctp.c        |   33 +++++------
>  net/netfilter/nf_conntrack_proto_tcp.c         |   48 +++++++---------
>  net/netfilter/nf_conntrack_proto_udp.c         |   21 +++----
>  net/netfilter/nf_conntrack_proto_udplite.c     |   22 ++++----

ERROR: use tabs not spaces
#13: FILE: include/net/netfilter/nf_conntrack_l4proto.h:29:
+^I                     struct nf_conntrack_tuple *tuple);$

ERROR: use tabs not spaces
#21: FILE: include/net/netfilter/nf_conntrack_l4proto.h:35:
+^I                     const struct nf_conntrack_tuple *orig);$

ERROR: use tabs not spaces
#32: FILE: include/net/netfilter/nf_conntrack_l4proto.h:48:
+^I            unsigned int dataoff);$

<hundreds more>

Jan, applying your patches is getting too much work, I'm
dropping everything I haven't applied yet. Your other patches
also have checkpatch errors, I'll fix those up :|

Some hints for the future to make this easier for both of us:

- submit small batches, split into logical units

- don't mix cleanups with real changes

- avoid style changes like this, especially when the entire file
   uses a consistent style:

> -static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
> -			       unsigned int dataoff,
> -			       struct nf_conntrack_tuple *tuple)
> +static bool
> +icmpv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
> +                    struct nf_conntrack_tuple *tuple)

- run checkpatch

- run sparse with endian checks

- compile test all the code your changing, including CONFIG_COMPAT

