Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB2C32ED43
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763385824; cv=none; b=qQhP5k6BpuDej3zOkJ0QHCJrFeFTPh0NRroNVzbdlX15sO8LygP0LdJ5bD86plGJRTQ8ccA9tDCV2wQtg6q7op6PeO5pRFFzK+59xLgnuK7jiVlsr7/AZHj1sr7MevQ3jr1HRG6X8zt3XKRP0jojf5YfFkGOVMgQuhP4qzkaWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763385824; c=relaxed/simple;
	bh=rwp67LGCCgBjrSzvfptqkJIcC3/38GeCH3jY9NCB/X4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNY6q5Q1L1T4MvyWRpLc4K6lmyBnnSEgK2o6CYrasPHmZb0xhgBWnNysX6noiMSp0CLX55VFCUimRa81y0G2u2xPI1fkEu9Km/Vs3CYYsTwSUVPyaBpIhN+z2w6yTH2nv3mQfdWTCZkE/4j4GFPW2/LUeIVR2N+x7GR3fA8nE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cuN6grp5; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cuN6grp5"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5e186858102so131469137.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 05:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763385821; x=1763990621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6Bd4TfE2CFNMOw4Zo1YniBBr4MUz5w78f6ia3r4hZw=;
        b=cuN6grp5PRTrXVttzAHymTbmBzI/tkbZGoW/NT+8dqv3ZVujTGrJ620WdCZEuxbWis
         mQfQw8cj/d2HEpi1obhucMKQ5EZw2v+Z5h0oEY93JiYTOBHCdM4J4oR3ef75C0qM9BZ7
         VsSvfIZanhB3+p8RzQwIwGKdVL0+NaP1AG2X31ygRCJixQQcIbTnct0B3R0KG/Mtfij2
         QxsVzn0EDsTCBN9sF0/fZyMeT1fSOo1k07p8IWcSTQMKKiO0NaOZT48+WBrKJXlLVcx7
         CYjz9bomY64Ee1H7q3V4kkyCrpQHjs50mLWqdt3AIOzDNqrCC593e+ZEtznWBRBgz7kF
         0dqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763385821; x=1763990621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E6Bd4TfE2CFNMOw4Zo1YniBBr4MUz5w78f6ia3r4hZw=;
        b=DQbVLgc4uycsj4bqnsWnMdGkD5IhdQcPwbTfj6yuJIuNE9wmIQvIOFK6WIDisDOLB/
         Om3gZ1boWyLBudm4AcnKttyYbP3cXGeaA6Kk996ySWorw/Z0ITZVzm6NvaCeksX/wTOy
         p7HEIRuTJoJiasIDlwkIHjv0HQU7Z6jj7tqKYbzWkXPNv7o1AZANj79kX6dtKxlt0bPK
         CYF1IFzWptnkWF27uA7j6d7SlMRZgf4jzPQSXuDy4opYuW7pJuonh2COmZncavCu2TRa
         LM4bbvstRCOliXIRkZdhBJn/Vs6U8ZZ2pN3q0b5MZhFZJCXG6b+vL68nJ6gg7rjvBjg+
         IpwA==
X-Forwarded-Encrypted: i=1; AJvYcCWWYL+sRdpDF90TUP67/Y9FxCfsPzlOr36NFGnsdX9Hy4qqqDHxsJRc+Cy8cXTqjmLRmNJUwNYGsCdFD4yVTgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZf7kZc1qL7A2B2yBMs75VI7D4Kzq7w9jSbgGLJZU48GjyB+m
	X8M1dvt6KBNuRVGfwztiReNSLP63c9R7uqcXZ9Z2x5yjzsJaoWgT/VOhYwo8dmvGlIlv+PhRaZK
	qaDhXc5CooFSBbIc/UNDyDND/8xvXn30=
X-Gm-Gg: ASbGnctfSDkw0DuzMX7llGdgsD8rYNsz9vUzw4uDQ7AB1PMYUkOYzxyuYBaaP2mN0Zm
	346FWtWaLVL4evesxehQrSDpv6Q/zaWTKyE/A0GuYtSgFCeOi3xWTGdaTcMKBmkdkrErNHAc56I
	ExZFA6g/6SWPDU6LSKEjRM+5AsByTZIKk04j6zl2LTMW0DtcBzQUlOEe0/iSlxPYHRpAu5ZWeNF
	a7oT9wHjCbk7k1bqcVs810icL8o38ShIonrJksQWydi6opiN72XaYpSA8YKdC/1sgjKV+bd
