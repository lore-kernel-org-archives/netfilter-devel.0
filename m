Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4242C43218
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 19:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FE72064A
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 19:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfD1Txu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 15:53:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:43310 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfD1Txu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 15:53:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hKprw-0002jR-MJ; Sun, 28 Apr 2019 21:53:48 +0200
Message-ID: <be584167d4096e238df5807ad0212234480c196c.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Sun, 28 Apr 2019 21:53:47 +0200
In-Reply-To: <20190427105741.nfxy56bkr62hupml@salvia>
References: <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
         <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
         <20190426180430.h5h7lqivx2qufuyi@salvia>
         <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
         <20190426192054.4iedgasehywqzyx6@salvia>
         <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
         <79a6e186763b199b3fd28ef0dc0e67b3698fea89.camel@sipsolutions.net>
         <20190427105741.nfxy56bkr62hupml@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 2019-04-27 at 12:57 +0200, Pablo Neira Ayuso wrote:

> But they all point to the same nested_policy, ie. these nested
> atributes represent instances of the same object class.

To some extent, yes.

> I think this is meaningful to userspace in terms of providing a
> description of the interface, rather than making it look.

Sure.

> Without the ID, it is not possible from userspace to see that MY_ATTR
> and MY_OTHER_ATTR refer to the same object, right?

There is an ID, and if you reference the same sub-policy multiple times
for nested / nested array attribute types (even at different levels of
nesting btw) then this sub-policy will only be dumped to userspace
multiple times, given an ID, and be referenced by that ID from the
appropriate attribute types in other root/sub-policies.

The only thing is that between kernel versions that ID may change as
it's computed while walking the policy graph, and that graph may change
and thus the walk may reach nodes in the graph in a different order and
thereby label them differently.

johannes

