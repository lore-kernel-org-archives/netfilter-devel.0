From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v3] src: update meta expr
Date: Sat, 28 Dec 2013 14:08:43 +0100
Message-ID: <20131228130843.GA7395@localhost>
References: <20131226154912.32433.7673.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44660 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3L1NIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:08:47 -0500
Content-Disposition: inline
In-Reply-To: <20131226154912.32433.7673.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 26, 2013 at 04:50:00PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds userspace support for the meta expression in the set flavour.
> 
> This expression indicates that the packet has to be set with a property,
> currently one of mark, priority or nftrace.

Applied to next-3.14, thanks!
