Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F88AC282CE
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 11:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 371242171F
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 11:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfDLL40 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:56:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46674 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfDLL40 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 07:56:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEunA-0005gb-25; Fri, 12 Apr 2019 13:56:24 +0200
Message-ID: <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 12 Apr 2019 13:56:22 +0200
In-Reply-To: <20190411192647.xsnhno6gcf5fen5u@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

> I'm glad to receive feedback, even 1 year later :-)

:-)

> > But this is _lots_ of code, and most of it is already encoded in the
> > nla_policy for all those attributes. I think we really need to find a
> > way to unify the two sets of data.
> 
> We could probably extract this from the nla_policy if we extend it. I
> can have a look...

Please do, and please have a look at the patch(es) I sent out regarding
this. I think we've extended the policy enough that most of this is
really there, and we can certainly add more to the policy.

For example, I am now considering allowing NLA_POLICY_RANGE(NLA_BINARY,
...) to have an upper *and* lower length bound for an NLA_BINARY value,
right now you can only have either of the two and we have uses cases
where we need both.

> > I'd actually be happy to *just* expose the policy with all its nested
> > elements/objects in there. That'd probably be also almost enough for
> > you?
> 
> Exposing commands is also important, I know of people poking for
> commands to see if they are available or not.

Alright, well, generic netlink already exposes the commands :-)

> I think we should full description to userspace, not only policies.

I guess the way I see it, they're all pieces of the puzzle. The policy
is good for both code in the kernel and for exposing it. The command
list is already exposed.

What now we're missing, in a sense, is which commands take which
attributes. This would actually *also* be a good thing for validation in
the kernel, but I haven't really found a good way to encode it yet.
Doing a bitmap isn't really feasible, and doing a list is difficult to
type out.

Perhaps if we do end up going with your code generation idea then we can
do this more easily.

> > Except we don't have an "object ID" (and obviously also that we can use
> > the same data to actually parse/validate messages, and so don't end up
> > with bad situations of nldesc saying one thing and the policy another.)
> 
> The object ID is needed by userspace, to build a flat table, and look
> up for the nested IDs, to express the graph. We can probably place
> this in the policy.

I don't really understand the object ID.

Say you have a top-level "filter" attribute (I'm completely making up
things here).

Now this filter "object" can have a number of attributes, and that's
captured by the nested policy there?

IOW - the code I wrote until now would expose

policy 0: attribute filter: nested with attrs from policy 1
policy 1: attribute abc: NLA_U8
policy 1: attribute xyz: NLA_U32

etc.

> This would be incomplete, since commands are an essential part too,
> and relation of attributes with commands are also too.

Agree. Still, I think it solves much of the problem, like I said above -
all are parts of the puzzle.

With generic netlink we have a list of commands already. That should be
easy to add elsewhere, though generic netlink has the advantage of
having the list of commands (and their handlers) as *data*, which I
think is expressed *code* in rtnetlink now? But that can either be fixed
or you just carry a separate list of commands there.

With the policy export I wrote we have the policy, and if you set it up
properly with all the nested sub-policies for each attribute etc.

So I agree - we're missing "this command uses these attributes", but
again I don't think the object description is actually the right
solution here, because you *also* want to enforce that in some way.

I feel the generic netlink model where the command handlers etc. are not
code but data is superior here because it lets us add things like that
relatively easily, though of course we haven't actually done it now.


So basically - my main concern with this bus description stuff you've
done here is that it duplicates all the data and needs to be maintained
separately from what should be the same data used for enforcement.

johannes

