From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Subject: BUGs at tcp state transition?
Date: Tue, 18 Sep 2007 09:43:59 +0800
Message-ID: <46EF2D5F.20702@nj.cpsecure.com>
Reply-To: Dong_Wei@nj.cpsecure.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi, all.
   When I tested 2.6.20.16, found something strange. The following is 
the test case:
1. Establish a connection between client and server [Client and Server 
in EST state]
2. Power down server [ client in EST state ]
3. CTL+C the client. client should invoke close() API, and send FIN. [ 
FW state]
4. client retransmit the FIN due to timeout [ Now, FW -> LAST_ACK ]
Here the bug happens. FW is a active close state, but LAST_ACK is a 
passive close state. The correct state is FW -> FW. The ip_conntrack TCP 
state is wrong!

Also I looked the kernel source. And found the bug.
ip_conntrack_proto_tcp.c at line 201

/*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
/*
*      sNO -> sIV      Too late and no reason to do anything...
*      sSS -> sIV      Client migth not send FIN in this state:
*                      we enforce waiting for a SYN/ACK reply first.
*      sSR -> sFW      Close started.
*      sES -> sFW
*      sFW -> sLA      FIN seen in both directions, waiting for
*                      the last ACK.
*                      Migth be a retransmitted FIN as well... [ Wrong 
state!!!]

It's easy to check a FIN packet is a restransmitted packet or not, but 
we need check every TCP packet in tcp_packet() function, Its performance 
is too bad. I don't like this. Anyone can give a good solution?

Thanks in advance :)

BR. Wei Dong
