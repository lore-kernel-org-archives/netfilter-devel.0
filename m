From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: ipv6: add getsockopt to retrieve
 origdst
Date: Fri, 2 Nov 2012 12:36:46 +0100
Message-ID: <20121102113646.GA27088@1984>
References: <1351595329-13081-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762395Ab2KBLgz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:36:55 -0400
Content-Disposition: inline
In-Reply-To: <1351595329-13081-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 30, 2012 at 12:08:49PM +0100, Florian Westphal wrote:
> userspace can query the original ipv4 destination address of a REDIRECTed
> connection via
> getsockopt(m_sock, SOL_IP, SO_ORIGINAL_DST, &m_server_addr, &addrsize)
> 
> but for ipv6 no such option existed.
> 
> This adds getsockopt(..., IPPROTO_IPV6, IP6T_SO_ORIGINAL_DST, ...).
> 
> Without this, userspace needs to parse /proc or use ctnetlink, which
> appears to be overkill.

Applied, thanks Florian.

> ---
>  Instead of adding new IP6T_SO_ORIGINAL_DST, we could also
>  simply re-use existing SO_ORIGINAL_DST ipv4 define.  Any Preferences?

I've added this to the patch description, for the record:

"This uses option number 80 for IP6T_SO_ORIGINAL_DST, which is spare,
to use the same number we use in the IPv4 socket option
SO_ORIGINAL_DST".
