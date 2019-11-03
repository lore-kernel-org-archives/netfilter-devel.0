Return-Path: <SRS0=L7DL=Y3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB51CA9EB0
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 19:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29D3B21744
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 19:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfKCTQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Nov 2019 14:16:51 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51442 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbfKCTQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Nov 2019 14:16:51 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iRLMn-00026I-IL; Sun, 03 Nov 2019 20:16:49 +0100
Date:   Sun, 3 Nov 2019 20:16:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: ebtables dnat rule gets system frozen
Message-ID: <20191103191649.GM876@breakpoint.cc>
References: <CAGnHSE=RxEesfAnzhHi+qteoWs1Mpc5BVWPn8zteEGqpTbgMeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnHSE=RxEesfAnzhHi+qteoWs1Mpc5BVWPn8zteEGqpTbgMeQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tom Yan <tom.ty89@gmail.com> wrote:
> Kernel version being 5.3.8, after adding a dnat rule (to the OUTPUT
> chain) with ebtables-nft in iptables 1.8.3, my system is frozen as
> soon as I ping anything. I couldn't catch anything with dmesg -w. Can
> anyone reproduce the same issue? I am on Arch Linux.

Yes, investigating.
