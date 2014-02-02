From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH RESEND v3] netfilter: xtables: add quota support to nfacct
Date: Sun, 2 Feb 2014 10:58:19 -0700
Message-ID: <CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
References: <1391292671-26466-1-git-send-email-mathieu.poirier@linaro.org>
	<20140201225726.GF776@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20140201225726.GF776@breakpoint.cc>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 1 February 2014 15:57, Florian Westphal <fw@strlen.de> wrote:
> mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> wrote:
>> +struct xt_nfacct_match_info_v1 {
>> +     char            name[NFACCT_NAME_MAX];
>> +     struct nf_acct  *nfacct;
>> +
>> +     __u32 flags;
>> +     __aligned_u64 quota;
>> +     /* used internally by kernel */
>> +     struct nf_acct_quota    *priv __attribute__((aligned(8)));
>> +};
>
> I think *nfacct pointer is also kernel internal, so it should also get
> aligned (might also be possible to stash it in *private struct).

I suspect Pablo didn't change it already for a good reason and as such
reluctant to do the modification myself.

>
>> +     if (info->flags & XT_NFACCT_QUOTA) {
>> +             spin_lock_bh(&info->priv->lock);
>> +             val = (info->flags & XT_NFACCT_QUOTA_PKTS) ?
>> +                             atomic64_read(&info->nfacct->pkts) :
>> +                             atomic64_read(&info->nfacct->bytes);
>> +             if (val <= info->quota) {
>> +                     ret = !ret;
>> +                     info->priv->quota_reached = false;
>
> Why quota_reached = false
> assignment?

An object that has reached it's quota can always be reset from the
userspace with:

$ nfacct get object_name reset

As such we need to reset the flag so that a broadcast isn't sent.

>
> [ How is this toggled (other than transition to 'true' below)? ]
>
>> +             if (val >= info->quota && !info->priv->quota_reached) {
>> +                     info->priv->quota_reached = true;
>> +                     nfnl_quota_event(info->nfacct);
>> +             }
>> +
>> +             spin_unlock_bh(&info->priv->lock);
>> +     }
>
> Hm.  Not sure why the lock has to be hold during all tests.  What about:

Here "info" is an object seen and shared by all processors.  If a
process looses the CPU between the two atomic64_read, other CPUs in
the system can grab "info" and go through the same code, leading to an
erroneous count of byte and packets.

To me the real problem is with the incrementation of "pkts" and
"bytes" in function "nfnl_acct_update" - there is simply no way to
prevent a process from loosing the CPU between the two incrementation.
 I've been assured this can't happen on the INPUT and FORWARD path but
still waiting an answer on my scenario for the OUTPUT path.  If it
wasn't for that I think there is a way to remove the utilisation of
the spinlock.

>
> if (info->flags & XT_NFACCT_QUOTA) {
>                 val = (info->flags & XT_NFACCT_QUOTA_PKTS) ?
>                                 atomic64_read(&info->nfacct->pkts) :
>                                 atomic64_read(&info->nfacct->bytes);
>                 /* normal case: quota not reached */
>                 if (val <= info->quota)
>                         return !ret;
>
>                 /* other case: quota reached AND event sent */
>                 if (info->priv->quota_reached)
>                        return ret;
>
>                 spin_lock_bh(&info->priv->lock);
>
>                 if (!info->priv->quota_reached) {
>                         info->priv->quota_reached = true;
>                         nfnl_quota_event(info->nfacct);
>                 }
>
>                 spin_unlock_bh(&info->priv->lock);
>
> [ could also cmpxchg instead of spinlock ]
>
> Other than that this looks good to me.
