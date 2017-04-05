From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/1] netfilter: Remove useless variable timeouts
 in init_conntrack
Date: Wed, 5 Apr 2017 15:17:28 +0200
Message-ID: <20170405131728.GA15315@breakpoint.cc>
References: <1491367754-16976-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40854 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755073AbdDENSc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2017 09:18:32 -0400
Content-Disposition: inline
In-Reply-To: <1491367754-16976-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

gfree.wind@foxmail.com <gfree.wind@foxmail.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> All l4_proto->new callbacks don't use the param timeouts currently,
> so remove it from param list. Then the variable timeouts isn't used
> as right value in init_conntrack, so remove it too.
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c |  2 +-
>  net/netfilter/nf_conntrack_core.c            | 13 ++-----------
>  net/netfilter/nf_conntrack_proto_dccp.c      |  2 +-
>  net/netfilter/nf_conntrack_proto_sctp.c      |  2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c       |  2 +-
>  net/netfilter/nf_conntrack_proto_udp.c       |  2 +-
>  7 files changed, 8 insertions(+), 17 deletions(-)

What about net/netfilter/nf_conntrack_proto_gre.c ?
