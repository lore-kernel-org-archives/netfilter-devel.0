From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 10/18]: Fix check for ESP header size in ip6t_esp
Date: Mon, 20 Dec 2004 08:15:07 +0100
Message-ID: <41C67BFB.1070004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070504050304090700060404"
Cc: netfilter-devel@lists.netfilter.org
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
--------------070504050304090700060404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix check for ESP header size in ip6t_esp. 2.6 already gets
it right by using struct ip_esp_hdr from include/linux/ip.h.


--------------070504050304090700060404
Content-Type: text/x-patch;
 name="10.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:17:12+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix check for ESP header size in ip6t_esp
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_esp.c
#   2004/12/05 23:17:10+01:00 yasuyuki.kozakai@toshiba.co.jp +1 -0
#   [NETFILTER]: Fix check for ESP header size in ip6t_esp
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c	2004-12-20 07:01:16 +01:00
+++ b/net/ipv6/netfilter/ip6t_esp.c	2004-12-20 07:01:16 +01:00
@@ -22,6 +22,7 @@
 
 struct esphdr {
 	__u32   spi;
+	__u32   seq_no;
 };
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */

--------------070504050304090700060404--
