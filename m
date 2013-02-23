From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH v2] nft: Split nft core to become
 family independant
Date: Sat, 23 Feb 2013 18:52:47 +0100
Message-ID: <20130223175246.GA12912@localhost>
References: <1359552828-13386-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:20349 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755041Ab3BWRww (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:52:52 -0500
Content-Disposition: inline
In-Reply-To: <1359552828-13386-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 30, 2013 at 03:33:48PM +0200, Tomasz Bursztyka wrote:
> This makes nft core code independant from the family. Each family needs
> to implement and provide a struct nft_family_ops {}.
> 
> This split will ease the future support of bridge and arp rules manipulations.

Finally applied, thanks a lot Tomasz.
