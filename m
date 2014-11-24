From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] iptables: nft: create a separated object update
 type to rename chains
Date: Mon, 24 Nov 2014 11:39:00 +0100
Message-ID: <20141124103900.GA8876@salvia>
References: <20141124101214.24914.2030.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaKXKhJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:37:09 -0500
Content-Disposition: inline
In-Reply-To: <20141124101214.24914.2030.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 11:12:15AM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds an explicit object update type to rename chains, so we avoid
> calling the nf_tables API with NLM_F_EXCL.

Applied and rebased ebtables-compat branch.

Thanks Arturo.
