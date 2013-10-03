From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] xtables: arp: Parse properly target's
 options
Date: Thu, 3 Oct 2013 15:00:37 +0200
Message-ID: <20131003130037.GC17594@localhost>
References: <1380803177-11733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32843 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3JCNAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:00:43 -0400
Content-Disposition: inline
In-Reply-To: <1380803177-11733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 03:26:17PM +0300, Tomasz Bursztyka wrote:
> Without this, target never gets its options parsed, so it's a bug.

Applied, thanks.
