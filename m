From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: fixed kernel panic when trying to find tcp option
Date: Wed, 15 Sep 2004 20:36:44 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409151136.i8FBajor029883@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Sep_15_20:36:44_2004_804)--"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Wed_Sep_15_20:36:44_2004_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This patch fixed panic on 2.6.9-rc2 when trying to find tcp option
in the packet which has no option.

If not fixed yet, please apply this patch.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Sep_15_20:36:44_2004_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="tcp_find_option.patch"

--- linux-2.6.9-rc2/net/ipv4/netfilter/ip_tables.c	2004-09-15 14:04:16.000000000 +0900
+++ linux-2.6.9-rc2-nolinearize/net/ipv4/netfilter/ip_tables.c	2004-09-15 20:01:42.970226904 +0900
@@ -1464,8 +1464,9 @@ tcp_find_option(u_int8_t option,
 	unsigned int i;
 
 	duprintf("tcp_match: finding option\n");
+	if (!optlen)
+		return invert;
 	/* If we don't have the whole header, drop packet. */
-	BUG_ON(!optlen);
 	op = skb_header_pointer(skb,
 				skb->nh.iph->ihl*4 + sizeof(struct tcphdr),
 				optlen, _opt);

----Next_Part(Wed_Sep_15_20:36:44_2004_804)----
