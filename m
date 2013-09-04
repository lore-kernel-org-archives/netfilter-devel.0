From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xt_owner: enable xt_owner on INPUT chain
Date: Wed, 4 Sep 2013 14:34:59 +0200
Message-ID: <20130904123459.GA4900@localhost>
References: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
 <1377866623-25948-2-git-send-email-valentina.giusti@bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: valentina.giusti@bmw-carit.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60123 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab3IDMfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:35:07 -0400
Content-Disposition: inline
In-Reply-To: <1377866623-25948-2-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 30, 2013 at 02:43:43PM +0200, valentina.giusti@bmw-carit.de wrote:
> From: Valentina Giusti <valentina.giusti@bmw-carit.de>
> 
> Since (41063e9 ipv4: Early TCP socket demux), we can apply the owner
> extension on the INPUT chain and match established TCP sockets.
> However, because of the same commit, we can have skb->sk pointing to a
> timewait socket, in which case accessing skb->sk->sk_socket is invalid.

This only works for established TCP sockets. Thus, this rule:

-A INPUT -m owner --socket-exists -j ACCEPT
-A OUTPUT -m owner --socket-exists -j ACCEPT

are semantically different depending on the path.
