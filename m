From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 2.4] fix typo in ipv6 netfilter makefile
Date: 15 Apr 2003 17:56:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1050422195.30795.26.camel@tux.rsn.bth.se>
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

Hi

While syncing netfilter patch-o-matic with 2.4-bk I found that there's
still a typo in ipv6/netfilter/Makefile

Next mail contains the same fix for 2.5

Please apply.


--- linux-2.4.21-pre7-bk.test/net/ipv6/netfilter/Makefile	2003-04-15 17:33:36.000000000 +0200
+++ linux-2.4.21-pre7-bk.test2/net/ipv6/netfilter/Makefile	2003-04-15 17:33:45.000000000 +0200
@@ -30,6 +30,6 @@
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
-obj-$(CONFIG_IP_NF_MATCH_HL) += ip6t_hl.o
+obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 
 include $(TOPDIR)/Rules.make


-- 
/Martin
