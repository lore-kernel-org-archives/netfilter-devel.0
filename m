From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: BUGs at tcp state transition?
Date: Tue, 18 Sep 2007 11:05:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709181028370.4348@blackhole.kfki.hu>
References: <46EF2D5F.20702@nj.cpsecure.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46EF2D5F.20702@nj.cpsecure.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, 18 Sep 2007, Dong_Wei wrote:

>   When I tested 2.6.20.16, found something strange. The following is the test
> case:
> 1. Establish a connection between client and server [Client and Server in EST
> state]
> 2. Power down server [ client in EST state ]
> 3. CTL+C the client. client should invoke close() API, and send FIN. [ FW
> state]
> 4. client retransmit the FIN due to timeout [ Now, FW -> LAST_ACK ]
> Here the bug happens. FW is a active close state, but LAST_ACK is a passive
> close state. The correct state is FW -> FW. The ip_conntrack TCP state is
> wrong!
> 
> Also I looked the kernel source. And found the bug.
> ip_conntrack_proto_tcp.c at line 201
> 
> /*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
> /*
> *      sNO -> sIV      Too late and no reason to do anything...
> *      sSS -> sIV      Client migth not send FIN in this state:
> *                      we enforce waiting for a SYN/ACK reply first.
> *      sSR -> sFW      Close started.
> *      sES -> sFW
> *      sFW -> sLA      FIN seen in both directions, waiting for
> *                      the last ACK.
> *                      Migth be a retransmitted FIN as well... [ Wrong
> state!!!]

Yes, that's true. But we keep only one state in the conntrack entry, and 
therefore just from the state table we cannot figure out wether the packet 
is a retransmitted FIN or a FIN from the other direction.
 
> It's easy to check a FIN packet is a restransmitted packet or not, but 
> we need check every TCP packet in tcp_packet() function, Its performance 
> is too bad. I don't like this. Anyone can give a good solution?

The effect of the bug is that instead of keeping a 2min timer, we start a 
shorter, 1min one and when it goes off, we may destroy the conntrack entry 
prematurely. Then some late FIN/ACK packets might be detected as invalid 
ones by conntrack.

Similarly to the efforts we make to detect reopened and half-open 
connections, we could check retransmitted FINs. But is it worth?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
