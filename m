From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix potential use after free in
 ip6_route_me_harder()
Date: Fri, 9 May 2014 12:44:08 +0200
Message-ID: <20140509104408.GA4300@localhost>
References: <1399555355-7677-1-git-send-email-popovich_sergei@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaEIKoW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 06:44:22 -0400
Content-Disposition: inline
In-Reply-To: <1399555355-7677-1-git-send-email-popovich_sergei@mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 08, 2014 at 04:22:35PM +0300, Sergey Popovich wrote:
> Dst is released one line before we access it again with dst->error.
> 
> Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
> ip6_route_me_harder()

Applied, thanks.
