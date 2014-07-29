From: Alexey Perevalov <alexey.perevalov@hotmail.com>
Subject: RE: [PATCH] netfilter: nfnetlink_acct: use flag to reset counters
Date: Wed, 30 Jul 2014 01:00:18 +0400
Message-ID: <DUB131-W7226804B48D9362BEDB548DF80@phx.gbl>
References: <20140725160123.GA20548@salvia>,<1406570272-3704-2-git-send-email-a.perevalov@samsung.com>,<20140728215325.GA4093@salvia>,<53D78978.5090408@samsung.com>,<20140729163208.GA3739@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"hs81.go@samsung.com" <hs81.go@samsung.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub004-omc3s23.hotmail.com ([157.55.2.32]:65185 "EHLO
	DUB004-OMC3S23.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbaG2VF3 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:05:29 -0400
In-Reply-To: <20140729163208.GA3739@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



----------------------------------------
> Date: Tue, 29 Jul 2014 18:32:09 +0200
> From: pablo@netfilter.org
> To: a.perevalov@samsung.com
> CC: kyungmin.park@samsung.com; hs81.go@samsung.com; netfilter-devel@v=
ger.kernel.org; alexey.perevalov@hotmail.com; mathieu.poirier@linaro.or=
g
> Subject: Re: [PATCH] netfilter: nfnetlink_acct: use flag to reset cou=
nters
>
> On Tue, Jul 29, 2014 at 03:46:00PM +0400, Alexey Perevalov wrote:
> [...]
>>>>@@ -143,7 +157,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 po=
rtid, u32 seq, u32 type,
>>>> if (nla_put_string(skb, NFACCT_NAME, acct->name))
>>>> goto nla_put_failure;
>>>>- if (type =3D=3D NFNL_MSG_ACCT_GET_CTRZERO) {
>>>>+ if (type =3D=3D NFNL_MSG_ACCT_GET_CTRZERO &&
>>>>+ (!nfacct_flags || is_counters_reset(nfacct_flags, acct->flags) ||
>>>>+ is_quotas_reset(nfacct_flags, acct->flags))) {
>>>Replacing this:
>>>
>>> acct->flags & nfacct_flags =3D=3D nfacct_flags
>>>
>>>I think it should be enough.
>>>
>> Yes, agree, but how to be with just counters without a quota,
>> at first look it should be
>> #define NFACCT_F_COUNTER ~(NFACCT_F_QUOTA_PKTS |
>> NFACCT_F_QUOTA_BYTES | NFACCT_F_OVERQUOTA)
>
> Right. I get the problem, what I proposed is not enough.
>
> We can extend this in a more flexible way to allow better filtering
> from userspace, eg.
>
> NFACCT_FLAGS_FILTER (nest)
> NFACCT_VALUE (u32)
> NFACCT_MASK (u32)
>
> The use the value and the mask to perform:
>
> value & filter->mask =3D=3D filter->data
>
> Where filter comes from netlink cb->data.
>
> Please, see this thread:
>
> http://www.spinics.net/lists/netfilter-devel/msg32173.html
>
> The idea is very similar. We should only have one single key after
> your patch to filter by flags.
>
> Is this OK for your needs?
I think yes, due filter mechanism should be extendible. As an example,
also I don't want to=A0 receive not yet touched counters (which has 0 b=
ytes).

>
>> Also I decided to put such condition not into nfnl_acct_fill_info,
>> but directly into nfnl_acct_dump, it will make this feature more
>> general,
>> client will get ability to filter it not only for reset command, but
>> also for list command, also nfnl_acct_fill_info is using in many
>> places, e.g.
>> just get command or nfnl_overquota_report.
>
> Right, the filtering should be generic for both list and reset
> commands.
>
>> And finally, I found strange approach for working with
>> NFACCT_F_OVERQUOTA (value 1 << 2, 4), in nfnl_acct_overquota the
>> test_and_set_bit function is used, which wants
>> Nth bit, and that Nth bit is 4, but not 2. Clearing is fine
>> clear_bit accept Nth bit as well,
>> but nfnl_acct_new gets from netlink attribute NFACCT_F_OVERQUOTA not
>> as offset value.
>
> That's a bug. Would you also send a separated patch for that, please?
Ok, but I need to know you opinion. My opinion is following:
if you have 1st, 2nd, 3rd bit for flags, you should use 1st,=A0 2nd, 3r=
d, and using power of 2
not robust, I think bug was hidden due it was the latest bit. But on ot=
her hand, usage of set_bit and clear_bit looks
really perfect. So right now user/kernel space serialization is using N=
=46ACCT_F_QUOTA_PKTS|BYTES their values are 1 and 2, I think it's not t=
oo late to change the value of enum nfnl_acct_flags to sequential numbe=
r, but not power of 2 and then use bit helper functions.
But you could stay on old used approach, power of 2 in enum and no bit =
helpers.

>
>> I took a look at it because of:
>> 1. It's not convenient to keep combined bit set for
>> NFACCT_F_COUNTER, because NFACCT_F_OVERQUOTA not what we have in
>> acct->flags. Of course if you not against such bit set.
>> 2. nlnf_overquata_report sends to user space _forth_ activated bit,
>> but not _second_ for NFACCT_F_OVERQUOTA, but
>> NFACCT_F_QUOTA_[BYTES|PKTS] was being sent as is. Output of the
>> nfacct, after overquota event occurred, not so clear, in case of
>> bytes quota it's just changing to package. It's not a big deal to
>> fix it to print "overquoted", but I feel it's better to use some
>> unified method to set bits.
>
> That's inconsistent and this of course needs a fix. Patch? Thanks
No problem.=20
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
