From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] src: add support for nft_redir expression
Date: Thu, 16 Oct 2014 13:54:25 +0200
Message-ID: <20141016115425.GA3346@salvia>
References: <20141016103819.8624.91474.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPLxO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20141016103819.8624.91474.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:39:29PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds support for the new nft_redir expression.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: redirect flags is uint 16.

Please, keep using u32 from the netlink interface. Only use u16 from
internal kernel structure.
