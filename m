From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH v2] nft: refactoring parse operations
 for more genericity
Date: Mon, 2 Sep 2013 23:39:47 +0200
Message-ID: <20130902213947.GA8732@localhost>
References: <1378128246-7593-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59102 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3IBVjx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:39:53 -0400
Content-Disposition: inline
In-Reply-To: <1378128246-7593-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 02, 2013 at 03:24:06PM +0200, Giuseppe Longo wrote:
> This will allow reusing nft_parse_* function for other family than IPv4
> or IPv6.

# xtables -A INPUT -s 1.1.1.1/32 -d 3.3.3.3/32 -j LOG
# xtables-save | grep 1.1.1.1
-A INPUT -s 1.1.1.1/32 -d 3.3.3.3/32

This doesn't work yet, it breaks targets.

Please, test your stuff.
