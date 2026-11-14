Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794632505;
	b=eC6xcb4yAnoCQdVB/v6Pr+DowCFt1OwfmQPL3cP6gATqnOMgUmIzNuDCrRgLEBdw8L8d
	 UzH12hQhquYL+MhK6Lt94jbfmt0mUT2UYTbtuXQMqcvcMXMnd7/WueBDdCEUpBErlfgPB
	 vxDKtUxg+vRuBMhZtJ5Gv34E2NJZYbOGB4VZIjTtMHGh1UUr3SY5TQFPWf55yD43Qof5q
	 6T4yYyiHhYrf8miUFL+tlfjeu2tNv0k4vqK9hRKhCfKA8U69yVgXzGAvevVCs4FbtHK+j
	 eDanz79hLrl0mBzEfYDc/8PfXTyat3teciitjVdB+sE9mOvQfDeD12xj4fMeLpckuVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794632505;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jMYTvmPr+KSRh1RdxaI2+rPAQFMAD6SO9Ci4p9a+jr4=;
	b=Ba0YtbIW0plj9mMe1A99Pv9j6NccaGgR59sMCnn54NPx5kgrmKfltXiZyldDeIdK/JFM
	 Pb94TR57qw4moETflZjpAj93RaYr0grQECZM7bwIiFnK0m5/l0VL7oO2P6+04pnEjmdew
	 baXRr6OG8dyNe0gbnxiknGvn65tlLmdaLrDqkSxOlybENv+fjW/jJqJeuszIb6FtCI/cg
	 n90pPP3nRsMoZB1AwrR4ATzmyaHsG+G0fLphD8IJPkn4DtGLZLrsHA0hrMT2xKfjpBogu
	 oCfYne13n2v4OT2546hbVfbzr5eFEfhpRfh8Z2s8r1Dh64Rf982Sxmhq1YKUrvm2NOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yLvHB6Tw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB44B606AB53
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 05:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB44B606AB53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yLvHB6Tw
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdac52511b3so153567a12.2
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 21:01:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794632504; cv=none;
        d=google.com; s=arc-20260327;
        b=EoLdnDb4LQcwRPzRRM57Io9bBteqZcXDlJu4pAqzx8a+FnAPX8XsReiM6uUQGGjeNa
         7LuYwSpGLB7ovEIMcCWu6O+wSBM2Euesw1H4T1U+D3B7LY9laDrlOD2I5rYsULrIz24b
         oPyuCflwENCSrqAnMTXezdI4jqHfcIDC8Wk9Ol75+olcrx4+ZNqt1MjfxL77QilCDdJ5
         eVTykVqB5dJf0nu916eYbMSqeGt2dk6eJLpbaJrGpMGzN1H/TqWM7XZ7ewe3wiHI0azs
         rro80GulJz4CUDq4swZJaC74tk8U4N2atko8Y0xoVIGYmde12OIPStA7BGfcMJKllP0x
         pP2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jMYTvmPr+KSRh1RdxaI2+rPAQFMAD6SO9Ci4p9a+jr4=;
        fh=A4ylub4Fc46sHAY1beBP8uTjwJ8uYF4ZtODKhwTxBKg=;
        b=C+IEwhmGubKXexIu2nTgO8LuEK0mU2I5ZL7q3FpmeOty68J4va4P4Pjdn9JaFiP1Od
         WSnXncD5h0asw3YIhkKivkQML7+zoMJvvqo28ji1mBAPcv2sZHBr/CBiXWUmldkZ9ZVd
         WGjSE8dm7BCKwLrXuxXTOr1dL8qN+p9NY0tGqFfdtvQt8b3SAkP4EVSy/Jn9SRcF1Kt2
         q/+xe8XSBWVQe/wrozo9+DeQiPHELIX+oVI/fl/T+rwqUHSwCOU7OlvCVjjsBoY+JO4/
         eBSf/wfepw19b/qgbgKbG20lvMIIwIhuZU7RXDhdK2AxzO5TfwmFGz1pEeVTvvjpAAO+
         zOvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794632504; x=1795237304; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jMYTvmPr+KSRh1RdxaI2+rPAQFMAD6SO9Ci4p9a+jr4=;
        b=yLvHB6Tw+n5zRGbneX/y2Nt0MBMkN4rYRxOLprnvZp+GSe8llWUPyw1f8imqYXsu4A
         YW4J1B8GglH1Frx2+9gA/v0Uon0ARHMkZ8g/WCrmsfvU8FlaT1Y+eST8NdVVGbRQr34P
         o71mESNozGnUQrGKOOCbRoMtyLhNVACAoIHKrJ1fKk4ECRWuezZEQxuCSP9/w1rrMC3D
         dewSAH8sd8wYLc6GNYzRhtM0i5y4CaBQkaXZ6OJAlzKLU7MsUZVk577Yx1b5qx/4jbpJ
         p3KusfCnQaMIaVm/U4c9nhLt1X0DoyQbzgYf8mwD2rDwIgFY/BXFRRkbKtLTea+myX7o
         yztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794632504; x=1795237304;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jMYTvmPr+KSRh1RdxaI2+rPAQFMAD6SO9Ci4p9a+jr4=;
        b=RHTn6jw1sne2rUlonlQKA3hOiGF6fh0CsIk2M9yBCxd08S/RgQhjyDXeNzpeO9s0P2
         VVuyTZQP1Y/s8hbhewagKYU5ks1xYGJKWcCjklLC2TTfRqZ0G66XFeA3Nw8tmzP6hGhZ
         /7A8iwLiO90RrEZUfiE62dQthhskUrUd72MZy7a91ok4rH1J9j5ttfYTs6XBtKg5G7cK
         Ell6DMrJKCcR/FLKU06qkJ0Yc1LgsX6/asaiQ1EJ0vG6v24NEL6vS4LdRCurq2MOvE2U
         4Fxo6igOIV0RTY0aRRPvcZ83qcu/CfPTs9ax1EiAoSlKpvTnN6VWr36q41VfeESyAbFA
         jYXQ==
