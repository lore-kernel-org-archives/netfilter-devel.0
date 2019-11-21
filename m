Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44958C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 05:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205C220872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 05:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfKUFdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 00:33:49 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38119 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbfKUFdt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 00:33:49 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 414E63A2383
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 16:33:34 +1100 (AEDT)
Received: (qmail 12136 invoked by uid 501); 21 Nov 2019 05:33:34 -0000
Date:   Thu, 21 Nov 2019 16:33:34 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <20191121053334.GB12786@dimstar.local.net>
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191120230942.GA12786@dimstar.local.net>
 <20191120232617.GH20235@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120232617.GH20235@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=Cn04F0WcHO2DFO5E6CoA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 12:26:17AM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > Deprecated nfq_set_queue_flags documents flag NFQA_CFG_F_FAIL_OPEN for kernel to
> > accept packets if the kernel queue gets full.
> >
> > Does this still work with libmnl?
>
> Yes.
> > I'm thinking we need a new "Library Setup
> > [CURRENT]" section to document available flags (including e.g. NFQA_CFG_F_GSO
> > that examples/nf-queue.c uses).
>
> Makes sense, thanks.
>
> > Maybe we need Attribute helper functions as well? (documentation *and* new
> > code).
>
> If you think it makes it easier, sure, why not.
> But it would be something like this:
>
> void nfq_nlmsg_cfg_put_flags(struct nlmsghdr *nlh, uint32_t flags)
> {
>         mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
>         mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
> }
>
> I'm not sure that warrants a library helper.

Many of the existing helper functions are 2-liners, some even 1 line. These
little functions often have more lines of doxygen documentation than of code.

So I think the extra helpers would fit in fine.

Cheers ... Duncan.
