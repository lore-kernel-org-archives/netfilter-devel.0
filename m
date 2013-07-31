From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/7] netfilter: nf_queue: relax NFQA_CT attribute check
Date: Wed, 31 Jul 2013 18:56:35 +0200
Message-ID: <20130731165635.GB25900@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab3GaQ4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:56:47 -0400
Content-Disposition: inline
In-Reply-To: <1375105316-13216-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:41:51PM +0200, Florian Westphal wrote:
> Allow modifying attributes of the conntrack associated with a packet
> without first requesting ct data via CFG_F_CONNTRACK or extra
> nfnetlink_conntrack socket.

Applied, thanks.

> Also remove unneded rcu_read_lock; the entire function is already
> protected by rcu.

Indeed, that code runs on call_rcu from nfnetlink.
