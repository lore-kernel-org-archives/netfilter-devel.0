From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_nat: fix oops on netns removal
Date: Mon, 16 Jun 2014 14:00:25 +0200
Message-ID: <20140616120025.GA10876@localhost>
References: <1402168624-10081-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbaFPMAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:00:39 -0400
Content-Disposition: inline
In-Reply-To: <1402168624-10081-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 07, 2014 at 09:17:04PM +0200, Florian Westphal wrote:
> Quoting Samu Kallio:
> 
>  Basically what's happening is, during netns cleanup,
>  nf_nat_net_exit gets called before ipv4_net_exit. As I understand
>  it, nf_nat_net_exit is supposed to kill any conntrack entries which
>  have NAT context (through nf_ct_iterate_cleanup), but for some
>  reason this doesn't happen (perhaps something else is still holding
>  refs to those entries?).
> 
>  When ipv4_net_exit is called, conntrack entries (including those
>  with NAT context) are cleaned up, but the
>  nat_bysource hashtable is long gone - freed in nf_nat_net_exit. The
>  bug happens when attempting to free a conntrack entry whose NAT hash
>  'prev' field points to a slot in the freed hash table (head for that
>  bin).
> 
> We ignore conntracks with null nat bindings.  But this is wrong,
> as these are in bysource hash table as well.
> 
> Restore nat-cleaning for the netns-is-being-removed case.
> 
> bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=65191
> Fixes: c2d421e1718 ('netfilter: nf_nat: fix race when unloading protocol modules')

Applied, thanks!
