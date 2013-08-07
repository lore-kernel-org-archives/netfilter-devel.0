From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 1/3] nft: Remove useless test on
 rulenum in nft_rule_list()
Date: Wed, 7 Aug 2013 10:59:11 +0200
Message-ID: <20130807085911.GA6935@localhost>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1375864297-9347-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3HGI7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:59:24 -0400
Content-Disposition: inline
In-Reply-To: <1375864297-9347-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 11:31:35AM +0300, Tomasz Bursztyka wrote:
> Rulenum is already handled before the loop, making this test useless.

This one was my fault.

Applied, thanks.
