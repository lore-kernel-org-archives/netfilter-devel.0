From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v5] netfilter: xtables: add quota support for nfacct
Date: Mon, 10 Mar 2014 14:14:04 -0600
Message-ID: <CANLsYkwiMJAhqnYk_po9JbDf2VMvkcz8+RNqQAKkV488CF+U6w@mail.gmail.com>
References: <1392740402-14952-1-git-send-email-mathieu.poirier@linaro.org>
	<20140225175410.GA25784@localhost>
	<CANLsYkw4aMQU4NM=oHdJBuPiHAagUck-eM6MEwaNGNcyoBVgYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CANLsYkw4aMQU4NM=oHdJBuPiHAagUck-eM6MEwaNGNcyoBVgYg@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I haven't heard back on this for 12 full days - is there anything
you'd like me to clarify?  If you are busy can you at least provide me
with a date by which I should expect an answer?

Mathieu

On 26 February 2014 11:38, Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> On 25 February 2014 10:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Hi Mathieu,
>>
>> This is looking better, but still more comments to address, see below.
>>
>> On Tue, Feb 18, 2014 at 09:20:02AM -0700, mathieu.poirier@linaro.org wrote:
>>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>>
>>> Adding packet and byte quota support.  Once a quota has been
>>> reached a noticifaction is sent to user space that includes
>>> the name of the accounting object along with the current byte
>>> and packet count.
>>>
>>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>>> ---
>>> Changes for v5:
>>> - Removed spinlock from 'nfnl_acct_update'.
>>> - Added accounting object store.
>>> ---
>>>  include/linux/netfilter/nfnetlink_acct.h      |  17 ++-
>>>  include/uapi/linux/netfilter/nfnetlink.h      |   2 +
>>>  include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
>>>  include/uapi/linux/netfilter/xt_nfacct.h      |  18 ++-
>>>  net/netfilter/Kconfig                         |   3 +-
>>>  net/netfilter/nfnetlink_acct.c                |  46 +++++--
>>>  net/netfilter/xt_nfacct.c                     | 179 ++++++++++++++++++++++++--
>>>  7 files changed, 238 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
>>> index b2e85e5..bb04204 100644
>>> --- a/include/linux/netfilter/nfnetlink_acct.h
>>> +++ b/include/linux/netfilter/nfnetlink_acct.h
>>> @@ -3,11 +3,24 @@
>>>
>>>  #include <uapi/linux/netfilter/nfnetlink_acct.h>
>>>
>>> +struct nf_acct {
>>> +     atomic64_t              pkts;
>>> +     atomic64_t              bytes;
>>> +     struct list_head        head;
>>> +     atomic_t                refcnt;
>>> +     char                    name[NFACCT_NAME_MAX];
>>> +     struct rcu_head         rcu_head;
>>> +};
>>>
>>> -struct nf_acct;
>>> +enum nfnl_acct_udt_type {
>>> +     NFNL_ACCT_UDT_PACKETS,
>>> +     NFNL_ACCT_UDT_BYTES,
>>> +};
>>
>> I prefer some like this instead of the one above:
>>
>> enum nfacct_quota_type {
>>         NFACCT_QUOTA_PACKETS = 0,
>>         NFACCT_QUOTA_BYTES
>> };
>>
>>>  struct nf_acct *nfnl_acct_find_get(const char *filter_name);
>>>  void nfnl_acct_put(struct nf_acct *acct);
>>> -void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
>>> +extern u64 nfnl_acct_update(const struct sk_buff *skb,
>>> +                        struct nf_acct *nfacct, int mode);
>>> +void nfnl_quota_event(struct nf_acct *cur);
>>>
>>>  #endif /* _NFNL_ACCT_H */
>>> diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
>>> index 596ddd4..354a7e5 100644
>>> --- a/include/uapi/linux/netfilter/nfnetlink.h
>>> +++ b/include/uapi/linux/netfilter/nfnetlink.h
>>> @@ -20,6 +20,8 @@ enum nfnetlink_groups {
>>>  #define NFNLGRP_CONNTRACK_EXP_DESTROY        NFNLGRP_CONNTRACK_EXP_DESTROY
>>>       NFNLGRP_NFTABLES,
>>>  #define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
>>> +     NFNLGRP_ACCT_QUOTA,
>>> +#define NFNLGRP_ACCT_QUOTA           NFNLGRP_ACCT_QUOTA
>>>       __NFNLGRP_MAX,
>>>  };
>>>  #define NFNLGRP_MAX  (__NFNLGRP_MAX - 1)
>>> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
>>> index c7b6269..ae8ea0a 100644
>>> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
>>> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
>>> @@ -19,6 +19,7 @@ enum nfnl_acct_type {
>>>       NFACCT_PKTS,
>>>       NFACCT_BYTES,
>>>       NFACCT_USE,
>>> +     NFACCT_QUOTA,
>>
>> This is wrong. You are using this new attribute (which defines another
>> TLV in the payload of a message) instead of the netlink message type
>> in nfnl_acct_fill_info(). This needs a specific message type to
>> announce that the quota has been exceeded.
>
> If I understand you correctly you want a new entry in
> "nfnl_acct_msg_types" - please confirm.
>
>>
>>>       __NFACCT_MAX
>>>  };
>>>  #define NFACCT_MAX (__NFACCT_MAX - 1)
>>> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
>>> index 3e19c8a..7c35ce0 100644
>>> --- a/include/uapi/linux/netfilter/xt_nfacct.h
>>> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
>>> @@ -3,11 +3,27 @@
>>>
>>>  #include <linux/netfilter/nfnetlink_acct.h>
>>>
>>> +enum xt_quota_flags {
>>> +     XT_NFACCT_QUOTA_PKTS    = 1 << 0,
>>> +     XT_NFACCT_QUOTA         = 1 << 1,
>>> +};
>>> +
>>>  struct nf_acct;
>>> +struct nf_acct_quota;
>>>
>>>  struct xt_nfacct_match_info {
>>>       char            name[NFACCT_NAME_MAX];
>>> -     struct nf_acct  *nfacct;
>>> +     struct nf_acct  *nfacct __aligned(8);
>>>  };
>>>
>>> +struct xt_nfacct_match_info_v1 {
>>> +     char            name[NFACCT_NAME_MAX];
>>> +     struct nf_acct  *nfacct __aligned(8);
>>
>> You have to move at the bottom of the structure, before the new
>> nf_acct_quota.
>>
>> The extension from userspace sets the .userspacesize field, which
>> helps iptables to skip internal pointers that are set by the kernel,
>> If you don't fix this, iptables -D to delete a rule with nfacct will
>> not work.
>
> Thanks for pointing that out - I've been experiencing problems with
> "iptables -D".
>
>>
>>> +     __u32 flags;
>>> +     __aligned_u64 quota;
>>> +
>>> +     /* used internally by kernel */
>>> +     struct nf_acct_quota *priv __aligned(8);
>>> +};
>>>  #endif /* _XT_NFACCT_MATCH_H */
>>> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>>> index 748f304..ce184951 100644
>>> --- a/net/netfilter/Kconfig
>>> +++ b/net/netfilter/Kconfig
>>> @@ -1108,7 +1108,8 @@ config NETFILTER_XT_MATCH_NFACCT
>>>       select NETFILTER_NETLINK_ACCT
>>>       help
>>>         This option allows you to use the extended accounting through
>>> -       nfnetlink_acct.
>>> +       nfnetlink_acct.  It is also possible to add quotas at the
>>> +       packet and byte level.
>>>
>>>         To compile it as a module, choose M here.  If unsure, say N.
>>>
>>> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
>>> index c7b6d46..5c580a7 100644
>>> --- a/net/netfilter/nfnetlink_acct.c
>>> +++ b/net/netfilter/nfnetlink_acct.c
>>> @@ -29,15 +29,6 @@ MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastructure");
>>>
>>>  static LIST_HEAD(nfnl_acct_list);
>>>
>>> -struct nf_acct {
>>> -     atomic64_t              pkts;
>>> -     atomic64_t              bytes;
>>> -     struct list_head        head;
>>> -     atomic_t                refcnt;
>>> -     char                    name[NFACCT_NAME_MAX];
>>> -     struct rcu_head         rcu_head;
>>> -};
>>> -
>>>  static int
>>>  nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>>>            const struct nlmsghdr *nlh, const struct nlattr * const tb[])
>>> @@ -92,7 +83,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>>>       return 0;
>>>  }
>>>
>>> -static int
>>> +int
>>>  nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>>>                  int event, struct nf_acct *acct)
>>>  {
>>> @@ -134,6 +125,7 @@ nla_put_failure:
>>>       nlmsg_cancel(skb, nlh);
>>>       return -1;
>>>  }
>>> +EXPORT_SYMBOL_GPL(nfnl_acct_fill_info);
>>
>> I think you don't need to export this symbol.
>>
>>>  static int
>>>  nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>> @@ -329,13 +321,41 @@ void nfnl_acct_put(struct nf_acct *acct)
>>>  }
>>>  EXPORT_SYMBOL_GPL(nfnl_acct_put);
>>>
>>> -void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
>>> +u64 nfnl_acct_update(const struct sk_buff *skb,
>>> +                 struct nf_acct *nfacct, int mode)
>>>  {
>>> -     atomic64_inc(&nfacct->pkts);
>>> -     atomic64_add(skb->len, &nfacct->bytes);
>>> +     u64 pkts, bytes;
>>> +
>>> +     pkts = atomic64_inc_return(&nfacct->pkts);
>>> +     bytes = atomic64_add_return(skb->len, &nfacct->bytes);
>>> +
>>> +     return (mode == NFNL_ACCT_UDT_PACKETS) ? pkts : bytes;
>>>  }
>>>  EXPORT_SYMBOL_GPL(nfnl_acct_update);
>>>
>>> +void
>>> +nfnl_quota_event(struct nf_acct *cur)
>>> +{
>>> +     int ret;
>>> +     struct sk_buff *skb;
>>> +
>>> +     skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
>>> +     if (skb == NULL)
>>> +             return;
>>> +
>>> +     ret = nfnl_acct_fill_info(skb, 0, 0, NFACCT_QUOTA,
>>> +                              NFNL_MSG_ACCT_NEW, cur);
>>> +
>>
>> Remove empty line above.
>>
>>> +     if (ret <= 0) {
>>> +             kfree_skb(skb);
>>> +             return;
>>> +     }
>>> +
>>> +     netlink_broadcast(init_net.nfnl, skb, 0,
>>> +                      NFNLGRP_ACCT_QUOTA, GFP_ATOMIC);
>>> +}
>>> +EXPORT_SYMBOL_GPL(nfnl_quota_event);
>>> +
>>>  static int __init nfnl_acct_init(void)
>>>  {
>>>       int ret;
>>> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
>>> index b3be0ef..d1bd5ea 100644
>>> --- a/net/netfilter/xt_nfacct.c
>>> +++ b/net/netfilter/xt_nfacct.c
>>> @@ -9,8 +9,10 @@
>>>  #include <linux/module.h>
>>>  #include <linux/skbuff.h>
>>>
>>> +#include <net/netlink.h>
>>>  #include <linux/netfilter/x_tables.h>
>>>  #include <linux/netfilter/nfnetlink_acct.h>
>>> +#include <linux/netfilter/nfnetlink.h>
>>>  #include <linux/netfilter/xt_nfacct.h>
>>>
>>>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>>> @@ -19,15 +21,62 @@ MODULE_LICENSE("GPL");
>>>  MODULE_ALIAS("ipt_nfacct");
>>>  MODULE_ALIAS("ip6t_nfacct");
>>>
>>> +static LIST_HEAD(nfacct_list);
>>> +static DEFINE_MUTEX(nfacct_list_mutex);
>>> +
>>> +struct nf_acct_quota {
>>> +     char                    name[NFACCT_NAME_MAX];
>>> +     int                     count;
>>> +     u32                     flags;
>>> +     u64                     quota;
>>> +     struct list_head        node;
>>> +     atomic_t                notified;
>>> +};
>>> +
>>>  static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>>  {
>>>       const struct xt_nfacct_match_info *info = par->targinfo;
>>> +     u64 __always_unused val;
>>> -     nfnl_acct_update(skb, info->nfacct);
>>> +     val = nfnl_acct_update(skb, info->nfacct, 0);
>>
>> I think you can just do:
>>
>>         nfnl_acct_update(skb, info->nfacct...);
>>
>> and ignore the returned value in this case.
>>
>>>       return true;
>>>  }
>>>
>>> +static bool
>>> +nfacct_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
>>> +{
>>> +     int mode;
>>> +     u64 val;
>>> +     const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
>>> +     struct nf_acct_quota *acct_quota = info->priv;
>>> +     bool ret = true;
>>> +
>>> +     mode = (acct_quota->flags & XT_NFACCT_QUOTA_PKTS) ?
>>> +            NFNL_ACCT_UDT_PACKETS : NFNL_ACCT_UDT_BYTES;
>>> +
>>> +     /* upgrade accounting stats */
>>> +     val = nfnl_acct_update(skb, info->nfacct, mode);
>>> +
>>> +     /* no need to go further if we don't have a quota */
>>> +     if (!(acct_quota->flags & XT_NFACCT_QUOTA))
>>> +             return ret;
>>> +
>>> +     /* are we over the limit ? */
>>> +     if (val <= info->quota) {
>>
>> You use <=, I think this should be <. Not further below you're using >=.
>
> That is the intended purpose - I take the limit to be inclusive.  If
> you have a limit of 200 packets, you want the packet that makes the
> count go from 199 to 200 to be allowed through.  At the same time you
> want the the notification to be sent out right away since you don't
> know how long it will take to receive the next packet.  Get back to me
> on that if you don't agree with my logic.
>
>>
>>> +             /* reset flag in case userspace cleared the counters */
>>> +             atomic_set(&acct_quota->notified, 0)
>>
>> This has runtime overhead and I think it's racy.
>
> Good catch on the racy part.
>
>  I think we can avoid
>> this if the quota object management is moved to nfnetlink_acct (see
>> below for further explanation). The idea is to iterate over the list
>> of quota objects (to find notified flags that need to be reset) by
>> when NFNL_MSG_ACCT_GET_CTRZERO is called.
>>
>>> +             ret = !ret;
>>> +     }
>>> +
>>> +     if (val >= info->quota)
>>
>> You have to use brackets here:
>>
>>         if (...) {
>>                 ...
>>         }
>>
>>> +             /* cmpxchg guarantees only one CPU can send a notification */
>>> +             if (atomic_cmpxchg(&acct_quota->notified, 0, 1) == 0)
>>> +                     nfnl_quota_event(info->nfacct);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>>  static int
>>>  nfacct_mt_checkentry(const struct xt_mtchk_param *par)
>>>  {
>>> @@ -44,32 +93,140 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
>>>       return 0;
>>>  }
>>>
>>> +static
>>> +struct nf_acct_quota *nfacct_find_quota(char *name)
>>> +{
>>> +     struct nf_acct_quota *curr, *match = NULL;
>>> +
>>> +     mutex_lock(&nfacct_list_mutex);
>>> +     list_for_each_entry(curr, &nfacct_list, node)
>>
>> missing brackets here in list_for_each_entry too.
>>
>>> +             if (strncmp(curr->name, name, NFACCT_NAME_MAX) == 0) {
>>> +                     match = curr;
>>> +                     match->count++;
>>> +                     break;
>>> +             }
>>> +
>>> +     mutex_unlock(&nfacct_list_mutex);
>>> +
>>> +     return match;
>>> +}
>>> +
>>> +static struct  nf_acct_quota *
>>> +nfacct_create_quota(struct xt_nfacct_match_info_v1 *info)
>>
>> Thinking of nftables and the reset notified flag above, I think it's
>> better if you move the quota object management to nfnetlink_acct.c by
>> adding new nfacct commands. The idea is to maintain a quota object
>> base that can be used by xt_nfacct. You have to add the following
>> commands:
>>
>> enum nfnl_acct_msg_types {
>>         ...
>>         NFNL_MSG_ACCT_QUOTA_NEW,
>>         NFNL_MSG_ACCT_QUOTA_GET,
>>         NFNL_MSG_ACCT_QUOTA_DEL,
>>         NFNL_MSG_ACCT_MAX
>> };
>>
>> Then, extend nfnl_callback to include this new commands. The idea is
>> to create/delete quota objects from the netlink interface, then attach
>> them from the iptables nfacct extension.
>>
>> You won't need the mutex anymore btw, since it's already protected by
>> nfnl_lock.
>
> Dealing with the overhead introduced by clearing the "notified" flag
> is completely different from the management of "quota" objects.  To do
> this the best solution is to introduce a callback to reset the flag
> when a "nfacct" object gets reset.  That would be simple and in line
> with what is used ubiquitously in the kernel.
>
> Moving the management of "quota" objects to nfnetlink_acct is a
> completely different ball game.  Not only that, it would also mandate
> to make changes to nfacct, libnfnl and libnl.  It would also require
> to pull a few tricks to make all that extra code compile conditionally
> when XT_QUOTA is not selected, unless we want to automatically select
> XT_QUOTA when NETLINK_ACCT gets enabled.  And what happens when
> another quota type-of-thing comes along?  We keep stuffing "nfacct"
> and "nfnetlink_acct.c" with more functionality?
>
> To me introducing a callback for each of the operation supported by
> "nfnl_acct_cb" is the way to go.  It would allow any future extension
> so take action whenever something happens to an "nfacct" object.
>
> I'll continue thinking about this but take my proposal into account
> and get back to me.
>
>>
>>> +{
>>> +     struct nf_acct_quota *acct_quota;
>>> +
>>> +     mutex_lock(&nfacct_list_mutex);
>>> +
>>> +     acct_quota = kmalloc(sizeof(struct nf_acct_quota), GFP_ATOMIC);
>>> +
>>
>> remove empty line above.
>>
>>> +     if (!acct_quota) {
>>> +             mutex_unlock(&nfacct_list_mutex);
>>> +             return NULL;
>>> +     }
>>> +
>>> +     strncpy(acct_quota->name, info->name, NFACCT_NAME_MAX);
>>> +     acct_quota->flags = info->flags;
>>> +     acct_quota->quota = info->quota;
>>> +     acct_quota->count = 1;
>>> +     atomic_set(&acct_quota->notified, 0);
>>> +     list_add_tail(&acct_quota->node, &nfacct_list);
>>
>> This needs to be converted to _rcu.
>
> You mean in the context that we move forward with your suggestion?
