From: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Thu, 13 Feb 2014 12:40:59 +0100
Message-ID: <1392291659-27444-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42975 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbaBMLos (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:44:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)
inserted IPSET_ATTR_MARKMASK in-between other enum values, i.e.
changing values of all further attributes.  This causes 'ipset list'
segfault on existing kernels since ipset no longer finds
IPSET_ATTR_MEMSIZE (it has a different value on kernel side).

Jozsef points out it should be moved below IPSET_ATTR_MARK which
works since there is some extra reserved space after that value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libipset/linux_ip_set.h                    | 4 ++--
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index c2bae85..a8d436f 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -84,13 +84,13 @@ enum {
 	IPSET_ATTR_CADT_FLAGS,	/* 8 */
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
+	IPSET_ATTR_MARKMASK,	/* 11 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
 	IPSET_ATTR_GC,
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
-	IPSET_ATTR_MARKMASK,
 	IPSET_ATTR_NETMASK,
 	IPSET_ATTR_PROBES,
 	IPSET_ATTR_RESIZE,
@@ -140,7 +140,6 @@ enum ipset_errno {
 	IPSET_ERR_EXIST,
 	IPSET_ERR_INVALID_CIDR,
 	IPSET_ERR_INVALID_NETMASK,
-	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_INVALID_FAMILY,
 	IPSET_ERR_TIMEOUT,
 	IPSET_ERR_REFERENCED,
@@ -148,6 +147,7 @@ enum ipset_errno {
 	IPSET_ERR_IPADDR_IPV6,
 	IPSET_ERR_COUNTER,
 	IPSET_ERR_COMMENT,
+	IPSET_ERR_INVALID_MARKMASK,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index c2bae85..a8d436f 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -84,13 +84,13 @@ enum {
 	IPSET_ATTR_CADT_FLAGS,	/* 8 */
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
+	IPSET_ATTR_MARKMASK,	/* 11 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
 	IPSET_ATTR_GC,
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
-	IPSET_ATTR_MARKMASK,
 	IPSET_ATTR_NETMASK,
 	IPSET_ATTR_PROBES,
 	IPSET_ATTR_RESIZE,
@@ -140,7 +140,6 @@ enum ipset_errno {
 	IPSET_ERR_EXIST,
 	IPSET_ERR_INVALID_CIDR,
 	IPSET_ERR_INVALID_NETMASK,
-	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_INVALID_FAMILY,
 	IPSET_ERR_TIMEOUT,
 	IPSET_ERR_REFERENCED,
@@ -148,6 +147,7 @@ enum ipset_errno {
 	IPSET_ERR_IPADDR_IPV6,
 	IPSET_ERR_COUNTER,
 	IPSET_ERR_COMMENT,
+	IPSET_ERR_INVALID_MARKMASK,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
-- 
1.8.1.5

