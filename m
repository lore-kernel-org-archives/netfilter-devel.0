From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:nf_tables-experiments PATCH 3/4] nf_tables: Add
 support for IPv6 NAT expression
Date: Thu, 15 Nov 2012 13:47:12 +0100
Message-ID: <20121115124712.GA4084@1984>
References: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1352970952-3447-4-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20121115122908.GB2271@1984>
 <50A4E3AB.3080703@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51483 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767694Ab2KOMrY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:47:24 -0500
Content-Disposition: inline
In-Reply-To: <50A4E3AB.3080703@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 02:44:27PM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>  #include <linux/netfilter_ipv4.h>
> >>>@@ -26,8 +27,10 @@
> >>>  #include <net/ip.h>
> >>>  >  struct nft_nat {
> >>>-	enum nft_registers      sreg_addr_min:8;
> >>>-	enum nft_registers      sreg_addr_max:8;
> >>>+	enum nft_registers      sreg_addr_min_v4:8;
> >>>+	enum nft_registers      sreg_addr_max_v4:8;
> >>>+	enum nft_registers      sreg_addr_min_v6:8;
> >>>+	enum nft_registers      sreg_addr_max_v6:8;
> >Suggestion: Couldn't we get this patch a bit smaller by adding int
> >family and the NFTA_NAT_FAMILY attribute?
> 
> Why not, at least semantically it could look better indeed, though
> from struct size point of view it won't change anything.
> The logic for parsing NFTA would be easier too.
> 
> Let's do this.

Great, thanks a lot.