X-Forwarded-Encrypted: i=1; AL+hErF8FKxn2up2idAzYG4TsBX9cPcAhnUHQlktyxPkt1TgiXkDZ5lRKDDq2Zy2cA42XJgEgNQ+BRX+tm0adEG/4Nk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+BEmfzA5xNzYgOJMkrAGLTgsuTCOrWQ6EJr4aZwCU9eKGVV9zx
	joCVxaieMspAp8aK+epTkv7xtEiYP3cYi6rNsAa22V3OKdazcc3jrrrr8vxy3rovYB/tT99UXov
	Q6y4Xx3NyHLTl+0tnD0fYjRekUQf75ss=
X-Gm-Gg: AYBFou0ut100BAWEX3fc3tdwZkKpGcXJDmF3PN1UCqEh4U23I/pRuvfG9qxnc2y47Ms
	BPWqSkil58cRqWhErjVUHh1iNZYif7z4lAwaH2KXpHMcEHPVsXM5FCDcwesPIOFp6Uy1TI/VvxX
	eSdBmT7c8kn/00NEcdxRaigePgN45lg2KpFka8UfSGZqrQd7y71I2Zd7fzTNcYFkFGcZ5b2eKch
	tRH9pKBxXFhQ2R9PMKyo7p8WnWccJdcJatPAYU9IGjiZWG2H/WPiLPjAHp8k+miRiDAVfOPbqOZ
	iG9V+a5VV3etySw2FAgg5TEjF38B3sQ20qW4Lj9DeJuf4MZB+tm2fyqNVlfCDbiqq1k2mSpLPVr
	DIj9pg5DmqE9ycmB+NIqKnvoloiq5IV2vfIJUTBY37ChYalQ54e+yMyvT+GItwYK9NFlHOg==
X-Received: by 2002:a05:6a00:2b8a:20b0:8bc:35d4:a983 with SMTP id
 d2e1a72fcca58-8beb63a0d7emr4947055b3a.3.1794632503862; Fri, 13 Nov 2026
 21:01:43 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105065509.94627-1-q.h.hack.winter@gmail.com> <avJqUf4_aBq_zkRo@chamomile>
