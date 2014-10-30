From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v2 1/3] netfilter: refactor NAT redirect IPv4
 to use it from nf_tables
Date: Thu, 30 Oct 2014 17:28:17 +0100
Message-ID: <20141030162817.GA2224@salvia>
References: <20141016102224.4715.64585.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbaJ3Q0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20141016102224.4715.64585.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:23:29PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactors the IPv4 code so it can be usable both from xt and
> nf_tables.
> 
> A similar patch follows-up to handle IPv6.

Applied, thanks.
