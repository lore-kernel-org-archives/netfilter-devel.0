From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 4/9]: Ignore PSH on SYN/ACK in TCP connection
 tracking
Date: Mon, 23 May 2005 15:19:01 +0900 (JST)
Message-ID: <200505230619.j4N6J20m016845@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:19:01_2005_473)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:19:01_2005_473)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Ignore PSH on SYN/ACK in TCP connection tracking

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:19:01_2005_473)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-tcp-psh.patch"

diff -Nur linux-2.6.12-rc4-nfct-3-tcp-csum/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.12-rc4-nfct-4-tcp-psh/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.12-rc4-nfct-3-tcp-csum/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-19 14:18:44.000000000 +0900
+++ linux-2.6.12-rc4-nfct-4-tcp-psh/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-19 14:22:58.000000000 +0900
@@ -779,6 +779,7 @@
 {
 	[TH_SYN]			= 1,
 	[TH_SYN|TH_ACK]			= 1,
+	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,

----Next_Part(Mon_May_23_15:19:01_2005_473)----
