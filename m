From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/12]: Use u_int16_t for initialized/num_manips in struct
 ip_nat_info
Date: Tue, 21 Sep 2004 05:22:44 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E84.8020507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010706090208090409050407"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010706090208090409050407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.6, 2004-09-19 15:33:35+02:00, kaber@coreworks.de
  [NETFILTER]: Use u_int16_t for initialized/num_manips in struct 
ip_nat_info
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------010706090208090409050407
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 15:33:35+02:00 kaber@coreworks.de 
#   [NETFILTER]: Use u_int16_t for initialized/num_manips in struct ip_nat_info
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat.h
#   2004/09/19 15:33:04+02:00 kaber@coreworks.de +2 -2
#   [NETFILTER]: Use u_int16_t for initialized/num_manips in struct ip_nat_info
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h	2004-09-20 11:58:08 +02:00
+++ b/include/linux/netfilter_ipv4/ip_nat.h	2004-09-20 11:58:08 +02:00
@@ -84,9 +84,9 @@
 struct ip_nat_info
 {
 	/* Set to zero when conntrack created: bitmask of maniptypes */
-	int initialized;
+	u_int16_t initialized;
 
-	unsigned int num_manips;
+	u_int16_t num_manips;
 
 	/* Manipulations to be done on this conntrack. */
 	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];

--------------010706090208090409050407--
