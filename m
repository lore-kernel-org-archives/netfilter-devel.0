From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [PATCH] kill lockhelp for CLUSTERIP
Date: Tue, 30 Aug 2005 18:41:03 +0200
Message-ID: <m2wtm3qsww.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--=-=-=

Hi,
this fix the missing lockhelp.h in kernel > 2.6.13
Maybe as it's very simple fix, it should be merge before the last 3
patches of Krisztian ?

regards, 
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename=CLUSTERIP_kill_lockhelp.patch
Content-Transfer-Encoding: quoted-printable

[NETFILTER] kill lockhelp.h for CLUSTERIP

---------------------------------------------------------------------------=
---

 ipt_CLUSTERIP.c |   46 ++++++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

---------------------------------------------------------------------------=
---

Index: linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c	(r=C3=A9vision 4251)
+++ linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c	(copie de travail)
@@ -29,7 +29,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
=20
 #define CLUSTERIP_VERSION "0.6"
=20
@@ -67,7 +66,7 @@
=20
 /* clusterip_lock protects the clusterip_configs list _AND_ the configurab=
le
  * data within all structurses (num_local_nodes, local_nodes[]) */
-static DECLARE_RWLOCK(clusterip_lock);
+static DEFINE_RWLOCK(clusterip_lock);
=20
 #ifdef CONFIG_PROC_FS
 static struct file_operations clusterip_proc_fops;
@@ -82,9 +81,9 @@
 static inline void
 clusterip_config_put(struct clusterip_config *c) {
 	if (atomic_dec_and_test(&c->refcount)) {
-		WRITE_LOCK(&clusterip_lock);
+		write_lock_bh(&clusterip_lock);
 		list_del(&c->list);
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		dev_mc_delete(c->dev, c->clustermac, ETH_ALEN, 0);
 		dev_put(c->dev);
 		kfree(c);
@@ -97,7 +96,6 @@
 {
 	struct list_head *pos;
=20
-	MUST_BE_READ_LOCKED(&clusterip_lock);
 	list_for_each(pos, &clusterip_configs) {
 		struct clusterip_config *c =3D list_entry(pos,=20
 					struct clusterip_config, list);
@@ -114,14 +112,14 @@
 {
 	struct clusterip_config *c;
=20
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
 	c =3D __clusterip_config_find(clusterip);
 	if (!c) {
-		READ_UNLOCK(&clusterip_lock);
+		read_unlock_bh(&clusterip_lock);
 		return NULL;
 	}
 	atomic_inc(&c->refcount);
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
=20
 	return c;
 }
@@ -160,9 +158,9 @@
 	c->pde->data =3D c;
 #endif
=20
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
 	list_add(&c->list, &clusterip_configs);
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
=20
 	return c;
 }
@@ -172,25 +170,25 @@
 {
 	int i;
=20
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
=20
 	if (c->num_local_nodes >=3D CLUSTERIP_MAX_NODES
 	    || nodenum > CLUSTERIP_MAX_NODES) {
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		return 1;
 	}
=20
 	/* check if we alrady have this number in our array */
 	for (i =3D 0; i < c->num_local_nodes; i++) {
 		if (c->local_nodes[i] =3D=3D nodenum) {
-			WRITE_UNLOCK(&clusterip_lock);
+			write_unlock_bh(&clusterip_lock);
 			return 1;
 		}
 	}
=20
 	c->local_nodes[c->num_local_nodes++] =3D nodenum;
=20
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
 	return 0;
 }
=20
@@ -199,10 +197,10 @@
 {
 	int i;
=20
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
=20
 	if (c->num_local_nodes <=3D 1 || nodenum > CLUSTERIP_MAX_NODES) {
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		return 1;
 	}
=20=09=09
@@ -211,12 +209,12 @@
 			int size =3D sizeof(u_int16_t)*(c->num_local_nodes-(i+1));
 			memmove(&c->local_nodes[i], &c->local_nodes[i+1], size);
 			c->num_local_nodes--;
-			WRITE_UNLOCK(&clusterip_lock);
+			write_unlock_bh(&clusterip_lock);
 			return 0;
 		}
 	}
=20
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
 	return 1;
 }
=20
@@ -286,21 +284,21 @@
 {
 	int i;
=20
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
=20
 	if (config->num_local_nodes =3D=3D 0) {
-		READ_UNLOCK(&clusterip_lock);
+		read_unlock_bh(&clusterip_lock);
 		return 0;
 	}
=20
 	for (i =3D 0; i < config->num_local_nodes; i++) {
 		if (config->local_nodes[i] =3D=3D hash) {
-			READ_UNLOCK(&clusterip_lock);
+			read_unlock_bh(&clusterip_lock);
 			return 1;
 		}
 	}
=20
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
=20
 	return 0;
 }
@@ -579,7 +577,7 @@
 	struct clusterip_config *c =3D pde->data;
 	unsigned int *nodeidx;
=20
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
 	if (*pos >=3D c->num_local_nodes)
 		return NULL;
=20
@@ -609,7 +607,7 @@
 {
 	kfree(v);
=20
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
 }
=20
 static int clusterip_seq_show(struct seq_file *s, void *v)

--=-=-=--
