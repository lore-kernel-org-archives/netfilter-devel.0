From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack DoS
Date: Thu, 27 Jun 2002 10:26:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206271021250.4405-100000@blackhole.kfki.hu>
References: <3D18F1DB.FD515947@marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <3D18F1DB.FD515947@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 26 Jun 2002, Henrik Nordstrom wrote:

> A running TCP packet flow (even for a "half-closed" uni-directional TCP)
> is never uni-directional. If there is data in flowing in one direction
> then there is ACKs in the other direction.

Yes, right.

> Idea on how conntrack could deal with such connections: If several
> retransmissions (lets say 5) is seen in one direction and no ACKs in the
> other within a reasonable timeframe (lets say 10 minutes) then the TCP
> is most likely dead and a low inactivity timeout can be assigned (lets
> say 20 minutes) to have it cleaned out from conntrack.
>
> At a first glance this can be simplified into a RETRANSMIT/ACK timeout
> state machinery, but there is a significant race window making a simple
> packet driven state machine unsuitable. Must not trigger on a delayed
> retransmission followed by a lost ACK, or delayed retransmissions not
> resulting in ACK (out of window).

I believe it is a good approach and can be implemented. But first the
NOTRACK patch...

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
