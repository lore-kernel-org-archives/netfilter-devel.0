Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A95C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 08:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AEF2218A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 08:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfCUIXJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 04:23:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39310 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCUIXI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 04:23:08 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h6sye-0004PG-AV; Thu, 21 Mar 2019 09:23:04 +0100
Date:   Thu, 21 Mar 2019 09:23:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: Implementing Deletion of Set Elements in Rulesets
Message-ID: <20190321082304.GH4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Karuna Grewal <karunagrewal98@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Karuna,

On Thu, Mar 21, 2019 at 11:57:15AM +0530, Karuna Grewal wrote:
> I'm trying to implement  "deletion of set elements in ruleset". For
> which I wanted to understand the way existing set operations are
> implemented.

What are you trying to achieve? Anonymous sets are immutable by design.
If you want to add/delete set elements, you can create a named set and
reference that from rules. See nftables wiki[1] for examples of usage.

Cheers, Phil

[1] https://wiki.nftables.org/wiki-nftables/index.php/Sets#Named_sets
