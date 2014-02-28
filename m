From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] xt_quota2: introduce support for netns
Date: Fri, 28 Feb 2014 03:33:03 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1402280327210.14757@nerf08.vanv.qr>
References: <20140225170034.GA10440@earthship.local.cellrox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jpa@google.com, john.stultz@linaro.org,
	containers@lists.linux-foundation.org,
	netfilter-devel@vger.kernel.org, orenl@cellrox.com,
	amir@cellrox.com
To: Daniel Golle <dgolle@cellrox.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:40176 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaB1CdF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:33:05 -0500
In-Reply-To: <20140225170034.GA10440@earthship.local.cellrox.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2014-02-25 18:00, Daniel Golle wrote:

>Initialize a separate xt_quota2 instance for each network
>namespace so data limit can be set and enforced per persona.

> net/netfilter/xt_quota2.c | 127 +++++++++++++++++++++++++++++++++++++=
---------
> 1 file changed, 102 insertions(+), 25 deletions(-)
>diff --git a/net/netfilter/xt_quota2.c b/net/netfilter/xt_quota2.c
>index fb2ef46..bba78ec 100644
>--- a/net/netfilter/xt_quota2.c
>+++ b/net/netfilter/xt_quota2.c

This does not apply. Unfortunately, it does not apply either after
munging the paths back to original=E2=80=A6 the patch needs to be produ=
ced
with an original xt-a as base, or I need you to also hand me a clone
URL to grab your tree that has the fb2ef46 blob object.


$ quilt pu
Applying patch quilt-patches/0
patching file extensions/xt_quota2.c
Hunk #1 succeeded at 11 with fuzz 2.
Hunk #2 FAILED at 49.
Hunk #3 FAILED at 63.
Hunk #4 FAILED at 75.
Hunk #5 FAILED at 111.
Hunk #6 FAILED at 183.
Hunk #7 succeeded at 135 with fuzz 1 (offset -63 lines).
Hunk #8 FAILED at 208.
Hunk #9 FAILED at 220.
Hunk #10 succeeded at 177 (offset -78 lines).
Hunk #11 succeeded at 190 (offset -78 lines).
Hunk #12 succeeded at 204 (offset -78 lines).
Hunk #13 FAILED at 312.
Hunk #14 FAILED at 349.
9 out of 14 hunks FAILED -- rejects in file extensions/xt_quota2.c
Patch quilt-patches/0 does not apply (enforce with -f)


>@@ -11,6 +11,12 @@
>  *	it under the terms of the GNU General Public License; either
>  *	version 2 of the License, as published by the Free Software Founda=
tion.
>  */
>+
>+#include <linux/nsproxy.h>
>+#include <net/net_namespace.h>
>+#include <net/netns/generic.h>
>+#include <net/dst.h>
>+
> #include <linux/list.h>
> #include <linux/module.h>
> #include <linux/proc_fs.h>
>@@ -43,13 +49,38 @@ module_param_named(event_num, qlog_nl_event, uint,=
 S_IRUGO | S_IWUSR);
