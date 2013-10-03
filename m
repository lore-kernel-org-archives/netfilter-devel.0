From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: Calculate properly the target
 size when parsing it back
Date: Thu, 3 Oct 2013 18:06:40 +0200
Message-ID: <20131003160640.GA4721@localhost>
References: <1380805259-12404-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45180 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab3JCQGq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:06:46 -0400
Content-Disposition: inline
In-Reply-To: <1380805259-12404-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 04:00:59PM +0300, Tomasz Bursztyka wrote:
> Without this, we might allocate less space for the xt_entry_target as we
> should, thus leading to a possible bug.

Applied, thanks.

