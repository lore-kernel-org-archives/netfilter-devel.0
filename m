From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] nat: xml: fix wrong node name in snprintf
Date: Mon, 12 Aug 2013 11:36:31 +0200
Message-ID: <20130812093631.GD6546@localhost>
References: <20130812073539.20663.65637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab3HLJgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:36:35 -0400
Content-Disposition: inline
In-Reply-To: <20130812073539.20663.65637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 12, 2013 at 09:35:39AM +0200, Arturo Borrero Gonzalez wrote:
> This patch renames all <nat_type> nodes to <type> in nat expr.
> A bug is fixed, since the default option in snprintf was already
> <type>.
> 
> This follows the pattern of avoid prefixing XML nodes.
> 
> Note that this is mostly reverting what was done at:
> 31e34c3 (nat: xml: rename node type to nat_type).

Applied, thanks.
