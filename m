From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] nft-arp: adds nft_arp_save_firewall
Date: Tue, 25 Feb 2014 17:44:48 +0100
Message-ID: <20140225164448.GA25611@localhost>
References: <1392811829-5303-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaBYQox (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:44:53 -0500
Content-Disposition: inline
In-Reply-To: <1392811829-5303-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 19, 2014 at 01:10:28PM +0100, Giuseppe Longo wrote:
> Adds nft_arp_save_firewall to arp family.
> (Avoids the segfault in xtables-events)

Applied, thanks.
