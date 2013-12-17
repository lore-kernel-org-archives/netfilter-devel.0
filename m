From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables-kernel PATCH] netfilter: nf_tables: Expose the table's
 chain usage to the netlink API
Date: Tue, 17 Dec 2013 14:30:17 +0100
Message-ID: <20131217133017.GA10989@localhost>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1386853244-16783-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38567 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LQNaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:30:25 -0500
Content-Disposition: inline
In-Reply-To: <1386853244-16783-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 12, 2013 at 03:00:42PM +0200, Tomasz Bursztyka wrote:
> User space can therefore know whether a table is in use or not, and by
> how many chains.
> 
> Suggested by Pablo Neira Ayuso.

Enqueue to the nftables tree, thanks.
