From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 1/3] xtables: arp: Store target entry
 properly and compare them relevantly
Date: Thu, 3 Oct 2013 12:32:19 +0200
Message-ID: <20131003103219.GA15413@localhost>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1380793977-9730-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43616 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab3JCKcY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:32:24 -0400
Content-Disposition: inline
In-Reply-To: <1380793977-9730-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 12:52:55PM +0300, Tomasz Bursztyka wrote:
> Fixes a segfault issue when deleting a rule.

Applied, thanks Tomasz.
