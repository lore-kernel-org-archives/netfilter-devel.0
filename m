From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables (nft-compat) PATCH 3/8] xtables: Handle family is not
 related to Netlink family
Date: Tue, 11 Feb 2014 12:02:42 +0100
Message-ID: <20140211110242.GB4299@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57816 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaBKLDO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:03:14 -0500
Content-Disposition: inline
In-Reply-To: <1392115608-6733-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 12:46:43PM +0200, Tomasz Bursztyka wrote:
> AF_INET vs NFPROTO_IPV4
> AF_INET6 vs NFPROTO_IPV6

I think we should stick to NFPROTO_*

I can see many references to AF_ in the compat layer, you can send me
a patch to rename all those instead.
