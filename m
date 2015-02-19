From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/7] extensions: SNPT,DNPT: fix save/print output
Date: Thu, 19 Feb 2015 14:11:21 +0100
Message-ID: <1424351483-27617-6-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58481 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbbBSNLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:47 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

wrong placement of ' ', i.e. we get
-j SNPT--src-pfx dead::/64 --dst-pfx 1c3::/64

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libip6t_DNPT.c | 8 ++++----
 extensions/libip6t_DNPT.t | 1 +
 extensions/libip6t_SNPT.c | 8 ++++----
 extensions/libip6t_SNPT.t | 1 +
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_DNPT.c b/extensions/libip6t_DNPT.c
index a442de6..d045e44 100644
--- a/extensions/libip6t_DNPT.c
+++ b/extensions/libip6t_DNPT.c
@@ -52,9 +52,9 @@ static void DNPT_print(const void *ip, const struct xt_entry_target *target,
 {
 	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
 
-	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
+	printf(" DNPT src-pfx %s/%u", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
 				 npt->src_pfx_len);
-	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
+	printf(" dst-pfx %s/%u", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
 				 npt->dst_pfx_len);
 }
 
@@ -65,12 +65,12 @@ static void DNPT_save(const void *ip, const struct xt_entry_target *target)
 
 	if (memcmp(&info->src_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
 	    info->src_pfx_len != 0)
-		printf("--src-pfx %s/%u ",
+		printf(" --src-pfx %s/%u",
 		       xtables_ip6addr_to_numeric(&info->src_pfx.in6),
 		       info->src_pfx_len);
 	if (memcmp(&info->dst_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
 	    info->dst_pfx_len != 0)
-		printf("--dst-pfx %s/%u ",
+		printf(" --dst-pfx %s/%u",
 		       xtables_ip6addr_to_numeric(&info->dst_pfx.in6),
 		       info->dst_pfx_len);
 }
diff --git a/extensions/libip6t_DNPT.t b/extensions/libip6t_DNPT.t
index 25ec935..0406dc9 100644
--- a/extensions/libip6t_DNPT.t
+++ b/extensions/libip6t_DNPT.t
@@ -1,5 +1,6 @@
 :PREROUTING
 *mangle
+-j DNPT --src-pfx dead::/64 --dst-pfx 1c3::/64;=;OK
 -j DNPT --src-pfx dead::beef --dst-pfx 1c3::/64;;FAIL
 -j DNPT --src-pfx dead::/64;;FAIL
 -j DNPT --dst-pfx dead::/64;;FAIL
diff --git a/extensions/libip6t_SNPT.c b/extensions/libip6t_SNPT.c
index 4f10de0..65f787d 100644
--- a/extensions/libip6t_SNPT.c
+++ b/extensions/libip6t_SNPT.c
@@ -52,9 +52,9 @@ static void SNPT_print(const void *ip, const struct xt_entry_target *target,
 {
 	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
 
-	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
+	printf(" SNPT src-pfx %s/%u", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
 				 npt->src_pfx_len);
-	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
+	printf(" dst-pfx %s/%u", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
 				 npt->dst_pfx_len);
 }
 
@@ -65,12 +65,12 @@ static void SNPT_save(const void *ip, const struct xt_entry_target *target)
 
 	if (memcmp(&info->src_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
 	    info->src_pfx_len != 0)
-		printf("--src-pfx %s/%u ",
+		printf(" --src-pfx %s/%u",
 		       xtables_ip6addr_to_numeric(&info->src_pfx.in6),
 		       info->src_pfx_len);
 	if (memcmp(&info->dst_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
 	    info->dst_pfx_len != 0)
-		printf("--dst-pfx %s/%u ",
+		printf(" --dst-pfx %s/%u",
 		       xtables_ip6addr_to_numeric(&info->dst_pfx.in6),
 		       info->dst_pfx_len);
 }
diff --git a/extensions/libip6t_SNPT.t b/extensions/libip6t_SNPT.t
index 5a2fe7f..7ed6d0c 100644
--- a/extensions/libip6t_SNPT.t
+++ b/extensions/libip6t_SNPT.t
@@ -1,5 +1,6 @@
 :INPUT,POSTROUTING
 *mangle
+-j SNPT --src-pfx dead::/64 --dst-pfx 1c3::/64;=;OK
 -j SNPT --src-pfx dead::beef --dst-pfx 1c3::/64;;FAIL
 -j SNPT --src-pfx dead::/64;;FAIL
 -j SNPT --dst-pfx dead::/64;;FAIL
-- 
2.0.5

