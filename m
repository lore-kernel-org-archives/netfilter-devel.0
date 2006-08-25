From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ip6t_REJECT: wire up ip6t_register_target() return value
Date: Fri, 25 Aug 2006 05:06:54 +0400
Message-ID: <20060825010654.GJ5204@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: netdev@vger.kernel.org
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv6/netfilter/ip6t_REJECT.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -256,9 +256,7 @@ static struct ip6t_target ip6t_reject_re
 
 static int __init ip6t_reject_init(void)
 {
-	if (ip6t_register_target(&ip6t_reject_reg))
-		return -EINVAL;
-	return 0;
+	return ip6t_register_target(&ip6t_reject_reg);
 }
 
 static void __exit ip6t_reject_fini(void)

