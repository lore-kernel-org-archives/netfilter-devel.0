From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes
 behavioural change in userspace?
Date: Thu, 24 Oct 2013 14:51:35 +0200
Message-ID: <20131024125135.GA993@breakpoint.cc>
References: <52667EBC.5010709@ee.oulu.fi>
 <20131024095212.GA4422@localhost>
 <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
 <526902D1.50803@ee.oulu.fi>
 <1382616307.7572.56.camel@edumazet-glaptop.roam.corp.google.com>
 <5269121A.3040104@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com,
	netfilter-devel@vger.kernel.org
To: Pekka =?iso-8859-15?Q?Pietik=E4inen?= <pp@ee.oulu.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41939 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab3JXMvn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:51:43 -0400
Content-Disposition: inline
In-Reply-To: <5269121A.3040104@ee.oulu.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pekka Pietik=E4inen <pp@ee.oulu.fi> wrote:
> On 24/10/13 15:05, Eric Dumazet wrote:
> >sk_state 7 means TCP_CLOSE
> >
> >I do not see how a TCP_CLOSE socket can be matched...
> >
> Yep, TCP_CLOSE can't be right, sk_state isn't correct with early
> demux perhaps?

What is weird is that early_demux should NOT influence xt_socket
because from the rules you posted you are using this in PREROUTING,
which is before tcp early demux magic.

Do you have any other netfilter rules (-j TPROXY perhaps?) that could
explain why the skb has a socket attached in the first place by
the time it ends up in the netfilter socket match?

[ ip_rcv() orphans the skb before netfilter prerouting, so skb->sk
  should be NULL ]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
