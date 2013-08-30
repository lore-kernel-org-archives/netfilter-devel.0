From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables-kernel PATCH] netfilter: nf_tables: Fixes how a table
 is checked to be in use
Date: Sat, 31 Aug 2013 00:37:06 +0200
Message-ID: <20130830223705.GA9864@localhost>
References: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51026 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3H3WhS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:37:18 -0400
Content-Disposition: inline
In-Reply-To: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 30, 2013 at 12:43:32PM +0300, Tomasz Bursztyka wrote:
> Let's check table's chain list emptyness instead so struct nft_table
> does not grow and we avoid the (unlikely to happen) overflow.

I prefer if you send me a patch to export the table use counter. I
think it can be useful from userspace to know if the table is used at
all and how many times it's used. I'm neither worry about the 2^32
chains limit and the extra 4 bytes per table (we'll have a small
number of tables object in memory).
