From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] xt_socket: add --restore-skmark option
Date: Tue, 30 Jun 2015 17:27:40 +0200
Message-ID: <20150630152740.GA5218@salvia>
References: <1434415279-15517-1-git-send-email-harouth@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Lorenzo Colitti <lorenzo@google.com>
To: Harout Hedeshian <harouth@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59724 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbbF3PWQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2015 11:22:16 -0400
Content-Disposition: inline
In-Reply-To: <1434415279-15517-1-git-send-email-harouth@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 15, 2015 at 06:41:19PM -0600, Harout Hedeshian wrote:
> xt_socket is useful for matching sockets with IP_TRANSPARENT and
> taking some action on the matching packets. However, it lacks the
> ability to match only a small subset of transparent sockets.
> 
> Suppose there are 2 applications, each with its own set of transparent
> sockets. The first application wants all matching packets dropped,
> while the second application wants them forwarded somewhere else.
> 
> Add the ability to retore the skb->mark from the sk_mark. The mark
> is only restored if a matching socket is found and the transparent /
> nowildcard conditions are satisfied.
> 
> Now the 2 hypothetical applications can differentiate their sockets
> based on a mark value set with SO_MARK.
> 
> iptables -t mangle -I PREROUTING -m socket --transparent \
>                                            --restore-skmark -j action
> iptables -t mangle -I PREROUTING -m socket --transparent \
>                                            --restore-skmark -j action
> iptables -t mangle -A action -m mark --mark 10 -j action2
> iptables -t mangle -A action -m mark --mark 11 -j action3

Applied, thanks.

It would be great if you can send me another patch to update the
manpage and the libxt_socket.t test file.
