From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] ruleset: factorize json/xml tagging
Date: Sun, 3 Nov 2013 22:13:49 +0100
Message-ID: <20131103211349.GA9532@localhost>
References: <20131028105747.32691.93153.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40365 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3KCVNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:13:54 -0500
Content-Disposition: inline
In-Reply-To: <20131028105747.32691.93153.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 11:57:47AM +0100, Arturo Borrero Gonzalez wrote:
> This factorization of JSON/XML open & close tag allows reutilice code in future
> patches (for example, the fprintf API functions).

Applied, thanks.
