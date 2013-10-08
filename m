From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: arp: add parse_target to nft_family_ops_arp
Date: Tue, 8 Oct 2013 21:39:14 +0200
Message-ID: <20131008193914.GA4167@localhost>
References: <1381063007-6184-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34595 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JHTjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:39:21 -0400
Content-Disposition: inline
In-Reply-To: <1381063007-6184-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 06, 2013 at 02:36:47PM +0200, Giuseppe Longo wrote:
> This patch adds parse_target for arp family, fixing segfaults
> for xtables-arp -L after rules like:
> 
> - xtables-arp -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
> - xtables-arp -A OUTPUT -o eth1 --h-length 6 -j mangle --mangle-mac-s 01:00:5e:00:01:01

Applied, thanks Giuseppe.
