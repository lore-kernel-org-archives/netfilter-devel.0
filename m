From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PATCH] fix netfilter build without INET
Date: Mon, 1 Nov 2004 15:50:02 -0800
Message-ID: <20041101155002.52f69c0d@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Get rid of build error if INET is not configured. Problem is that 
core would end up exporting non-existent symbol.

Signed-off-by: Stephen Hemminger <shemminger@osdl.org>

diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	2004-11-01 15:44:31 -08:00
+++ b/net/core/netfilter.c	2004-11-01 15:44:31 -08:00
@@ -673,6 +673,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ip_route_me_harder);
 
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
@@ -818,7 +819,6 @@
 }
 
 EXPORT_SYMBOL(ip_ct_attach);
-EXPORT_SYMBOL(ip_route_me_harder);
 EXPORT_SYMBOL(nf_getsockopt);
 EXPORT_SYMBOL(nf_hook_slow);
 EXPORT_SYMBOL(nf_hooks);
