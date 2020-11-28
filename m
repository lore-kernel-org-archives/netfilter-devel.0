Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBADC63777
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 00:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA0622242
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 00:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjLWmI24"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbgK1AJG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Nov 2020 19:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbgK1AHX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Nov 2020 19:07:23 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8122223F;
        Sat, 28 Nov 2020 00:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606522012;
        bh=vKtuflB+uX//47kPExVKZUpC7QhQUKuvAV4+YCehQ8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UjLWmI24e0g6nPlixMKB3jCxjmT5sMd4dwJmzpJzA38AaBYtA362ktn3V1tJoSghO
         srdfJtBGm0YHOww5S3bUJWPxZ3lfA+5l2xL4J041BInnSb4EorZ3yTCsF1yO5PsSbn
         sK5ptL/poB54WNbp13c2RbqbAoLcefp05xnPEsbI=
Date:   Fri, 27 Nov 2020 16:06:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Antoine Tenart <atenart@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, sbrivio@redhat.com
Subject: Re: [PATCH net-next] netfilter: bridge: reset skb->pkt_type after
 NF_INET_POST_ROUTING traversal
Message-ID: <20201127160650.1f36b889@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201123183253.GA2730@breakpoint.cc>
References: <20201123174902.622102-1-atenart@kernel.org>
        <20201123183253.GA2730@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 23 Nov 2020 19:32:53 +0100 Florian Westphal wrote:
> Antoine Tenart <atenart@kernel.org> wrote:
> > Netfilter changes PACKET_OTHERHOST to PACKET_HOST before invoking the
> > hooks as, while it's an expected value for a bridge, routing expects
> > PACKET_HOST. The change is undone later on after hook traversal. This
> > can be seen with pairs of functions updating skb>pkt_type and then
> > reverting it to its original value:
> > 
> > For hook NF_INET_PRE_ROUTING:
> >   setup_pre_routing / br_nf_pre_routing_finish
> > 
> > For hook NF_INET_FORWARD:
> >   br_nf_forward_ip / br_nf_forward_finish
> > 
> > But the third case where netfilter does this, for hook
> > NF_INET_POST_ROUTING, the packet type is changed in br_nf_post_routing
> > but never reverted. A comment says:
> > 
> >   /* We assume any code from br_dev_queue_push_xmit onwards doesn't care
> >    * about the value of skb->pkt_type. */  
> 
> [..]
> > But when having a tunnel (say vxlan) attached to a bridge we have the
> > following call trace:  
> 
> > In this specific case, this creates issues such as when an ICMPv6 PTB
> > should be sent back. When CONFIG_BRIDGE_NETFILTER is enabled, the PTB
> > isn't sent (as skb_tunnel_check_pmtu checks if pkt_type is PACKET_HOST
> > and returns early).
> > 
> > If the comment is right and no one cares about the value of
> > skb->pkt_type after br_dev_queue_push_xmit (which isn't true), resetting
> > it to its original value should be safe.  
> 
> That comment is 18 years old, safe bet noone thought of
> ipv6-in-tunnel-interface-added-as-bridge-port back then.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Sounds like a fix. Probably hard to pin point which commit to blame,
but this should go to net, not net-next, right?
