From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 16:44:00 +0100
Message-ID: <20170322154400.GB8584@breakpoint.cc>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759742AbdCVPp4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 11:45:56 -0400
Content-Disposition: inline
In-Reply-To: <20170322153204.GA22898@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hm, I wonder why you need this new line in proto_inet_service:
> 
> +         PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),

meta_expr_pctx_update calls proto_find_upper(), without this
that returns NULL and proto base is set to 'unknown'.

