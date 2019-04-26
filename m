Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BFFC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD8D2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfDZTqh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:46:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41332 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfDZTqg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:46:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK6nq-0000Sw-WA; Fri, 26 Apr 2019 21:46:35 +0200
Message-ID: <79a6e186763b199b3fd28ef0dc0e67b3698fea89.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Apr 2019 21:46:33 +0200
In-Reply-To: <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
         <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
         <20190426180430.h5h7lqivx2qufuyi@salvia>
         <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
         <20190426192054.4iedgasehywqzyx6@salvia>
         <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 21:37 +0200, Johannes Berg wrote:

> You're now thinking of the "policy ID" I assigned for the wire format as
> the object ID, but really that's not what it is. The object ID that
> you're looking for is the attribute type of the nested attribute.
> 
> So if you have
> 
> struct nla_policy nested_policy[...] = { ... };
> 
> struct nla_policy policy[...] = {
>     [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
> };
> 
So if we extend this, say like this:

struct nla_policy policy[...] = {
    [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
    [MY_OTHER_ATTR] = NLA_POLICY_NESTED(nested_policy),
};

then you could perhaps argue that having an object ID makes sense, and
assigning the same object ID to MY_ATTR and MY_OTHER_ATTR would make
sense?

Of course, my could would assign this the same (temporary) policy ID,
but there can be no reliance on the policy ID beyond what's needed at
runtime to map the attribute to the nested policy.

You still see at runtime that these have the same policy (since they
have the same policy ID), but at the same time presumably there was a
reason to have MY_ATTR and MY_OTHER_ATTR, so perhaps the semantics are
different even if the attributes are the same, as could perhaps be
expected if you have a SET and a CLEAR attribute (MY_ATTR and
MY_OTHER_ATTR respectively) and the contents you give has the same
policy, but different logic?

Basically, I just didn't consider this case to be significant enough to
manually and assign stable IDs of some sort, when we already have them
in the form of the attribute type.

johannes

