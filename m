From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (7/x): move /proc/net/ip_conntrack to seq_file
Date: Sat, 24 Jul 2004 10:41:59 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724144159.GP2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qXPE+6hUsFlDAc0e"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qXPE+6hUsFlDAc0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch makes ip_conntrack use the seq_file API

Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_=
conntrack_protocol.h linux-2.6.8-rc2-nfpending-seqfile/include/linux/netfil=
ter_ipv4/ip_conntrack_protocol.h
--- linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_conntrack_pro=
tocol.h	2004-07-22 14:05:49.732256392 -0400
+++ linux-2.6.8-rc2-nfpending-seqfile/include/linux/netfilter_ipv4/ip_connt=
rack_protocol.h	2004-07-22 14:08:47.483234136 -0400
@@ -3,6 +3,11 @@
 #define _IP_CONNTRACK_PROTOCOL_H
 #include <linux/netfilter_ipv4/ip_conntrack.h>
=20
+/* length of buffer to which print_tuple/print_conntrack members are
+ * writing */
+
+#define IP_CT_PRINT_BUFLEN 100
+
 struct ip_conntrack_protocol
 {
 	/* Next pointer. */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_=
standalone.c linux-2.6.8-rc2-nfpending-seqfile/net/ipv4/netfilter/ip_conntr=
ack_standalone.c
--- linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_standalone.c	=
2004-07-22 14:06:34.138505616 -0400
+++ linux-2.6.8-rc2-nfpending-seqfile/net/ipv4/netfilter/ip_conntrack_stand=
alone.c	2004-07-22 14:30:44.548009856 -0400
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
@@ -63,142 +64,224 @@
 	return len;
 }
=20
-/* FIXME: Don't print source proto part. --RR */
-static unsigned int
-print_expect(char *buffer, const struct ip_conntrack_expect *expect)
-{
-	unsigned int len;
-
-	if (expect->expectant->helper->timeout)
-		len =3D sprintf(buffer, "EXPECTING: %lu ",
-			      timer_pending(&expect->timeout)
-			      ? (expect->timeout.expires - jiffies)/HZ : 0);
-	else
-		len =3D sprintf(buffer, "EXPECTING: - ");
-	len +=3D sprintf(buffer + len, "use=3D%u proto=3D%u ",
-		      atomic_read(&expect->use), expect->tuple.dst.protonum);
-	len +=3D print_tuple(buffer + len, &expect->tuple,
-			   __ip_ct_find_proto(expect->tuple.dst.protonum));
-	len +=3D sprintf(buffer + len, "\n");
-	return len;
-}
-
 #ifdef CONFIG_IP_NF_CT_ACCT
 static unsigned int
-print_counters(char *buffer, struct ip_conntrack_counter *counter)
+seq_print_counters(struct seq_file *s, struct ip_conntrack_counter *counte=
r)
 {
-	return sprintf(buffer, "packets=3D%llu bytes=3D%llu ",=20
-			counter->packets, counter->bytes);
+	return seq_printf(s, "packets=3D%llu bytes=3D%llu ",
+			  counter->packets, counter->bytes);
 }
 #else
 #define seq_print_counters(x, y)	0
 #endif
=20
-static unsigned int
-print_conntrack(char *buffer, struct ip_conntrack *conntrack)
+static void *ct_seq_start(struct seq_file *s, loff_t *pos)
 {
-	unsigned int len;
-	struct ip_conntrack_protocol *proto
-		=3D __ip_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			       .tuple.dst.protonum);
+	unsigned int *bucket;
=20
-	len =3D sprintf(buffer, "%-8s %u %lu ",
-		      proto->name,
-		      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-		      .tuple.dst.protonum,
-		      timer_pending(&conntrack->timeout)
-		      ? (conntrack->timeout.expires - jiffies)/HZ : 0);
-
-	len +=3D proto->print_conntrack(buffer + len, conntrack);
-	len +=3D print_tuple(buffer + len,
-			   &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			   proto);
-	len +=3D print_counters(buffer + len,=20
-			      &conntrack->counters[IP_CT_DIR_ORIGINAL]);
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
-		len +=3D sprintf(buffer + len, "[UNREPLIED] ");
-	len +=3D print_tuple(buffer + len,
-			   &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
-			   proto);
-	len +=3D print_counters(buffer + len,=20
-			      &conntrack->counters[IP_CT_DIR_REPLY]);
-	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
-		len +=3D sprintf(buffer + len, "[ASSURED] ");
-	len +=3D sprintf(buffer + len, "use=3D%u ",
-		       atomic_read(&conntrack->ct_general.use));
-	len +=3D sprintf(buffer + len, "\n");
+	/* strange seq_file api calls stop even if we fail,
+	 * thus we need to grab lock since stop unlocks */
+	READ_LOCK(&ip_conntrack_lock);
+ =20
+	if (*pos >=3D ip_conntrack_htable_size)
+		return NULL;
=20
-	return len;
+	bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
+	if (!bucket) {
+		return ERR_PTR(-ENOMEM);
+	}
+ =20
+	*bucket =3D *pos;
+	return bucket;
 }
