From: Jarno Rajahalme <jarno@ovn.org>
Subject: Re: [PATCH nf v3] net/openvswitch: Delete conntrack entry clashing with an expectation.
Date: Tue, 18 Apr 2017 11:33:28 -0700
Message-ID: <72B13D6E-7414-471B-90F1-8F524312F1BB@ovn.org>
References: <1492205198-41758-1-git-send-email-jarno@ovn.org> <CAPWQB7FDrL_+jRDzOG7+EpncrEpszS_Db1+a04DZ8QkbFCUQSA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Joe Stringer <joe@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34207 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdDRSdb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 14:33:31 -0400
Received: by mail-pg0-f66.google.com with SMTP id o123so204397pga.1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 11:33:31 -0700 (PDT)
In-Reply-To: <CAPWQB7FDrL_+jRDzOG7+EpncrEpszS_Db1+a04DZ8QkbFCUQSA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> On Apr 18, 2017, at 11:27 AM, Joe Stringer <joe@ovn.org> wrote:
> 
> On 14 April 2017 at 14:26, Jarno Rajahalme <jarno@ovn.org> wrote:
>> Conntrack helpers do not check for a potentially clashing conntrack
>> entry when creating a new expectation.  Also, nf_conntrack_in() will
>> check expectations (via init_conntrack()) only if a conntrack entry
>> can not be found.  The expectation for a packet which also matches an
>> existing conntrack entry will not be removed by conntrack, and is
>> currently handled inconsistently by OVS, as OVS expects the
>> expectation to be removed when the connection tracking entry matching
>> that expectation is confirmed.
>> 
>> It should be noted that normally an IP stack would not allow reuse of
>> a 5-tuple of an old (possibly lingering) connection for a new data
>> connection, so this is somewhat unlikely corner case.  However, it is
>> possible that a misbehaving source could cause conntrack entries be
>> created that could then interfere with new related connections.
>> 
>> Fix this in the OVS module by deleting the clashing conntrack entry
>> after an expectation has been matched.  This causes the following
>> nf_conntrack_in() call also find the expectation and remove it when
>> creating the new conntrack entry, as well as the forthcoming reply
>> direction packets to match the new related connection instead of the
>> old clashing conntrack entry.
>> 
>> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
>> Reported-by: Yang Song <yangsong@vmware.com>
>> Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
>> ---
> 
> Hi Jarno,
> 
>> v3: Removed unnecessary if statement.
>> v2: Fixed commit title.
>> 
>> net/openvswitch/conntrack.c | 31 ++++++++++++++++++++++++++++++-
>> 1 file changed, 30 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> index 7b2c2fc..d796ae7 100644
>> --- a/net/openvswitch/conntrack.c
>> +++ b/net/openvswitch/conntrack.c
>> @@ -514,10 +514,39 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
>>                   u16 proto, const struct sk_buff *skb)
>> {
>>        struct nf_conntrack_tuple tuple;
>> +       struct nf_conntrack_expect *exp;
>> 
>>        if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, net, &tuple))
>>                return NULL;
>> -       return __nf_ct_expect_find(net, zone, &tuple);
>> +
>> +       exp = __nf_ct_expect_find(net, zone, &tuple);
>> +
> 
> Extraneous whitespace^
> 

You mean the empty line?

>> +       if (exp) {
>> +               struct nf_conntrack_tuple_hash *h;
>> +
>> +               /* Delete existing conntrack entry, if it clashes with the
>> +                * expectation.  This can happen since conntrack ALGs do not
>> +                * check for clashes between (new) expectations and existing
>> +                * conntrack entries.  nf_conntrack_in() will check the
>> +                * expectations only if a conntrack entry can not be found,
>> +                * which can lead to OVS finding the expectation (here) in the
>> +                * init direction, but which will not be removed by the
>> +                * nf_conntrack_in() call, if a matching conntrack entry is
>> +                * found instead.  In this case all init direction packets
>> +                * would be reported as new related packets, while reply
>> +                * direction packets would be reported as un-related
>> +                * established packets. */
>> +
> 
> Extraneous whitespace^
> 
>> +               h = nf_conntrack_find_get(net, zone, &tuple);
>> +               if (h) {
>> +                       struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
>> +
>> +                       nf_ct_delete(ct, 0, 0);
>> +                       nf_conntrack_put(&ct->ct_general);
> 
> Do we need the extra nf_conntrack_put() here? If
> nf_conntrack_find_get() returns an entry, we'll call nf_ct_delete()
> which releases a reference on the CT entry.

There is one reference held by the table, but nf_conntrack_find_get() takes another. nf_ct_delete() releases the reference held by the table as the entry is removed, but we need to explicitly release the reference taken by nf_conntrack_find_get().

  Jarno


