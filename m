From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 3/10]: fixes for ip6t_esp
Date: Wed, 01 Dec 2004 17:05:35 +0900 (JST)
Message-ID: <200412010805.iB185a28003133@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:05:36_2004_579)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Wed_Dec__1_17:05:36_2004_579)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes the check of ESP header size.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Dec__1_17:05:36_2004_579)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="esp.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6t_esp.c	2003-08-25 20:44:44.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6t_esp.c	2004-11-10 00:51:45.000000000 +0900
@@ -22,6 +22,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 
 struct esphdr {
 	__u32   spi;
+	__u32   seq_no;
 };
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */

----Next_Part(Wed_Dec__1_17:05:36_2004_579)----
