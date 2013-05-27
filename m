From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next, resend] netfilter: nfnetlink_queue: avoid
 peer_portid test
Date: Mon, 27 May 2013 13:57:49 +0200
Message-ID: <20130527115749.GA9505@localhost>
References: <1369482370-9145-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab3E0L6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 07:58:02 -0400
Content-Disposition: inline
In-Reply-To: <1369482370-9145-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 25, 2013 at 01:46:10PM +0200, Florian Westphal wrote:
> The portid is set to NETLINK_CB(skb).portid at create time.
> The run-time check will always be false.

Applied to nf-next, thanks Florian.
