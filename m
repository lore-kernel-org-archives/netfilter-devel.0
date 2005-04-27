From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] owner-socketlookup update for 2.6.12-rc3
Date: Wed, 27 Apr 2005 08:43:04 +0200
Message-ID: <20050427064304.GA5828@oknodo.bof.de>
References: <Xine.LNX.4.44.0504270021020.15959-100000@thoron.boston.redhat.com>
	<Xine.LNX.4.44.0504270200190.16150-100000@thoron.boston.redhat.com>
	<20050426231328.0ab5b357.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050426231328.0ab5b357.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> It still hurts my eyes to see the tcp_tw_bucket internals being
> referenced in netfilter code :-)

Is it even correct to make an exception (return 0, i.e. do not match)
when a TW socket is hit? Conceptually, a TW socket is the same logical
entity as its former "established and owned" socket - wouldn't one
expect a rule accepting the established socket, to also match that
socket in the TW phase?

> Or even:
> 
> extern struct sock *ip_lookup_socket(saddr, sport, daddr, dport);
> 
> And this new function knows TCP internals and does not return
> time-wait sockets and stuff like that.

Hmm. In the light of the above, what about this:

int ip_socket_owner(struct sockowner *so, prot, src, sport, dst, dport) {}

with the 'struct sockowner *' an OUT parameter that is to be filled,
and boolean found/notfound return.

struct sockowner {
	... contains whatever the owner match needs to look at
};

This way, no sock internals need to be visible to the owner match.

To solve the mentioned conceptional TW problem, the tw sock must
be extended
	struct sockowner *tw_ownerinfo;
and, for performance reasons, the normal sock would probably need
a single DID_OWNER state bit, which would be set whenever the normal
sock is queried by ip_socket_owner(). Finally, when the normal sock
morphs into the tw sock, set
	tw_ownerinfo = sk->DID_OWNER ? X(sk) : 0
with X(sk) kmalloc()ing a struct sockowner, and initializing it like
a call to ip_socket_owner() would.

Very convoluted, but what good is a matching feature that only
sometimes works?

(or maybe I'm just silly?)

best regards
  Patrick