> MODULE_PARM_DESC(event_num,
> 		 "Event number for NETLINK_NFLOG message. 0 disables log."
> 		 "111 is what ipt_ULOG uses.");
>-static struct sock *nflognl;
> #endif
>=20
>-static LIST_HEAD(counter_list);
>+struct quota2_net {
>+	struct list_head counter_list;
>+	struct proc_dir_entry *proc_xt_quota;
>+#ifdef CONFIG_NETFILTER_XT_MATCH_QUOTA2_LOG
>+	struct sock *nflognl;
>+#endif
>+};
>+
>+static int quota2_net_id;
>+static inline struct quota2_net *quota2_pernet(struct net *net)
>+{
>+	return net_generic(net, quota2_net_id);
>+}
>+
>+/* from xt_TEE, should probably go into some common include */
>+static struct net *pick_net(const struct sk_buff *skb)
>+{
>+#ifdef CONFIG_NET_NS
>+	const struct dst_entry *dst;
>+	if (skb->dev !=3D NULL)
>+		return dev_net(skb->dev);
>+	dst =3D skb_dst(skb);
>+	if (dst !=3D NULL && dst->dev !=3D NULL)
>+		return dev_net(dst->dev);
>+#endif
>+	return &init_net;
>+}
>+
> static DEFINE_SPINLOCK(counter_list_lock);
>=20
>-static struct proc_dir_entry *proc_xt_quota;
> static unsigned int quota_list_perms =3D S_IRUGO | S_IWUSR;
> static unsigned int quota_list_uid   =3D 0;
> static unsigned int quota_list_gid   =3D 0;
>@@ -57,9 +88,9 @@ module_param_named(perms, quota_list_perms, uint, S_=
IRUGO | S_IWUSR);
> module_param_named(uid, quota_list_uid, uint, S_IRUGO | S_IWUSR);
> module_param_named(gid, quota_list_gid, uint, S_IRUGO | S_IWUSR);
>=20
>-
> #ifdef CONFIG_NETFILTER_XT_MATCH_QUOTA2_LOG
>-static void quota2_log(unsigned int hooknum,
>+static void quota2_log(struct net *net,
>+		       unsigned int hooknum,
> 		       const struct sk_buff *skb,
> 		       const struct net_device *in,
> 		       const struct net_device *out,
>@@ -69,7 +100,7 @@ static void quota2_log(unsigned int hooknum,
> 	struct sk_buff *log_skb;
> 	size_t size;
> 	struct nlmsghdr *nlh;
>-
>+	struct quota2_net *quota2_net =3D quota2_pernet(net);
> 	if (!qlog_nl_event)
> 		return;
>=20
>@@ -105,13 +136,14 @@ static void quota2_log(unsigned int hooknum,
>=20
> 	NETLINK_CB(log_skb).dst_group =3D 1;
> 	pr_debug("throwing 1 packets to netlink group 1\n");
>-	netlink_broadcast(nflognl, log_skb, 0, 1, GFP_ATOMIC);
>+	netlink_broadcast(quota2_net->nflognl, log_skb, 0, 1, GFP_ATOMIC);
>=20
> nlmsg_failure:  /* Used within NLMSG_PUT() */
> 	pr_debug("xt_quota2: error during NLMSG_PUT\n");
> }
> #else
>-static void quota2_log(unsigned int hooknum,
>+static void quota2_log(struct net *net,
>+		       unsigned int hooknum,
> 		       const struct sk_buff *skb,
> 		       const struct net_device *in,
> 		       const struct net_device *out,
>@@ -177,11 +209,12 @@ q2_new_counter(const struct xt_quota_mtinfo2 *q,=
 bool anon)
>  * @name:	name of counter
>  */
> static struct xt_quota_counter *
>-q2_get_counter(const struct xt_quota_mtinfo2 *q)
>+q2_get_counter(struct net *net, const struct xt_quota_mtinfo2 *q)
> {
> 	struct proc_dir_entry *p;
> 	struct xt_quota_counter *e =3D NULL;
> 	struct xt_quota_counter *new_e;
>+	struct quota2_net *quota2_net =3D quota2_pernet(net);
>=20
> 	if (*q->name =3D=3D '\0')
> 		return q2_new_counter(q, true);
>@@ -192,7 +225,7 @@ q2_get_counter(const struct xt_quota_mtinfo2 *q)
> 		goto out;
>=20
> 	spin_lock_bh(&counter_list_lock);
>-	list_for_each_entry(e, &counter_list, list)
>+	list_for_each_entry(e, &quota2_net->counter_list, list)
> 		if (strcmp(e->name, q->name) =3D=3D 0) {
> 			atomic_inc(&e->ref);
> 			spin_unlock_bh(&counter_list_lock);
>@@ -202,7 +235,7 @@ q2_get_counter(const struct xt_quota_mtinfo2 *q)
> 		}
> 	e =3D new_e;
> 	pr_debug("xt_quota2: new_counter name=3D%s", e->name);
>-	list_add_tail(&e->list, &counter_list);
>+	list_add_tail(&e->list, &quota2_net->counter_list);
> 	/* The entry having a refcount of 1 is not directly destructible.
> 	 * This func has not yet returned the new entry, thus iptables
> 	 * has not references for destroying this entry.
>@@ -214,7 +247,7 @@ q2_get_counter(const struct xt_quota_mtinfo2 *q)
>=20
> 	/* create_proc_entry() is not spin_lock happy */
> 	p =3D e->procfs_entry =3D create_proc_entry(e->name, quota_list_perm=
s,
>-	                      proc_xt_quota);
>+	                      quota2_net->proc_xt_quota);
>=20
> 	if (IS_ERR_OR_NULL(p)) {
> 		spin_lock_bh(&counter_list_lock);
>@@ -249,7 +282,7 @@ static int quota_mt2_check(const struct xt_mtchk_p=
aram *par)
> 		return -EINVAL;
> 	}
>=20
>-	q->master =3D q2_get_counter(q);
>+	q->master =3D q2_get_counter(par->net, q);
> 	if (q->master =3D=3D NULL) {
> 		printk(KERN_ERR "xt_quota.3: memory alloc failure\n");
> 		return -ENOMEM;
>@@ -262,6 +295,7 @@ static void quota_mt2_destroy(const struct xt_mtdt=
or_param *par)
> {
> 	struct xt_quota_mtinfo2 *q =3D par->matchinfo;
> 	struct xt_quota_counter *e =3D q->master;
>+	struct quota2_net *quota2_net =3D quota2_pernet(par->net);
>=20
> 	if (*q->name =3D=3D '\0') {
> 		kfree(e);
>@@ -275,7 +309,7 @@ static void quota_mt2_destroy(const struct xt_mtdt=
or_param *par)
> 	}
>=20
> 	list_del(&e->list);
>-	remove_proc_entry(e->name, proc_xt_quota);
>+	remove_proc_entry(e->name, quota2_net->proc_xt_quota);
> 	spin_unlock_bh(&counter_list_lock);
> 	kfree(e);
> }
>@@ -305,7 +339,8 @@ quota_mt2(const struct sk_buff *skb, struct xt_act=
ion_param *par)
> 		} else {
> 			/* We are transitioning, log that fact. */
> 			if (e->quota) {
>-				quota2_log(par->hooknum,
>+				quota2_log(pick_net(skb),
>+					   par->hooknum,
> 					   skb,
> 					   par->in,
> 					   par->out,
>@@ -342,34 +377,76 @@ static struct xt_match quota_mt2_reg[] __read_mo=
stly =3D {
> 	},
> };
>=20
>-static int __init quota_mt2_init(void)
>+static int __net_init quota2_net_init(struct net *net)
> {
>-	int ret;
>-	pr_debug("xt_quota2: init()");
>-
>+	struct quota2_net *quota2_net =3D quota2_pernet(net);
>+	INIT_LIST_HEAD(&quota2_net->counter_list);
> #ifdef CONFIG_NETFILTER_XT_MATCH_QUOTA2_LOG
>-	nflognl =3D netlink_kernel_create(&init_net,
>+	quota2_net->nflognl =3D netlink_kernel_create(net,
> 					NETLINK_NFLOG, 1, NULL,
> 					NULL, THIS_MODULE);
>-	if (!nflognl)
>+	if (quota2_net->nflognl =3D=3D NULL)
> 		return -ENOMEM;
> #endif
>=20
>-	proc_xt_quota =3D proc_mkdir("xt_quota", init_net.proc_net);
>-	if (proc_xt_quota =3D=3D NULL)
>+	quota2_net->proc_xt_quota =3D proc_mkdir("xt_quota", net->proc_net);
>+	if (quota2_net->proc_xt_quota =3D=3D NULL) {
>+#ifdef CONFIG_NETFILTER_XT_MATCH_QUOTA2_LOG
>+		netlink_kernel_release(quota2_net->nflognl);
>+#endif
> 		return -EACCES;
>+	}
>+	return 0;
>+}
>+
>+static void __net_exit quota2_net_exit(struct net *net)
>+{
>+	struct quota2_net *quota2_net =3D quota2_pernet(net);
>+	struct xt_quota_counter *e =3D NULL;
>+	struct list_head *pos, *q;
>+#ifdef CONFIG_NETFILTER_XT_MATCH_QUOTA2_LOG
>+	netlink_kernel_release(quota2_net->nflognl);
>+#endif
>+	remove_proc_entry("xt_quota", net->proc_net);
>+
>+	/* destroy counter_list while freeing it's content */
>+	spin_lock_bh(&counter_list_lock);
>+	list_for_each_safe(pos, q, &quota2_net->counter_list) {
>+		e =3D list_entry(pos, struct xt_quota_counter, list);
>+		list_del(pos);
>+		kfree(e);
>+	}
>+	spin_unlock_bh(&counter_list_lock);
>+}
>+
>+static struct pernet_operations quota2_net_ops =3D {
>+	.init   =3D quota2_net_init,
>+	.exit   =3D quota2_net_exit,
>+	.id     =3D &quota2_net_id,
>+	.size   =3D sizeof(struct quota2_net),
>+};
>+
>+static int __init quota_mt2_init(void)
>+{
>+	int ret;
>+	pr_debug("xt_quota2: init()");
>+
>+	ret =3D register_pernet_subsys(&quota2_net_ops);
>+	if (ret < 0)
>+		return ret;
>=20
> 	ret =3D xt_register_matches(quota_mt2_reg, ARRAY_SIZE(quota_mt2_reg)=
);
> 	if (ret < 0)
>-		remove_proc_entry("xt_quota", init_net.proc_net);
>+		unregister_pernet_subsys(&quota2_net_ops);
> 	pr_debug("xt_quota2: init() %d", ret);
>+
> 	return ret;
> }
>=20
> static void __exit quota_mt2_exit(void)
> {
> 	xt_unregister_matches(quota_mt2_reg, ARRAY_SIZE(quota_mt2_reg));
>-	remove_proc_entry("xt_quota", init_net.proc_net);
>+	unregister_pernet_subsys(&quota2_net_ops);
> }
>=20
> module_init(quota_mt2_init);
>--=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
