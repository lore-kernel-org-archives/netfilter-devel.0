Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D01C2E7BD6
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785016775; cv=pass; b=oQhc/pAZlZLvX1RPcxGbhuFsFQRCAZix9lJjFK73JP+urlfpa5tYGqKGDW4iqCIueXl3W7tkYWQa684DSQfKL1NvPQCYjKpJX4kzdkcPU4+Nv1sm3JJQ+zcXHXbBKEEK/LfuALk0umyQ9IfLtx5y5AYRQWMY6BOv0fogDW+i8MM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785016775; c=relaxed/simple;
	bh=U6mjhyiRpLaLB9KAl6dmzxU9rY5e4QrHQWmS+UYxkas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MWMdf+6dS5sjRjhlcUeMRK1KQfz6yfQs+9AV0JNMcB3peNOPqqi6N7BcvvbVkTWqvZONL5JCc/PQOmTQwP8W3tdcwXGDwN6VZaEa361tf1SywVw0JMt5pN7d5P5egpRvbykYQXmR6ZecQ2RctZQGuB4Sj1E3viR1mVWWFcoSGDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=XJA9w0mJ; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="XJA9w0mJ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so23604835ad.0
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 14:59:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785016771; cv=none;
        d=google.com; s=arc-20260327;
        b=ne9EnEL9TvSIddKuVJGd1WW20fTB7DID4fnNLp5bQiDg6gHNAmzO3PF+T9ZbkY59os
         qHSb6Af2nM9OsFWOUmMlGQUFSUiflw7yUekT2SxetqAn4E5ev/kFaGtHAHBMO+TcNV/y
         9Jkayukn8bmhdVWTMAUWUqOx6V9Lake8b0G3j+QvYoOZKR0RLLRH2yFaIJqf5+guOJFn
         xa5YGEAslH9ee4fX4ZeFkbYj1yKZWdoVSNdrd1hPmQzrTnzb4VZOEHtX3SWh3DuK7uwG
         nn7EYdnJ4PAz3oEcxUwRI7ievwoZ27TDUSRyRyg7C460wXQwuWOeG9gqCCpWg+6uFhPn
         XWAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=604Ldio6O4k/Z0kUfQq96pKAmoGJa7Roa+RxaLoogKE=;
        fh=dHZoHqTV3MYsgfBR2RPwKITDoogXeY8lP23V6lIepBk=;
        b=liUSGQk00nZ+nFi3H4zcwrgrc3Aoo6Vt+CEh/JFP+ORObIbj7j+UhLi80/vpnd7vpu
         bJCqaJNUpBgdpTPDyuhPDU7OZw210y4dTMdbuFb64LILSvHNVtTi0GQYL6tfjfLa/uZy
         9cdEv35CZBduenuDWrJqptp49P/pMTp1Y7q1zs1VkRHA3GK8HDGvNAItP0fPH0h0D4FJ
         PI8eBXKU46q3SBIxzsrM3LzAA9YsFRp5R6CBw3BK3MC2RzIRy7mnrST8epgmW18DpMvU
         hsNSErSZhg/B2/ukF5/z4AYJTrVk9mAF/c+UIw5KR4wVEcHfimKLZ16U+fXtrmFea8JH
         fyDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1785016771; x=1785621571; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=604Ldio6O4k/Z0kUfQq96pKAmoGJa7Roa+RxaLoogKE=;
        b=XJA9w0mJDIduKhHmvKIEBwAV+1gEIKl58UyJcfEO8fl+08sceANZaaRxDqvhHSUbvW
         84LnCgWSkSBOMrA26ZZ7w3j/byzBgSiC/kgqDnAWZITGD2021XQH6zsOxrf7nVjbCunP
         Eu6MZQHUMnr/TCv0IExNoT/WG9pCfU4IkriBLXkq5Q3mcv9+HOK3dLOjCOsVWjCGDQZD
         ZLeJuuYWyO1EQlj/btZSHUIJ8qduIvz4syzaYIy4azpv7WmDPRb1hjRFnG4G4aArKyug
         fIgVZ7Xl0YgNa+QOqRLQGrlw3A/CqV9W7RUz1KyjeKiyhHbeHYMfuzcAN4hZ9lMiJxkw
         6FhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785016771; x=1785621571;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=604Ldio6O4k/Z0kUfQq96pKAmoGJa7Roa+RxaLoogKE=;
        b=Th5CvFeruwXGJX12eZS/4dwMe8ZMt5H1JQFvBQpczgwGIAqCKYuVSjsMw7AOKvm+w8
         0H8IxtWr6YBL0m9veW3pXa/ksVpLJAj/TxG60OkC1YgNhI308lE6dn6g2IficANqPAdh
         /nhcSqQhlxnhSa6uLho114Fk+/OQvMdl+JC4sJLi+GUMptoMi8bocVL4Z6DHpm+3ZjxG
         Utcm9kdCvdaAe/rXpuZYBQCRKONp7y3vgrC+G8PSnXxX4vZ3J+Fc28PUnbF075uwZ2ey
         ug7onfJv/0/166DjcEFgFbHgOm+NFmToMaZn84sW/MuwofZK3R979k07c/ZOIrc5O450
         tHJA==
X-Forwarded-Encrypted: i=1; AHgh+RpESgy5YExPCM9rSRwRhaF0acAfM0DxTmIt3+dL+atp5eaLbyQ9YvTp93sp58dfRG/dThGecZPbo89zwWe0xiU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1dNq7BatBsvklpSPMcBnGIR0Gw8ueJ1GUVHzfJYEoylXxW83G
	oTGK8sjekoRdmpz0P4BV08o/k8KmhLZYIG+MyZaVD1Cw2RNaJyg7RxsM7uibtzGg0hcr9AP3H97
	rGhdR6i3OMNGY8L3BcPWfS1oSrdrQfErqSlxIBH2/