+ =20
+static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	unsigned int *bucket =3D (unsigned int *) v;
=20
-/* Returns true when finished. */
-static inline int
-conntrack_iterate(const struct ip_conntrack_tuple_hash *hash,
-		  char *buffer, off_t offset, off_t *upto,
-		  unsigned int *len, unsigned int maxlen)
+	*pos =3D ++(*bucket);
+	if (*pos >=3D ip_conntrack_htable_size) {
+		kfree(v);
+		return NULL;
+	}
+	return bucket;
+}
+ =20
+static void ct_seq_stop(struct seq_file *s, void *v)
 {
-	unsigned int newlen;
-	IP_NF_ASSERT(hash->ctrack);
+	READ_UNLOCK(&ip_conntrack_lock);
+}
+
+/* return 0 on success, 1 in case of error */
+static int ct_seq_real_show(const struct ip_conntrack_tuple_hash *hash,
+			    struct seq_file *s)
+{
+	struct ip_conntrack *conntrack =3D hash->ctrack;
+	struct ip_conntrack_protocol *proto;
+	char buffer[IP_CT_PRINT_BUFLEN];
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
=20
-	/* Only count originals */
+	IP_NF_ASSERT(conntrack);
+
+	/* we only want to print DIR_ORIGINAL */
 	if (DIRECTION(hash))
 		return 0;
=20
-	if ((*upto)++ < offset)
-		return 0;
+	proto =3D __ip_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+			       .tuple.dst.protonum);
+	IP_NF_ASSERT(proto);
+
+	if (seq_printf(s, "%-8s %u %lu ",
+		      proto->name,
+		      conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		      timer_pending(&conntrack->timeout)
+		      ? (conntrack->timeout.expires - jiffies)/HZ : 0) !=3D 0)
+		return 1;
+
+	proto->print_conntrack(buffer, conntrack);
+	if (seq_puts(s, buffer))
+		return 1;
+ =20
+	print_tuple(buffer, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+		    proto);
+
+ 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
+		return 1;
+
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
+		if (seq_printf(s, "[UNREPLIED] "))
+			return 1;
+
+	print_tuple(buffer, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
+		    proto);
+	if (seq_puts(s, buffer))
+		return 1;
+
+ 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
+		return 1;
=20
-	newlen =3D print_conntrack(buffer + *len, hash->ctrack);
-	if (*len + newlen > maxlen)
+	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
+		if (seq_printf(s, "[ASSURED] "))
+			return 1;
+
+	if (seq_printf(s, "use=3D%u\n", atomic_read(&conntrack->ct_general.use)))
 		return 1;
-	else *len +=3D newlen;
=20
 	return 0;
 }
=20
-static int
-list_conntracks(char *buffer, char **start, off_t offset, int length)
+
+static int ct_seq_show(struct seq_file *s, void *v)
 {
-	unsigned int i;
-	unsigned int len =3D 0;
-	off_t upto =3D 0;
-	struct list_head *e;
+	unsigned int *bucket =3D (unsigned int *) v;
=20
-	READ_LOCK(&ip_conntrack_lock);
-	/* Traverse hash; print originals then reply. */
-	for (i =3D 0; i < ip_conntrack_htable_size; i++) {
-		if (LIST_FIND(&ip_conntrack_hash[i], conntrack_iterate,
-			      struct ip_conntrack_tuple_hash *,
-			      buffer, offset, &upto, &len, length))
-			goto finished;
+	if (LIST_FIND(&ip_conntrack_hash[*bucket], ct_seq_real_show,
+		      struct ip_conntrack_tuple_hash *, s)) {
+		/* buffer was filled and unable to print that tuple */
+		return 1;
 	}
+	return 0;
+}
+=09
+static struct seq_operations ct_seq_ops =3D {
+	.start =3D ct_seq_start,
+	.next  =3D ct_seq_next,
+	.stop  =3D ct_seq_stop,
+	.show  =3D ct_seq_show
+};
+ =20
+static int ct_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ct_seq_ops);
+}
=20
-	/* Now iterate through expecteds. */
+static struct file_operations ct_file_ops =3D {
+	.owner   =3D THIS_MODULE,
+	.open    =3D ct_open,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release
+};
+ =20
+/* expects */
+static void *exp_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct list_head *e =3D &ip_conntrack_expect_list;
+	loff_t i;
+
+	/* strange seq_file api calls stop even if we fail,
+	 * thus we need to grab lock since stop unlocks */
+	READ_LOCK(&ip_conntrack_lock);
 	READ_LOCK(&ip_conntrack_expect_tuple_lock);
