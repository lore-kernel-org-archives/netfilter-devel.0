From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH 2/9] nft: Handle error on adding rule
 expressions
Date: Tue, 16 Jul 2013 22:11:31 +0200
Message-ID: <20130716201131.GB14035@localhost>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1373978333-17427-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab3GPULf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:11:35 -0400
Content-Disposition: inline
In-Reply-To: <1373978333-17427-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:38:46PM +0300, Tomasz Bursztyka wrote:
> If adding one of match/target/jumpto/verdit/counters fails, adding a rule will
> return an error.

Applied, thanks.
