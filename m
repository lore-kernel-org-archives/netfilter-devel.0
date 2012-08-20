From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: sparse endian fixes
Date: Mon, 20 Aug 2012 16:53:16 +0200
Message-ID: <20120820145316.GC18676@1984>
References: <1345407370-30009-1-git-send-email-kaber@trash.net>
 <1345407370-30009-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab2HTOxW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:53:22 -0400
Content-Disposition: inline
In-Reply-To: <1345407370-30009-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 19, 2012 at 10:16:09PM +0200, Patrick McHardy wrote:
> Fix a couple of endian annotation in net/netfilter:
> 
> net/netfilter/nfnetlink_acct.c:82:30: warning: cast to restricted __be64
> net/netfilter/nfnetlink_acct.c:86:30: warning: cast to restricted __be64
> net/netfilter/nfnetlink_cthelper.c:77:28: warning: cast to restricted __be16
> net/netfilter/xt_NFQUEUE.c:46:16: warning: restricted __be32 degrades to integer
> net/netfilter/xt_NFQUEUE.c:60:34: warning: restricted __be32 degrades to integer
> net/netfilter/xt_NFQUEUE.c:68:34: warning: restricted __be32 degrades to integer
> net/netfilter/xt_osf.c:272:55: warning: cast to restricted __be16

Applied, thanks Patrick. I'll pass schedule this for net-next.
