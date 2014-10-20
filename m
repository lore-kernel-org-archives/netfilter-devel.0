From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-compat PATCH 1/3] ebtables-compat: fix print_header
Date: Mon, 20 Oct 2014 11:04:31 +0200
Message-ID: <20141020090431.GA5031@salvia>
References: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
 <20141020090142.GA4977@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaJTJDD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:03:03 -0400
Content-Disposition: inline
In-Reply-To: <20141020090142.GA4977@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 11:01:42AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 16, 2014 at 04:29:51PM +0200, Giuseppe Longo wrote:
> > This prints the header like ebtables.
> 
> Applied to the ebtables-compat branch. Thanks.

I forgot to say that I made a quick change, so the iptables/nft.c code
remains family agnostic.

See the new .print_table_header callback:

http://git.netfilter.org/iptables/commit/?h=ebtables-compat-experimental3&id=457c2065827cc05a4c30e27fd57da998550dd078
