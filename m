From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_nat: fix locking in nf_nat_seq_adjust()
Date: Wed, 31 Jul 2013 18:55:23 +0200
Message-ID: <20130731165523.GD13813@localhost>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
 <1375044851-12471-4-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000Ab3GaQzb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:55:31 -0400
Content-Disposition: inline
In-Reply-To: <1375044851-12471-4-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 28, 2013 at 10:54:09PM +0200, Patrick McHardy wrote:
> nf_nat_seq_adjust() needs to grab nf_nat_setofs_lock to protect against
> concurrent changes to the sequence adjustment data.

Applied, thanks.

I have enqueued this to nf so it hits 3.11. I have to wait to take 4/5
and 5/5 for a while until this patch hits Linus tree.
