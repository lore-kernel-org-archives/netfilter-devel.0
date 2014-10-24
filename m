From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH netfilter] Fix Unknown symbols in nf_reject_ipvX
 modules
Date: Fri, 24 Oct 2014 11:47:43 +0200
Message-ID: <20141024094743.GA3628@salvia>
References: <1414135732.19476.10.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Li Zhong <zhong@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaJXJqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:46:10 -0400
Content-Disposition: inline
In-Reply-To: <1414135732.19476.10.camel@TP420>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 24, 2014 at 03:28:52PM +0800, Li Zhong wrote:
> Commit c8d7b98bec43 moved nf_send_resetX() to modules without module
> license, which causes following errors seen on my system: 
> 
> [   26.926014] nf_reject_ipv4: Unknown symbol rcu_read_lock_bh_held (err 0)
> [   26.926022] nf_reject_ipv4: Unknown symbol rcu_read_lock_held (err 0)
> [   26.926030] nf_reject_ipv4: Unknown symbol ip_local_out_sk (err 0)
> 
> The code below adds MODULE_LICENSE("GPL") to fix this issue. 

We already sent a similar patch that should hit Linus' tree soon.

Sorry for the inconvenience.
