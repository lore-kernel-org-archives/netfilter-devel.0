From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 1/1 v4] nft: refactoring parse
 operations for more genericity
Date: Wed, 4 Sep 2013 14:47:10 +0200
Message-ID: <20130904124710.GA4371@localhost>
References: <1378298201-10814-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab3IDMrQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:47:16 -0400
Content-Disposition: inline
In-Reply-To: <1378298201-10814-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 02:36:41PM +0200, Giuseppe Longo wrote:
> This will allow reusing nft_parse_* function for other family than IPv4
> or IPv6.

Applied, thanks Giuseppe!
