From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: tcp/udp: Only get 4 bytes to get tcp/udp
 ports
Date: Sat, 23 Jul 2016 12:29:52 +0200
Message-ID: <20160723102952.GB3204@salvia>
References: <1469203162-12717-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbcGWKaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:30:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 90C94E7DA8
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:30:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82D36FC61E
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:30:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6ED82FAB58
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:29:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469203162-12717-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 11:59:22PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> We use tcp/udp_pkt_to_tuple to get the ports of tcp/udp.
> Actually only need to get 4 bytes by skb_header_pointer instead
> of 8 bytes.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Use 4 bytes intead of 8 bytes, and add more description
>  v1: Initial Patch
> 
>  net/netfilter/nf_conntrack_proto_tcp.c | 4 ++--
>  net/netfilter/nf_conntrack_proto_udp.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 70c8381..4abe9e1 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c

Could you also review other existing trackers? eg. SCTP.
