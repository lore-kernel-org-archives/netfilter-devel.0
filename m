Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AFCC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1408A61029
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhHDLTt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbhHDLTs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 07:19:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931D9C0613D5
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Aug 2021 04:19:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mBEvu-0003zZ-KB; Wed, 04 Aug 2021 13:19:34 +0200
Date:   Wed, 4 Aug 2021 13:19:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH nf] netfilter: conntrack: remove offload_pickup sysctl
 again
Message-ID: <20210804111934.GE607@breakpoint.cc>
References: <20210804092549.1091-1-fw@strlen.de>
 <57d7336e-67a9-661e-e0ef-aa49ee08b8c5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d7336e-67a9-661e-e0ef-aa49ee08b8c5@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Oz Shlomo <ozsh@nvidia.com> wrote:
> > When flow transitions back from offload to software, also clear the
> > ASSURED bit -- this allows conntrack to early-expire the entry in case
> > the table is full.
> 
> Doesn't this introduce a discrpency between offloaded and non-offload connections?
> IIUC, offloaded connections might timeout earlier after they are picked up
> by the software when the conntrack table is full.

Yes, if no packet was seen after the flow got moved back to software and
a new connection request is made while table is full.

> However, if the same tcp connection was not offloaded it would timeout after 5 days.

Yes.  The problem is that AFAIU HW may move flow back to SW path after
it saw e.g. FIN bit, or after one side went silent (i.e., unacked data).

And and in that case, SW path has a lot smaller timeout than the 5day
established value.

AFAICS there is no way to detect this on generic side and it might even
be different depending on hw/driver?
