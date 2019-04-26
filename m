Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE2CC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B67B20679
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfDZThr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:37:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfDZThq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:37:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK6fI-0000Cc-CZ; Fri, 26 Apr 2019 21:37:44 +0200
Message-ID: <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Apr 2019 21:37:43 +0200
In-Reply-To: <20190426192054.4iedgasehywqzyx6@salvia>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 21:20 +0200, Pablo Neira Ayuso wrote:

> > > I solved this in my patchset through the object ID. So each command
> > > points to an object ID, then such object ID comes with a list of
> > > attributes.
> > 
> > Yeah, ok. Each object you had is basically its own policy.
> 
> Hm, not necessarily.
> 
> The object id is matching to the "root policy". Several commands may
> have the same "root policy" (or as I call it "object id"). For
> example, in netfilter we have commands to add and to delete rules,
> both would have the same "root policy".

Right, I didn't mean they necessarily had a different policy, just that
they could.

So ... I guess I need to think about this a bit more.

My approach to this was that as long as you have a single enum
(namespace) for attributes (e.g. enum nft_chain_attributes to pick a
random example), you'd also want to have a single policy for these,
describing the possibilities.

I do admit though that this doesn't cover the "only some of these
attributes are valid for a given command" part, and I also admit that I
had sort of punted that part.

We can solve that by having separate policies, so if you have two
operations using NTFA_CHAIN_*, then perhaps an operation deletes a chain
can only take a NFTA_CHAIN_HANDLE or NFTA_CHAIN_NAME, but an operations
that sets things inside might take all the other attributes.

HOWEVER, having separate policies then opens up an easy avenue for
(mistakenly or not) having, well, separate policies! Even for the same
attribute type. And that's something we really *don't* want.

So I actually think that separating "type description", which is the
policy today, from the "type validity description" is valuable, because
ideally we do want each type (e.g. NFTA_CHAIN_HANDLE) to always be the
same regardless of command, so that a hypothetical GET_STATS command
won't take a U64 CHAIN_HANDLE while a (similarly hypothetical)
DELETE_CHAIN command takes a U32 CHAIN_HANDLE!

Hence my thought of separating "this is the policy for the attributes
(types)" and "this is the list of allowed types for this command". I do
realize now that the latter becomes difficult with nested attributes
though, but we're probably better off finding ways to express that than
having entirely different policies (also, the data would be smaller).

[[[ total aside: we could do something like the "list of allowed types"
being an array of
union valid_type {
   u16 attr;
   struct nested *nested;
};

with

struct nested {
  u16 attr;
  union valid_type *valid_nested_types;
};

I think we can probably safely assume that pointers are always >>MAX_U16
but if not we can either make that larger or find other ways of
disambiguating, e.g. by alignment (and making ATTR_TO_PTR(attr)
something like "(attr << 1) | 0x1" since "struct nested" requires 2-byte 
alignment.

> > > If we use the list policies that you propose, then it's just an extra
> > > enumeration to maintain for each command. And many commands will
> > > likely reuse the same object ID.
> > 
> > A policy pointer, really.
> 
> Sort of, but it has to be stable along time for userspace, right?
> Actually, it's an ID.

The ID in my policy export is not stable in any way. The only thing that
it's used for is to identify which sub-policy is used while you're
dumping it. It will be stable by virtue of the algorithm, but will
change when you add different sub-policy links etc. You cannot rely on
it being stable, but you also do not need to since it's only relevant
that you are able to identify the nested policy while dumping.

> > The list of policies is just built internally when you dump out a policy
> > with its sub-policies for nested attributes/arrays.
> 
> If we expose these to userspace, we need that these object IDs are
> stable, hence the enum. So userspace results in a simple program that
> just makes look ups for the object ID that contains the description of
> the attributes that are available.

Well, no.

You're now thinking of the "policy ID" I assigned for the wire format as
the object ID, but really that's not what it is. The object ID that
you're looking for is the attribute type of the nested attribute.

So if you have

struct nla_policy nested_policy[...] = { ... };

struct nla_policy policy[...] = {
    [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
};

and you dump out starting from "policy" then yes, "policy" will have ID
0, and "nested_policy" will have ID 1, but those are only temporary
identifiers for the dump. What's really relevant is the attribute type
"MY_ATTR".

johannes

