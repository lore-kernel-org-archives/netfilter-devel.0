From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: ipv6: add getsockopt to retrieve
 origdst
Date: Wed, 31 Oct 2012 09:48:15 +0100
Message-ID: <20121031084815.GA29966@breakpoint.cc>
References: <1351595329-13081-1-git-send-email-fw@strlen.de>
 <1351649498.10780.6947.camel@nbnickhq4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nick Jones <nick.jones@network-box.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42264 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935123Ab2JaItT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:49:19 -0400
Content-Disposition: inline
In-Reply-To: <1351649498.10780.6947.camel@nbnickhq4>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nick Jones <nick.jones@network-box.com> wrote:
> > getsockopt(m_sock, SOL_IP, SO_ORIGINAL_DST, &m_server_addr, &addrsize)
> > 
> > but for ipv6 no such option existed.
> > 
> > This adds getsockopt(..., IPPROTO_IPV6, IP6T_SO_ORIGINAL_DST, ...).
> > 
> > Without this, userspace needs to parse /proc or use ctnetlink, which
> > appears to be overkill.
> 
> Doesn't getsockname(2) provide this information?

No.  It will show the local address (the address we REDIRECT'ed to).

> It does for TPROXY'd connections.

Yes, because with TPROXY the destination won't be rewritten.
