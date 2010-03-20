From: wzt.wzt@gmail.com
Subject: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Sat, 20 Mar 2010 22:32:40 +0800
Message-ID: <20100320143240.GB2942@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:34631 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0CTOcp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:32:45 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The get.size field in the get_entries() interface is not bounded
correctly. The size is used to determine the total entry size.
The size is bounded, but can overflow and so the size checks may
not be sufficient to catch invalid size. Fix it by catching size
values that would cause overflows before calculating the size.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv4/netfilter/ip_tables.c  |    4 ++++
 net/ipv6/netfilter/ip6_tables.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4e7c719..6abd3d2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1164,6 +1164,10 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr, int *len)
 	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
+
+	if (get.size >= INT_MAX / sizeof(struct ipt_get_entries))
+		return -EINVAL;
+
 	if (*len != sizeof(struct ipt_get_entries) + get.size) {
 		duprintf("get_entries: %u != %zu\n",
 			 *len, sizeof(get) + get.size);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0b4557e..5185822 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1190,6 +1190,10 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr, int *len)
 	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
+
+	if (get.size >= INT_MAX / sizeof(struct ip6t_get_entries))
+		return -EINVAL;
+
 	if (*len != sizeof(struct ip6t_get_entries) + get.size) {
 		duprintf("get_entries: %u != %zu\n",
 			 *len, sizeof(get) + get.size);
-- 
1.6.5.3

