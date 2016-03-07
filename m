From: Patrick McHardy <kaber@trash.net>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Mon, 7 Mar 2016 14:20:12 +0100
Message-ID: <20160307132011.GA7620@macbook.localdomain>
References: <56DAC502.2060809@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: christophe leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50007 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcCGNUQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:20:16 -0500
Content-Disposition: inline
In-Reply-To: <56DAC502.2060809@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.03, christophe leroy wrote:
> Hello,
> 
> I'm trying to implement support for CT HELPERs in linux kernel for
> nftables and need some help/guidance.
> 
> The rule beeing 'udp dport tftp ct helper set "tftp"', I get
> nft_ct_set_init() called when I add the rule in the table output filter
> table.
> 
> I believe I have to call nf_ct_helper_ext_add() from nft_ct_set_init(),
> but for that I need the name of the helper that is to be set, ie 'tftp'.
> How do I get the name of the requested helper in that function ? I
> suppose once I get it I can do the same as  xt_ct_set_helper() does.

This depends on how we want to implement this. We could pass a static helper
name in a new CT attribute, look the helper up in the init path and assign it
to the conntrack in the eval function. This means we'd require a single rule
for every helper assignment.

Alternatively we could pass the helper name in a register and do the lookup
at runtime, that would allow to use maps for helper assignment, IOW:

ct set helper tcp dport { 21 : ftp, 5060 : sip, ... }

Since helper assignment should probably also do a module load, I'm leaning
towards the first possibility. If we still want to do map based assignements,
we could use maps of CT expressions, similar to what we do with dynset but
with statically initialized expressions.
