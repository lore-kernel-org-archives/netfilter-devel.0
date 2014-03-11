From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v5] netfilter: xtables: add quota support for nfacct
Date: Tue, 11 Mar 2014 09:24:33 -0600
Message-ID: <CANLsYkwh+hgqyfH84=Lp+PN0ufV9ug0sPNPvVMfD1iUxkYGsuA@mail.gmail.com>
References: <1392740402-14952-1-git-send-email-mathieu.poirier@linaro.org>
	<20140225175410.GA25784@localhost>
	<CANLsYkw4aMQU4NM=oHdJBuPiHAagUck-eM6MEwaNGNcyoBVgYg@mail.gmail.com>
	<20140310210227.GA23426@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20140310210227.GA23426@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 10 March 2014 15:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 26, 2014 at 11:38:19AM -0700, Mathieu Poirier wrote:
>> >> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
>> >> index c7b6269..ae8ea0a 100644
>> >> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
>> >> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
>> >> @@ -19,6 +19,7 @@ enum nfnl_acct_type {
>> >>       NFACCT_PKTS,
>> >>       NFACCT_BYTES,
>> >>       NFACCT_USE,
>> >> +     NFACCT_QUOTA,
>> >
>> > This is wrong. You are using this new attribute (which defines another
>> > TLV in the payload of a message) instead of the netlink message type
>> > in nfnl_acct_fill_info(). This needs a specific message type to
>> > announce that the quota has been exceeded.
>>
>> If I understand you correctly you want a new entry in
>> "nfnl_acct_msg_types" - please confirm.
>
> Yes. There is no other way to make it.
>
> You are not adding an attribute to the payload of the netlink message
> but a new message type...

ACK

>
>> >>       __NFACCT_MAX
>> >>  };
>> >>  #define NFACCT_MAX (__NFACCT_MAX - 1)
>> >> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
>> >> index 3e19c8a..7c35ce0 100644
>> >> --- a/include/uapi/linux/netfilter/xt_nfacct.h
>> >> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
>> >> @@ -3,11 +3,27 @@
>> >>
>> >>  #include <linux/netfilter/nfnetlink_acct.h>
>> >>
>> >> +enum xt_quota_flags {
>> >> +     XT_NFACCT_QUOTA_PKTS    = 1 << 0,
>> >> +     XT_NFACCT_QUOTA         = 1 << 1,
>> >> +};
>> >> +
>> >>  struct nf_acct;
>> >> +struct nf_acct_quota;
>> >>
>> >>  struct xt_nfacct_match_info {
>> >>       char            name[NFACCT_NAME_MAX];
>> >> -     struct nf_acct  *nfacct;
>> >> +     struct nf_acct  *nfacct __aligned(8);
>> >>  };
>> >>
>> >> +struct xt_nfacct_match_info_v1 {
>> >> +     char            name[NFACCT_NAME_MAX];
>> >> +     struct nf_acct  *nfacct __aligned(8);
>> >
>> > You have to move at the bottom of the structure, before the new
>> > nf_acct_quota.
>> >
>> > The extension from userspace sets the .userspacesize field, which
>> > helps iptables to skip internal pointers that are set by the kernel,
>> > If you don't fix this, iptables -D to delete a rule with nfacct will
>> > not work.
>>
>> Thanks for pointing that out - I've been experiencing problems with
>> "iptables -D".
>
> BTW, don't change the layout of xt_nfacct_match_info, leave it as is.
> Only use struct nf_acct  *nfacct __aligned(8); in struct
> xt_nfacct_match_info_v1, OK?

Ok, but why?  There is obviously a reason and I don't understand it.

>
>> >> +static bool
>> >> +nfacct_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
>> >> +{
>> >> +     int mode;
>> >> +     u64 val;
>> >> +     const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
>> >> +     struct nf_acct_quota *acct_quota = info->priv;
>> >> +     bool ret = true;
>> >> +
>> >> +     mode = (acct_quota->flags & XT_NFACCT_QUOTA_PKTS) ?
>> >> +            NFNL_ACCT_UDT_PACKETS : NFNL_ACCT_UDT_BYTES;
>> >> +
>> >> +     /* upgrade accounting stats */
>> >> +     val = nfnl_acct_update(skb, info->nfacct, mode);
>> >> +
>> >> +     /* no need to go further if we don't have a quota */
>> >> +     if (!(acct_quota->flags & XT_NFACCT_QUOTA))
>> >> +             return ret;
>> >> +
>> >> +     /* are we over the limit ? */
>> >> +     if (val <= info->quota) {
>> >
>> > You use <=, I think this should be <. Not further below you're using >=.
>>
>> That is the intended purpose - I take the limit to be inclusive.  If
>> you have a limit of 200 packets, you want the packet that makes the
>> count go from 199 to 200 to be allowed through.  At the same time you
>> want the the notification to be sent out right away since you don't
>> know how long it will take to receive the next packet.  Get back to me
>> on that if you don't agree with my logic.
>
> OK, makes sense.
>
>> >> +             /* reset flag in case userspace cleared the counters */
>> >> +             atomic_set(&acct_quota->notified, 0)
>> >
>> > This has runtime overhead and I think it's racy.
>>
>> Good catch on the racy part.
>>
>> > I think we can avoid
>> > this if the quota object management is moved to nfnetlink_acct (see
>> > below for further explanation). The idea is to iterate over the list
>> > of quota objects (to find notified flags that need to be reset) by
>> > when NFNL_MSG_ACCT_GET_CTRZERO is called.
>> >
> [...]
>> >> +static struct  nf_acct_quota *
>> >> +nfacct_create_quota(struct xt_nfacct_match_info_v1 *info)
>> >
>> > Thinking of nftables and the reset notified flag above, I think it's
>> > better if you move the quota object management to nfnetlink_acct.c by
>> > adding new nfacct commands. The idea is to maintain a quota object
>> > base that can be used by xt_nfacct. You have to add the following
>> > commands:
>> >
>> > enum nfnl_acct_msg_types {
>> >         ...
>> >         NFNL_MSG_ACCT_QUOTA_NEW,
>> >         NFNL_MSG_ACCT_QUOTA_GET,
>> >         NFNL_MSG_ACCT_QUOTA_DEL,
>> >         NFNL_MSG_ACCT_MAX
>> > };
>> >
>> > Then, extend nfnl_callback to include this new commands. The idea is
>> > to create/delete quota objects from the netlink interface, then attach
>> > them from the iptables nfacct extension.
>> >
>> > You won't need the mutex anymore btw, since it's already protected by
>> > nfnl_lock.
>>
>> Dealing with the overhead introduced by clearing the "notified" flag
>> is completely different from the management of "quota" objects.  To do
>> this the best solution is to introduce a callback to reset the flag
>> when a "nfacct" object gets reset.  That would be simple and in line
>> with what is used ubiquitously in the kernel.
>>
>> Moving the management of "quota" objects to nfnetlink_acct is a
>> completely different ball game.  Not only that, it would also mandate
>> to make changes to nfacct, libnfnl and libnl.  It would also require
>> to pull a few tricks to make all that extra code compile conditionally
>> when XT_QUOTA is not selected, unless we want to automatically select
>> XT_QUOTA when NETLINK_ACCT gets enabled.  And what happens when
>> another quota type-of-thing comes along?  We keep stuffing "nfacct"
>> and "nfnetlink_acct.c" with more functionality?
>
> This is the most generic thing to make it.
>
> How the user will inspect if quota has been already fulfilled? And how
> will the user reset it in case it needs it? Or simply upgrade the
> quota without reloading the rule?

Since quotas are intrinsically linked to nfacct objects, the best way
to know if a quota has been reached is to look at the statistics for
the corresponding nfacct object.  Even if quota status was available
via cmdline, users would still have to parse iptables rules to know
the nfacct object the quota belongs to, unless we add that information
in the output status of quota objects along with the mode.

> You have to provide a netlink
> interface if you want to implement this in a nice way.  Otherwise, I
> bet that someone will come with yet another hackish /proc interface
> for this, no please. Or worst, people will code perl scripts to parse
> the iptables -L -n output.

We could create a sysfs entry for each quota but it doesn't scale well.

>
> Of course, it's more code to nfnetlink_acct, the libraries and the
> utility, but this will be pretty generic and we'll provide a nice
> interface.
>
> And again, thinking of nftables, if we implement the quota management
> code in nfnetlink_acct, adding support for nfacct and quota will just
> require very little code since we'll reuse most of the common
> infrastructure.
>
> I really think the quota management code belongs nfnetlink_acct, not
> xt_nfacct.

I'm not against your idea but the thought of starting over after 1)
agreeing on a design and 2) investing so much time is disappointing.
If we end up choosing your way, would you prefer enhancing the nfacct
tool with quota capabilities or adding something like "nfquota"?
Personally I would prefer the latter as it scales better.

>
>> To me introducing a callback for each of the operation supported by
>> "nfnl_acct_cb" is the way to go.  It would allow any future extension
>> so take action whenever something happens to an "nfacct" object.
>>
>> I'll continue thinking about this but take my proposal into account
>> and get back to me.
>>
>> >
>> >> +{
>> >> +     struct nf_acct_quota *acct_quota;
>> >> +
>> >> +     mutex_lock(&nfacct_list_mutex);
>> >> +
>> >> +     acct_quota = kmalloc(sizeof(struct nf_acct_quota), GFP_ATOMIC);
>> >> +
>> >
>> > remove empty line above.
>> >
>> >> +     if (!acct_quota) {
>> >> +             mutex_unlock(&nfacct_list_mutex);
>> >> +             return NULL;
>> >> +     }
>> >> +
>> >> +     strncpy(acct_quota->name, info->name, NFACCT_NAME_MAX);
>> >> +     acct_quota->flags = info->flags;
>> >> +     acct_quota->quota = info->quota;
>> >> +     acct_quota->count = 1;
>> >> +     atomic_set(&acct_quota->notified, 0);
>> >> +     list_add_tail(&acct_quota->node, &nfacct_list);
>> >
>> > This needs to be converted to _rcu.
>>
>> You mean in the context that we move forward with your suggestion?
>
> Right.
