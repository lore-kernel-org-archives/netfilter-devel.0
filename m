From: Pawel Sikora <pluto@agmk.net>
Subject: [TRIVIAL PATCH] pptp / kill gcc warnings.
Date: Mon, 1 Aug 2005 12:08:19 +0200
Message-ID: <200508011208.19824.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TSf7CZggk5FVpo/"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
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

--Boundary-00=_TSf7CZggk5FVpo/
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



--Boundary-00=_TSf7CZggk5FVpo/
Content-Type: text/x-diff;
  charset="utf-8";
  name="pptp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pptp.diff"

  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_gre.o
          net/ipv4/netfilter/ip_conntrack_proto_gre.c: In function 'gre_packet':
          net/ipv4/netfilter/ip_conntrack_proto_gre.c:283: warning:
           passing argument 3 of 'ip_ct_refresh_acct' discards qualifiers from pointer target type
          net/ipv4/netfilter/ip_conntrack_proto_gre.c:288: warning:
           passing argument 3 of 'ip_ct_refresh_acct' discards qualifiers from pointer target type
          net/ipv4/netfilter/ip_conntrack_proto_gre.c: At top level:
          net/ipv4/netfilter/ip_conntrack_proto_gre.c:329: warning:
           initialization from incompatible pointer type

Index: linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c
===================================================================
--- linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c	(revision 4208)
+++ linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c	(working copy)
@@ -273,7 +273,7 @@
 
 /* Returns verdict for packet, and may modify conntrack */
 static int gre_packet(struct ip_conntrack *ct,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info conntrackinfo)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.

--Boundary-00=_TSf7CZggk5FVpo/--
