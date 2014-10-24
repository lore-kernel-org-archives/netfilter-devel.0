From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] mnl: delete useless parameter nf_sock in batch
 functions
Date: Fri, 24 Oct 2014 11:55:31 +0200
Message-ID: <20141024095531.GA3947@salvia>
References: <20141021094724.7107.39795.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39728 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbaJXJx4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:53:56 -0400
Content-Disposition: inline
In-Reply-To: <20141021094724.7107.39795.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 11:47:24AM +0200, Arturo Borrero Gonzalez wrote:
> The 'struct mnl_socket *nf_sock' parameter is useless and perturbing.

Applied.
