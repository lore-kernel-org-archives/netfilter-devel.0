From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_ct: add zone id set support
Date: Wed, 8 Feb 2017 10:29:29 +0100
Message-ID: <20170208092929.GC28205@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-4-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932909AbdBHJ3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 04:29:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E07C1373AD
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EF54BAAA0
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29A3ABAAA6
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203123556.17357-4-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 01:35:50PM +0100, Florian Westphal wrote:
> zones allow tracking multiple connections sharing identical tuples,
> this is needed e.g. when tracking distinct vlans with overlapping ip
> addresses (conntrack is l2 agnostic).
> 
> Thus the zone has to be set before the packet is picked up by the
> connection tracker.  This is done by means of 'conntrack templates' which
> are conntrack structures used solely to pass this info from one netfilter
> hook to the next.
> 
> The iptables CT target instantiates these connection tracking templates
> once per rule, i.e. the template is fixed/tied to particular zone, can
> be read-only and therefore be re-used by as many skbs simultaneously as
> needed.
> 
> We can't follow this model because we want to take the zone id from
> an sreg at rule eval time so we could e.g. fill in the zone id from
> the packets vlan id or a e.g. nftables key : value maps.
> 
> To avoid cost of per packet alloc/free of the template, use a percpu
> template 'scratch' object and use the refcount to detect the (unlikely)
> case where the template is still attached to another skb (i.e., previous
> skb was nfqueued ...).

Applied, thanks!
