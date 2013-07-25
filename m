From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] src: utils: add verdict2str
Date: Thu, 25 Jul 2013 22:33:50 +0200
Message-ID: <20130725203350.GA3407@localhost>
References: <20130725202033.21531.41100.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41548 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab3GYUd6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:33:58 -0400
Content-Disposition: inline
In-Reply-To: <20130725202033.21531.41100.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 25, 2013 at 10:20:33PM +0200, Arturo Borrero Gonzalez wrote:
> Add verdict2str() and str2verdict() helper functions and use in XML.
> 
> I've followed nft_verdict_init() in net/netfilter/nf_tables_api.c
> 
> While at it, I've fixed a small style issue in the data_reg JSON output and a
> bug in the data_reg XML parser:
> The parser walked the top level tree, instead of single <data_reg> node.
> This patch fixes it. Introduced at: 51370f0 src: add support for XML parsing.

Applied, thanks.
