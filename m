From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/64]: {ip,ip6}_tables: fix format strings
Date: Tue, 18 Dec 2007 00:46:38 +0100 (MET)
Message-ID: <20071217234638.23601.87425.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38937 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbXLQXqk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:40 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6}_tables: fix format strings

Use %zu for sizeof() and remove casts.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f6ef0d462fc82cabb301c055e35617fbe91e062d
tree 3c02133f043d0c239e6cb731adeaeb5d732b8f19
parent 78122604ad05f50a11447c798605d985a4357843
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:58 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 net/ipv4/netfilter/ip_tables.c  |   20 ++++++++------------
 net/ipv6/netfilter/ip6_tables.c |   16 +++++++---------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 231f5d2..98c65ac 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1091,8 +1091,8 @@ static int get_info(void __user *user, int *len, int compat)
 	int ret;
 
 	if (*len != sizeof(struct ipt_getinfo)) {
-		duprintf("length %u != %u\n", *len,
-			(unsigned int)sizeof(struct ipt_getinfo));
+		duprintf("length %u != %zu\n", *len,
+			 sizeof(struct ipt_getinfo));
 		return -EINVAL;
 	}
 
@@ -1151,16 +1151,14 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
-		duprintf("get_entries: %u < %d\n", *len,
-				(unsigned int)sizeof(get));
+		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
 	if (*len != sizeof(struct ipt_get_entries) + get.size) {
-		duprintf("get_entries: %u != %u\n", *len,
-				(unsigned int)(sizeof(struct ipt_get_entries) +
-				get.size));
+		duprintf("get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
@@ -1911,8 +1909,7 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
-		duprintf("compat_get_entries: %u < %u\n",
-			 *len, (unsigned int)sizeof(get));
+		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 
@@ -1920,9 +1917,8 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 		return -EFAULT;
 
 	if (*len != sizeof(struct compat_ipt_get_entries) + get.size) {
-		duprintf("compat_get_entries: %u != %u\n", *len,
-			 (unsigned int)(sizeof(struct compat_ipt_get_entries) +
-			 get.size));
+		duprintf("compat_get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0a2ec4b..40893fc 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1120,7 +1120,7 @@ static int get_info(void __user *user, int *len, int compat)
 	int ret;
 
 	if (*len != sizeof(struct ip6t_getinfo)) {
-		duprintf("length %u != %u\n", *len,
+		duprintf("length %u != %zu\n", *len,
 			 sizeof(struct ip6t_getinfo));
 		return -EINVAL;
 	}
@@ -1180,14 +1180,14 @@ get_entries(struct ip6t_get_entries __user *uptr, int *len)
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
-		duprintf("get_entries: %u < %u\n", *len, sizeof(get));
+		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
 	if (*len != sizeof(struct ip6t_get_entries) + get.size) {
-		duprintf("get_entries: %u != %u\n", *len,
-			 sizeof(struct ip6t_get_entries) + get.size);
+		duprintf("get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
@@ -1931,8 +1931,7 @@ compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
-		duprintf("compat_get_entries: %u < %u\n",
-			 *len, (unsigned int)sizeof(get));
+		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 
@@ -1940,9 +1939,8 @@ compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 		return -EFAULT;
 
 	if (*len != sizeof(struct compat_ip6t_get_entries) + get.size) {
-		duprintf("compat_get_entries: %u != %u\n", *len,
-			 (unsigned int)(sizeof(struct compat_ip6t_get_entries) +
-			 get.size));
+		duprintf("compat_get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
