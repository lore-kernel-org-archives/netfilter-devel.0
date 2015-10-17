From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Need net-next in nf-next for netfilter ipv6 frag patchset
Date: Sat, 17 Oct 2015 13:05:16 +0200
Message-ID: <20151017110516.GA1841@salvia>
References: <20151017090047.GB30789@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45541 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbbJQK6M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Oct 2015 06:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20151017090047.GB30789@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 17, 2015 at 11:00:47AM +0200, Florian Westphal wrote:
> Hi Pablo
> 
> Please consider pulling net-next into nf-next tree to obtain
> commit
> 
> ipv6: Pass struct net into nf_ct_frag6_gather
> 
> There are bugs in openvswitch ipv6 defragmentation that are better
> resolved on netfilter side (also simplifies nf side).
> 
> Problem is that these patches don't apply cleanly to net-next.
> So I can either send what I have and Dave will need to resolve
> the (easy) conflicts, or I can rebase it on nf-next once you
> pulled in the net change.

Please, let me follow up now with a pull request for David with the
batch that I have accumulated up to this point. Then, I'll be
refreshing the nf-next tree.

It will require some little wait though, let me know if this is fine
to you, thanks.
