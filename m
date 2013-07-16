From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH 1/9] nft: Set the rule family when
 creating a new one
Date: Tue, 16 Jul 2013 22:11:16 +0200
Message-ID: <20130716201116.GA14035@localhost>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1373978333-17427-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55049 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab3GPULW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:11:22 -0400
Content-Disposition: inline
In-Reply-To: <1373978333-17427-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:38:45PM +0300, Tomasz Bursztyka wrote:
> Fixes the debug output from (in case of ipv4 rule):
> 	DEBUG: rule: arp filter INPUT 0
> to:
> 	DEBUG: rule: ip filter INPUT 0

Applied.
