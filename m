From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] exponential worst-case search for loops (ip_tables.c)
Date: Sun, 26 Nov 2006 18:15:46 +0000
Message-ID: <20061126181546.GY3078@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

If we come to node we'd already marked as seen and it's not a part of path
(i.e. we don't have a loop right there), we already know that it isn't a
part of any loop, so we don't need to revisit it.

That speeds the things up if some chain is refered to from several places
and kills O(exp(table size)) worst-case behaviour (without sleeping,
at that, so if you manage to self-LART that way, you are SOL for a long
time)...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/netfilter/ip_tables.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8a45543..10883e8 100644
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
 
 				/* Return: backtrack through the last
-- 
1.4.2.GIT