In-Reply-To: <avJqUf4_aBq_zkRo@chamomile>
From: Qihang <q.h.hack.winter@gmail.com>
Date: Sat, 14 Nov 2026 13:01:31 +0800
X-Gm-Features: AclHuK9PCwUMjk3k3_3TWX_7upd_aucCkRivxjBESCeq8VS_CuRBZq74-OGcivY
Message-ID: <CAH78Gvu+_-aD6tOn4A9OfDWWwrbrb3-vX1YiP827i_-UFMg5wg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_flow_table: defer pernet stats release
 to last flowtable teardown
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, phil@nwl.cc, vladbu@nvidia.com, ozsh@nvidia.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

You are right, your nf,v4 patch covers this.  I re-ran my reproducer on
a clean 7.3.0-rc6 tree, same .config and initramfs, your patch as the
only difference: the unpatched kernel reports the percpu write in 3/3
runs, yours is clean in 3/3 with the counters still demonstrably live.

Your synchronous purge removes the teardown GC passes that could queue
further DEL work, which covers the path my reproducer exercises, so I am
withdrawing the patch and do not plan a v2.

One correction to my report: act_ct sets NF_FLOWTABLE_HW_OFFLOAD
unconditionally, so my "flushes were skipped" explanation does not apply.

Thanks,
Qihang

