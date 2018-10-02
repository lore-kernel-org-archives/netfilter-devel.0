From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 01:24:29 -0700
Message-ID: <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com> <20181002075903.3wpgej3j6dttbqck@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Maciej Zenczykowski <maze@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181002075903.3wpgej3j6dttbqck@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> A few questions, see below.
>
> First one is, don't we need a new match revision for this new option?

We were very careful to do this in a way that doesn't need a new revision.

That's what basically dictates most of the design.

If we bump the revision then you don't get fixed semantics unless
you update both kernel and userspace iptables versions... and additionally
we basically end up with two copies of xt_quota in the kernel source since
there's pretty much nothing that can be shared between the two.

> So 1 means, don't keep updating, quota is depleted?

The counter is always 1 higher then the remaining quota.
So 1 means 0.
And 0 means uninitialized and is only present on input from userspace.

> This current_count =3D 1 would be exposed to userspace too, right?
>
> Hm, this semantics are going to be a bit awkwards to users I think, I
> would prefer to expose this in a different way.

New userspace iptables hides this from users by adding/decrementing by
one as needed on ingress/egress from kernel.
Old iptables never looks at this field.

>> +             if (current_count <=3D skb->len) {
>> +                     atomic64_set(&q->counter, 1);
>> +                     return ret;
>> +             }
>> +             old_count =3D current_count;
>> +             new_count =3D current_count - skb->len;
>> +             current_count =3D atomic64_cmpxchg(&q->counter, old_count,
>> +                                              new_count);
>> +     } while (current_count !=3D old_count);
>
> Probably we simplify this via atomic64_add_return()?

Unfortunately that doesn't work because it's racy if current value is
2 and two (or three) threads both add -1 you end up at zero (or even
+lots).

> I guess problem is userspace may get a current counter that is larger
> than the quota, but we could handle this from userspace iptables to
> print a value that equals the quota, ie. from userspace, before
> printing:

I'm not sure what you mean.

>
>         if (consumed > quota)
>                 printf("--consumed %PRIu64 ", quota);
>         else
>                 printf("--consumed %PRIu64 ", consumed);
>
>> +     return !ret;
>>  }
>
> Thanks !

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
