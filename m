From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 0/2] xt_u32 - match arbitrary bits and bytes of a packet
Date: Sat, 2 Jun 2007 23:46:46 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello!


along comes xt_u32, a revamped ipt_u32,

    *	added ipv6 support since that seemed dead simple, given u32's 
	task. I would have even liked to unlock u32 for _all_ protocols, 
	but .family = AF_UNSPEC does not do the right thing right now, 
	but that's not so much a showstopper.

	And arptables seems miles away from using iptables modules. So
	AF_INET and AF_INET6 it is for now.

    *	Reduced the buffer size to 17 KB. I think that is quite ok since 
	I added an overflow check,  SHOULD THERE BE ANY device with an 
	MTU larger than our loopback masterpiece (16436 bytes).

	Are there such devices that support Megasuperjumboframes?
	The previous buffer size of 64 KB was probably the cutting edge,
	as a single IPv4 fragment/packet does not support more than that 
	anyway.


Questions, comments, blame, praise, please.
I'd like to get this merged so I do not have to maintain it out-of-tree.


	Jan
-- 
