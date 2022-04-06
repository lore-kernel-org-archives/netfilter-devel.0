Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A91EC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 09:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiDFJCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453494AbiDFI6x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 04:58:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E894ABF61
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 20:12:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nbw68-0002jM-Nf; Wed, 06 Apr 2022 05:12:44 +0200
Date:   Wed, 6 Apr 2022 05:12:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next PATCH v2 1/5] netfilter: bitwise: keep track of
 bit-length of expressions
Message-ID: <20220406031244.GA18470@breakpoint.cc>
References: <20220404120417.188410-1-jeremy@azazel.net>
 <20220404120417.188410-2-jeremy@azazel.net>
 <20220405112850.GE12048@breakpoint.cc>
 <Ykyq+JE0/nTM/de0@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykyq+JE0/nTM/de0@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> It wouldn't be straightforward.  Expression udata might make more sense
> than adding a new bitwise attribute, but that doesn't currently exist.
> Would it be worth adding?  I seem to recall considering something along
> those lines for passing type information with expressions as a way to
> implement casting.

Had not thought of casting, good point.
Given bitwise needs to be touched anyway to get the second register
operations I think the proposed patch isn't too bad.

For casts and other use cases (including bitlen), I think its
not needed to add special udata for expressions, as userspace can't
zap them selectively.

We already do something similar for sets (to embed 'typeof' info
for key and data).

Probably extend nftnl_udata_rule_types in libnftnl to add a
NFTNL_UDATA_RULE_EXPR_INFO.

NFTNL_UDATA_RULE_EXPR_INFO would be nested and contain
expression specific (nested) attributes.

i.e., if you have something like

meta mark -> reg 1
binop reg1 &= 0x0000ffff
ct mark -> reg 2
binop and reg1 &= reg2  // ulen 16

Then rule udata would have:
NFTNL_UDATA_RULE_EXPR_INFO (nested)
   type 4 (nested, 4 refers to the last expression above,
 	   type '0' is reserved).
      type 1 // nla_u32  -> for binop, 1 is 'len', it would be
               defined privately in src/bitwise.c
END

because only expression 4 needs annotations, so we don't waste
space for expressions that do not need extra data.

We could reserve a few nested numbers for things that might make sense
for all (or many) expresssions, e.g. 'cast to type x'.

We could of course place expr specific structs in there too but so
far we managed to avoid this and it would be not-so-nice to break
nft userspace when listing a ruleset added by an older version.

Probably could extend struct netlink_linearize_ctx with a memory
blob pointer that netlink_linearize_rule()/netlink_gen_stmt() can use
to add extra data.

My problem is that its a lot of (userspace) code for something that can
easily be done by a small kernel patch such as this one and so far we
don't have a real need for something like this.
