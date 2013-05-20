From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC 2/2] netfilter: nf_tables: improvements for the existing
 transaction approach
Date: Mon, 20 May 2013 15:47:25 +0200
Message-ID: <20130520134725.GA20912@localhost>
References: <1369054843-14591-1-git-send-email-pablo@netfilter.org>
 <1369054843-14591-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tomasz.bursztyka@linux.intel.com, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59296 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab3ETNra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 May 2013 09:47:30 -0400
Content-Disposition: inline
In-Reply-To: <1369054843-14591-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 20, 2013 at 03:00:43PM +0200, Pablo Neira Ayuso wrote:
> * One transaction comes in one batch packet composed of several
>   netlink messages from user-space.
> 
> * All rule updates are handled as transactions.
> 
> * No need for explicit begin, commit and abort commands.

We seem to need an explicit commit operation, we still have to support
iptables-restore -t, in that case the rule-set update is not applied.
This is supported with the current approach but this RFC does not
cover that case.  I'm going to give it another try to re-spin to this.