On Tue, Nov 10, 2026 at 8:50=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Thu, Nov 05, 2026 at 02:55:09PM +0800, Qihang wrote:
> > The pernet flowtable statistics (net->ft.stat) are released when the
> > netns exits, but the flowtables attached to a dying netns are torn down
> > asynchronously afterwards: the tc conntrack action frees its flowtable
> > from an RCU-delayed workqueue item (tcf_ct_flow_table_cleanup_work()),
> > and nf_tables releases flowtables from the transaction release work.
> >
> > nf_flow_table_free() ends with a garbage-collection pass that queues
> > offload works; flow_offload_queue_work() increments the pernet counters
> > when scheduling them and the handlers decrement the counters again once
> > they complete.  The flushes in nf_flow_table_free() only drain those
> > workqueues when hardware offload is in use, so after free_percpu() the
> > stray workers still this_cpu_inc()/this_cpu_dec() into freed percpu
> > memory.
> >
> > Account flowtables at init time and defer the release of the statistics
> > to the last nf_flow_table_free() of a dismantled netns, after draining
> > the offload workqueues.  A netns without flowtables keeps the
> > synchronous release.
>
> Looks like a duplicate of:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261029230657=
.302417-1-pablo@netfilter.org/
>
> > Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload w=
orkqueue tasks")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
> > ---
> >  include/net/netfilter/nf_flow_table.h |  1 +
> >  include/net/netns/flow_table.h        | 11 +++++++
> >  net/netfilter/nf_flow_table_core.c    | 44 ++++++++++++++++++++++++++-
> >  net/netfilter/nf_flow_table_offload.c |  7 +++++
> >  4 files changed, 62 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfil=
ter/nf_flow_table.h
> > index 5b22d31cb1407..91ffa3072a0cc 100644
> > --- a/include/net/netfilter/nf_flow_table.h
> > +++ b/include/net/netfilter/nf_flow_table.h
> > @@ -376,6 +376,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flo=
wtable,
> >
> >  void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
> >  void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtabl=
e);
> > +void nf_flow_table_offload_drain(void);
> >
> >  int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
> >                               struct net_device *dev,
> > diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_ta=
ble.h
> > index 1c5fc657e2675..6d2dc0d1f06c7 100644
> > --- a/include/net/netns/flow_table.h
> > +++ b/include/net/netns/flow_table.h
> > @@ -2,6 +2,9 @@
> >  #ifndef __NETNS_FLOW_TABLE_H
> >  #define __NETNS_FLOW_TABLE_H
> >
> > +#include <linux/spinlock.h>
> > +#include <linux/types.h>
> > +
> >  struct nf_flow_table_stat {
> >       unsigned int count_wq_add;
> >       unsigned int count_wq_del;
> > @@ -9,6 +12,14 @@ struct nf_flow_table_stat {
> >  };
> >
> >  struct netns_ft {
> > +     /* Protects nr_ft and exiting. */
> > +     spinlock_t              lock;
> > +     /* Number of flowtables attached to this netns. */
> > +     int                     nr_ft;
> > +     /* Set at netns exit; the statistics are then released by the
> > +      * last flowtable teardown.
> > +      */
> > +     bool                    exiting;
> >       struct nf_flow_table_stat __percpu *stat;
> >  };
> >  #endif
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow=
_table_core.c
> > index 0d72dc8ae47a1..de0a9f0e4f7b9 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
> >
> >  int nf_flow_table_init(struct nf_flowtable *flowtable)
> >  {
> > +     struct net *net;
> >       int err;
> >
> >       INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
> > @@ -733,6 +734,13 @@ int nf_flow_table_init(struct nf_flowtable *flowta=
ble)
> >       list_add(&flowtable->list, &flowtables);
> >       mutex_unlock(&flowtable_lock);
> >
> > +     net =3D read_pnet(&flowtable->net);
> > +     if (net) {
> > +             spin_lock(&net->ft.lock);
> > +             net->ft.nr_ft++;
> > +             spin_unlock(&net->ft.lock);
> > +     }
> > +
> >       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(nf_flow_table_init);
> > @@ -771,6 +779,8 @@ EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
> >
> >  void nf_flow_table_free(struct nf_flowtable *flow_table)
> >  {
> > +     struct net *net;
> > +
> >       mutex_lock(&flowtable_lock);
> >       list_del(&flow_table->list);
> >       mutex_unlock(&flowtable_lock);
> > @@ -781,19 +791,51 @@ void nf_flow_table_free(struct nf_flowtable *flow=
_table)
> >       nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL)=
;
> >       nf_flow_table_gc_run(flow_table);
> >       nf_flow_table_offload_flush_cleanup(flow_table);
> > +
> > +     /* The gc pass above can still queue offload works whose handlers
> > +      * decrement the pernet statistics.  Drain them all.
> > +      */
> > +     nf_flow_table_offload_drain();
> >       rhashtable_destroy(&flow_table->rhashtable);
> > +
> > +     net =3D read_pnet(&flow_table->net);
> > +     if (net) {
> > +             bool release;
> > +
> > +             spin_lock(&net->ft.lock);
> > +             release =3D net->ft.exiting && !--net->ft.nr_ft;
> > +             spin_unlock(&net->ft.lock);
> > +
> > +             /* Released by the last flowtable teardown, see
> > +              * nf_flow_table_fini_net().
> > +              */
> > +             if (release)
> > +                     free_percpu(net->ft.stat);
> > +     }
> >  }
> >  EXPORT_SYMBOL_GPL(nf_flow_table_free);
> >
> >  static int nf_flow_table_init_net(struct net *net)
> >  {
> > +     spin_lock_init(&net->ft.lock);
> >       net->ft.stat =3D alloc_percpu(struct nf_flow_table_stat);
> >       return net->ft.stat ? 0 : -ENOMEM;
> >  }
> >
> >  static void nf_flow_table_fini_net(struct net *net)
> >  {
> > -     free_percpu(net->ft.stat);
> > +     bool release;
> > +
> > +     spin_lock(&net->ft.lock);
> > +     net->ft.exiting =3D true;
> > +     release =3D !net->ft.nr_ft;
> > +     spin_unlock(&net->ft.lock);
> > +
> > +     /* Pending flowtables still update the statistics from workqueue
> > +      * context; the last one releases them, see nf_flow_table_free().
> > +      */
> > +     if (release)
> > +             free_percpu(net->ft.stat);
> >  }
> >
> >  static int nf_flow_table_pernet_init(struct net *net)
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_f=
low_table_offload.c
> > index 4365859220e6a..6ac28802ef632 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -1180,6 +1180,13 @@ void nf_flow_table_offload_flush(struct nf_flowt=
able *flowtable)
> >       }
> >  }
> >
> > +void nf_flow_table_offload_drain(void)
> > +{
> > +     flush_workqueue(nf_flow_offload_add_wq);
> > +     flush_workqueue(nf_flow_offload_del_wq);
> > +     flush_workqueue(nf_flow_offload_stats_wq);
> > +}
> > +
> >  static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
> >                                    struct flow_block_offload *bo,
> >                                    enum flow_block_command cmd)
> > --
> > 2.54.0 (Apple Git-157)
> >
