From: Oskar Berggren <beo@sgs.o.se>
Subject: [PATCH] pool match and iptables-save
Date: Fri, 15 Nov 2002 18:03:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DD528EF.7030908@sgs.o.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This patch fixes a problem using the pool match and iptables-save
together.

regards,
Oskar


diff -ur iptables-1.2.7a-orig/extensions/libipt_pool.c iptables-1.2.7a-fix/extensions/libipt_pool.c
--- iptables-1.2.7a-orig/extensions/libipt_pool.c       Wed May 29 15:08:16 2002
+++ iptables-1.2.7a-fix/extensions/libipt_pool.c        Wed Oct 30 00:42:32 2002
@@ -113,11 +113,11 @@
                (struct ipt_pool_info *)match->data;
 
        if (info->src != IP_POOL_NONE)
-               printf("%s--srcpool %s",
+               printf("%s--srcpool %s ",
                        (info->flags & IPT_POOL_INV_SRC) ? "! " : "",
                        ip_pool_get_name(buf, sizeof(buf), info->src, 0));
        if (info->dst != IP_POOL_NONE)
-               printf("%s--dstpool %s",
+               printf("%s--dstpool %s ",
                        (info->flags & IPT_POOL_INV_DST) ? "! " : "",
                        ip_pool_get_name(buf, sizeof(buf), info->dst, 0));
 }



-- 
/----------------------------------------------------------------------\
| Oskar Berggren        beo@sgs.o.se                                   |
| Network and Software Engineer                     SGS Datanätgrupp   |
|                                                   Gothenburg, Sweden |
\----------------------------------------------------------------------/
