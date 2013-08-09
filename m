From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 15/16] nft: Add a function to
 reset the counters of an existing rule
Date: Sat, 10 Aug 2013 00:00:50 +0200
Message-ID: <20130809220050.GD7102@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-16-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49001 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031243Ab3HIWBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:01:00 -0400
Content-Disposition: inline
In-Reply-To: <1376055090-26551-16-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:31:29PM +0300, Tomasz Bursztyka wrote:
> Now that we parse properly, in one place and at once, the rule back into a
> command structure, it's now easier to reset its counters from that command
> structure which we can pass again to nft_rule_append. (Thus the rule will
> be replaced since we provide it's handle.)

I guess this patch could follow up after the refactorization patches
(11-13) as I don't see any obvious dependency with your translation
engine.
