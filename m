From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] owner-socketlookup update for 2.6.12-rc3
Date: Tue, 26 Apr 2005 23:13:28 -0700
Message-ID: <20050426231328.0ab5b357.davem@davemloft.net>
References: <Xine.LNX.4.44.0504270021020.15959-100000@thoron.boston.redhat.com>
	<Xine.LNX.4.44.0504270200190.16150-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
In-Reply-To: <Xine.LNX.4.44.0504270200190.16150-100000@thoron.boston.redhat.com>
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

On Wed, 27 Apr 2005 02:04:04 -0400 (EDT)
James Morris <jmorris@redhat.com> wrote:

> Here's an updated version of the patch (based on the latest pom-ng patch), 
> had to uninline udp_v4_lookup().

If you really want to do this, can we at least export it via some
of the proto_ops infrastructure?  We already have "hash" and
"unhash", a "lookup" method could thus be added.

It still hurts my eyes to see the tcp_tw_bucket internals being
referenced in netfilter code :-)

Or even:

extern struct sock *ip_lookup_socket(saddr, sport, daddr, dport);

And this new function knows TCP internals and does not return
time-wait sockets and stuff like that.

What about an idea like that?
