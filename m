From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] Add icmpv6 support.
Date: Wed, 31 Jul 2013 19:29:12 +0200
Message-ID: <20130731172912.GA5676@localhost>
References: <1375050656-9424-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54472 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3GaR3V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:29:21 -0400
Content-Disposition: inline
In-Reply-To: <1375050656-9424-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 12:30:56AM +0200, Eric Leblond wrote:
> This patch adds ICMPv6 support to nftables. It is now possible to
> write rules such as:
>   nft add rule ip6 filter input icmpv6 type nd-router-advert accept

Applied, thanks Eric!
