From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables kernel - PATCH 2/2] netfilter: nf_tables: Fix the
 netlink attributes policy for chain
Date: Fri, 11 Oct 2013 10:43:16 +0200
Message-ID: <20131011084316.GB3956@localhost>
References: <1381139880-20311-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1381139880-20311-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45992 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3JKInU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:43:20 -0400
Content-Disposition: inline
In-Reply-To: <1381139880-20311-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 07, 2013 at 12:58:00PM +0300, Tomasz Bursztyka wrote:
> - Reorder them as they appear in enum nft_chain_attributes
> - Add NFTA_CHAIN_COUNTERS

Also applied, thanks.
