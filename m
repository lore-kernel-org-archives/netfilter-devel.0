From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH] netfilter: nft_compat: fix wrong target lookup
 in nft_target_select_ops()
Date: Mon, 27 Oct 2014 22:20:32 +0100
Message-ID: <20141027212032.GA4370@salvia>
References: <20141026112133.9114.98321.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34216 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaJ0VS4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:18:56 -0400
Content-Disposition: inline
In-Reply-To: <20141026112133.9114.98321.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 26, 2014 at 12:22:40PM +0100, Arturo Borrero Gonzalez wrote:
> The code looks for an already loaded target, and the correct list to search
> is nft_target_list, not nft_match_list.

Applied, thanks.
