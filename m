From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] netfilter: nf_nat: use per-conntrack locking for
 sequence number adjustments
Date: Wed, 31 Jul 2013 19:59:06 +0200
Message-ID: <20130731175906.GA9619@localhost>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
 <1375044851-12471-6-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57087 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3GaR7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:59:11 -0400
Content-Disposition: inline
In-Reply-To: <1375044851-12471-6-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 28, 2013 at 10:54:11PM +0200, Patrick McHardy wrote:
> Get rid of the global lock and use per-conntrack locks for protecting the
> sequencen number adjustment data. Additionally saves one lock/unlock
> operation for every TCP packet.

also applied, thanks.
