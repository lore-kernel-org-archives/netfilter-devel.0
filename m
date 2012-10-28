From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove silly double assignment
Date: Sun, 28 Oct 2012 23:53:49 +0100
Message-ID: <20121028225349.GB1143@1984>
References: <20121026101320.18664.26806.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2J1Wxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 18:53:53 -0400
Content-Disposition: inline
In-Reply-To: <20121026101320.18664.26806.stgit@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 26, 2012 at 11:13:27AM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> I don't even want to think what the C spec says for this 8)

I don't want to know it either :-), I have applied this.

@Simon: this patch is fairly small, I'll take it myself into nf-next.
