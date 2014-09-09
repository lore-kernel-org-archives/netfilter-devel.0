From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v4 2/5] netfilter: nf_nat_masquerade_ipv4: code
 factorization
Date: Tue, 9 Sep 2014 11:52:31 +0200
Message-ID: <20140909095231.GB9128@salvia>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120619.5971.10541.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaIIJvo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:51:44 -0400
Content-Disposition: inline
In-Reply-To: <20140904120619.5971.10541.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 02:06:33PM +0200, Arturo Borrero Gonzalez wrote:
> Let's refactor the code so we can reach the masquerade functionality from
> outside the xt context (ie, nftables).
> 
> The patch includes adding an atomic counter to the masquerade notifier: the
> stuff to be done by the notifier is the same in any case, and agnostic
> about who called it. Only one notification handler is needed.
> 
> This factorization only involves IPv4; a similar patch will follow to handle
> IPv6.

Applied, thanks.

