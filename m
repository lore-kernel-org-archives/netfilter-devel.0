From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] nft: replace nft_rule_attr_get_u8
Date: Mon, 24 Mar 2014 12:08:43 +0100
Message-ID: <20140324110843.GA5074@localhost>
References: <1395658786-3862-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43732 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbaCXLIx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:08:53 -0400
Content-Disposition: inline
In-Reply-To: <1395658786-3862-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 24, 2014 at 11:59:46AM +0100, Giuseppe Longo wrote:
> Since the family declaration has been modified in libnftnl,
> from commit 3cd9cd06625f8181c713489cec2c1ce6722a7e16
> the assertion is failed for {ip,ip6,arp}tables-compat
> when printing rules.
> 
> iptables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> libnftnl: attribute 0 assertion failed in rule.c:273
> 
> ip6tables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> libnftnl: attribute 0 assertion failed in rule.c:273
> 
> arptables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> libnftnl: attribute 0 assertion failed in rule.c:273

Applied, thanks Giuseppe.
