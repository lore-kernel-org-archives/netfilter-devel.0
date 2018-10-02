From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 12:11:19 +0200
Message-ID: <20181002101119.tyljwzqpdj7qoe6f@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia>
 <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>,
        Maciej Zenczykowski <maze@google.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Maciej!

On Tue, Oct 02, 2018 at 01:24:29AM -0700, Maciej Żenczykowski wrote:
> > A few questions, see below.
> >
> > First one is, don't we need a new match revision for this new option?
> 
> We were very careful to do this in a way that doesn't need a new revision.
> 
> That's what basically dictates most of the design.
> 
> If we bump the revision then you don't get fixed semantics unless
> you update both kernel and userspace iptables versions...

Well, you will need a kernel + userspace update anyway, right?

> and additionally we basically end up with two copies of xt_quota in
> the kernel source since there's pretty much nothing that can be
> shared between the two.

OK. Well, there is still one downside though from user perspective: A
user with new iptables userspace that supports --remain and old kernel
will not get this to work, since this option will be silently accepted
by the kernel, but it will be simply ignored.

I agree having revision infrastructure is limited and results in more
duplicated code, but this is what we have in iptables.

> > So 1 means, don't keep updating, quota is depleted?
> 
> The counter is always 1 higher then the remaining quota.
> So 1 means 0.
> And 0 means uninitialized and is only present on input from userspace.

OK.

> > This current_count = 1 would be exposed to userspace too, right?
> >
> > Hm, this semantics are going to be a bit awkwards to users I think, I
> > would prefer to expose this in a different way.
> 
> New userspace iptables hides this from users by adding/decrementing by
> one as needed on ingress/egress from kernel.
> Old iptables never looks at this field.

I see, indeed.

> >> +             if (current_count <= skb->len) {
> >> +                     atomic64_set(&q->counter, 1);
> >> +                     return ret;
> >> +             }
> >> +             old_count = current_count;
> >> +             new_count = current_count - skb->len;
> >> +             current_count = atomic64_cmpxchg(&q->counter, old_count,
> >> +                                              new_count);
> >> +     } while (current_count != old_count);
> >
> > Probably we simplify this via atomic64_add_return()?
> 
> Unfortunately that doesn't work because it's racy if current value is
> 2 and two (or three) threads both add -1 you end up at zero (or even
> +lots).

Hm, not sure what you mean with adding -1. I mean replacing all this
code above with something like:

        ret = (atomic64_add_return(skb->len, &consumed) >= quota) ^ XT_QUOTA_INVERT;

But I might be missing anything from your response on why this is
racy.

> > I guess problem is userspace may get a current counter that is larger
> > than the quota, but we could handle this from userspace iptables to
> > print a value that equals the quota, ie. from userspace, before
> > printing:
> 
> I'm not sure what you mean.

I mean: Instead of using atomic64_set() to set the counter to 1 once
we went over quota,

Please, don't get this as some sort of push back / I'm saying no to
this as it is.

I just would like we are aware of possible downsides with this
approach. Having said this, I'll take it as is if you insist that this
is the right approach :-)

Thanks !
