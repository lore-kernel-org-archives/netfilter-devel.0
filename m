From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
 XT_SOCKET_MATCHSOCKMARK flag and mark fields
Date: Mon, 15 Jun 2015 18:22:46 +0200
Message-ID: <20150615162246.GA14375@salvia>
References: <1434148795-19937-1-git-send-email-harouth@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Lorenzo Colitti <lorenzo@google.com>
To: Harout Hedeshian <harouth@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbbFOQR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 12:17:27 -0400
Content-Disposition: inline
In-Reply-To: <1434148795-19937-1-git-send-email-harouth@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 12, 2015 at 04:39:55PM -0600, Harout Hedeshian wrote:
> xt_socket is useful for matching sockets with IP_TRANSPARENT and
> taking some action on the matching packets. However, it lacks the
> ability to match only a small subset of transparent sockets.
>
> Suppose there are 2 applications, each with its own set of transparent
> sockets. The first application wants all matching packets dropped,
> while the second application wants them forwarded somewhere else.
>
> Add the ability to match sockets based on the socket mark.
>
> Now the 2 hypothetical applications can differentiate their sockets
> based on a mark value set with SO_MARK.
>
> iptables -t mangle -I PREROUTING -m socket --transparent --mark 10 -J act1
> iptables -t mangle -I PREROUTING -m socket --transparent --mark 11 -J act2

Wouldn't it be better to restore the sk_mark to skb->mark? I mean:

        iptables -t mangle -I PREROUTING \
                -m socket --transparent --restore-skmark -j myskchain

Thus, you can use -m mark from the 'myskchain' without having to fetch
and inspect the sk over and over again as it happens with this
extension.
