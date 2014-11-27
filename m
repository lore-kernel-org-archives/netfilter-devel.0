From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2 v4] bridge: export nft_reject_ip*hdr_validate
 functions
Date: Thu, 27 Nov 2014 12:59:24 +0100
Message-ID: <20141127115924.GA14723@salvia>
References: <1416993697-18285-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39104 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaK0L5O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:57:14 -0500
Content-Disposition: inline
In-Reply-To: <1416993697-18285-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:21:36AM +0100, Alvaro Neira Ayuso wrote:
> This patch exports the functions nft_reject_iphdr_validate and
> nft_reject_ip6hdr_validate to use it in follow up patches.
> These functions check if the ethernet header is correct.

Applied, thanks.
