Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5F8C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 10:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B134B60EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 10:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhHPK5Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhHPK5P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 06:57:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857C3C061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 03:56:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mFaIL-0005IH-Sf; Mon, 16 Aug 2021 12:56:41 +0200
Date:   Mon, 16 Aug 2021 12:56:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     alexandre.ferrieux@orange.com
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <20210816105641.GM607@breakpoint.cc>
References: <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
 <20210816090555.GA2364@salvia>
 <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

alexandre.ferrieux@orange.com <alexandre.ferrieux@orange.com> wrote:
> Well, the problem is backwards compatibility. Indeed I'd propose more
> flexible batching via an array of ids instead of a maxid. But the main added
> value of this flexibility is to enable reused-small-integers ids, like file
> descriptors. As long as the maxid API remains in place, this is impossible.

You cannot remove the maxid API.