X-Google-Smtp-Source: AGHT+IHXupDc6wuDYnYRytmVAWoT14b4/ceyrtVaE+IYWHhw+zqgL7t2wvRCqkDV3SvyZ1BJtpSlT2AjfxAV0wfQ3fc=
X-Received: by 2002:a05:6102:c47:b0:5dd:b100:47df with SMTP id
 ada2fe7eead31-5dfc54f9307mr3261417137.4.1763385820656; Mon, 17 Nov 2025
 05:23:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430071140.GA29525@breakpoint.cc> <20250430072810.63169-1-vimal.agrawal@sophos.com>
 <aO-id5W6Tr7frdHN@strlen.de>
In-Reply-To: <aO-id5W6Tr7frdHN@strlen.de>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Mon, 17 Nov 2025 18:53:29 +0530
X-Gm-Features: AWmQ_bluQvaWH8_O2REA37Qt8kU7_BwYoDkmsBitb89lQlFVwPjXe4jHWGgRRbQ
Message-ID: <CALkUMdQmHAoJ8dQGi9qmwOw_MbJin1oKr3rHpH8OkdfkC0XtQA@mail.gmail.com>
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
To: Florian Westphal <fw@strlen.de>
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org, 
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	anirudh.gupta@sophos.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Folorian,

How about we keep only the minimum expiry time out of all (one which
is going to expire next) and if there are listeners then we just
schedule gc_worker to that minimum time (and do this only if there are
ctnetlink listeners in userspace)? so that we don't delay even if
there is 1 such low value timer expiring in the near future.
Do you think it will cause too frequent wake ups for gc_worker?

Thanks,
Vimal


