From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack DoS
Date: Wed, 26 Jun 2002 00:42:35 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D18F1DB.FD515947@marasystems.com>
References: <Pine.LNX.4.33.0206252341290.1273-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> > The good news is that second case can be detected by detecting a long term
> > uni-directional packet flow, and we probably do not need to care about the
> > first..
> 
> How could be such connections (second case) sorted out from
> legitimate uni-directional (even half-closed) connections?

A running TCP packet flow (even for a "half-closed" uni-directional TCP)
is never uni-directional. If there is data in flowing in one direction
then there is ACKs in the other direction.

Idea on how conntrack could deal with such connections: If several
retransmissions (lets say 5) is seen in one direction and no ACKs in the
other within a reasonable timeframe (lets say 10 minutes) then the TCP
is most likely dead and a low inactivity timeout can be assigned (lets
say 20 minutes) to have it cleaned out from conntrack.

At a first glance this can be simplified into a RETRANSMIT/ACK timeout
state machinery, but there is a significant race window making a simple
packet driven state machine unsuitable. Must not trigger on a delayed
retransmission followed by a lost ACK, or delayed retransmissions not
resulting in ACK (out of window).

Regards
Henrik
