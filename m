Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F88C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 10:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCNKxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 06:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCNKxO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 06:53:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 518D11B1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 03:52:50 -0700 (PDT)
Date:   Tue, 14 Mar 2023 11:52:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] NF NAT deduplication refactoring
Message-ID: <ZBBR/gcg6/Oiyq07@salvia>
References: <20230313134649.186812-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230313134649.186812-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Mar 13, 2023 at 01:46:46PM +0000, Jeremy Sowden wrote:
> These three patches perform refactoring in NF NAT modules to remove
> duplicate code.

Thanks for consolidating this.

I collapsed patch 1 and 3, in this particular case I think it is easy
to review to do these two things at once, I can see this:

+static unsigned int
+nf_nat_redirect(struct sk_buff *skb, const struct nf_nat_range2 *range,
+               const union nf_inet_addr *newdst)
+{
+       struct nf_nat_range2 newrange;
+       enum ip_conntrack_info ctinfo;
+       struct nf_conn *ct;
+
+       ct = nf_ct_get(skb, &ctinfo);
+       WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));

nf_nat_setup_info() calls _is_confirmed() which expect ct to be
non-null, so crash will happen right after this WARN_ON.

and _is_confirmed() implicitly means that this is either IP_CT_NEW or
IP_CT_RELATED.

This comes from 44d6e2f27328b25411 which replaced an assertion, quite
straight forward.

I'd suggest to remove this.

+       newrange.flags          = range->flags | NF_NAT_RANGE_MAP_IPS;
+       newrange.min_addr       = *newdst;
+       newrange.max_addr       = *newdst;
+       newrange.min_proto      = range->min_proto;
+       newrange.max_proto      = range->max_proto;

This newrange is missing memset(), other existing nat code calls
memset(), I think it might be related to iptables which is exposing
this structure to userspace through blob. I would need to check the
NAT core to check if this memset is really required.

+       return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
+}

May you submit v2 with these two changes?

Thanks.
