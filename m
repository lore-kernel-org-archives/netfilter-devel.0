Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793887768;
	b=gmG0QEpoSKWoI2YHiUBJhnezAyvotUPCs912gG1psMNC5XHjarrhFvmOE9uLZgL4IdH+
	 cVy06d8aEUuAgbEse4Wnf248qIhQtrF1hfGgPgZfZHH+UBlD5oqvdeBhcOX2gSkwul8Oe
	 2f+ftDuc8A25R74PvloKwSBBAWlYaX8+dXUswFatGwJBH0bOYoXGdWXlqOK4lQy+lZLzh
	 hcGjBodvoVA+cYCsVomDgLZkAvdJtzLbJEvrErnxsj2MA0tBzviyDQ/JPP+iuxDeUZVYM
	 p94hjGd/IomQH27lHM1EIrc8s0ZkZHH4LXxFdZ3x1t+dxMYMmIAVLosfjE8zRqT1Ugg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793887768;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XvkCqG8Qur/AzCmoRe2tXGXoOuCXGx7iLZbrG3/wjiI=;
	b=MCUQ8aHMDKJPbsolA016jp7E1j9viWZeUyPr2ZTeaJ3lqPb5YTDus+nv8zhBeggxTjBm
	 Zh21eVvvnWsKbKez7gsqvsTcl5yGbOVViQ73p1h1sUQbIZrqLnPnLcozyYYy7vDS/M/oH
	 yJKt8WZ9vgrvYar+NYugFF28viXJp53SCkuWj7G/uFrFx87HKAZ9Cd2MYrRcdSWMSSQN5
	 vA6xuOsAtO7zZk5L+H1gFY420X1lC3eYifyeYNXzty92LqTMWHH+rdyvaDCtG84LA1DoK
	 hwD7IOkUhr8oYxty7l7f0Rs2psV/SpHgRKJYi2/6GbLAOmv+sb91Y9UmhcsZlRWpU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnS7GBIf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F50606A326
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnS7GBIf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FEE1F00A1D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793887768;
	bh=XvkCqG8Qur/AzCmoRe2tXGXoOuCXGx7iLZbrG3/wjiI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fnS7GBIfm7qR0g00t+CSsE5TUYTp9G2gn8IG2yJAFCrmUIyKV5QJx1J560zD0c/As
	 o05tQmUmDvzocVbWRQ0Vc4DHgNP6JPZns2LG/z1tCogv85QzFgVR+wiNO1B+jeLC6F
	 abCu0U/sPdvniBqKyyX3AJIBYH4L9WX61nQJHEJe1BS/GPM5sTK5CKbHpdqxnnktM3
	 e9oCUxf5vMYGgdb1+lYvnTfQvVUGsgl4kdluHoSm696CWWcBqc2MkNAkabiMW0uTQR
	 6I6fVoK5vvgf58MqYvgOV6T+x1syzJZnT8r4rAVuD8tTbkmwTWeStSoWVyg7uTumB3
	 1Bd81S2gsgl6Q==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3acd304b5fbso14928411fa.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 06:09:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzmlGcBUtEm0B9s11wFdbRovj7KMNBDdepgK9lo6r9ZTVZtekC/uvImObBZWVSW1rptQE+R9i6ZH93E+KRehPY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/iFzlbi/O4nLoZzuzUG5Q/C8tsIbamTxc+UWuvoNRrh9qIJ5cR
	JcBcs+Yg8ZQiTZJMddY4UrktrGVOIPrd4nD6lwmBx0+RvTUNZk9goxf4rzw/PhpFhGxrGugKRTB
	nEEpHg0rXJampPDAKIeIaCbTVMDrSwcE=
X-Received: by 2002:a2e:a9ab:0:b0:3ab:3a7c:a4ca with SMTP id
 38308e7fff4ca-3acb7ac3fdbmr48815381fa.24.1793887766429; Thu, 05 Nov 2026
 06:09:26 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>
 <aux2zX3dLKYnzG56@chamomile> <CAEnQdOox6ddd_GScf24z65bocnMvX0KHeDTju_8j3bzQjLi0HQ@mail.gmail.com>
