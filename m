From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack DoS
Date: Tue, 25 Jun 2002 23:47:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206252341290.1273-100000@blackhole.kfki.hu>
References: <200206252253.15622.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>,
	Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206252253.15622.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Jun 2002, Henrik Nordstrom wrote:

> > if conntrack  doesn't see a FIN or RST packet, it won't be forwarded by
> > the machine and thus never arrive at the receiver.  The sender will thus
> > retransmit, and hope the packet makes it next time.
>
> FIN will be retransmitted a couple of times, but RST won't. RST will only be
> retransmitted indirectly if data arrives from the other end.

Yes.

> This brings me back to the important cases where TCP closes down without
> conntrack noticing. Have tried to bring this up a couple of times before but
> I do not recall seeing much of a response..
>
> There exists at least two real-life cenarios where conntrack won't notice that
> a TCP connection is gone:
>
> If the RST is lost on a aborted connection where the other endpoint has
> disappeared.
>
> when the TCP is dropped due to retransmission timeouts after one of the
> endpoints have disappeared.
>
> The two cases above is only slight variations of the same scenario. A TCP is
> established, then one of the endpoints disappears from the network preventing
> the connection to be shut down in a normal manner.
>
> The first very uncommon and probably not easily exploitable.
>
> The second case is a real problem and can quite easily be used to DoS
> conntrack with a relatively small amount of packets. (total ~20 minimum size
> TCP packets per wasted conntrack entry)
>
> The good news is that second case can be detected by detecting a long term
> uni-directional packet flow, and we probably do not need to care about the
> first..

How could be such connections (second case) sorted out from
legitimate uni-directional (even half-closed) connections?

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
