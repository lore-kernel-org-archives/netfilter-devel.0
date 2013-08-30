From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: refactoring parse operations for
 more genericity
Date: Sat, 31 Aug 2013 00:31:41 +0200
Message-ID: <20130830222928.GA9725@localhost>
References: <1377869753-9093-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50795 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3H3Wbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:31:46 -0400
Content-Disposition: inline
In-Reply-To: <1377869753-9093-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

On Fri, Aug 30, 2013 at 03:35:53PM +0200, Giuseppe Longo wrote:
> This will allow reusing nft_parse_* function for other family than IPv4
> or IPv6.

I like that you send me patches to prepare the arptables support, but
it seems to break things. If I run:

xtables -I INPUT -s 1.1.1.1/32 -d 2.2.2.2/32 -j LOG

the xtables-save says:

-A INPUT -s 1.1.1.1/32 -d 2.2.2.2/32

Note the missing -j target.

Please, fix and resend.
