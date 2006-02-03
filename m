From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/14]: Fix possible overflow in netfilters do_replace()
Date: Fri,  3 Feb 2006 14:44:13 +0100 (MET)
Message-ID: <20060203134413.2141.83807.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Fix possible overflow in netfilters do_replace()

netfilter's do_replace() can overflow on addition within SMP_ALIGN()
and/or on multiplication by NR_CPUS, resulting in a buffer overflow on
the copy_from_user().  In practice, the overflow on addition is
triggerable on all systems, whereas the multiplication one might require
much physical memory to be present due to the check above.  Either is
sufficient to overwrite arbitrary amounts of kernel memory.

I really hate adding the same check to all 4 versions of do_replace(),
but the code is duplicate...

Found by Solar Designer during security audit of OpenVZ.org

Signed-Off-By: Kirill Korotaev <dev@openvz.org>
Signed-Off-By: Solar Designer <solar@openwall.com>
Signed-off-by: Patrck McHardy <kaber@trash.net>

---
commit 9da97b95715756a28bfc1a931f033db6206d7dfd
tree 324df1f3f32b106230846b91decb996bda9bafbb
parent 37c30c251f15cb0a38cd4065e178f11b6ed5c145
author Kirill Korotaev <dev@openvz.org> Fri, 03 Feb 2006 12:46:15 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:46:15 +0100

 net/bridge/netfilter/ebtables.c |    7 +++++++
 net/ipv4/netfilter/arp_tables.c |    7 +++++++
 net/ipv4/netfilter/ip_tables.c  |    7 +++++++
 net/ipv6/netfilter/ip6_tables.c |    7 +++++++
 4 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 00729b3..cbd4020 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -934,6 +934,13 @@ static int do_replace(void __user *user,
 		BUGPRINT("Entries_size never zero\n");
 		return -EINVAL;
 	}
+	/* overflow check */
+	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+		return -ENOMEM;
+
 	countersize = COUNTER_OFFSET(tmp.nentries) * 
 					(highest_possible_processor_id()+1);
 	newinfo = (struct ebt_table_info *)
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index afe3d8f..dd1048b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -807,6 +807,13 @@ static int do_replace(void __user *user,
 	if (len != sizeof(tmp) + tmp.size)
 		return -ENOPROTOOPT;
 
+	/* overflow check */
+	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES)
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2371b20..16f47c6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -921,6 +921,13 @@ do_replace(void __user *user, unsigned i
 	if (len != sizeof(tmp) + tmp.size)
 		return -ENOPROTOOPT;
 
+	/* overflow check */
+	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES)
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 847068f..74ff56c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -978,6 +978,13 @@ do_replace(void __user *user, unsigned i
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
+	/* overflow check */
+	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES)
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
 		return -ENOMEM;
