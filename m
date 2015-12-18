From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 nf-next] netfilter: meta: add support for setting
 skb->pkttype
Date: Fri, 18 Dec 2015 13:07:36 +0100
Message-ID: <20151218120736.GA2606@salvia>
References: <1449767047-15389-1-git-send-email-fw@strlen.de>
 <20151214114525.GA3469@salvia>
 <20151214133846.GF12854@breakpoint.cc>
 <20151214172642.GA1365@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47088 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbbLRMHj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 07:07:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8D513129257
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 13:07:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 67872DA865
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 13:07:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 87E8BDA85F
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 13:07:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151214172642.GA1365@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 14, 2015 at 06:26:42PM +0100, Pablo Neira Ayuso wrote:
> We may keep going with the existing approach, ie. just raw data with
> no semantics, then if we decide to go this path, to retain backward
> compatibility, we would need to pass two data attributes through
> netlink: one with the raw data and another with the specific datatype
> so older kernels keep handling what userspace generates.

I working on a RFC patchset that should cover these concerns above,
but I think that new infrastructure is too much for this specific
case.

So I'm reconsidering this, I'm going to apply this patch.

Thanks.