X-Gm-Gg: AR+sD11LMjYjxlnbXeXaOkIGf07T/2QIAcIFNqvck63IzBQuxad2QNoCTCw6XBM1zl8
	rrdrkqplj6GxkW3gETkYGGInMSaGD15HGiOchPW/PWqh6+Cae8/Zyj2Ssr/PuahNWGhTPL70lg5
	eqi490cSBhAOt1PNt/0veixiF2tekI/tOJbnJPtK+9y878pM80lpsyRgdS2hQ58lsYMUj0DwpEp
	JLzHMgnTPdu93dd8cVy8RWjWJSkBUh+k2BG/VGuyVxaJ8fBtfSTWxx2iAMHkFcIHRGTWjanhnrA
	1wV1y2NXmkPSCo2xDg==
X-Received: by 2002:a17:903:2bcb:b0:2c8:1c05:16aa with SMTP id
 d9443c01a7336-2cfde7c66b1mr28574475ad.19.1785016771480; Sat, 25 Jul 2026
 14:59:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722223832.3524006-1-xmei5@asu.edu> <fd5dcd37-c4f8-94de-6fa2-01d30427f63e@blackhole.kfki.hu>
In-Reply-To: <fd5dcd37-c4f8-94de-6fa2-01d30427f63e@blackhole.kfki.hu>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 25 Jul 2026 14:59:20 -0700
X-Gm-Features: AUfX_mxqEnB6EYWgu3OUWMFbSignSZXrEFWaUkiAUdm1kVaUAIsQfEtRBnFupLo
Message-ID: <CAPpSM+TZwQGHUX9QnwkOa9ufBueG2g1My=ZsnYxyt_zNL7TUMg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ipset: fix refcount race between list:set
 GC and swap
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 12:33=E2=80=AFAM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> On Wed, 22 Jul 2026, Xiang Mei (Microsoft) wrote:
>
> > __ip_set_put_byindex() resolved the index to a set pointer under RCU,
> > then took ip_set_ref_lock in __ip_set_put() to decrement set->ref.
> > ip_set_swap() holds that same lock while swapping both the ip_set_list
> > slots and the two sets' ref counters, so it can interleave between the
> > dereference and the lock acquisition, leaving the caller to decrement a
> > set whose reference already moved to the other index and hit
> > BUG_ON(set->ref =3D=3D 0). list_set_gc() reaches this from timer softir=
q,
> > which the nfnl mutex does not serialize against swap: an expiring
> > list:set member calls list_set_del() -> ip_set_put_byindex() while
> > IPSET_CMD_SWAP runs on the referenced sets.
> >
> > Resolve the index and decrement under ip_set_ref_lock, as ip_set_swap()
> > already does, keeping the refcount tied to the index rather than to a
> > stale set pointer.
> >
> >  kernel BUG at net/netfilter/ipset/ip_set_core.c:685!
> >  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> >  RIP: 0010:ip_set_put_byindex (net/netfilter/ipset/ip_set_core.c:870)
> >  Call Trace:
> >   <IRQ>
> >   list_set_del (net/netfilter/ipset/ip_set_list_set.c:159)
> >   set_cleanup_entries (net/netfilter/ipset/ip_set_list_set.c:181)
> >   list_set_gc (net/netfilter/ipset/ip_set_list_set.c:578)
> >   call_timer_fn (kernel/time/timer.c:1748)
> >   __run_timers (kernel/time/timer.c:1799 kernel/time/timer.c:2374)
> >   run_timer_softirq (kernel/time/timer.c:2405)
> >   </IRQ>
> >  Kernel panic - not syncing: Fatal exception in interrupt
> >
> > Fixes: 9076aea76538 ("netfilter: ipset: Increase the number of maximal =
sets automatically")
> > Reported-by: AutonomousCodeSecurity@microsoft.com
> > Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
>
> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
>
> Best regards,
> Jozsef

Awesome, thank you for your review!

-Xiang
>
> > ---
> > net/netfilter/ipset/ip_set_core.c | 19 +++++++++++++------
> > 1 file changed, 13 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip=
_set_core.c
> > index 6cfad152d7d1..16d33c3e28cf 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -679,11 +679,18 @@ __ip_set_get(struct ip_set *set)
> > }
> >
> > static void
> > -__ip_set_put(struct ip_set *set)
> > +__ip_set_put_locked(struct ip_set *set)
> > {
> > -     write_lock_bh(&ip_set_ref_lock);
> > +     lockdep_assert_held(&ip_set_ref_lock);
> >       BUG_ON(set->ref =3D=3D 0);
> >       set->ref--;
> > +}
> > +
> > +static void
> > +__ip_set_put(struct ip_set *set)
> > +{
> > +     write_lock_bh(&ip_set_ref_lock);
> > +     __ip_set_put_locked(set);
> >       write_unlock_bh(&ip_set_ref_lock);
> > }
> >
> > @@ -854,11 +861,11 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_=
set_id_t index)
> > {
> >       struct ip_set *set;
> >
> > -     rcu_read_lock();
> > -     set =3D rcu_dereference(inst->ip_set_list)[index];
> > +     write_lock_bh(&ip_set_ref_lock);
> > +     set =3D ip_set(inst, index);
> >       if (set)
> > -             __ip_set_put(set);
> > -     rcu_read_unlock();
> > +             __ip_set_put_locked(set);
> > +     write_unlock_bh(&ip_set_ref_lock);
> > }
> >
> > void
> > --
> > 2.43.0
> >
> >
> >
