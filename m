From: Joe Stringer <joe@ovn.org>
Subject: Re: [PATCH nf v3] net/openvswitch: Delete conntrack entry clashing
 with an expectation.
Date: Tue, 18 Apr 2017 12:24:28 -0700
Message-ID: <CAPWQB7EDaRaLGknCLOiVgcBbsZ_O1jTYOvKsCjsakb_2sDc3Cw@mail.gmail.com>
References: <1492205198-41758-1-git-send-email-jarno@ovn.org>
 <CAPWQB7FDrL_+jRDzOG7+EpncrEpszS_Db1+a04DZ8QkbFCUQSA@mail.gmail.com> <72B13D6E-7414-471B-90F1-8F524312F1BB@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Jarno Rajahalme <jarno@ovn.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:51760 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdDRTYw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 15:24:52 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by relay9-d.mail.gandi.net (Postfix) with ESMTPS id 88E9E406DE
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 21:24:51 +0200 (CEST)
Received: from mfilter5-d.gandi.net (mfilter5-d.gandi.net [217.70.178.132])
        by relay6-d.mail.gandi.net (Postfix) with ESMTP id 76CF5FB89F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 21:24:51 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([IPv6:::ffff:217.70.183.198])
        by mfilter5-d.gandi.net (mfilter5-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id vZlS2yw2l4Od for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Apr 2017 21:24:49 +0200 (CEST)
Received: from mail-qk0-f169.google.com (mail-qk0-f169.google.com [209.85.220.169])
        (Authenticated sender: joe@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id AA412FB8A1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 21:24:49 +0200 (CEST)
Received: by mail-qk0-f169.google.com with SMTP id d131so2537780qkc.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 12:24:49 -0700 (PDT)
In-Reply-To: <72B13D6E-7414-471B-90F1-8F524312F1BB@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 April 2017 at 11:33, Jarno Rajahalme <jarno@ovn.org> wrote:
>
>> On Apr 18, 2017, at 11:27 AM, Joe Stringer <joe@ovn.org> wrote:
>>
>> On 14 April 2017 at 14:26, Jarno Rajahalme <jarno@ovn.org> wrote:
>>> Conntrack helpers do not check for a potentially clashing conntrack
>>> entry when creating a new expectation.  Also, nf_conntrack_in() will
>>> check expectations (via init_conntrack()) only if a conntrack entry
>>> can not be found.  The expectation for a packet which also matches an
>>> existing conntrack entry will not be removed by conntrack, and is
>>> currently handled inconsistently by OVS, as OVS expects the
>>> expectation to be removed when the connection tracking entry matching
>>> that expectation is confirmed.
>>>
>>> It should be noted that normally an IP stack would not allow reuse of
>>> a 5-tuple of an old (possibly lingering) connection for a new data
>>> connection, so this is somewhat unlikely corner case.  However, it is
>>> possible that a misbehaving source could cause conntrack entries be
>>> created that could then interfere with new related connections.
>>>
>>> Fix this in the OVS module by deleting the clashing conntrack entry
>>> after an expectation has been matched.  This causes the following
>>> nf_conntrack_in() call also find the expectation and remove it when
>>> creating the new conntrack entry, as well as the forthcoming reply
>>> direction packets to match the new related connection instead of the
>>> old clashing conntrack entry.
>>>
>>> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
>>> Reported-by: Yang Song <yangsong@vmware.com>
>>> Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
>>> ---
>>
>> Hi Jarno,
>>
>>> v3: Removed unnecessary if statement.
>>> v2: Fixed commit title.
>>>
>>> net/openvswitch/conntrack.c | 31 ++++++++++++++++++++++++++++++-
>>> 1 file changed, 30 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>>> index 7b2c2fc..d796ae7 100644
>>> --- a/net/openvswitch/conntrack.c
>>> +++ b/net/openvswitch/conntrack.c
>>> @@ -514,10 +514,39 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
>>>                   u16 proto, const struct sk_buff *skb)
>>> {
>>>        struct nf_conntrack_tuple tuple;
>>> +       struct nf_conntrack_expect *exp;
>>>
>>>        if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, net, &tuple))
>>>                return NULL;
>>> -       return __nf_ct_expect_find(net, zone, &tuple);
>>> +
>>> +       exp = __nf_ct_expect_find(net, zone, &tuple);
>>> +
>>
>> Extraneous whitespace^
>>
>
> You mean the empty line?

Yeah.

>>> +       if (exp) {
>>> +               struct nf_conntrack_tuple_hash *h;
>>> +
>>> +               /* Delete existing conntrack entry, if it clashes with the
>>> +                * expectation.  This can happen since conntrack ALGs do not
>>> +                * check for clashes between (new) expectations and existing
>>> +                * conntrack entries.  nf_conntrack_in() will check the
>>> +                * expectations only if a conntrack entry can not be found,
>>> +                * which can lead to OVS finding the expectation (here) in the
>>> +                * init direction, but which will not be removed by the
>>> +                * nf_conntrack_in() call, if a matching conntrack entry is
>>> +                * found instead.  In this case all init direction packets
>>> +                * would be reported as new related packets, while reply
>>> +                * direction packets would be reported as un-related
>>> +                * established packets. */
>>> +
>>
>> Extraneous whitespace^
>>
>>> +               h = nf_conntrack_find_get(net, zone, &tuple);
>>> +               if (h) {
>>> +                       struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
>>> +
>>> +                       nf_ct_delete(ct, 0, 0);
>>> +                       nf_conntrack_put(&ct->ct_general);
>>
>> Do we need the extra nf_conntrack_put() here? If
>> nf_conntrack_find_get() returns an entry, we'll call nf_ct_delete()
>> which releases a reference on the CT entry.
>
> There is one reference held by the table, but nf_conntrack_find_get() takes another. nf_ct_delete() releases the reference held by the table as the entry is removed, but we need to explicitly release the reference taken by nf_conntrack_find_get().

Ah, makes sense.

Acked-by: Joe Stringer <joe@ovn.org>

Did you intend for Pablo to take this? Pablo, is this fine or should
Jarno resubmit against net?
