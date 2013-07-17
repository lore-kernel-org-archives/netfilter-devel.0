From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH 2/2] nft: Fix code style issues
Date: Wed, 17 Jul 2013 15:47:42 +0200
Message-ID: <20130717134742.GA7940@localhost>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1374046455-19234-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3GQNrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:47:46 -0400
Content-Disposition: inline
In-Reply-To: <1374046455-19234-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I don't feel like taking this at this moment.

I think many of those style adjustments could be fixed by splitting
functions into smaller chunks and with several helper functions
similar to your "nft: add function to test for a builtin chain" patch,
which I think is the way to go to get this code better.

We can also revisit this later if you don't want to work on this at
this moment.

Thanks for the patch in any case.
