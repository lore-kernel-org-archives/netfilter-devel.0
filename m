From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 3/3] xtables: arp: Do not add a useless
 prefix for afinfo_arp
Date: Thu, 3 Oct 2013 12:37:01 +0200
Message-ID: <20131003103701.GA15843@localhost>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1380793977-9730-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3JCKhF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:37:05 -0400
Content-Disposition: inline
In-Reply-To: <1380793977-9730-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 12:52:57PM +0300, Tomasz Bursztyka wrote:
> Let's use libxt_ as it should, since CLASSIFY and now mangle targets
> (the 2 only targets xtables-arp is going to use) are libxt_ prefixed.

I think that .libprefix is ignored, so we don't really need this
change.

Are you noticing any problem when adding xtables-arp commands?
