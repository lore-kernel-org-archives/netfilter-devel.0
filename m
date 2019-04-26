Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA45C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31CB2146E
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfDZRRR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:17:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfDZRRQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:17:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK4TK-0005Ox-Ir; Fri, 26 Apr 2019 19:17:14 +0200
Message-ID: <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Apr 2019 19:17:13 +0200
In-Reply-To: <20190426164252.a2yxjxf3thotrqu3@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 18:42 +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 12, 2019 at 01:56:22PM +0200, Johannes Berg wrote:
> > > > I'd actually be happy to *just* expose the policy with all its nested
> > > > elements/objects in there. That'd probably be also almost enough for
> > > > you?
> > > 
> > > Exposing commands is also important, I know of people poking for
> > > commands to see if they are available or not.
> > 
> > Alright, well, generic netlink already exposes the commands :-)
> 
> How are you going to relate this with the policy description?

Well, I'm not actually relating this at all right now.

Since generic netlink already has a list of commands like

{
  .cmd = XYZ,
  .doit = do_xyz,
  .dumpit = dump_xyz,
}

and I recently moved the policy to be for the whole *family*, not for
each command, basically all we're missing is a list of attributes used
by this command.

Ideally, we'd add this as

{
  .cmd = XYZ,
  .doit = do_xyz,
  .dumpit = dump_xyz,
  .attrs = { ATTR_A, ATTR_B, ATTR_C, ATTR_D },
}

but of course there's no good way to express this in C, you'd have to
build an out-of-line array and point to it.

If we do this though, it's easy to expose, right? Just a list of
attribute types that you can go look up in the policy description
obtained separately.

> Could you post a schema of the netlink attribute hierarchy of your
> policy descriptions?

The whole patch is in your inbox ;-)

But basically it looks like this:
FAMILY_SPECIFIC_POLICY_ATTRIBUTE = { // nested
  [policy index] = { // nested, 0 = root policy
    [attribute type] = { // nested
      [NL_POLICY_TYPE_ATTR_TYPE] = U32(NL_ATTR_TYPE_*),

      // for signed limited values:
      [NL_POLICY_TYPE_ATTR_MIN_VALUE_S] = S64(...),
      [NL_POLICY_TYPE_ATTR_MAX_VALUE_S] = S64(...),

      // for unsigned limited values:
      [NL_POLICY_TYPE_ATTR_MIN_VALUE_U] = U64(...),
      [NL_POLICY_TYPE_ATTR_MAX_VALUE_U] = U64(...),

      // for binary min/max length:
      [NL_POLICY_TYPE_ATTR_MIN_LENGTH] = U32(...),
      [NL_POLICY_TYPE_ATTR_MAX_LENGTH] = U32(...),

      // for nested policy (nested or nested array):
      [NL_POLICY_TYPE_ATTR_POLICY_IDX] = U32(...),
      [NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE] = U32(...),

      // for bitfield32:
      [NL_POLICY_TYPE_ATTR_BITFIELD32_MASK] = U32(...),
    }
  }
}

> > > The object ID is needed by userspace, to build a flat table, and look
> > > up for the nested IDs, to express the graph. We can probably place
> > > this in the policy.
> > 
> > I don't really understand the object ID.
> 
> This object ID is a policy nest ID.

Ok. So basically I even already have the object ID, except that I don't
really specifically give it one, I just build it based on the flattening
algorithm I described in my other email..

> The idea is to expose an array of nest IDs (object IDs), then this array
> contains the attributes that this nest contains and if there are nested
> attributes, then in case of nested attributed, the nest ID that describe
> this attribute.
> 
> The idea is to make it easy for userspace to build this table, and then
> userspace performs lookups based on this object ID (policy nest ID).

Right. I think I have that?

> > So basically - my main concern with this bus description stuff you've
> > done here is that it duplicates all the data and needs to be maintained
> > separately from what should be the same data used for enforcement.
> 
> My idea was to provide a description of netlink, then a compiler tool
> that would autogenerate the policy structures and the UAPI headers from
> this bus description. Yes, it sounds too futuristic to autogenerate code
> in the kernel, but other projects do already.

Yeah, ok, but I think you'll have a hard time convincing everyone to
switch to that whole-sale, and ban the other approach. What I've done
with the policy is far more agreeable to making progress without a
complete rewrite. The policy exposure for generic netlink is mostly
automatic, for example, as it could be for other netlink families I
guess.

The issue with C I noted above of course does lend itself really well to
expressing it in a DSL and then generating the C code, but even *then* I
would still argue that having all of this duplicated is a waste of
memory since we need to have the same data already.

Anyway. Please check out the patches I posted today. I do know that they
cannot currently express the "which attribute belongs to which command"
part, but I believe that we can add that in some way without rewriting
the whole thing, and that making step-by-step progress is better.

So please check out the patches and tell me whether you see any
fundamental problem with that, or if you just think that they're
incomplete in this manner - I agree and really would like to address
that, but need to also see how that feeds back into the validation (it
must, after all) etc.

johannes

