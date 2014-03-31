From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RFC PATCH 2/2] netfilter: xt_nfacct: Add quota to nfacct filter
Date: Mon, 31 Mar 2014 07:50:06 -0600
Message-ID: <CANLsYky5ciqKEP7oNuP1bEdX3iARKHtDgv=87j8dFXjTCt255Q@mail.gmail.com>
References: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
	<1396213844-10528-3-git-send-email-mathieu.poirier@linaro.org>
	<20140331121351.GA3866@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20140331121351.GA3866@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 31 March 2014 06:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Mar 30, 2014 at 03:10:44PM -0600, mathieu.poirier@linaro.org wrote:
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> Fixing quota management in accounting framework, most notably:
>> - Clearing overquota bit in 'nfnl_acct_fill_info' when userspace
>> resets accounting statistics.
>> - Decoupling quota attainment verification and message dispatch
>> in 'nfnl_acct_overquota'.
>
> Please, merge this to 1/2. I don't really mind about the one showing
> up as author in the patch. You can add in the commit log that this
> patch is a joint work between you and me so I'm also credited for the
> changes.

Very well.

>
> Another comment below.
>
>> With the above adding quota limits to xt_nfacct is trival.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>  include/linux/netfilter/nfnetlink_acct.h |  3 ++-
>>  net/netfilter/nfnetlink_acct.c           | 36 ++++++++++++++++++++++----------
>>  net/netfilter/xt_nfacct.c                | 13 ++++++++++++
>>  3 files changed, 40 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
>> index b2e85e5..cfc210d 100644
>> --- a/include/linux/netfilter/nfnetlink_acct.h
>> +++ b/include/linux/netfilter/nfnetlink_acct.h
>> @@ -9,5 +9,6 @@ struct nf_acct;
>>  struct nf_acct *nfnl_acct_find_get(const char *filter_name);
>>  void nfnl_acct_put(struct nf_acct *acct);
>>  void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
>> -
>> +extern bool nfnl_acct_overquota(const struct sk_buff *skb,
>> +                             struct nf_acct *nfacct);
>>  #endif /* _NFNL_ACCT_H */
>> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
>> index 25afecf..e0b5147 100644
>> --- a/net/netfilter/nfnetlink_acct.c
>> +++ b/net/netfilter/nfnetlink_acct.c
>> @@ -147,6 +147,10 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>>       if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
>>               pkts = atomic64_xchg(&acct->pkts, 0);
>>               bytes = atomic64_xchg(&acct->bytes, 0);
>> +             if (acct->flags & NFACCT_F_QUOTA) {
>> +                     smp_mb__before_clear_bit();
>> +                     clear_bit(NFACCT_F_OVERQUOTA, &acct->flags);
>> +             }
>>       } else {
>>               pkts = atomic64_read(&acct->pkts);
>>               bytes = atomic64_read(&acct->bytes);
>> @@ -393,23 +397,33 @@ static void nfnl_overquota_report(struct nf_acct *nfacct)
>>                         GFP_ATOMIC);
>>  }
>>
>> +/* Check 'skb' statistics against accounting object 'nfacct'.  Quotas limits
>> + * are considered inclusive.  A message is sent to userspace if at or above
>> + * a quota.
>> + *
>> + * Returns -EINVAL if nfacct object doesn't have a quota, true if above quota
>> + * and false is below or at quota.
>> + */
>>  bool nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
>>  {
>> +     u64 now;
>>       u64 *quota;
>>       bool ret = false;
>>
>> -     if (nfacct->flags & NFACCT_F_QUOTA_PKTS) {
>> -             quota = (u64 *)nfacct->data;
>> -             ret = atomic64_read(&nfacct->pkts) >= *quota &&
>> -                   !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
>> -     }
>> -     if (nfacct->flags & NFACCT_F_QUOTA_BYTES) {
>> -             quota = (u64 *)nfacct->data;
>> -             ret = atomic64_read(&nfacct->bytes) >= *quota &&
>> -                   !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
>> -     }
>> -     if (ret)
>> +     /* no place here if we don't have a quota */
>> +     if (!(nfacct->flags & NFACCT_F_QUOTA))
>> +             return -EINVAL;
>
> This function returns boolean, we have to change it. You can probably
> use this return values:
>
> -1 no quota
> 0 underquota
> 1 overquota

Ok.

>
> You can just define some enum, ie.
>
> enum {
>         NFACCT_NO_QUOTA         = -1,
>         NFACCT_UNDERQUOTA,
>         NFACCT_OVERQUOTA,
> };
>
> to include/linux/netfilter/nfnetlink_acct.h.
>
> I guess with that we can also remove the comments everywhere, as it
> will be quite clear with the enums.
>
> Merge window will be close soon, please also post the userspace
> changes for the library and the utility asap.

At this time I only have the userspace modifications in the nfacct
port I did for Android.  That one links to libnl2.0 and won't be of
interest to you.  I can get you the kernel work in time for the merge
window but modifications to the "real" nfacct may not make it.  I'd
love to see the work going in the 3.15 merge window but can't offer
guarantees.

Would you consider queuing the kernel patch in the merge window
without the userspace?  Note that I would understand if you woudn't
accept that....

>
> Thanks.
>
>> +
>> +     quota = (u64 *)nfacct->data;
>> +     now = (nfacct->flags & NFACCT_F_QUOTA_PKTS) ?
>> +            atomic64_read(&nfacct->pkts) : atomic64_read(&nfacct->bytes);
>> +
>> +     ret = now > *quota;
>> +
>> +     if (now >= *quota &&
>> +         !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags)) {
>>               nfnl_overquota_report(nfacct);
>> +     }
>>
>>       return ret;
>>  }
>> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
>> index b3be0ef..bbe1491 100644
>> --- a/net/netfilter/xt_nfacct.c
>> +++ b/net/netfilter/xt_nfacct.c
>> @@ -21,10 +21,23 @@ MODULE_ALIAS("ip6t_nfacct");
>>
>>  static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>  {
>> +     bool overquota;
>>       const struct xt_nfacct_match_info *info = par->targinfo;
>>
>>       nfnl_acct_update(skb, info->nfacct);
>>
>> +     overquota = nfnl_acct_overquota(skb, info->nfacct);
>> +
>> +     /* The only time packets are allowed through is when:
>> +      * 1) A quota has been specivied.
>> +      * 2) That quota hasn't been reached yet.
>> +      */
>> +     if (overquota == false)
>> +             return false;
>> +
>> +      /* Return true if a quota hasn't been specified or if
>> +       * quota has been attained.
>> +       */
>>       return true;
>>  }
>>
>> --
>> 1.8.3.2
>>
