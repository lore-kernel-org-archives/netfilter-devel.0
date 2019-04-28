Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A004C4321A
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 19:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F8AE20679
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 19:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfD1TvV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 15:51:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:43254 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfD1TvU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 15:51:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hKppW-0002ey-HP; Sun, 28 Apr 2019 21:51:18 +0200
Message-ID: <89b91d97701b58aa50b5ea66ca21dd9f9a6d4b1c.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Sun, 28 Apr 2019 21:51:17 +0200
In-Reply-To: <20190427105208.xlqv77pmjvkpyxr4@salvia>
References: <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
         <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
         <20190426180430.h5h7lqivx2qufuyi@salvia>
         <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
         <20190426192054.4iedgasehywqzyx6@salvia>
         <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
         <20190427105208.xlqv77pmjvkpyxr4@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 2019-04-27 at 12:52 +0200, Pablo Neira Ayuso wrote:

> > So I actually think that separating "type description", which is the
> > policy today, from the "type validity description" is valuable, because
> > ideally we do want each type (e.g. NFTA_CHAIN_HANDLE) to always be the
> > same regardless of command, so that a hypothetical GET_STATS command
> > won't take a U64 CHAIN_HANDLE while a (similarly hypothetical)
> > DELETE_CHAIN command takes a U32 CHAIN_HANDLE!
> 
> If we want to avoid the extra code for the netlink description, and
> reuse the existing policy objects, then we'll need policies for each
> command that express what attributes make sense per command as you
> describe above.

Yes. Although when you say "policies", I'd argue that's not an
"nla_policy" but rather some sort of "list of permitted attributes".

> > Hence my thought of separating "this is the policy for the attributes
> > (types)" and "this is the list of allowed types for this command". I do
> > realize now that the latter becomes difficult with nested attributes
> > though, but we're probably better off finding ways to express that than
> > having entirely different policies (also, the data would be smaller).
> 
> The netlink description is telling what attributes are available for
> each command and policies, so policy definitions are a subset of the
> netlink description.
> 
> If I understand well, your concern is that you would like that we
> use reuse / extend the existing policy structures to be used for the
> netlink description. That's very reasonable indeed and a good idea.

Yes, mostly. My bigger concern isn't really that we reuse it, my bigger
concern is that if we *don't* we'll eventually end up with something
like:

struct nla_policy policy_for_one_command[] = {
   [NLA_MY_ATTR] = { .type = NLA_U32 },
   ...
};

struct nla_policy policy_for_another_command[] = {
   [NLA_MY_ATTR] = { .type = NLA_U16 },
   ...
};

and then we just have a big mess. So I'd like to separate the "type"
policy (what type is each attribute in a given netlink type enum) from
the "permissible" policy (which attributes are valid in a given context
like a command).

I've not actually started working on the second part at all yet, but
because I strongly believe it makes sense to separate them, I don't see
a need to interleave it with the rest of the patch series.

> > You're now thinking of the "policy ID" I assigned for the wire format as
> > the object ID, but really that's not what it is. The object ID that
> > you're looking for is the attribute type of the nested attribute.
> 
> I'm attaching userspace code for the netlink description
> infrastructure for libmnl. It should be easy to rework it to build a
> flat table with these IDs. The IDs are helping to provide a easy way
> to express this graph in a data structure that is easy to navigate
> from userspace.

Right.

> My usecase is this: I don't want to probe the kernel to guess if a
> command / attribute is available for this kernel version or not.
> I just want to dump the netlink description, then navigate this table
> to search if that command / attribute is there.

Sure.

The only difference between the "object ID" that you manually assign and
the "policy ID" that my code automatically assigns is that the latter is
somewhat ephemeral - a new kernel version may change it.

So, let's say you have
struct nla_policy policy[...] = {
  [NLA_MY_OBJECT] = NLA_POLICY_NESTED(sub_policy),
  [NLA_ANOTHER_OBJ] = NLA_POLICY_NESTED_ARRAY(sub_policy),
};

Then in one kernel version you might get reported to userspace:

NLA_MY_OBJECT: nested - policy 7
NLA_ANOTHER_OBJ: nested array - policy 7

and in a new kernel version the value "7" there might change to be 8 or
6 or whatever depending on changes in any possible nested policy for
other attributes, but it would still always be the same number (unless
you actually changed the fact that both link to "sub_policy" in the C
code description), and the contents of that referenced policy would
still all be the same as before. Just the ID that links them together at
runtime would be more ephemeral than the object ID you proposed.

I don't, however, think that this is a problem as I don't see any value
in the object ID itself. It's just an ID to tell you what kind of sub-
attributes are allowed.

> > So if you have
> > 
> > struct nla_policy nested_policy[...] = { ... };
> > 
> > struct nla_policy policy[...] = {
> >     [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
> > };
> > 
> > and you dump out starting from "policy" then yes, "policy" will have ID
> > 0, and "nested_policy" will have ID 1, but those are only temporary
> > identifiers for the dump. What's really relevant is the attribute type
> > "MY_ATTR".
> 
> Do you have userspace I can have a look? With runtime / dynamic ID
> generation, I cannot see yet how to navigate such a table or how the
> userspace representation would look like.

I posted a very hacky patch before, let me see if I can find it...

https://p.sipsolutions.net/4c674acaf8d6ca71.txt

> By using MY_ATTR as ID, I think you will have to build a graph
> structure in userspace, I was trying to provide a simple flat table
> representation for userspace.

I'm not using MY_ATTR as ID. I'm just making up an (ephemeral) object ID
at runtime based on the policy pointer. See above though.

johannes

