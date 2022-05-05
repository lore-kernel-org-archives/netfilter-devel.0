Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82805C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 May 2022 19:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiEET6F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 May 2022 15:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbiEET6E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 May 2022 15:58:04 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D605F246
        for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2022 12:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V+EvXpjFHGRYLjAjCh8Hz6j/QX5AkmnOIbQQZxbcb5c=; b=cVgaTqhUmHsdYNDrpN7fVBa6kP
        4vq0WrJYm0mwt7P8YwF1OLk+dF1Ow/rT9RYeJa7xdsg/HkRMGTPbo0mArAwChffuVEshJu9wGYEPZ
        yfVWgeLKFU/6UgPP6hWOSrcqAACVl5b9ct+jPpNRH6pI4Si4ho1mHGqDR7XTN68lu45TYkTFsYCo3
        EuLrQCJK7rnmAM5ttgOr9O5TSHccI/V+s4HgUZ8m0SXzBQs7O6Uop+RxVLh/2/6n8/9eITEonzQGQ
        EXnRyAp2/hlbf5TGwkT3N4G50jvwQK9p12XiWIXSwjhiAfPcpp6Dsx/wZWPxIBQwd1vMIPFkSqbV/
        nhlX3/mA==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nmhYK-000C9H-IC; Thu, 05 May 2022 20:54:20 +0100
Date:   Thu, 5 May 2022 20:54:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next PATCH v2 1/5] netfilter: bitwise: keep track of
 bit-length of expressions
Message-ID: <YnQra+9MlkfNYSrC@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
 <20220404120417.188410-2-jeremy@azazel.net>
 <20220405112850.GE12048@breakpoint.cc>
 <Ykyq+JE0/nTM/de0@azazel.net>
 <20220406031244.GA18470@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406031244.GA18470@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2022-04-06, at 05:12:44 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > It wouldn't be straightforward.  Expression udata might make more sense
> > than adding a new bitwise attribute, but that doesn't currently exist.
> > Would it be worth adding?  I seem to recall considering something along
> > those lines for passing type information with expressions as a way to
> > implement casting.
> 
> Had not thought of casting, good point.
> Given bitwise needs to be touched anyway to get the second register
> operations I think the proposed patch isn't too bad.

Cool.

> For casts and other use cases (including bitlen), I think its
> not needed to add special udata for expressions, as userspace can't
> zap them selectively.
> 
> We already do something similar for sets (to embed 'typeof' info
> for key and data).
> 
> Probably extend nftnl_udata_rule_types in libnftnl to add a
> NFTNL_UDATA_RULE_EXPR_INFO.
> 
> NFTNL_UDATA_RULE_EXPR_INFO would be nested and contain
> expression specific (nested) attributes.
> 
> i.e., if you have something like
> 
> meta mark -> reg 1
> binop reg1 &= 0x0000ffff
> ct mark -> reg 2
> binop and reg1 &= reg2  // ulen 16
> 
> Then rule udata would have:
> NFTNL_UDATA_RULE_EXPR_INFO (nested)
>    type 4 (nested, 4 refers to the last expression above,
>  	   type '0' is reserved).
>       type 1 // nla_u32  -> for binop, 1 is 'len', it would be
>                defined privately in src/bitwise.c
> END
> 
> because only expression 4 needs annotations, so we don't waste
> space for expressions that do not need extra data.
> 
> We could reserve a few nested numbers for things that might make sense
> for all (or many) expresssions, e.g. 'cast to type x'.
> 
> We could of course place expr specific structs in there too but so
> far we managed to avoid this and it would be not-so-nice to break
> nft userspace when listing a ruleset added by an older version.
> 
> Probably could extend struct netlink_linearize_ctx with a memory
> blob pointer that netlink_linearize_rule()/netlink_gen_stmt() can use
> to add extra data.
> 
> My problem is that its a lot of (userspace) code for something that can
> easily be done by a small kernel patch such as this one and so far we
> don't have a real need for something like this.

Yes, quite.

If you're happy passing the bit-length through the kernel, how about the
rest of the series?  I'm pretty sure there's some debatable choices in
there too. :)

J.
