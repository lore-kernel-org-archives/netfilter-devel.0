From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] netfilter: xtables: add missing aliases for autoloading via iptables
Date: Tue, 18 Jan 2011 16:16:55 +0100
Message-ID: <1295363820-14881-2-git-send-email-jengelh@medozas.de>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40484 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1ARPRH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:17:07 -0500
In-Reply-To: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_IDLETIMER.c |    2 ++
 net/netfilter/xt_LED.c       |    2 ++
 net/netfilter/xt_cpu.c       |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index be1f22e..3bdd443 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -313,3 +313,5 @@ MODULE_AUTHOR("Timo Teras <ext-timo.teras@nokia.com>");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_DESCRIPTION("Xtables: idle time monitor");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("ipt_IDLETIMER");
+MODULE_ALIAS("ip6t_IDLETIMER");
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index a414050..993de2b 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -31,6 +31,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
 MODULE_DESCRIPTION("Xtables: trigger LED devices on packet match");
+MODULE_ALIAS("ipt_LED");
+MODULE_ALIAS("ip6t_LED");
 
 static LIST_HEAD(xt_led_triggers);
 static DEFINE_MUTEX(xt_led_mutex);
diff --git a/net/netfilter/xt_cpu.c b/net/netfilter/xt_cpu.c
index b39db8a..c7a2e54 100644
--- a/net/netfilter/xt_cpu.c
+++ b/net/netfilter/xt_cpu.c
@@ -22,6 +22,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Dumazet <eric.dumazet@gmail.com>");
 MODULE_DESCRIPTION("Xtables: CPU match");
+MODULE_ALIAS("ipt_cpu");
+MODULE_ALIAS("ip6t_cpu");
 
 static int cpu_mt_check(const struct xt_mtchk_param *par)
 {
-- 
1.7.1

