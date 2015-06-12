From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: bridge: restore vlan tag when refragmenting
Date: Fri, 12 Jun 2015 14:31:48 +0200
Message-ID: <20150612123148.GB13790@salvia>
References: <1433503633-16312-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbbFLM0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:26:36 -0400
Content-Disposition: inline
In-Reply-To: <1433503633-16312-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 05, 2015 at 01:27:13PM +0200, Florian Westphal wrote:
> If bridge netfilter is used with both
> bridge-nf-call-iptables and bridge-nf-filter-vlan-tagged enabled
> then ip fragments in VLAN frames are sent without the vlan header.
> 
> This has never worked reliably.  Turns out this relied on pre-3.5
> behaviour where skb frag_list was used to store ip fragments;
> ip_fragment() then re-used these skbs.
> 
> But since commit 3cc4949269e01f39443d0fcfffb5bc6b47878d45
> ("ipv4: use skb coalescing in defragmentation") this is no longer
> the case.  ip_do_fragment now needs to allocate new skbs, but these
> don't contain the vlan tag information anymore.
> 
> Fix it by storing vlan information of the ressembled skb in the
> br netfilter percpu frag area, and restore them for each of the
> fragments.
> 
> Fixes: 3cc4949269e01f3 ("ipv4: use skb coalescing in defragmentation")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied to nf-next. Thanks Florian.
