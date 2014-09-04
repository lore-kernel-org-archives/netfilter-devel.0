From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v4 5/5] netfilter: nft_nat: add masquerade
 support
Date: Thu, 4 Sep 2014 14:40:36 +0200
Message-ID: <20140904124036.GA16426@salvia>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120710.5971.32117.stgit@nfdev.cica.es>
 <20140904122150.GF29395@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36423 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbaIDMjw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:39:52 -0400
Content-Disposition: inline
In-Reply-To: <20140904122150.GF29395@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 01:21:51PM +0100, Patrick McHardy wrote:
> On Thu, Sep 04, 2014 at 02:07:21PM +0200, Arturo Borrero Gonzalez wrote:
> > This patch adds masquerade support to nft_nat.
> > 
> > Note that enum nf_nat_manip_type is replaced by enum nft_nat_types in order
> > to support masquerade.
> 
> Is it really worth combining them? We have lots of code churn to move
> them into a single module, and static NAT and masquerading have some
> fundamental differences in the data they need, so now we're adding
> new code to validate all of this, we're adding a new NAT type which
> is actually not a new NAT type but simply a special case of SNAT etc.
> 
> Why not simply create a new masquerade expression?

Indeed. We're going to have four unused fields in the nft_nat
expression:

+       enum nft_registers      sreg_addr_min:8;
+       enum nft_registers      sreg_addr_max:8;
+       enum nft_registers      sreg_proto_min:8;
+       enum nft_registers      sreg_proto_max:8;

And we can skip the nft_nat per family split that happens in patch 4/5.

I like the idea of the masquerade expression.
