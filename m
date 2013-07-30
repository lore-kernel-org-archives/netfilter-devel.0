From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 5/5] nft: fix family operation lookup
Date: Tue, 30 Jul 2013 11:46:15 +0200
Message-ID: <20130730094615.GA8961@localhost>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
 <1374836719-27596-5-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43886 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab3G3JqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:46:19 -0400
Content-Disposition: inline
In-Reply-To: <1374836719-27596-5-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 26, 2013 at 01:05:19PM +0200, Giuseppe Longo wrote:
> This fixes the family operations lookup: handle's family is the one
> to use at this point

I have applied this with a couple more fixes for the IPv6 side. I have
also reworked the description.

Thanks Giuseppe.
