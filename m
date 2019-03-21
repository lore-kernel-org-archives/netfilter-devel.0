Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3595CC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 08:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F701218D3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 08:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfCUIpT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 04:45:19 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34616 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfCUIpT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 04:45:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h6tK8-0004Fy-7W; Thu, 21 Mar 2019 09:45:16 +0100
Date:   Thu, 21 Mar 2019 09:45:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>,
        Karuna Grewal <karunagrewal98@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: Implementing Deletion of Set Elements in Rulesets
Message-ID: <20190321084516.6qmr23meelir7uc3@breakpoint.cc>
References: <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
 <20190321082304.GH4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321082304.GH4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Hi Karuna,
> 
> On Thu, Mar 21, 2019 at 11:57:15AM +0530, Karuna Grewal wrote:
> > I'm trying to implement  "deletion of set elements in ruleset". For
> > which I wanted to understand the way existing set operations are
> > implemented.
> 
> What are you trying to achieve? Anonymous sets are immutable by design.
> If you want to add/delete set elements, you can create a named set and
> reference that from rules. See nftables wiki[1] for examples of usage.

This is about deletion of elements from the packet path in dynamic
sets, see https://people.netfilter.org/pablo/nf-ideas-2019.txt, 1.4 .
