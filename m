From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: initialize flags in
 nft_arp_parse_meta
Date: Thu, 3 Oct 2013 18:06:53 +0200
Message-ID: <20131003160653.GA4731@localhost>
References: <1380810699-2872-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab3JCQG7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:06:59 -0400
Content-Disposition: inline
In-Reply-To: <1380810699-2872-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 04:31:39PM +0200, Giuseppe Longo wrote:
> This small patch initialize the flags in nft_arp_parse_meta,
> now the nft_arp_rule_find is working properly.

Applied, thanks.
