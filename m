From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: combine IPv4 and IPv6 nf_nat_redirect
 code in one module
Date: Tue, 2 Dec 2014 18:18:07 +0100
Message-ID: <20141202171807.GB3195@salvia>
References: <1417004330-29618-1-git-send-email-pablo@netfilter.org>
 <547DCEB1.5090105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com,
	fw@strlen.de, rupran@einserver.de
To: Or Gerlitz <ogerlitz@mellanox.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39678 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbaLBRPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:15:55 -0500
Content-Disposition: inline
In-Reply-To: <547DCEB1.5090105@mellanox.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 02, 2014 at 04:37:37PM +0200, Or Gerlitz wrote:
> On 11/26/2014 2:18 PM, Pablo Neira Ayuso wrote:
> >This resolves linking problems with CONFIG_IPV6=n:
> 
> I have CONFIG_IPV6=m

OK, IIRC you have IP6_NF_IPTABLES=n then, which is another way you can
hit this.

> >net/built-in.o: In function `redirect_tg6':
> >xt_REDIRECT.c:(.text+0x6d021): undefined reference to `nf_nat_redirect_ipv6'
> >
> >Reported-by: Andreas Ruprecht<rupran@einserver.de>
> >Reported-by: Or Gerlitz<ogerlitz@mellanox.com>
> >Signed-off-by: Pablo Neira Ayuso<pablo@netfilter.org>
> 
