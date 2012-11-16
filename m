From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:nf_tables-experiments PATCH - v2 - 0/4] NAT
 expression and IPv6 NAT support
Date: Fri, 16 Nov 2012 08:00:10 +0100
Message-ID: <20121116070010.GA12690@1984>
References: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37047 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2KPHAT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:00:19 -0500
Content-Disposition: inline
In-Reply-To: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 02:24:58PM +0200, Tomasz Bursztyka wrote:
> Hi, 
> 
> same patches as before with modifications applied according to Pablo's comments.
> Patch 3 is therefore much simpler.
> 
> Tomasz Bursztyka (4):
>   nf_tables: Change NFTA_NAT_ attributes to better semantic
>     significance
>   nf_tables: Split IPv4 NAT into NAT expression and NAT IPv4 chain.
>   nf_tables: Add support for IPv6 NAT expression
>   nf_tables: Add support for IPv6 NAT chain

All applied, thanks a lot Tomasz
