From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_reject_inet: fix unintended fall-through
 in switch-statatement
Date: Fri, 14 Feb 2014 17:59:19 +0100
Message-ID: <20140214165919.GA7415@localhost>
References: <20140212211313.GB8437@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davej@redhat.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33593 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaBNQ7X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:59:23 -0500
Content-Disposition: inline
In-Reply-To: <20140212211313.GB8437@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 12, 2014 at 09:13:16PM +0000, Patrick McHardy wrote:
> netfilter: nft_reject_inet: fix unintended fall-through in switch-statement
> 
> For IPv4 packets, we call both IPv4 and IPv6 reject.

Applied, thanks!
