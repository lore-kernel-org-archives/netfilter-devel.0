Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957D3C55ABD
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442CF206B6
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgKJMZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKJMZu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:25:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC258C0613CF;
        Tue, 10 Nov 2020 04:25:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kcSiU-0002H9-NU; Tue, 10 Nov 2020 13:25:42 +0100
Date:   Tue, 10 Nov 2020 13:25:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Numan Siddique <nusiddiq@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, ovs dev <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp
 flag - BE_LIBERAL per-ct basis.
Message-ID: <20201110122542.GG23619@breakpoint.cc>
References: <20201109072930.14048-1-nusiddiq@redhat.com>
 <20201109213557.GE23619@breakpoint.cc>
 <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Numan Siddique <nusiddiq@redhat.com> wrote:
> On Tue, Nov 10, 2020 at 3:06 AM Florian Westphal <fw@strlen.de> wrote:
> Thanks for the comments. I actually tried this approach first, but it
> doesn't seem to work.
> I noticed that for the committed connections, the ct tcp flag -
> IP_CT_TCP_FLAG_BE_LIBERAL is
> not set when nf_conntrack_in() calls resolve_normal_ct().

Yes, it won't be set during nf_conntrack_in, thats why I suggested
to do it before confirming the connection.

> Would you expect that the tcp ct flags should have been preserved once
> the connection is committed ?

Yes, they are preserved when you set them after nf_conntrack_in(), else
we would already have trouble with hw flow offloading which needs to
turn off window checks as well.