-	list_for_each(e, &ip_conntrack_expect_list) {
-		unsigned int last_len;
-		struct ip_conntrack_expect *expect
-			=3D (struct ip_conntrack_expect *)e;
-		if (upto++ < offset) continue;
-
-		last_len =3D len;
-		len +=3D print_expect(buffer + len, expect);
-		if (len > length) {
-			len =3D last_len;
-			goto finished_expects;
-		}
+
+	if (list_empty(e))
+		return NULL;
+
+	for (i =3D 0; i <=3D *pos; i++) {
+		e =3D e->next;
+		if (e =3D=3D &ip_conntrack_expect_list)
+			return NULL;
 	}
+	return e;
+}
+
+static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+ 	struct list_head *e =3D v;
=20
- finished_expects:
+	e =3D e->next;
+
+	if (e =3D=3D &ip_conntrack_expect_list)
+		return NULL;
+
+	return e;
+}
+
+static void exp_seq_stop(struct seq_file *s, void *v)
+{
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
- finished:
 	READ_UNLOCK(&ip_conntrack_lock);
+}
=20
-	/* `start' hack - see fs/proc/generic.c line ~165 */
-	*start =3D (char *)((unsigned int)upto - offset);
-	return len;
+static int exp_seq_show(struct seq_file *s, void *v)
+{
+	struct ip_conntrack_expect *expect =3D v;
+	char buffer[IP_CT_PRINT_BUFLEN];
+
+	if (expect->expectant->helper->timeout)
+		seq_printf(s, "%lu ", timer_pending(&expect->timeout)
+			   ? (expect->timeout.expires - jiffies)/HZ : 0);
+	else
+		seq_printf(s, "- ");
+
+	seq_printf(s, "use=3D%u proto=3D%u ", atomic_read(&expect->use),
+		   expect->tuple.dst.protonum);
+
+	print_tuple(buffer, &expect->tuple,
+		    __ip_ct_find_proto(expect->tuple.dst.protonum));
+	return seq_printf(s, "%s\n", buffer);
+}
+
+static struct seq_operations exp_seq_ops =3D {
+	.start =3D exp_seq_start,
+	.next =3D exp_seq_next,
+	.stop =3D exp_seq_stop,
+	.show =3D exp_seq_show
+};
+
+static int exp_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &exp_seq_ops);
 }
+ =20
+static struct file_operations exp_file_ops =3D {
+	.owner   =3D THIS_MODULE,
+	.open    =3D exp_open,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release
+};
=20
 static unsigned int ip_confirm(unsigned int hooknum,
 			       struct sk_buff **pskb,
@@ -525,7 +608,7 @@
 #endif
 static int init_or_cleanup(int init)
 {
-	struct proc_dir_entry *proc;
+	struct proc_dir_entry *proc, *proc_exp;
 	int ret =3D 0;
=20
 	if (!init) goto cleanup;
@@ -534,14 +617,18 @@
 	if (ret < 0)
 		goto cleanup_nothing;
=20
-	proc =3D proc_net_create("ip_conntrack", 0440, list_conntracks);
+	proc =3D proc_net_create("ip_conntrack", 0440, NULL);
 	if (!proc) goto cleanup_init;
-	proc->owner =3D THIS_MODULE;
+	proc->proc_fops =3D &ct_file_ops;
+
+	proc_exp =3D proc_net_create("ip_conntrack_expect", 0440, NULL);
+	if (!proc_exp) goto cleanup_proc;
+	proc_exp->proc_fops =3D &exp_file_ops;
=20
 	ret =3D nf_register_hook(&ip_conntrack_defrag_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
-		goto cleanup_proc;
+		goto cleanup_proc_exp;
 	}
 	ret =3D nf_register_hook(&ip_conntrack_defrag_local_out_ops);
 	if (ret < 0) {
@@ -593,6 +680,8 @@
 	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
  cleanup_defragops:
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
+cleanup_proc_exp:
+	proc_net_remove("ip_conntrack_exp");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qXPE+6hUsFlDAc0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnU3XaXGVTD0i/8RAtQKAKCwe4rf0s6eHkYEZ72C31C/qtPGJwCdEMiz
4GDeGlP/SY37TXVKI2I/eHE=
=9wNR
-----END PGP SIGNATURE-----

--qXPE+6hUsFlDAc0e--
