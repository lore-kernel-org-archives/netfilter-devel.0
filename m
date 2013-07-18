From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables - PATCH 2/2] nft: Fix code style issues
Date: Thu, 18 Jul 2013 14:12:25 +0300
Message-ID: <51E7CD99.1020001@linux.intel.com>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1374046455-19234-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20130717134742.GA7940@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54619 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3GRLM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:12:28 -0400
In-Reply-To: <20130717134742.GA7940@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I think many of those style adjustments could be fixed by splitting
> functions into smaller chunks and with several helper functions
> similar to your "nft: add function to test for a builtin chain" patch,
> which I think is the way to go to get this code better.
>
> We can also revisit this later if you don't want to work on this at
> this moment.

As this is not in a hurry, let's see yes.

Actually Giuseppe's work might help on that since he will move some of 
these common helpers to nft-shared.c (or a new nft-utils.c, let's see)

Tomasz
