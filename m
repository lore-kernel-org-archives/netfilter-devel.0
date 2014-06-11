From: Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 16:10:06 +0400
Message-ID: <1402488606.32126.72.camel@tkhai>
References: <1396871929.3741.6.camel@tkhai>
	 <20140428142306.GA28547@localhost> <1402487079.32126.54.camel@tkhai>
	 <20140611114957.GA23352@localhost> <1402487718.32126.63.camel@tkhai>
	 <20140611120027.GA23485@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <tkhai@yandex.ru>,
	"Pavel Emelyanov" <xemul@parallels.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:59931 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaFKMKM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:10:12 -0400
In-Reply-To: <20140611120027.GA23485@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D0=92 =D0=A1=D1=80, 11/06/2014 =D0=B2 14:00 +0200, Pablo Neira Ayuso =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, Jun 11, 2014 at 03:55:18PM +0400, Kirill Tkhai wrote:
> > =D0=92 =D0=A1=D1=80, 11/06/2014 =D0=B2 13:49 +0200, Pablo Neira Ayu=
so =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > On Wed, Jun 11, 2014 at 03:44:39PM +0400, Kirill Tkhai wrote:
> > > > Hi, Pablo,
> > > >=20
> > > > =D0=92 =D0=9F=D0=BD, 28/04/2014 =D0=B2 16:23 +0200, Pablo Neira=
 Ayuso =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > > > Hi,
> > > > >=20
> > > > > On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> > > > > > Clusterip target does dev_hold() in .checkentry, while dev_=
put() in .destroy.
> > > > > > So, unregister_netdevice catches the leak:
> > > > > >=20
> > > > > > # modprobe dummy
> > > > > > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --has=
hmode sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2=
 --local-node 1
> > > > > > # rmmod dummy
> > > > > >
> > > > > >   Message from syslogd@localhost ...
> > > > > >     kernel: unregister_netdevice: waiting for dummy0 to bec=
ome free. Usage count =3D 1
> > > > > >
> > > > > [...]
> > > > > >  1 file changed, 134 insertions(+), 12 deletions(-)
> > > > >=20
> > > > > I have spinned several times on this patch, and I'm not very =
happy
> > > > > with taking this fix:
> > > > >=20
> > > > > 1) It's quite large fix for a situation that seems unlikely t=
o me.
> > > >=20
> > > > We have several reports from containers users, who bumped into =
this.
> > > > The hang happens on netns stop, it's 100% reproducible. Every t=
ime
> > > > a container is stopping or a device is going away, the unregist=
ration
> > > > fails and hungs if CLUSTERIP is used. So, we'd want to have som=
e fix
> > > > of this.
> > >=20
> > > How it this combination being triggered there? I mean:
> > >=20
> > > # modprobe dummy
> > > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
> > > # rmmod dummy
> > >=20
> > > Is it something included in some scripts that automate the setup?
> >=20
> > It's a sample of how to trigger this. The problem is not in rmmod.
> >=20
> > Really it happens when container is stopping and device is going aw=
ay.
> > It's not OpenVZ related, current LXC has the same problem.
>=20
> But that sample should be really easy to trigger if you're getting
> lost of reports for this.
>=20
> Are your users really hitting that problem by accident? It seems quit=
e
> rare condition to me. Please, clarify.

We had it so many times, that we had to add this ugly workaround
in our kernels in mid 2011:

commit 56ec6942c28cd6823f1481da8d0df829672f03d3
Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date:   Mon Aug 8 12:11:16 2011 +0400

    kernel.spec v2.6.32-131.6.1.el6-042stab026.1-vz
---
 net/core/dev.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++---
 1 file changed, 91 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index eaa31c1..d29131d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5483,6 +5483,64 @@ out:
 EXPORT_SYMBOL(register_netdev);
