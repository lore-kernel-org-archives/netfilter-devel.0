From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [HEADS UP] libnftables renamed to libnftnl
Date: Mon, 20 Jan 2014 15:06:58 +0100
Message-ID: <20140120140658.GA30049@localhost>
References: <20140120121935.GA2794@localhost>
 <52DD2997.4040506@linux.intel.com>
 <20140120135250.GA5495@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56646 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaATOHE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:07:04 -0500
Content-Disposition: inline
In-Reply-To: <20140120135250.GA5495@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 20, 2014 at 01:52:51PM +0000, Patrick McHardy wrote:
> On Mon, Jan 20, 2014 at 03:50:15PM +0200, Tomasz Bursztyka wrote:
> > Hi Pablo,
> > 
> > Thus we have to adapt iptables to look for libnfnl headers instead
> > of libnftables?
> > (and nftables too btw).
> 
> Crap, indeed, seems the change to configure.ac was not complete:
> 
> AC_CHECK_LIB([nftables], [nft_rule_alloc], ,                                    
>              AC_MSG_ERROR([No suitable version of libnftnl found]))

Going to push a patch for this.
