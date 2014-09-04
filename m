From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH v4 5/5] netfilter: nft_nat: add masquerade
 support
Date: Thu, 4 Sep 2014 13:21:51 +0100
Message-ID: <20140904122150.GF29395@acer.localdomain>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120710.5971.32117.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIDMV5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:21:57 -0400
Content-Disposition: inline
In-Reply-To: <20140904120710.5971.32117.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 02:07:21PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds masquerade support to nft_nat.
> 
> Note that enum nf_nat_manip_type is replaced by enum nft_nat_types in order
> to support masquerade.

Is it really worth combining them? We have lots of code churn to move
them into a single module, and static NAT and masquerading have some
fundamental differences in the data they need, so now we're adding
new code to validate all of this, we're adding a new NAT type which
is actually not a new NAT type but simply a special case of SNAT etc.

Why not simply create a new masquerade expression?
