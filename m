From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] libxt_quota: fix _save() invert syntax
Date: Mon, 23 Feb 2015 15:20:08 +0100
Message-ID: <20150223142008.GA4622@salvia>
References: <20150223103111.2927.44023.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbbBWOQj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2015 09:16:39 -0500
Content-Disposition: inline
In-Reply-To: <20150223103111.2927.44023.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 23, 2015 at 11:31:11AM +0100, Arturo Borrero Gonzalez wrote:
> Space is misplaced.

Applied, thanks.

I have also updated extensions/libxt_quota.t so it catches this case
from the automated regression testing infrastructure.
