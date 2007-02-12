From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 11/14] nfnetlink_log: iterator functions need iter_state * only
Date: Mon, 12 Feb 2007 21:22:00 +0100
Message-ID: <20070212202200.GB28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965363AbXBLUWT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

get_*() don't need access to seq_file - iter_state is enough for them.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.9	2007-02-12 00:19:16.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:05:14.0000=
00000 +0100
@@ -929,10 +929,8 @@ struct iter_state {
 	unsigned int bucket;
 };
=20
-static struct hlist_node *get_first(struct seq_file *seq)
+static struct hlist_node *get_first(struct iter_state *st)
 {
-	struct iter_state *st =3D seq->private;
-
 	if (!st)
 		return NULL;
=20
@@ -943,10 +941,8 @@ static struct hlist_node *get_first(stru
 	return NULL;
 }
=20
-static struct hlist_node *get_next(struct seq_file *seq, struct hlist_=
node *h)
+static struct hlist_node *get_next(struct iter_state *st, struct hlist=
_node *h)
 {
-	struct iter_state *st =3D seq->private;
-
 	h =3D h->next;
 	while (!h) {
 		if (++st->bucket >=3D INSTANCE_BUCKETS)
@@ -957,13 +953,13 @@ static struct hlist_node *get_next(struc
 	return h;
 }
=20
-static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
+static struct hlist_node *get_idx(struct iter_state *st, loff_t pos)
 {
 	struct hlist_node *head;
-	head =3D get_first(seq);
+	head =3D get_first(st);
=20
 	if (head)
-		while (pos && (head =3D get_next(seq, head)))
+		while (pos && (head =3D get_next(st, head)))
 			pos--;
 	return pos ? NULL : head;
 }
@@ -971,13 +967,13 @@ static struct hlist_node *get_idx(struct
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
 	read_lock_bh(&instances_lock);
-	return get_idx(seq, *pos);
+	return get_idx(seq->private, *pos);
 }
=20
 static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
-	return get_next(s, v);
+	return get_next(s->private, v);
 }
=20
 static void seq_stop(struct seq_file *s, void *v)
