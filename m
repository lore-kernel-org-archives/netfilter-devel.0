From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/12]: nfnetlink_log: iterator functions need
	iter_state * only
Date: Fri, 23 Mar 2007 15:05:07 +0100 (MET)
Message-ID: <20070323140441.22987.2704.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: iterator functions need iter_state * only

get_*() don't need access to seq_file - iter_state is enough for them.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 711273c65e2da4bd148f9c72d30970859d4255ad
tree 0f2964dda9df25ad6e7819dbf042a39d99a84f8b
parent 76fd1fbb4efe0c85596590b0a56ffaf4fc467c61
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:02:29 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:22 +0100

 net/netfilter/nfnetlink_log.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 441f0fb..e934770 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -919,10 +919,8 @@ struct iter_state {
 	unsigned int bucket;
 };
 
-static struct hlist_node *get_first(struct seq_file *seq)
+static struct hlist_node *get_first(struct iter_state *st)
 {
-	struct iter_state *st = seq->private;
-
 	if (!st)
 		return NULL;
 
@@ -933,10 +931,8 @@ static struct hlist_node *get_first(struct seq_file *seq)
 	return NULL;
 }
 
-static struct hlist_node *get_next(struct seq_file *seq, struct hlist_node *h)
+static struct hlist_node *get_next(struct iter_state *st, struct hlist_node *h)
 {
-	struct iter_state *st = seq->private;
-
 	h = h->next;
 	while (!h) {
 		if (++st->bucket >= INSTANCE_BUCKETS)
@@ -947,13 +943,13 @@ static struct hlist_node *get_next(struct seq_file *seq, struct hlist_node *h)
 	return h;
 }
 
-static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
+static struct hlist_node *get_idx(struct iter_state *st, loff_t pos)
 {
 	struct hlist_node *head;
-	head = get_first(seq);
+	head = get_first(st);
 
 	if (head)
-		while (pos && (head = get_next(seq, head)))
+		while (pos && (head = get_next(st, head)))
 			pos--;
 	return pos ? NULL : head;
 }
@@ -961,13 +957,13 @@ static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
 	read_lock_bh(&instances_lock);
-	return get_idx(seq, *pos);
+	return get_idx(seq->private, *pos);
 }
 
 static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
-	return get_next(s, v);
+	return get_next(s->private, v);
 }
 
 static void seq_stop(struct seq_file *s, void *v)
