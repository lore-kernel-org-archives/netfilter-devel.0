From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
 XT_SOCKET_RESTORESKMARK flag
Date: Tue, 16 Jun 2015 17:02:03 +0200
Message-ID: <20150616150203.GA3513@salvia>
References: <1434415243-15474-1-git-send-email-harouth@codeaurora.org>
 <008a01d0a839$c4bb0ee0$4e312ca0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	'Lorenzo Colitti' <lorenzo@google.com>
To: Harout Hedeshian <harouth@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46421 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbbFPO4t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 10:56:49 -0400
Content-Disposition: inline
In-Reply-To: <008a01d0a839$c4bb0ee0$4e312ca0$@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 07:38:44AM -0600, Harout Hedeshian wrote:
[...]
> > Now the 2 hypothetical applications can differentiate their sockets
> > based on a mark value set with SO_MARK.
> > 
> > iptables -t mangle -I PREROUTING -m socket --transparent \
> >                                            --restore-skmark -j action
> > iptables -t mangle -I PREROUTING -m socket --transparent \
> >                                            --restore-skmark -j action
> 
> Oops, redundant command in the commit message. I'll submit a v2 if we are
> happy with the rest of the patch.

Never mind, I'll mangle this myself here before applying it.

> > iptables -t mangle -A action -m mark --mark 10 -j action2
> > iptables -t mangle -A action -m mark --mark 11 -j action3

