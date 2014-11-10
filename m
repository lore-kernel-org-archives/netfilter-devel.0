From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] tests/regression: masquerade: fix invalid syntax
Date: Mon, 10 Nov 2014 18:22:15 +0100
Message-ID: <20141110172215.GA28853@salvia>
References: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42745 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaKJRUa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:20:30 -0500
Content-Disposition: inline
In-Reply-To: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 07, 2014 at 12:39:24PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fixes invalid syntax in the masquerade test files.
> 
> I used ' ;ok' instead of ';ok', and ' ;nok' instead of ';fail'.

Applied.
