From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 2.5] fix typo in ipv6 netfilter makefile
Date: 15 Apr 2003 17:56:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1050422204.30781.28.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Here's the fix for 2.5

--- linux-2.5.67/net/ipv6/netfilter/Makefile.orig	2003-04-15 17:37:32.000000000 +0200
+++ linux-2.5.67/net/ipv6/netfilter/Makefile	2003-04-15 17:37:44.000000000 +0200
@@ -21,4 +21,4 @@
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
-obj-$(CONFIG_IP_NF_MATCH_HL) += ip6t_hl.o
+obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o



-- 
/Martin
