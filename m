From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/64]: ip_tables: account for struct ipt_entry/struct compat_ipt_entry size diff
Date: Tue, 18 Dec 2007 00:46:19 +0100 (MET)
Message-ID: <20071217234619.23601.99496.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38893 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbXLQXqU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:20 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: account for struct ipt_entry/struct compat_ipt_entry size diff

Account for size differences when dumping entries or calculating the
entry positions. This doesn't actually make any difference for IPv4
since the structures have the same size, but its logically correct
and needed for IPv6.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cac25046b4856c4b88839f58149fa287a5067d55
tree 6cdebbd22200d853b7c87fc5bfebce598736a4b8
parent ab9bc844e8aa064500496a0de876e1afe4466d9c
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:39 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:39 +0100

 net/ipv4/netfilter/ip_tables.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4586af3..cc896fe 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1098,7 +1098,7 @@ static int compat_calc_entry(struct ipt_entry *e,
 	unsigned int entry_offset;
 	int off, i, ret;
 
-	off = 0;
+	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - base;
 	IPT_MATCH_ITERATE(e, compat_calc_match, &off);
 	t = ipt_get_target(e);
@@ -1501,6 +1501,8 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 		goto out;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
+	*size -= sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
+
 	ret = IPT_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
@@ -1605,7 +1607,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	if (ret)
 		return ret;
 
-	off = 0;
+	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
@@ -1671,6 +1673,8 @@ compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 	memcpy(de, e, sizeof(struct ipt_entry));
 
 	*dstptr += sizeof(struct compat_ipt_entry);
+	*size += sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
+
 	ret = IPT_MATCH_ITERATE(e, xt_compat_match_from_user, dstptr, size);
 	if (ret)
 		return ret;
