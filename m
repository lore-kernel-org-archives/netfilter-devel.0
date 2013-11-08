From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: arp: inhibate -l option so only a
 fixed size arhln is in use
Date: Fri, 8 Nov 2013 08:39:54 +0100
Message-ID: <20131108073954.GB4752@localhost>
References: <1383738669-25602-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50292 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab3KHHj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:39:59 -0500
Content-Disposition: inline
In-Reply-To: <1383738669-25602-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 06, 2013 at 01:51:09PM +0200, Tomasz Bursztyka wrote:
> This is a temporary fallback mechanism until variable interface hardware
> address length can be handled through nftables.

Applied, thanks.
