From: Chris Wilson <chris@netservers.co.uk>
Subject: TOS target broken wrt RFC 1349
Date: Wed, 28 Apr 2004 13:15:04 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0404281230300.3120@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Fred N. van Kempen" <waltje@uWalt.NL.Mugnet.ORG>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Summary: the TOS target (and indeed the whole Linux kernel) appears to use 
different bits in the IP header than those defined in RFC 1349 for TOS 
use, therefore TOS under Linux is seriously broken?

Hi all,

I have a question about the TOS target, because I'm confused about how it 
works. I know that TOS has been superceded by DSCP, but most routers 
and networks still do not support DSCP but do support TOS.

RFC 1349 [ftp://ftp.isi.edu/in-notes/rfc1349.txt] defines the use of the 
TOS octet in the IP header as follows:

   The Type of Service octet consists of three fields:

                0     1     2     3     4     5     6     7
             +-----+-----+-----+-----+-----+-----+-----+-----+
             |                 |                       |     |
             |   PRECEDENCE    |          TOS          | MBZ |
             |                 |                       |     |
             +-----+-----+-----+-----+-----+-----+-----+-----+

   The first field, labeled "PRECEDENCE" above, is intended to denote
   the importance or priority of the datagram.  This field is not
   discussed in detail in this memo.

   The second field, labeled "TOS" above, denotes how the network should
   make tradeoffs between throughput, delay, reliability, and cost.  The
   TOS field is the primary topic of this memo.

Now, if we look at linux/include/ip.h:

   #define IPTOS_TOS_MASK          0x1E
   #define IPTOS_TOS(tos)          ((tos)&IPTOS_TOS_MASK)
   #define IPTOS_LOWDELAY          0x10
   #define IPTOS_THROUGHPUT        0x08
   #define IPTOS_RELIABILITY       0x04
   #define IPTOS_MINCOST           0x02

It seems to me that the four bits which ip.h specifies for TOS flags are 
bits 1-5, not bits 3-7, in the TOS octet. Bits 0 and 1 are currently 
redefined by RFC 3168 [ftp://ftp.isi.edu/in-notes/rfc3168.txt] for use in 
ECN.

Therefore, it appears that use of the iptables TOS target, which modifies
bits 1-5 using the constants defined inip.h, will have unexpected results,
corrupting the ECN flags and not setting the actual TOS flags to the 
expected values.

Can anyone tell me where I'm going wrong, if at all, or whether in their
experience the TOS target works as expected under Linux? I would guess
that this problem permeates the whole kernel, and as a result would only
be a problem for interoperability between Linux and non-Linux systems.

tcpdump shows that the value of the TOS octet (which it reports as
[tos 0x??]) is set to the value specified on the iptables command line, 
and provides additional confirmation that the TOS target does indeed set 
the wrong bits in this octet. For example, with "-j TOS --set-tos 0x02", 
we see:

  12:55:28.150000 xxx.115.249.2.smtp > xxx.255.116.207.3225: . ack 2770120 
	win 62780 (DF) [tos 0x2,ECT]

(tcpdump's interpretation of the ECT bit is also wrong under RFC 2481
[ftp://ftp.isi.edu/in-notes/rfc2481.txt], since it uses bits 0-1 instead
of 6-7 as mandated by the RFC for ECN).

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
