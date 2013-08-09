From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 11/16] nft: Refactor firewall
 printing so it reuses already parsed cs struct
Date: Fri, 9 Aug 2013 23:51:45 +0200
Message-ID: <20130809215145.GB7102@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031258Ab3HIVv5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:51:57 -0400
Content-Disposition: inline
In-Reply-To: <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:31:25PM +0300, Tomasz Bursztyka wrote:
> Now that we parse properly, in one place and at once, the rule back into
> a command structure, it's now easier to print the rule from that command
> structure.

I like patches from 11 to 13, that refactorization save us quite some
code and the result in one single parsing and we also work with the
command structure.

Please, can you send me these three patches in first place?
