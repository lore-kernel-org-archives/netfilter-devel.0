From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/4]: Fix compile with NAT but without modules
Date: Tue, 25 Jan 2005 05:48:25 +0100
Message-ID: <41F5CF99.8010503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060303090207030901050106"
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
--------------060303090207030901050106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------060303090207030901050106
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/25 04:12:44+01:00 gandalf@wlug.westbo.se 
#   [NETFILTER]: Fix compile with NAT but without modules
#   
#   Here's another patch to fix compile-errors, this time with NAT but
#   without modules. There's a missing 'extern' in ip_conntrack_tftp.h
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_tftp.h
#   2005/01/25 04:12:37+01:00 gandalf@wlug.westbo.se +1 -1
#   [NETFILTER]: Fix compile with NAT but without modules
#   
#   Here's another patch to fix compile-errors, this time with NAT but
#   without modules. There's a missing 'extern' in ip_conntrack_tftp.h
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_tftp.h b/include/linux/netfilter_ipv4/ip_conntrack_tftp.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-25 04:37:16 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-25 04:37:16 +01:00
@@ -13,7 +13,7 @@
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
+extern unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
 				 struct ip_conntrack_expect *exp);
 

--------------060303090207030901050106--
