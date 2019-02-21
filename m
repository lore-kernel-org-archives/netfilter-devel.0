Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B3CC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 15:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EBDE2077B
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 15:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfBUPMx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:12:53 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49516 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbfBUPMw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 10:12:52 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gwq1r-00009m-Fc; Thu, 21 Feb 2019 16:12:51 +0100
Date:   Thu, 21 Feb 2019 16:12:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: avoid same-timeout update
Message-ID: <20190221151251.ujjtvvz2m7k4e3zz@breakpoint.cc>
References: <20190221143829.7252-1-fw@strlen.de>
 <20190221150850.GS23745@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221150850.GS23745@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> >  void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
> >  			  const struct sk_buff *skb,
> > -			  unsigned long extra_jiffies, int do_acct);
> > +			  u32, bool do_acct);
> 
> Maybe not worth a respin, but this mix of named and unnamed parameters
> in function prototype is probably not intentional.

Right, its not -- I don't plan to send a v2 though.
