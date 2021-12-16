Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8684CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 15:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbhLPPEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbhLPPEJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 10:04:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728AC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 07:04:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mxsIg-0005Bh-9l; Thu, 16 Dec 2021 16:04:06 +0100
Date:   Thu, 16 Dec 2021 16:04:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nat: force port remap to
 prevent shadowing well-known ports
Message-ID: <YbtVZplqiYb4OHic@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Eric Garver <eric@garver.life>
References: <20211215122026.20850-1-fw@strlen.de>
 <20211215122026.20850-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215122026.20850-3-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 15, 2021 at 01:20:26PM +0100, Florian Westphal wrote:
[...]
> @@ -507,11 +539,17 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
>  		 struct nf_conn *ct,
>  		 enum nf_nat_manip_type maniptype)
>  {
> +	bool random_port = range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL;
>  	const struct nf_conntrack_zone *zone;
>  	struct net *net = nf_ct_net(ct);
>  
>  	zone = nf_ct_zone(ct);
>  
> +	if (maniptype == NF_NAT_MANIP_SRC &&
> +	    !ct->local_origin &&
> +	    tuple_force_port_remap(orig_tuple))
> +		random_port = true;

	if (maniptype == NF_NAT_MANIP_SRC && !ct->local_origin)
		random_port = random_port || tuple_force_port_remap(orig_tuple);

Maybe? This avoids calling tuple_force_port_remap() if the flag is set.

Cheers, Phil
