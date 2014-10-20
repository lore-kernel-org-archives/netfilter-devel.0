From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-compat PATCH 3/3] nft-ipv46: replace offset var with
 ctx->payload.offset
Date: Mon, 20 Oct 2014 11:02:37 +0200
Message-ID: <20141020090237.GC4977@salvia>
References: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
 <1413469793-21382-3-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55499 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbaJTJBK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:01:10 -0400
Content-Disposition: inline
In-Reply-To: <1413469793-21382-3-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 04:29:53PM +0200, Giuseppe Longo wrote:
> The offset variable (undefined) is passed to DEBUGP function,
> so you get a compilation error if you try to build iptables
> with debug enabled

Applied to master, thanks.

I have rebased the ebtables-compat branch again upon these fixes.
