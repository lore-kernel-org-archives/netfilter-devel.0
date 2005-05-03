From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Don't checksum CHECKSUM_UNNECESSARY skbs in TCP
 connection tracking
Date: Tue, 03 May 2005 18:53:15 +0200
Message-ID: <4277AC7B.6020600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010104010002030407020003"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------010104010002030407020003
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

TCP connection tracking incorrectly tries to verify the checksum of
CHECKSUM_UNNECESSARY packets. This causes packets on loopback to
be tracked as INVALID since we now drop the conntrack reference on
output and don't skip connection tracking on input anymore.


--------------010104010002030407020003
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Don't checksum CHECKSUM_UNNECESSARY skbs in TCP connection tracking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 28b4b5756c08e6c4f053e6298c6cc176dd51cc9c
tree 37a577077717c6fc76b74317dd95502e3c0b0803
parent 480fc9b2802f2093e728567010506732e382b688
author Patrick McHardy <kaber@trash.net> 1115138945 +0200
committer Patrick McHardy <kaber@trash.net> 1115138945 +0200

Index: net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- 97b316503a4524074c05d5fb4cab63264690d0d6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:2b87c1974be605d5bdb1ee769188d7e03fb2ddc8)
+++ 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:721ddbf522b422d554479a7ab15c0955798f16ee)
@@ -819,6 +819,7 @@
 	 */
 	/* FIXME: Source route IP option packets --RR */
 	if (hooknum == NF_IP_PRE_ROUTING
+	    && skb->ip_summed != CHECKSUM_UNNECESSARY
 	    && csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
 			         skb->ip_summed == CHECKSUM_HW ? skb->csum
 			      	 : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {

--------------010104010002030407020003--
