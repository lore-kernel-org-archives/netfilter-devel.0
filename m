Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B51FC4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 20:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0D160EB2
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 20:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhHNUxq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Aug 2021 16:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhHNUxp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Aug 2021 16:53:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BBBC061764
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Aug 2021 13:53:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mF0eY-00058G-Pl; Sat, 14 Aug 2021 22:53:14 +0200
Date:   Sat, 14 Aug 2021 22:53:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210814205314.GF607@breakpoint.cc>
References: <20210814174643.130760-1-fw@strlen.de>
 <84q02320-o5pp-8q8q-q646-473ssq92n552@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84q02320-o5pp-8q8q-q646-473ssq92n552@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> 
> On Saturday 2021-08-14 19:46, Florian Westphal wrote:
> > Conservative change:
> > iptables-nft -X will not remove empty builtin chains.
> > OTOH, maybe it would be better to auto-remove those too, if empty.
> > Comments?
> 
> How are chain policies expressed in nft, as a property on the
> chain (like legacy), or as a separate rule?
> That is significant when removing "empty" chains.

Indeed.  Since this removes the base chain, it implicitly reverts
a DROP policy too.

I wish that iptables-nft would do drop policy by DROP rule (then the
deletion would fail), but it does not.

As it stands, the only way to get rid of an iptables-nft added table
is via nft.  For -legacy its not even possible unless you can rmmod
the module, which is not always possible.

Sucks.  Any suggestions/idea?