On Wed, Oct 15, 2025 at 7:02=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> avimalin@gmail.com <avimalin@gmail.com> wrote:
> > Default initial gc scan interval of 60 secs is too long for system
> > with low number of conntracks causing delay in conntrack deletion.
> > It is affecting userspace which are replying on timely arrival of
> > conntrack destroy event. So it is better that this is controlled
> > through sysctl
>
> Patch is fine.  I do wonder however if there are alternatives.
> Rather than expose the gc interval (gc worker is internal implementation
> detail, e.g. we could move back to per-ct timers theoretically).
>
> What about something like this (untested):
>
> [RFC] netfilter: conntrack: expedite evictions when userspace is subscrib=
ed to destroy events
>
> Track number of soon-to-expire conntracks.
> If enough entries are likely to expire within 1/2/4/8/16/32 second bucket=
s,
> then reschedule earlier than what the normal next value would be.
>
> Do this only when userspace is listening to destroy event notifcations
> via ctnetlink, otherwise its not relevant when a conntrack entry is
> released.
>
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
> index 210792a2275d..22274193b093 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -52,6 +52,8 @@
>  #include <net/netns/hash.h>
>  #include <net/ip.h>
>
> +#include <uapi/linux/netfilter/nfnetlink.h>
> +
>  #include "nf_internals.h"
>
>  __cacheline_aligned_in_smp spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS=
];
> @@ -63,12 +65,15 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
>  struct hlist_nulls_head *nf_conntrack_hash __read_mostly;
>  EXPORT_SYMBOL_GPL(nf_conntrack_hash);
>
> +#define GC_HORIZON_BUCKETS     6
> +
>  struct conntrack_gc_work {
>         struct delayed_work     dwork;
>         u32                     next_bucket;
>         u32                     avg_timeout;
>         u32                     count;
>         u32                     start_time;
> +       u8                      horizon_count[GC_HORIZON_BUCKETS];
>         bool                    exiting;
>         bool                    early_drop;
>  };
> @@ -96,6 +101,10 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
>  #define GC_SCAN_MAX_DURATION   msecs_to_jiffies(10)
>  #define GC_SCAN_EXPIRED_MAX    (64000u / HZ)
>
> +/* schedule worker earlier if this many entries are about to expire
> + * in the near future */
> +#define GC_SCAN_EXPEDITED      min(255, (GC_HORIZON_BUCKETS * GC_SCAN_EX=
PIRED_MAX))
> +
>  #define MIN_CHAINLEN   50u
>  #define MAX_CHAINLEN   (80u - MIN_CHAINLEN)
>
> @@ -1508,6 +1517,71 @@ static bool gc_worker_can_early_drop(const struct =
nf_conn *ct)
>         return false;
>  }
>
> +static unsigned int gc_horizon_max(unsigned int i)
> +{
> +       return (1 << i) * HZ;
> +}
> +
> +static void gc_horizon_account(struct conntrack_gc_work *gc, unsigned lo=
ng expires)
> +{
> +       int i =3D ARRAY_SIZE(gc->horizon_count);
> +
> +       BUILD_BUG_ON(GC_SCAN_EXPEDITED > 255);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(gc->horizon_count); i++) {
> +               unsigned int max =3D gc_horizon_max(i);
> +
> +               if (gc->horizon_count[i] >=3D GC_SCAN_EXPEDITED)
> +                       return;
> +
> +               if (expires <=3D max) {
> +                       gc->horizon_count[i]++;
> +                       return;
> +               }
> +       }
> +}
> +
> +static bool nf_ctnetlink_has_listeners(void)
> +{
> +       u8 v =3D READ_ONCE(nf_ctnetlink_has_listener);
> +
> +       return v & (1 << NFNLGRP_CONNTRACK_DESTROY);
> +}
> +
> +/* schedule worker early if we have ctnetlink listeners that subscribed
> + * to CONNTRACK_DESTROY events so they receive more timely notifications=
.
> + *
> + * ->horizon_count[] contains the number of conntrack entries that are
> + *  about the expire in 1, 2, 4, 8, 16 and 32 seconds.
> + */
> +static noinline unsigned long
> +gc_horizon_next_run(const struct conntrack_gc_work *gc_work,
> +                   unsigned long next_run, unsigned long delta_time)
> +{
> +       unsigned int count =3D 0;
> +       unsigned int i;
> +
> +       if (next_run <=3D (unsigned long)delta_time)
> +               return 1;
> +
> +       next_run -=3D delta_time;
> +
> +       if (!nf_ctnetlink_has_listeners())
> +               return next_run;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(gc_work->horizon_count); i++) {
> +               count +=3D gc_work->horizon_count[i];
> +
> +               if (count >=3D GC_SCAN_EXPEDITED) {
> +                       unsigned long new_next_run =3D gc_horizon_max(i);
> +
> +                       return min(new_next_run, next_run);
> +               }
> +       }
> +
> +       return next_run;
> +}
> +
>  static void gc_worker(struct work_struct *work)
>  {
>         unsigned int i, hashsz;
> @@ -1526,6 +1600,7 @@ static void gc_worker(struct work_struct *work)
>                 gc_work->avg_timeout =3D GC_SCAN_INTERVAL_INIT;
>                 gc_work->count =3D GC_SCAN_INITIAL_COUNT;
>                 gc_work->start_time =3D start_time;
> +               memset(gc_work->horizon_count, 0, sizeof(gc_work->horizon=
_count));
>         }
>
>         next_run =3D gc_work->avg_timeout;
> @@ -1575,7 +1650,11 @@ static void gc_worker(struct work_struct *work)
>                                 continue;
>                         }
>
> -                       expires =3D clamp(nf_ct_expires(tmp), GC_SCAN_INT=
ERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
> +                       expires =3D nf_ct_expires(tmp);
> +
> +                       gc_horizon_account(gc_work, expires);
> +
> +                       expires =3D clamp(expires, GC_SCAN_INTERVAL_MIN, =
GC_SCAN_INTERVAL_CLAMP);
>                         expires =3D (expires - (long)next_run) / ++count;
>                         next_run +=3D expires;
>                         net =3D nf_ct_net(tmp);
> @@ -1633,10 +1712,7 @@ static void gc_worker(struct work_struct *work)
>         next_run =3D clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERV=
AL_MAX);
>
>         delta_time =3D max_t(s32, nfct_time_stamp - gc_work->start_time, =
1);
> -       if (next_run > (unsigned long)delta_time)
> -               next_run -=3D delta_time;
> -       else
> -               next_run =3D 1;
> +       next_run =3D gc_horizon_next_run(gc_work, next_run, delta_time);
>
>  early_exit:
>         if (gc_work->exiting)
