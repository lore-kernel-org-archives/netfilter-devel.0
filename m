From: Harald Welte <laforge@netfilter.org>
Subject: [laforge@gnumonks.org: [PATCH] add /proc/net/netfilter/nf_queue]
Date: Mon, 8 Aug 2005 15:28:01 +0200
Message-ID: <20050808132801.GC25303@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pe+tqlI1iYzVj1X/"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--pe+tqlI1iYzVj1X/
Content-Type: multipart/mixed; boundary="fmEUq8M7S0s+Fl0V"
Content-Disposition: inline


--fmEUq8M7S0s+Fl0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I forgot to Cc the list with this one...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fmEUq8M7S0s+Fl0V
Content-Type: message/rfc822
Content-Disposition: inline

Date: Mon, 8 Aug 2005 15:27:24 +0200
From: Harald Welte <laforge@gnumonks.org>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] add /proc/net/netfilter/nf_queue
Message-ID: <20050808132723.GB25303@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
User-Agent: mutt-ng devel-20050619 (Debian)


--5oH/S/bF6lOfqCQb
Content-Type: multipart/mixed; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply to your net-2.6.14 tree, thanks.

--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="37-proc_net_netfilter_nf_queue.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER] add /proc/net/netfilter interface to nf_queue

This patch adds a /proc/net/netfilter/nf_queue file, similar to the
recently-added /proc/net/netfilter/nf_log.  It indicates which queue
handler is registered to which protocol family.  This is useful since
there are now multiple queue handlers in the treee (ip[6]_queue,
nfnetlink_queue).

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 920c6ab53de92da82f0e3dc7de30ae6f1d0dd3a8
tree bdf86e03da89db980b19331efabb85125a915ef5
parent 6a85f7cafea91c2eea692828c7c1602d2da4f4c4
author Harald Welte <laforge@netfilter.org> Mo, 08 Aug 2005 08:57:08 +0200
committer Harald Welte <laforge@netfilter.org> Mo, 08 Aug 2005 08:57:08 +02=
00

 include/linux/netfilter.h       |   13 +++--
 net/ipv4/netfilter/ip_queue.c   |    9 +++
 net/ipv6/netfilter/ip6_queue.c  |    9 +++
 net/netfilter/nf_queue.c        |  105 ++++++++++++++++++++++++++++++++---=
----
 net/netfilter/nfnetlink_queue.c |   12 +++-
 5 files changed, 114 insertions(+), 34 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -225,13 +225,16 @@ int nf_getsockopt(struct sock *sk, int p
 		  int *len);
=20
 /* Packet queuing */
-typedef int (*nf_queue_outfn_t)(struct sk_buff *skb,=20
-                                struct nf_info *info,
-				unsigned int queuenum, void *data);
+struct nf_queue_handler {
+	int (*outfn)(struct sk_buff *skb, struct nf_info *info,
+		     unsigned int queuenum, void *data);
+	void *data;
+	char *name;
+};
 extern int nf_register_queue_handler(int pf,=20
-                                     nf_queue_outfn_t outfn, void *data);
+                                     struct nf_queue_handler *qh);
 extern int nf_unregister_queue_handler(int pf);
-extern void nf_unregister_queue_handlers(nf_queue_outfn_t outfn);
+extern void nf_unregister_queue_handlers(struct nf_queue_handler *qh);
 extern void nf_reinject(struct sk_buff *skb,
 			struct nf_info *info,
 			unsigned int verdict);
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -649,6 +649,11 @@ ipq_get_info(char *buffer, char **start,
 }
 #endif /* CONFIG_PROC_FS */
