From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] netfilter: nfnetlink_queue: add skb info attribute
Date: Sat, 27 Apr 2013 19:46:29 +0200
Message-ID: <20130427174629.GC4891@localhost>
References: <1366383507-16633-1-git-send-email-fw@strlen.de>
 <1366383507-16633-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38776 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3D0Rqe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:46:34 -0400
Content-Disposition: inline
In-Reply-To: <1366383507-16633-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 19, 2013 at 04:58:26PM +0200, Florian Westphal wrote:
> Once we allow userspace to receive gso/gro packets, userspace
> needs to be able to determine when checksums appear to be
> broken, but are not.
> 
> NFQA_SKB_CSUMNOTREADY means 'checksums will be fixed in kernel
> later, pretend they are ok'.
> 
> NFQA_SKB_GSO could be used for statistics, or to determine when
> packet size exceeds mtu.

Applied, thanks.
