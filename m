From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v5] netfilter: xtables: add quota support for nfacct
Date: Wed, 12 Mar 2014 08:18:32 -0600
Message-ID: <CANLsYkzP0pGM7MyLLii+jcihgGz8N_OBuuTf=-F=iqV3aDR0KA@mail.gmail.com>
References: <1392740402-14952-1-git-send-email-mathieu.poirier@linaro.org>
	<20140225175410.GA25784@localhost>
	<CANLsYkw4aMQU4NM=oHdJBuPiHAagUck-eM6MEwaNGNcyoBVgYg@mail.gmail.com>
	<20140310210227.GA23426@localhost>
	<CANLsYkwh+hgqyfH84=Lp+PN0ufV9ug0sPNPvVMfD1iUxkYGsuA@mail.gmail.com>
	<20140312121204.GA5049@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20140312121204.GA5049@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 12 March 2014 06:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 11, 2014 at 09:24:33AM -0600, Mathieu Poirier wrote:
>> >> >>       __NFACCT_MAX
>> >> >>  };
>> >> >>  #define NFACCT_MAX (__NFACCT_MAX - 1)
>> >> >> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
>> >> >> index 3e19c8a..7c35ce0 100644
>> >> >> --- a/include/uapi/linux/netfilter/xt_nfacct.h
>> >> >> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
>> >> >> @@ -3,11 +3,27 @@
>> >> >>
>> >> >>  #include <linux/netfilter/nfnetlink_acct.h>
>> >> >>
>> >> >> +enum xt_quota_flags {
>> >> >> +     XT_NFACCT_QUOTA_PKTS    = 1 << 0,
>> >> >> +     XT_NFACCT_QUOTA         = 1 << 1,
>> >> >> +};
>> >> >> +
>> >> >>  struct nf_acct;
>> >> >> +struct nf_acct_quota;
>> >> >>
>> >> >>  struct xt_nfacct_match_info {
>> >> >>       char            name[NFACCT_NAME_MAX];
>> >> >> -     struct nf_acct  *nfacct;
>> >> >> +     struct nf_acct  *nfacct __aligned(8);
>> >> >>  };
>> >> >>
>> >> >> +struct xt_nfacct_match_info_v1 {
>> >> >> +     char            name[NFACCT_NAME_MAX];
>> >> >> +     struct nf_acct  *nfacct __aligned(8);
>> >> >
>> >> > You have to move at the bottom of the structure, before the new
>> >> > nf_acct_quota.
>> >> >
>> >> > The extension from userspace sets the .userspacesize field, which
>> >> > helps iptables to skip internal pointers that are set by the kernel,
>> >> > If you don't fix this, iptables -D to delete a rule with nfacct will
>> >> > not work.
>> >>
>> >> Thanks for pointing that out - I've been experiencing problems with
>> >> "iptables -D".
>> >
>> > BTW, don't change the layout of xt_nfacct_match_info, leave it as is.
>> > Only use struct nf_acct  *nfacct __aligned(8); in struct
>> > xt_nfacct_match_info_v1, OK?
>>
>> Ok, but why?  There is obviously a reason and I don't understand it.
>
> If you change it, you're breaking the binary interface, so old
> iptables versions will not work anymore.
>
> So the problem is that 32/64 architectures are currently broken
> without that alignment, so let's fix that with your new revision 1. The
> revision 0 has to stay as is, we can't fix that one, it's too late as
> it will break anyone already having an old iptables binary.

Ok.

>
> [...]
>> >> Dealing with the overhead introduced by clearing the "notified" flag
>> >> is completely different from the management of "quota" objects.  To do
>> >> this the best solution is to introduce a callback to reset the flag
>> >> when a "nfacct" object gets reset.  That would be simple and in line
>> >> with what is used ubiquitously in the kernel.
>> >>
>> >> Moving the management of "quota" objects to nfnetlink_acct is a
>> >> completely different ball game.  Not only that, it would also mandate
>> >> to make changes to nfacct, libnfnl and libnl.  It would also require
>> >> to pull a few tricks to make all that extra code compile conditionally
>> >> when XT_QUOTA is not selected, unless we want to automatically select
>> >> XT_QUOTA when NETLINK_ACCT gets enabled.  And what happens when
>> >> another quota type-of-thing comes along?  We keep stuffing "nfacct"
>> >> and "nfnetlink_acct.c" with more functionality?
>> >
>> > This is the most generic thing to make it.
>> >
>> > How the user will inspect if quota has been already fulfilled? And how
>> > will the user reset it in case it needs it? Or simply upgrade the
>> > quota without reloading the rule?
>>
>> Since quotas are intrinsically linked to nfacct objects, the best way
>> to know if a quota has been reached is to look at the statistics for
>> the corresponding nfacct object.
>
> OK, let's put the quota on the nfacct object using some variable size
> tricks. Please see the (unfinished) patch attached, it's just compile
> tested.
>
> The missing chunks are the xt_nfacct.c change and the userspace code
> updates.
>
>> > You have to provide a netlink interface if you want to implement
>> > this in a nice way.  Otherwise, I bet that someone will come with
>> > yet another hackish /proc interface for this, no please. Or worst,
>> > people will code perl scripts to parse the iptables -L -n output.
>>
>> We could create a sysfs entry for each quota but it doesn't scale well.
>
> /sysfs doesn't make any better than /proc IMO. The standard interface
> in netfilter is netlink, let's stick to that.
>
>> > Of course, it's more code to nfnetlink_acct, the libraries and the
>> > utility, but this will be pretty generic and we'll provide a nice
>> > interface.
>> >
>> > And again, thinking of nftables, if we implement the quota management
>> > code in nfnetlink_acct, adding support for nfacct and quota will just
>> > require very little code since we'll reuse most of the common
>> > infrastructure.
>> >
>> > I really think the quota management code belongs nfnetlink_acct, not
>> > xt_nfacct.
>>
>> I'm not against your idea but the thought of starting over after 1)
>> agreeing on a design and 2) investing so much time is disappointing.
>> If we end up choosing your way, would you prefer enhancing the nfacct
>> tool with quota capabilities or adding something like "nfquota"?
>> Personally I would prefer the latter as it scales better.
>
> Enhancing the nfacct tool is good.

In light of the above introducing "nfquota" doesn't make sense anymore.

>
> Let me know if you find any problem with the patch I sent you. Thanks.

I get what you did - I'll fill-in the missing bits and see how well it
all works.