=20
+static struct nf_queue_handler nfqh =3D {
+	.name	=3D "ip_queue",
+	.outfn	=3D &ipq_enqueue_packet,
+};
+
 static int
 init_or_cleanup(int init)
 {
@@ -677,7 +682,7 @@ init_or_cleanup(int init)
 	register_netdevice_notifier(&ipq_dev_notifier);
 	ipq_sysctl_header =3D register_sysctl_table(ipq_root_table, 0);
 =09
-	status =3D nf_register_queue_handler(PF_INET, ipq_enqueue_packet, NULL);
+	status =3D nf_register_queue_handler(PF_INET, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip_queue: failed to register queue handler\n");
 		goto cleanup_sysctl;
@@ -685,7 +690,7 @@ init_or_cleanup(int init)
 	return status;
=20
 cleanup:
-	nf_unregister_queue_handlers(&ipq_enqueue_packet);
+	nf_unregister_queue_handlers(&nfqh);
 	synchronize_net();
 	ipq_flush(NF_DROP);
 =09
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -645,6 +645,11 @@ ipq_get_info(char *buffer, char **start,
 	return len;
 }
=20
+static struct nf_queue_handler nfqh =3D {
+	.name	=3D "ip6_queue",
+	.outfn	=3D &ipq_enqueue_packet,
+};
+
 static int
 init_or_cleanup(int init)
 {
@@ -672,7 +677,7 @@ init_or_cleanup(int init)
 	register_netdevice_notifier(&ipq_dev_notifier);
 	ipq_sysctl_header =3D register_sysctl_table(ipq_root_table, 0);
 =09
-	status =3D nf_register_queue_handler(PF_INET6, ipq_enqueue_packet, NULL);
+	status =3D nf_register_queue_handler(PF_INET6, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip6_queue: failed to register queue handler\n");
 		goto cleanup_sysctl;
@@ -680,7 +685,7 @@ init_or_cleanup(int init)
 	return status;
=20
 cleanup:
-	nf_unregister_queue_handlers(&ipq_enqueue_packet);
+	nf_unregister_queue_handlers(&nfqh);
 	synchronize_net();
 	ipq_flush(NF_DROP);
 =09
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -14,17 +14,12 @@
  * long term mutex.  The handler must provide an an outfn() to accept pack=
ets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static struct nf_queue_handler_t {
-	nf_queue_outfn_t outfn;
-	void *data;
-} queue_handler[NPROTO];
-
+static struct nf_queue_handler *queue_handler[NPROTO];
 static struct nf_queue_rerouter *queue_rerouter;
=20
 static DEFINE_RWLOCK(queue_handler_lock);
=20
-
-int nf_register_queue_handler(int pf, nf_queue_outfn_t outfn, void *data)
+int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
 {     =20
 	int ret;
=20
@@ -32,11 +27,10 @@ int nf_register_queue_handler(int pf, nf
 		return -EINVAL;
=20
 	write_lock_bh(&queue_handler_lock);
-	if (queue_handler[pf].outfn)
+	if (queue_handler[pf])
 		ret =3D -EBUSY;
 	else {
-		queue_handler[pf].outfn =3D outfn;
-		queue_handler[pf].data =3D data;
+		queue_handler[pf] =3D qh;
 		ret =3D 0;
 	}
 	write_unlock_bh(&queue_handler_lock);
@@ -52,8 +46,7 @@ int nf_unregister_queue_handler(int pf)
 		return -EINVAL;
=20
 	write_lock_bh(&queue_handler_lock);
-	queue_handler[pf].outfn =3D NULL;
-	queue_handler[pf].data =3D NULL;
+	queue_handler[pf] =3D NULL;
 	write_unlock_bh(&queue_handler_lock);
 =09
 	return 0;
@@ -85,16 +78,14 @@ int nf_unregister_queue_rerouter(int pf)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_queue_rerouter);
=20
-void nf_unregister_queue_handlers(nf_queue_outfn_t outfn)
+void nf_unregister_queue_handlers(struct nf_queue_handler *qh)
 {
 	int pf;
=20
 	write_lock_bh(&queue_handler_lock);
 	for (pf =3D 0; pf < NPROTO; pf++)  {
-		if (queue_handler[pf].outfn =3D=3D outfn) {
-			queue_handler[pf].outfn =3D NULL;
-			queue_handler[pf].data =3D NULL;
-		}
+		if (queue_handler[pf] =3D=3D qh)
+			queue_handler[pf] =3D NULL;
 	}
 	write_unlock_bh(&queue_handler_lock);
 }
@@ -121,7 +112,7 @@ int nf_queue(struct sk_buff **skb,=20
=20
 	/* QUEUE =3D=3D DROP if noone is waiting, to be safe. */
 	read_lock(&queue_handler_lock);
-	if (!queue_handler[pf].outfn) {
+	if (!queue_handler[pf]->outfn) {
 		read_unlock(&queue_handler_lock);
 		kfree_skb(*skb);
 		return 1;
@@ -162,8 +153,8 @@ int nf_queue(struct sk_buff **skb,=20
 	if (queue_rerouter[pf].save)
 		queue_rerouter[pf].save(*skb, info);
=20
-	status =3D queue_handler[pf].outfn(*skb, info, queuenum,
-					 queue_handler[pf].data);
+	status =3D queue_handler[pf]->outfn(*skb, info, queuenum,
+					  queue_handler[pf]->data);
=20
 	if (status >=3D 0 && queue_rerouter[pf].reroute)
 		status =3D queue_rerouter[pf].reroute(skb, info);
@@ -259,13 +250,87 @@ void nf_reinject(struct sk_buff *skb, st
 }
 EXPORT_SYMBOL(nf_reinject);
=20
+#ifdef CONFIG_PROC_FS
+static void *seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos >=3D NPROTO)
+		return NULL;
+
+	return pos;
+}
+
+static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+
+	if (*pos >=3D NPROTO)
+		return NULL;
+
+	return pos;
+}
+
+static void seq_stop(struct seq_file *s, void *v)
+{
+
+}
+
+static int seq_show(struct seq_file *s, void *v)
+{
+	int ret;
+	loff_t *pos =3D v;
+	struct nf_queue_handler *qh;
+
+	read_lock_bh(&queue_handler_lock);
+	qh =3D queue_handler[*pos];
+	if (!qh)
+		ret =3D seq_printf(s, "%2lld NONE\n", *pos);
+	else
+		ret =3D seq_printf(s, "%2lld %s\n", *pos, qh->name);
+	read_unlock_bh(&queue_handler_lock);
+
+	return ret;
+}
+
+static struct seq_operations nfqueue_seq_ops =3D {
+	.start	=3D seq_start,
+	.next	=3D seq_next,
+	.stop	=3D seq_stop,
+	.show	=3D seq_show,
+};
+
+static int nfqueue_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &nfqueue_seq_ops);
+}
+
+static struct file_operations nfqueue_file_ops =3D {
+	.owner	 =3D THIS_MODULE,
+	.open	 =3D nfqueue_open,
+	.read	 =3D seq_read,
+	.llseek	 =3D seq_lseek,
+	.release =3D seq_release,
+};
+#endif /* PROC_FS */
+
+
 int __init netfilter_queue_init(void)
 {
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *pde;
+#endif
 	queue_rerouter =3D kmalloc(NPROTO * sizeof(struct nf_queue_rerouter),
 				 GFP_KERNEL);
 	if (!queue_rerouter)
 		return -ENOMEM;
=20
+#ifdef CONFIG_PROC_FS
+	pde =3D create_proc_entry("nf_queue", S_IRUGO, proc_net_netfilter);
+	if (!pde) {
+		kfree(queue_rerouter);
+		return -1;
+	}
+	pde->proc_fops =3D &nfqueue_file_ops;
+#endif
 	memset(queue_rerouter, 0, NPROTO * sizeof(struct nf_queue_rerouter));
=20
 	return 0;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -809,6 +809,11 @@ static const int nfqa_cfg_min[NFQA_CFG_M
 	[NFQA_CFG_PARAMS-1]	=3D sizeof(struct nfqnl_msg_config_params),
 };
=20
+static struct nf_queue_handler nfqh =3D {
+	.name 	=3D "nf_queue",
+	.outfn	=3D &nfqnl_enqueue_packet,
+};
+
 static int
 nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		  struct nlmsghdr *nlh, struct nfattr *nfqa[], int *errp)
@@ -854,10 +859,7 @@ nfqnl_recv_config(struct sock *ctnl, str
 		case NFQNL_CFG_CMD_PF_BIND:
 			QDEBUG("registering queue handler for pf=3D%u\n",
 				ntohs(cmd->pf));
-			ret =3D nf_register_queue_handler(ntohs(cmd->pf),
-							nfqnl_enqueue_packet,
-							NULL);
-
+			ret =3D nf_register_queue_handler(ntohs(cmd->pf), &nfqh);
 			break;
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			QDEBUG("unregistering queue handler for pf=3D%u\n",
@@ -1062,7 +1064,7 @@ init_or_cleanup(int init)
 	return status;
=20
 cleanup:
-	nf_unregister_queue_handlers(nfqnl_enqueue_packet);
+	nf_unregister_queue_handlers(&nfqh);
 	unregister_netdevice_notifier(&nfqnl_dev_notifier);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_queue", proc_net_netfilter);

--q9KOos5vDmpwPx9o--

--5oH/S/bF6lOfqCQb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC9127XaXGVTD0i/8RAihRAJ93ZKQ89IYv8PLF7oJUBSim4U60dQCeLidj
UfjYx3RWTqB7ukJda9HLKiM=
=WO2Q
-----END PGP SIGNATURE-----

--5oH/S/bF6lOfqCQb--

--fmEUq8M7S0s+Fl0V--

--pe+tqlI1iYzVj1X/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC913hXaXGVTD0i/8RAlo4AJ47UZ+7sYZfos36DzYp1cmXMjPsBQCfXobe
3ppKUUl+NikDYO9Z5yEWuIg=
=JKrG
-----END PGP SIGNATURE-----

--pe+tqlI1iYzVj1X/--
