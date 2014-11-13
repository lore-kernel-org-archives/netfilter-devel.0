From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables/nft-bridge.c: fix
 inversion of builtin matches
Date: Thu, 13 Nov 2014 12:18:34 +0100
Message-ID: <20141113111834.GA3711@salvia>
References: <20141112161025.9723.51400.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52782 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbaKMLQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:16:37 -0500
Content-Disposition: inline
In-Reply-To: <20141112161025.9723.51400.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 12, 2014 at 05:10:25PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fixes inversion of builtin matches by updating the use of add_*()
> functions and using nft_invflags2cmp() as well.

Applied, thanks Arturo.
