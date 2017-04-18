From: Joe Stringer <joe@ovn.org>
Subject: Re: [PATCH nf v3] net/openvswitch: Delete conntrack entry clashing
 with an expectation.
Date: Tue, 18 Apr 2017 11:27:47 -0700
Message-ID: <CAPWQB7FDrL_+jRDzOG7+EpncrEpszS_Db1+a04DZ8QkbFCUQSA@mail.gmail.com>
References: <1492205198-41758-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:54625 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754811AbdDRSf3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 14:35:29 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id E6003487F3A
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 20:28:27 +0200 (CEST)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by relay7-d.mail.gandi.net (Postfix) with ESMTPS id 607E1848
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 20:28:11 +0200 (CEST)
Received: from mfilter6-d.gandi.net (mfilter6-d.gandi.net [217.70.178.135])
        by relay3-d.mail.gandi.net (Postfix) with ESMTP id 4C8B6A80CD
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 20:28:11 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([IPv6:::ffff:217.70.183.195])
        by mfilter6-d.gandi.net (mfilter6-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id 8L3fQBIRtWwB for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Apr 2017 20:28:09 +0200 (CEST)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com [209.85.220.178])
        (Authenticated sender: joe@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 15ED9A80CE
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 20:28:08 +0200 (CEST)
Received: by mail-qk0-f178.google.com with SMTP id f133so1200453qke.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 11:28:08 -0700 (PDT)
In-Reply-To: <1492205198-41758-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 April 2017 at 14:26, Jarno Rajahalme <jarno@ovn.org> wrote:
> Conntrack helpers do not check for a potentially clashing conntrack
> entry when creating a new expectation.  Also, nf_conntrack_in() will
> check expectations (via init_conntrack()) only if a conntrack entry
> can not be found.  The expectation for a packet which also matches an
> existing conntrack entry will not be removed by conntrack, and is
> currently handled inconsistently by OVS, as OVS expects the
> expectation to be removed when the connection tracking entry matching
> that expectation is confirmed.
>
> It should be noted that normally an IP stack would not allow reuse of
> a 5-tuple of an old (possibly lingering) connection for a new data
> connection, so this is somewhat unlikely corner case.  However, it is
> possible that a misbehaving source could cause conntrack entries be
> created that could then interfere with new related connections.
>
> Fix this in the OVS module by deleting the clashing conntrack entry
> after an expectation has been matched.  This causes the following
> nf_conntrack_in() call also find the expectation and remove it when
> creating the new conntrack entry, as well as the forthcoming reply
> direction packets to match the new related connection instead of the
> old clashing conntrack entry.
>
> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Reported-by: Yang Song <yangsong@vmware.com>
> Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
> ---

Hi Jarno,

> v3: Removed unnecessary if statement.
> v2: Fixed commit title.
>
> net/openvswitch/conntrack.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 7b2c2fc..d796ae7 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -514,10 +514,39 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
>                    u16 proto, const struct sk_buff *skb)
>  {
>         struct nf_conntrack_tuple tuple;
> +       struct nf_conntrack_expect *exp;
>
>         if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, net, &tuple))
>                 return NULL;
> -       return __nf_ct_expect_find(net, zone, &tuple);
> +
> +       exp = __nf_ct_expect_find(net, zone, &tuple);
> +

Extraneous whitespace^

> +       if (exp) {
> +               struct nf_conntrack_tuple_hash *h;
> +
> +               /* Delete existing conntrack entry, if it clashes with the
> +                * expectation.  This can happen since conntrack ALGs do not
> +                * check for clashes between (new) expectations and existing
> +                * conntrack entries.  nf_conntrack_in() will check the
> +                * expectations only if a conntrack entry can not be found,
> +                * which can lead to OVS finding the expectation (here) in the
> +                * init direction, but which will not be removed by the
> +                * nf_conntrack_in() call, if a matching conntrack entry is
> +                * found instead.  In this case all init direction packets
> +                * would be reported as new related packets, while reply
> +                * direction packets would be reported as un-related
> +                * established packets. */
> +

Extraneous whitespace^

> +               h = nf_conntrack_find_get(net, zone, &tuple);
> +               if (h) {
> +                       struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
> +
> +                       nf_ct_delete(ct, 0, 0);
> +                       nf_conntrack_put(&ct->ct_general);

Do we need the extra nf_conntrack_put() here? If
nf_conntrack_find_get() returns an entry, we'll call nf_ct_delete()
which releases a reference on the CT entry.
