From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v4 3/5] netfilter: nf_nat_masquerade_ipv6: code
 factorization
Date: Tue, 9 Sep 2014 11:52:54 +0200
Message-ID: <20140909095254.GA9475@salvia>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120638.5971.87107.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33035 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbaIIJwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:52:03 -0400
Content-Disposition: inline
In-Reply-To: <20140904120638.5971.87107.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 02:06:49PM +0200, Arturo Borrero Gonzalez wrote:
> Let's refactor the code so we can reach the masquerade functionality from
> outside the xt context (ie, nftables).
> 
> The patch includes adding an atomic counter to the masquerade notifier: the
> stuff to be done by the notifier is the same in any case, and agnostic
> about who called it. Only one notification handler is needed.
> 
> This factorization only involves IPv6; a similar patch exists to handle IPv4.
> 

Also applied, thanks.

