Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71A5EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 11:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbjGMLIR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 07:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbjGMLIC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 07:08:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A7A273A
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jul 2023 04:07:41 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qJuAa-0007ID-Ef; Thu, 13 Jul 2023 13:07:36 +0200
Date:   Thu, 13 Jul 2023 13:07:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, igor@gooddata.com
Subject: Re: [PATCH iptables] nft-bridge: pass context structure to
 ops->add() to improve anonymous set support
Message-ID: <ZK/a+LkEDbcAcZDZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, igor@gooddata.com
References: <20230712095912.140792-1-pablo@netfilter.org>
 <ZK7fTtDVp61+7byX@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK7fTtDVp61+7byX@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 12, 2023 at 07:13:50PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 12, 2023 at 11:59:12AM +0200, Pablo Neira Ayuso wrote:
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index 1cb104e75ccc..59e3fa7079c4 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> [...]
> > @@ -2878,6 +2888,9 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
> >  {
> >  	struct iptables_command_state cs = {};
> >  	struct nftnl_rule *r, *new_rule;
> > +	struct nft_rule_ctx ctx = {
> > +		.command = NFT_COMPAT_RULE_ZERO,
> 
> BTW. I changed this to:
> 
>                 .command = NFT_COMPAT_RULE_APPEND,
> 
> before pushing it out, for the record.

Hmm. :)

I'm curious how to trigger the problem. Could you please provide a
test-case?

Thanks, Phil
