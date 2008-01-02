From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 1/7] netfilter: Export ip6t_mh.h and xt_quota.h for iptables build
Date: Wed, 2 Jan 2008 08:57:35 -0700
Message-ID: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
Cc: netfilter-devel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760553AbYGUEgW@vger.kernel.org>
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

CC: netfilter-devel@vger.kernel.org
Signed-off-by: Soren Hansen <soren@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Collins <ben.lcollins@canonical.com>
---
 include/linux/netfilter/Kbuild      |    2 ++
 include/linux/netfilter_ipv6/Kbuild |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 3aff513..3a04da3 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -31,6 +31,8 @@ header-y += xt_multiport.h
 header-y += xt_owner.h
 header-y += xt_pkttype.h
 header-y += xt_rateest.h
+header-y += xt_policy.h
+header-y += xt_quota.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index 8887a5f..aca4bd1 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -11,6 +11,7 @@ header-y += ip6t_length.h
 header-y += ip6t_limit.h
 header-y += ip6t_mac.h
 header-y += ip6t_mark.h
+header-y += ip6t_mh.h
 header-y += ip6t_multiport.h
 header-y += ip6t_opts.h
 header-y += ip6t_owner.h
-- 
1.5.4.3
