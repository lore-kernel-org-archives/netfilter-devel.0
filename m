From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] C99 initializers for pom-ng ip6t_HL.c
Date: Sun, 23 Jan 2005 23:12:29 +0100
Message-ID: <916084496.20050123231229@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello,

let us use C99 initializers in ip6t_HL.c

Regards,
Maciej

Index: ip6t_HL.c
===================================================================
--- ip6t_HL.c   (revision 3612)
+++ ip6t_HL.c   (working copy)
@@ -88,8 +88,12 @@
        return 1;
 }

-static struct ip6t_target ip6t_HL = { { NULL, NULL }, "HL",
-       ip6t_hl_target, ip6t_hl_checkentry, NULL, THIS_MODULE };
+static struct ip6t_target ip6t_HL = {
+       .name           = "HL",
+       .target         = ip6t_hl_target,
+       .checkentry     = ip6t_hl_checkentry,
+       .me             = THIS_MODULE
+};

 static int __init init(void)
 {
