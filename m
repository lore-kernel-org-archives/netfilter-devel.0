From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] examples: nft-table-add: fix wrong buffer
 pointer
Date: Tue, 30 Sep 2014 11:02:34 +0200
Message-ID: <20140930090234.GA7059@salvia>
References: <20140929204104.16927.59891.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52001 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaI3JB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:01:28 -0400
Content-Disposition: inline
In-Reply-To: <20140929204104.16927.59891.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 29, 2014 at 10:41:05PM +0200, Arturo Borrero Gonzalez wrote:
> We should point to the batch buffer as returned by the libmnl helper.

Applied, thanks.

