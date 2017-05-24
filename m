From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Wed, 24 May 2017 17:43:02 +0200
Message-ID: <20170524154302.GE11547@breakpoint.cc>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        arturo@debian.org, fw@strlen.de
To: Shyam Saini <mayhs11saini@gmail.com>, g@breakpoint.cc
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45030 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752492AbdEXPnJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 11:43:09 -0400
Content-Disposition: inline
In-Reply-To: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shyam Saini <mayhs11saini@gmail.com> wrote:
> Add translation for cluster to nft
> 
> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
> 0xdeadbeef -j MARK --set-mark 0xffff
> 
> nft add rule ip mangle PREROUTING iifname eth1 ct state {new,established, related, untracked} ct direction original mark set jhash ip saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff

Can you explain why ct expression is needed in this way?

afaics translation would be (untested):

nft add rule ip mangle PREROUTING iifname eth1 mark set jhash ct saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff fib saddr type multicast meta pkttype set host

we might need to implement "ct master-saddr" to deal with ct->master use
in xt_cluster as well, but we could do that later as a followup.

fib saddr type is needed to not set real mutlicast traffic to unicast
type and only catch l3-unicast-in-l2-multicast.
