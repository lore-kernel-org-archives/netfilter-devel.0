From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/8]: SCTP conntrack: fix association restart
Date: Fri, 04 Mar 2005 13:00:49 +0100
Message-ID: <42284DF1.5090303@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="06.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:18:41+01:00 ariel@blueslice.com 
#   [NETFILTER]: SCTP conntrack: fix association restart
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2005/03/03 23:18:33+01:00 ariel@blueslice.com +2 -2
#   [NETFILTER]: SCTP conntrack: fix association restart
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-03-03 23:36:00 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-03-03 23:36:00 +01:00
@@ -400,8 +400,8 @@
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
-					ih->init_tag, CTINFO2DIR(ctinfo));
-			conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = ih->init_tag;
+					ih->init_tag, !CTINFO2DIR(ctinfo));
+			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