=20
 /*
+ * We do horrible things -- we left a netdevice
+ * in "leaked" state, which means we release as much
+ * resources as possible but the device will remain
+ * present in namespace because someone holds a reference.
+ *
+ * The idea is to be able to force stop VE.
+ */
+static void ve_netdev_leak(struct net_device *dev)
+{
+	struct napi_struct *p, *n;
+
+	dev->is_leaked =3D 1;
+	barrier();
+
+	/*
+	 * Make sure we're unable to tx/rx
+	 * network packets to outside.
+	 */
+	WARN_ON_ONCE(dev->flags & IFF_UP);
+	WARN_ON_ONCE(dev->qdisc !=3D &noop_qdisc);
+
+	rtnl_lock();
+
+	/*
+	 * No address and napi after that.
+	 */
+	dev_addr_flush(dev);
+	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
+		netif_napi_del(p);
+
+	/*
+	 * No release_net() here since the device remains
+	 * present in the namespace.
+	 */
+
+	__rtnl_unlock();
+
+	put_beancounter(netdev_bc(dev)->exec_ub);
+	put_beancounter(netdev_bc(dev)->owner_ub);
+
+	netdev_bc(dev)->exec_ub		=3D get_beancounter(get_ub0());
+	netdev_bc(dev)->owner_ub	=3D get_beancounter(get_ub0());
+
+	/*
+	 * Since we've already screwed the device and releasing
+	 * it in a normal way is not possible anymore, we're
+	 * to be sure the device will remain here forever.
+	 */
+	dev_hold(dev);
+
+	synchronize_net();
+
+	pr_emerg("Device (%s:%d:%u:%p) marked as leaked\n",
+		 dev->name, atomic_read(&dev->refcnt) - 1,
+		 VEID(dev->owner_env), dev);
+}
+
+/*
  * netdev_wait_allrefs - wait until all references are gone.
  *
  * This is called when unregistering network devices.
@@ -5493,9 +5551,10 @@ EXPORT_SYMBOL(register_netdev);
  * We can get stuck here if buggy protocols don't correctly
  * call dev_put.
  */
-static void netdev_wait_allrefs(struct net_device *dev)
+static int netdev_wait_allrefs(struct net_device *dev)
 {
 	unsigned long rebroadcast_time, warning_time;
+	int i =3D 0;
=20
 	rebroadcast_time =3D warning_time =3D jiffies;
 	while (atomic_read(&dev->refcnt) !=3D 0) {
@@ -5525,12 +5584,27 @@ static void netdev_wait_allrefs(struct net_devi=
ce *dev)
=20
 		if (time_after(jiffies, warning_time + 10 * HZ)) {
 			printk(KERN_EMERG "unregister_netdevice: "
-			       "waiting for %s to become free. Usage "
-			       "count =3D %d\n",
-			       dev->name, atomic_read(&dev->refcnt));
+			       "waiting for %s=3D%p to become free. Usage "
+			       "count =3D %d\n ve=3D%u",
+			       dev->name, dev, atomic_read(&dev->refcnt),
+			       VEID(get_exec_env()));
 			warning_time =3D jiffies;
 		}
+
+		/*
+		 * If device has lost the reference we might stuck
+		 * in this loop forever not having a chance the VE
+		 * to stop.
+		 */
+		if (++i > 200) { /* give 50 seconds to try */
+			if (!ve_is_super(dev->owner_env)) {
+				ve_netdev_leak(dev);
+				return -EBUSY;
+			}
+		}
 	}
+
+	return 0;
 }
=20
 /* The sequence is:
@@ -5585,7 +5659,12 @@ void netdev_run_todo(void)
=20
 		on_each_cpu(flush_backlog, dev, 1);
=20
-		netdev_wait_allrefs(dev);
+		/*
+		 * Even if device get stuck here we are
+		 * to proceed the rest of the list.
+		 */
+		if (netdev_wait_allrefs(dev))
+			continue;
=20
 		/* paranoia */
 		BUG_ON(atomic_read(&dev->refcnt));
@@ -5768,6 +5847,13 @@ void free_netdev(struct net_device *dev)
 {
 	struct napi_struct *p, *n;
=20
+	if (dev->is_leaked) {
+		pr_emerg("%s: device %s=3D%p is leaked\n",
+			 __func__, dev->name, dev);
+		dump_stack();
+		return;
+	}
+
 	release_net(dev_net(dev));
=20
 	kfree(dev->_tx);


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