In-Reply-To: <CAEnQdOox6ddd_GScf24z65bocnMvX0KHeDTju_8j3bzQjLi0HQ@mail.gmail.com>
From: Eric Dumazet <edumazet@kernel.org>
Date: Thu, 5 Nov 2026 15:09:13 +0100
X-Gmail-Original-Message-ID: <CAL4Wiir+91dO7AVVq3O86bWu9NC+8Z+kFUeYveJqfW44-5ChvQ@mail.gmail.com>
X-Gm-Features: AclHuK_Xwgo_6rj5ZBvRIGUbs5ntI7NEXVoZOfO4mdFCJNfTsi5voi6FCacCUho
Message-ID: <CAL4Wiir+91dO7AVVq3O86bWu9NC+8Z+kFUeYveJqfW44-5ChvQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: fix pernet use-after-free on
 UNREGISTER rebroadcast
To: henry martin <bsdhenrymartin@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeu. 5 nov. 2026 =C3=A0 14:15, henry martin <bsdhenrymartin@gmail.com> a=
 =C3=A9crit :
>
> Hi Pablo,
>
> Full reproducer below; runs as root in a KASAN guest. Verified on
> v7.4-rc1 (6628e7d4c6b2c): unpatched, the quoted splat (freed by
> net_passive_dec <- cleanup_net); patched, zero reports and all three
> notifiers hit the new guard 91/91/91 times over the rebroadcast window.
>
> delayer.ko only simulates a driver holding a reference with a delay
> across NETDEV_UNREGISTER - the same delay source as the netdevsim
> case in the original netdev-genl syzbot report; it is an environment
> aid, not part of the bug.
>
> 1) delayer.c - helper module (build: make -C <kernel tree> M=3D$PWD modul=
es):
>
> // delayer.c - holds a device reference with a delay across NETDEV_UNREGI=
STER
> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/netdevice.h>
> #include <linux/workqueue.h>
>
> static char *watch_dev =3D "vethA";
> module_param(watch_dev, charp, 0444);
> static int delay_secs =3D 15;
> module_param(delay_secs, int, 0444);
>
> static void delayer_put(struct work_struct *w);
> static struct delayed_work dw;
> static struct net_device *held;
>
> static void delayer_put(struct work_struct *w)
> {
> if (held) {
> pr_info("delayer: dev_put %s\n", held->name);
> dev_put(held);
> held =3D NULL;
> }
> }
>
> static int delayer_event(struct notifier_block *nb, unsigned long ev, voi=
d *ptr)
> {
> struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
>
> if (ev =3D=3D NETDEV_UNREGISTER && !strcmp(dev->name, watch_dev) && !held=
) {
> dev_hold(dev);
> held =3D dev;
> schedule_delayed_work(&dw, delay_secs * HZ);
> pr_info("delayer: holding %s for %ds\n", dev->name, delay_secs);
> }
> return NOTIFY_DONE;
> }
>
> static struct notifier_block delayer_nb =3D { .notifier_call =3D delayer_=
event };
>
> static int __init delayer_init(void)
> {
> INIT_DELAYED_WORK(&dw, delayer_put);
> return register_netdevice_notifier(&delayer_nb);
> }
>
> static void __exit delayer_exit(void)
> {
> cancel_delayed_work_sync(&dw);
> unregister_netdevice_notifier(&delayer_nb);
> if (held)
> dev_put(held);
> }
>
> module_init(delayer_init);
> module_exit(delayer_exit);
> MODULE_LICENSE("GPL");
>
> 2) repro.sh - the trigger (prerequisite: insmod delayer.ko
> watch_dev=3DvethA delay_secs=3D60):
>
> #!/bin/bash
> set -e
> ip link add vethA type veth peer name vethB
> ip link set vethB up
> ip netns add A
> ip link set vethA netns A
> ip -n A link set lo up
> ip -n A link set vethA up
> dmesg -C
> ip link del vethB &
> sleep 0.5
> ip netns del A
> sleep 20
> dmesg | grep -cE 'KASAN|BUG: '
>
> 3) sprayer.c - heap groom for the write leg only, not needed for the
>    splat (sprays user_key_payload, kmalloc-256 non-cg):
>
> // sprayer.c - spray kmalloc-256 non-cg objects via add_key
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/syscall.h>
> #define __NR_add_key 248
> #define PLEN 216
> int main(int argc, char **argv) {
>     unsigned char buf[PLEN];
>     memset(buf, argc > 1 ? argv[1][0] : 'A', PLEN);
>     int n =3D argc > 2 ? atoi(argv[2]) : 3000;
>     int ids =3D 0;
>     for (int i =3D 0; i < n; i++) {
>         char desc[32];
>         snprintf(desc, sizeof(desc), "spray_%d", i);
>         long r =3D syscall(__NR_add_key, "user", desc, buf, PLEN, -2);
>         if (r >=3D 0) ids++;
>     }
>     printf("sprayed %d keys\n", ids);
>     pause();
>     return 0;
> }
>
> Run: insmod delayer.ko watch_dev=3DvethA delay_secs=3D60; ( ./sprayer A
> 4000 & ); bash repro.sh
>
> Thanks,
> Henry
>
> Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2026=E5=B9=B411=E6=9C=88=
5=E6=97=A5=E5=91=A8=E5=9B=9B 20:30=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Thu, Nov 05, 2026 at 07:48:17PM +0800, Henry Martin wrote:
> > > A device unregistered outside its netns teardown can be stuck in
> > > netdev_wait_allrefs_any() while the pernet exit handlers of its
> > > netns run to completion.  The nftables pernet storage is freed on
> > > that path.  The rebroadcasts then hit the nf_tables netdev
> > > notifiers (base chain, flowtable, offload), which read the freed
> > > storage via nft_pernet() and take commit_mutex on it, e.g. on
> > > mainline v7.4-rc1 (KASAN build):
> > >
> > >     BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x17c
> > >     Read of size 8 at addr ffff88811061c980 by task ip/422
> > >     Call Trace:
> > >      nf_tables_netdev_event+0x17c/0x1c0
> > >     Freed by task 62:
> > >      kfree+0x161/0x450
> > >      net_passive_dec+0xe5/0x180
> > >      cleanup_net+0x45a/0x780
> >
> > Could ypu pass on a reproducer?
> >
> > > Skip the rebroadcasts in all three notifiers, which are the only
> > > NETDEV_UNREGISTER events delivered with reg_state =3D=3D
> > > NETREG_UNREGISTERED.  This mirrors commit fd0909e963ed8
> > > ("netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts").
> > >
> > > This issue was discovered by Tencent CodeBuddy Security.
> > >
> > > Fixes: 8a4fc54b07d75 ("net: get rid of rtnl_lock_unregistering()")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> > > ---
> > >  net/netfilter/nf_tables_api.c     | 9 +++++++++
> > >  net/netfilter/nf_tables_offload.c | 8 ++++++++
> > >  net/netfilter/nft_chain_filter.c  | 9 +++++++++
> > >  3 files changed, 26 insertions(+)
> > >
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_=
api.c
> > > index 59ac623e6805f..e43a1b9fefc36 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -9902,6 +9902,15 @@ static int nf_tables_flowtable_event(struct no=
tifier_block *this,
> > >           event !=3D NETDEV_CHANGENAME)
> > >               return NOTIFY_DONE;
> > >
> > > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > > +      * while waiting for the last references to be dropped; the
> > > +      * netns and its nftables pernet storage may already be torn
> > > +      * down by then.
> > > +      */
> > > +     if (event =3D=3D NETDEV_UNREGISTER &&
> > > +         READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > > +             return NOTIFY_DONE;
> > > +
> > >       net =3D dev_net(dev);
> > >       nft_net =3D nft_pernet(net);
> > >       mutex_lock(&nft_net->commit_mutex);
> > > diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tab=
les_offload.c
> > > index 0ac3c26dfb3d1..d360e233d0366 100644
> > > --- a/net/netfilter/nf_tables_offload.c
> > > +++ b/net/netfilter/nf_tables_offload.c
> > > @@ -672,6 +672,14 @@ static int nft_offload_netdev_event(struct notif=
ier_block *this,
> > >       if (event !=3D NETDEV_UNREGISTER)
> > >               return NOTIFY_DONE;
> > >
> > > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > > +      * while waiting for the last references to be dropped; the
> > > +      * netns and its nftables pernet storage may already be torn
> > > +      * down by then.
> > > +      */
> > > +     if (READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > > +             return NOTIFY_DONE;
> > > +
> > >       nft_net =3D nft_pernet(net);
> > >       mutex_lock(&nft_net->commit_mutex);
> > >       chain =3D __nft_offload_get_chain(nft_net, dev);
> > > diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_cha=
in_filter.c
> > > index e04e689f22284..b3cfe8d426753 100644
> > > --- a/net/netfilter/nft_chain_filter.c
> > > +++ b/net/netfilter/nft_chain_filter.c
> > > @@ -412,6 +412,15 @@ static int nf_tables_netdev_event(struct notifie=
r_block *this,
> > >           event !=3D NETDEV_CHANGENAME)
> > >               return NOTIFY_DONE;
> > >
> > > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > > +      * while waiting for the last references to be dropped; the
> > > +      * netns and its nftables pernet storage may already be torn
> > > +      * down by then.
> > > +      */
> > > +     if (event =3D=3D NETDEV_UNREGISTER &&
> > > +         READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > > +             return NOTIFY_DONE;
> > > +
> > >       nft_net =3D nft_pernet(dev_net(dev));
> > >       mutex_lock(&nft_net->commit_mutex);

Instead of working around the problem, what about fixing it in the core?

commit bbe8af9893694c807435178eb428c42d3305db97
Author: Eric Dumazet <edumazet@kernel.org>
Date:   Thu Nov 5 13:44:07 2026 +0100

    net: wait for in-flight device unregistrations before netns dismantle

    A device can be unregistered by a context other than the cleanup_net()
    of its own netns, for instance a veth whose peer in another netns is
    deleted. If references on it are still held, it stays in
    netdev_wait_allrefs_any(), which rebroadcasts NETDEV_UNREGISTER every
    second.

    Meanwhile its netns can be dismantled: default_device_exit_batch()
    only takes care of devices still listed in the netns, then pernet exit
    handlers free their state, and finally struct net is freed while the
    device still points to it.

    The rebroadcasts then run notifiers against torn down pernet state, or
    freed memory. Two instances were reported so far:

     - netdev_genl_netdevice_event(): net->genl_sock is NULL [1]
     - nh_netdev_event(): net->nexthop.devhash is NULL [2]

    but any notifier using dev_net(dev) is affected, as is
    netdev_wait_allrefs_any() itself (__rtnl_net_lock(dev_net(dev)) with
    CONFIG_DEBUG_NET_SMALL_RTNL=3Dy).

    This was prevented by rtnl_lock_unregistering() until I removed it
    in commit 8a4fc54b07d7 ("net: get rid of rtnl_lock_unregistering()"),
    considering only the loopback dependency, and missing the notifiers one=
.

    Restore a per-netns counter of devices sitting in netdev_run_todo(),
    and make default_device_exit_batch() wait for it to reach zero, after
    it has unregistered all devices of the dying netns(es). At this point
    no new unregistration can be started for these netns.

    Unlike the old barrier, this only waits for devices of the netns being
    dismantled and runs after their own devices are gone.

    Tested on a KASAN kernel with a debug-only hack holding a reference
    on a veth device for 5 seconds after its unregistration: a nexthop
    on the veth in netns X, delete its peer from init_net, then delete X.
    Without this patch, the nexthop_flush_dev() null-ptr-deref from [2]
    triggers. With it, no splat; netns churn and dismantle of a netns
    whose own device is held still work.

    [1] https://lore.kernel.org/netdev/6adf9f64.6200f071.51519.0ed1.GAE@goo=
gle.com/
    [2] https://lore.kernel.org/netdev/20261105114707.3030737-1-bsdhenrymar=
tin@gmail.com/

    Fixes: 8a4fc54b07d7 ("net: get rid of rtnl_lock_unregistering()")
    Reported-by: syzbot+1269fe6cc2016008124e@syzkaller.appspotmail.com
    Closes: https://lore.kernel.org/netdev/6adf9f64.6200f071.51519.0ed1.GAE=
@google.com/
    Reported-by: Henry Martin <bsdhenrymartin@gmail.com>
    Closes: https://lore.kernel.org/netdev/20261105114707.3030737-1-bsdhenr=
ymartin@gmail.com/
    Signed-off-by: Eric Dumazet <edumazet@kernel.org>

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c29a22ca178fa678c0468247b9f85f53eec86184..4a4d72080acdc787797bffd3a5a=
1bc0e6d4b46c7
100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -72,6 +72,7 @@ struct net {

        unsigned int            dev_base_seq;   /* protected by rtnl_mutex =
*/
        atomic_t                dev_mc_genid;   /* dev->mc membership chang=
es */
+       atomic_t                dev_unreg_pending; /* devices in
netdev_run_todo() */
        u32                     ifindex;

        spinlock_t              nsid_lock;
diff --git a/net/core/dev.c b/net/core/dev.c
index df1a840b033437a168d4290f19611e6a23507d08..dfcb0fc4bb23f682fc412648be3=
8cf3ffdb64f2c
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11101,6 +11101,14 @@ atomic_t dev_unreg_count =3D ATOMIC_INIT(0);
 static void net_set_todo(struct net_device *dev)
 {
        list_add_tail(&dev->todo_list, &net_todo_list);
+       atomic_inc(&dev_net(dev)->dev_unreg_pending);
+}
+
+/* Paired with net_set_todo(). @net must not be used after this call. */
+static void net_unreg_done(struct net *net)
+{
+       if (atomic_dec_and_test(&net->dev_unreg_pending))
+               wake_up(&netdev_unregistering_wq);
 }

 static netdev_features_t netdev_sync_upper_features(struct net_device *low=
er,
@@ -12000,6 +12008,7 @@ void netdev_run_todo(void)
                if (unlikely(dev->reg_state !=3D NETREG_UNREGISTERING)) {
                        netdev_WARN(dev, "run_todo but not unregistering\n"=
);
                        list_del(&dev->todo_list);
+                       net_unreg_done(dev_net(dev));
                        continue;
                }

@@ -12016,8 +12025,11 @@ void netdev_run_todo(void)

        cnt =3D 0;
        while (!list_empty(&list)) {
+               struct net *net;
+
                dev =3D netdev_wait_allrefs_any(&list);
                list_del(&dev->todo_list);
+               net =3D dev_net(dev);

                /* paranoia */
                BUG_ON(netdev_refcnt_read(dev) !=3D 1);
@@ -12038,6 +12050,8 @@ void netdev_run_todo(void)

                /* Free network device */
                kobject_put(&dev->dev.kobj);
+
+               net_unreg_done(net);
        }
        if (cnt && atomic_sub_and_test(cnt, &dev_unreg_count))
                wake_up(&netdev_unregistering_wq);
@@ -13486,6 +13500,17 @@ static void __net_exit
default_device_exit_net(struct net *net)
        }
 }

+static bool __net_exit dev_unreg_pending(const struct list_head *net_list)
+{
+       struct net *net;
+
+       list_for_each_entry(net, net_list, exit_list) {
+               if (atomic_read(&net->dev_unreg_pending))
+                       return true;
+       }
+       return false;
+}
+
 static void __net_exit default_device_exit_batch(struct list_head *net_lis=
t)
 {
        /* At exit all network devices most be removed from a network
@@ -13527,6 +13552,16 @@ static void __net_exit
default_device_exit_batch(struct list_head *net_list)
        unregister_netdevice_many(&dev_kill_list);
        rtnl_unlock();

+       /* Devices of these netns unregistered from another context
+        * (e.g. a veth whose peer was deleted) can still be waiting
+        * in netdev_run_todo() for their last references, while
+        * NETDEV_UNREGISTER is rebroadcast for them. Wait for them
+        * before pernet exit handlers tear down the state used by
+        * netdevice notifiers, and before the netns is freed.
+        * No new unregistration can start: all devices are unlisted.
+        */
+       wait_event(netdev_unregistering_wq, !dev_unreg_pending(net_list));
+
        rtnl_net_flush_workqueue();
 }
