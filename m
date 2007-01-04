From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: ebtables: don't compute gap before checking
	struct type
Date: Thu,  4 Jan 2007 19:38:27 +0100 (MET)
Message-ID: <20070104183827.18369.42643.sendpatchset@localhost.localdomain>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ebtables: don't compute gap before checking struct type

We cannot compute the gap until we know we have a 'struct ebt_entry' and
not 'struct ebt_entries'.  Failure to check can cause crash.

Tested-by: Santiago Garcia Mantinan <manty@manty.net>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5a6aa046d38ffffa96ee2c6cbba0ea7fa405abdf
tree d7215dd5b39707affd4ce0e70d313335ffd85611
parent 36263425185d6993ca8af49ad6e7d1af66846d9c
author Chuck Ebbert <76306.1226@compuserve.com> Thu, 04 Jan 2007 19:28:53 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 04 Jan 2007 19:28:53 +0100

 net/bridge/netfilter/ebtables.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index bee558a..6c84ccb 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -610,7 +610,7 @@ ebt_check_entry(struct ebt_entry *e, str
 	struct ebt_entry_target *t;
 	struct ebt_target *target;
 	unsigned int i, j, hook = 0, hookmask = 0;
-	size_t gap = e->next_offset - e->target_offset;
+	size_t gap;
 	int ret;
 
 	/* don't mess with the struct ebt_entries */
@@ -660,6 +660,7 @@ ebt_check_entry(struct ebt_entry *e, str
 	if (ret != 0)
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
+	gap = e->next_offset - e->target_offset;
 	target = find_target_lock(t->u.name, &ret, &ebt_mutex);
 	if (!target)
 		goto cleanup_watchers;
