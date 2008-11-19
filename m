From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] netfilter: ip{,6}t_policy.h should include xp_policy.h
Date: Wed, 19 Nov 2008 16:21:22 +0000
Message-ID: <1227111682-14073-1-git-send-email-apw@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It seems that all of the include/netfilter_{ipv4,ipv6}/{ipt,ip6t}_*.h which
share constants include the corresponding include/netfilter/xp_*.h files.
Neither ipt_policy.h not ip6t_policy.h do.  Make these consistant with
the norm.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 include/linux/netfilter_ipv4/ipt_policy.h  |    2 ++
 include/linux/netfilter_ipv6/ip6t_policy.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_policy.h b/include/linux/netfilter_ipv4/ipt_policy.h
index b9478a2..1037fb2 100644
--- a/include/linux/netfilter_ipv4/ipt_policy.h
+++ b/include/linux/netfilter_ipv4/ipt_policy.h
@@ -1,6 +1,8 @@
 #ifndef _IPT_POLICY_H
 #define _IPT_POLICY_H
 
+#include <linux/netfilter/xt_policy.h>
+
 #define IPT_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
 /* ipt_policy_flags */
diff --git a/include/linux/netfilter_ipv6/ip6t_policy.h b/include/linux/netfilter_ipv6/ip6t_policy.h
index 6bab316..b1c449d 100644
--- a/include/linux/netfilter_ipv6/ip6t_policy.h
+++ b/include/linux/netfilter_ipv6/ip6t_policy.h
@@ -1,6 +1,8 @@
 #ifndef _IP6T_POLICY_H
 #define _IP6T_POLICY_H
 
+#include <linux/netfilter/xt_policy.h>
+
 #define IP6T_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
 /* ip6t_policy_flags */
-- 
1.6.0.4.911.gc990

