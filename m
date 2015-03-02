From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 15:03:12 +0100
Message-ID: <20150302140312.GA22752@salvia>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131853.GP6142@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47296 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbbCBN7f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 08:59:35 -0500
Content-Disposition: inline
In-Reply-To: <20150302131853.GP6142@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 01:19:01PM +0000, Patrick McHardy wrote:
> On 02.03, Pablo Neira Ayuso wrote:
> > Currently, we have four xtables extensions that cannot be used from the
> > xt over nft compat layer. The problem is that they need real access to
> > the full blown xt_entry to validate that the rule comes with the right
> > dependencies. This check was introduced to overcome the lack of
> > sufficient userspace dependency validation in iptables.
> > 
> > To resolve this problem, this patch introduces a new field to the
> > xt_tgchk_param structure that tell us if the target is executed from
> > nft_compat context.
> > 
> > The four affected extensions are:
> > 
> > 1) CLUSTERIP, this target has been superseded by xt_cluster. So just
> >    bail out by returning -EINVAL.
> > 
> > 2) TCPMSS. Relax the checking when used from nft_compat and make sure
> >    that we skip !syn packets in case userspace provides a wrong
> >    configuration.
> > 
> > 3) SYMPROXY6. Don't check for e->ipv6.flags, we can instead check
> >    for e->ipv6.proto as other extensions do, if zero then it doesn't
> >    fulfill the dependency.
> 
> But we don't perform a protocol match in ip6_tables if the IP6T_F_PROTO
> flag is not given. ip6_tables differs from ip_tables in this regard.

This just makes sure that SYNPROXY6 is not called for non-tcp traffic
in the rule loading path, which should be OK.
