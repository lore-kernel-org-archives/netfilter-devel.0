Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AA7C77B7E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Apr 2023 19:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjDZT6v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjDZT6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 15:58:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6D98D2
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2023 12:58:47 -0700 (PDT)
Date:   Wed, 26 Apr 2023 21:58:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <ZEmCdMVboNu6dKiL@calendula>
References: <Y90o8eq3egHbtC3Z@salvia>
 <Y900iRzf2q8xnXyv@orbyte.nwl.cc>
 <Y94oUYqArYqhkmOX@salvia>
 <Y97HaXaEtIlFUQSJ@orbyte.nwl.cc>
 <Y+DN2miPlSlBAIaj@salvia>
 <Y+IrUPyJi/GE6Cbk@salvia>
 <Y+Iudd7MODhgjrgz@orbyte.nwl.cc>
 <Y+4LoOjaT1RU6I1r@orbyte.nwl.cc>
 <Y+4Tmv3H24XTiEhK@salvia>
 <Y+4cBvcq7tH2Iw2t@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+4cBvcq7tH2Iw2t@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Feb 16, 2023 at 01:05:26PM +0100, Phil Sutter wrote:
> On Thu, Feb 16, 2023 at 12:29:30PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Feb 16, 2023 at 11:55:28AM +0100, Phil Sutter wrote:
> > > On Tue, Feb 07, 2023 at 11:56:53AM +0100, Phil Sutter wrote:
> > > [...]
> > > > Yes, please! I'll finish user space this week. :)
> > > 
> > > Famous last words. :(
> > > 
> > > I realized anonymous sets are indeed a problem, and I'm not sure how it
> > > could be solved. I missed the fact that with lookup expressions one has
> > > to run the init() callback to convert their per-batch set ID into the
> > > kernel-defined set name. So the simple "copy and return nla" approach is
> > > not sufficient.
> > > 
> > > Initializing all of the dump-only expressions though causes other
> > > unwanted side-effects, like e.g. duplicated chain use-counters.
> > > 
> > > One could ban lookup from being used in dump-only expressions. Right
> > > now, only ebtables' among match requires it.
> > > 
> > > To still allow for ebtables-nft to use the compat interface, among match
> > > could be rewritten to use the legacy extension in-kernel. This doesn't
> > > solve the original problem though, because old ebtables-nft versions
> > > can't parse a match expression containing among extension.
> > > 
> > > Another option that might work is to parse the dump-only expressions in
> > > nf_tables_newrule(), dump them into an skb, drop them again and extract
> > > the skb's buffer for later.
> > > 
> > > Do you have a better idea perhaps? I'm a bit clueless how to proceed
> > > further right now. :(
> > 
> > I'll drop the patch from nf-next and we take more time to think how to
> > solve this.
> 
> ACK!
> 
> > This problem is interesting, but it is difficult!
> 
> Yes, it is. Maybe a feasible solution is to scan through the dump-only
> expression nla and update any lookup ones manually. Pretty ugly though,
> because it breaks the attribute encapsulation in expressions.

My proposal:

- Add support for cookies, this is an identifier that the user can
  specify when the object is created, this is allocated by the user.
  We already discussed this in the past for different purpose. The idea
  would be to add a _COOKIE attribute to the objects, which is dumped
  via netlink.
- Add the alternative compat representation to the userdata, use the
  cookie identifier to refer to the anonymous set. By the time you
  create the anonymous set, you can already

With this approach, you add cookie support - which is something that
has been already discussed in the past - and you can use it from the
userdata to refer to the anonymous set.

If you fall back to the compat representation, then you look at the
userdata and, if there is a cookie reference, you can fetch the object
accordingly and put all pieces together to print the rule.

You could possibly make this without kernel updates? Add an internal
cookie field in userdata, that is included in the anonymous set. Then,
from the rule userdata, you refer to the internal cookie that refers
to the anonymous set. In such case, you can implement all what you
need from userspace, without kernel updates, to deal with this "forward
compatibility" requirement for the containers case.
