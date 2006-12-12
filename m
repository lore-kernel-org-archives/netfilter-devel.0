From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/06]: {ip, ip6,
	arp}_tables: fix exponential worst-case search for loops
Date: Tue, 12 Dec 2006 09:06:26 +0100 (MET)
Message-ID: <20061212080950.4788.65813.sendpatchset@localhost.localdomain>
References: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
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

[NETFILTER]: {ip,ip6,arp}_tables: fix exponential worst-case search for loops

If we come to node we'd already marked as seen and it's not a part of path
(i.e. we don't have a loop right there), we already know that it isn't a
part of any loop, so we don't need to revisit it.

That speeds the things up if some chain is refered to from several places
and kills O(exp(table size)) worst-case behaviour (without sleeping,
at that, so if you manage to self-LART that way, you are SOL for a long
time)...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1ed7c34fb5da5919a9b0fcae5299b8297ccae21d
tree 645eafd9a55aba9b094826489e0a44482ab9a62d
parent b364d80996eb9ebd18b443dac82cb6c47b72f381
author Al Viro <viro@zeniv.linux.org.uk> Tue, 12 Dec 2006 08:50:50 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:50 +0100

 net/ipv4/netfilter/arp_tables.c |    5 +++--
 net/ipv4/netfilter/ip_tables.c  |    5 +++--
 net/ipv6/netfilter/ip6_tables.c |    5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 71b76ad..9aa2239 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -358,6 +358,7 @@ static int mark_source_chains(struct xt_
 		for (;;) {
 			struct arpt_standard_target *t
 				= (void *)arpt_get_target(e);
+			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_ARP_NUMHOOKS)) {
 				printk("arptables: loop hook %u pos %u %08X.\n",
@@ -368,11 +369,11 @@ static int mark_source_chains(struct xt_
 				|= ((1 << hook) | (1 << NF_ARP_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if (e->target_offset == sizeof(struct arpt_entry)
+			if ((e->target_offset == sizeof(struct arpt_entry)
 			    && (strcmp(t->target.u.user.name,
 				       ARPT_STANDARD_TARGET) == 0)
 			    && t->verdict < 0
-			    && unconditional(&e->arp)) {
+			    && unconditional(&e->arp)) || visited) {
 				unsigned int oldpos, size;
 
 				if (t->verdict < -NF_MAX_VERDICT - 1) {
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 83ebbeb..09696f1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -384,6 +384,7 @@ mark_source_chains(struct xt_table_info 
 		for (;;) {
 			struct ipt_standard_target *t
 				= (void *)ipt_get_target(e);
+			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_IP_NUMHOOKS)) {
 				printk("iptables: loop hook %u pos %u %08X.\n",
@@ -394,11 +395,11 @@ mark_source_chains(struct xt_table_info 
 				|= ((1 << hook) | (1 << NF_IP_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if (e->target_offset == sizeof(struct ipt_entry)
+			if ((e->target_offset == sizeof(struct ipt_entry)
 			    && (strcmp(t->target.u.user.name,
 				       IPT_STANDARD_TARGET) == 0)
 			    && t->verdict < 0
-			    && unconditional(&e->ip)) {
+			    && unconditional(&e->ip)) || visited) {
 				unsigned int oldpos, size;
 
 				if (t->verdict < -NF_MAX_VERDICT - 1) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 4eec4b3..99502c5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -413,6 +413,7 @@ mark_source_chains(struct xt_table_info 
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ip6t_entry *e
 			= (struct ip6t_entry *)(entry0 + pos);
+		int visited = e->comefrom & (1 << hook);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -433,11 +434,11 @@ mark_source_chains(struct xt_table_info 
 				|= ((1 << hook) | (1 << NF_IP6_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if (e->target_offset == sizeof(struct ip6t_entry)
+			if ((e->target_offset == sizeof(struct ip6t_entry)
 			    && (strcmp(t->target.u.user.name,
 				       IP6T_STANDARD_TARGET) == 0)
 			    && t->verdict < 0
-			    && unconditional(&e->ipv6)) {
+			    && unconditional(&e->ipv6)) || visited) {
 				unsigned int oldpos, size;
 
 				if (t->verdict < -NF_MAX_VERDICT - 1) {
