Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119E5C2D0F2
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 07:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1F282078B
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 07:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgDAH5N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 03:57:13 -0400
Received: from a3.inai.de ([88.198.85.195]:38992 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732046AbgDAH5M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 03:57:12 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id AEF815876E1B7; Wed,  1 Apr 2020 09:57:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id AE30160C62DC3;
        Wed,  1 Apr 2020 09:57:10 +0200 (CEST)
Date:   Wed, 1 Apr 2020 09:57:10 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
In-Reply-To: <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2004010955340.2411@n3.vanv.qr>
References: <20200331163559.132240-1-zenczykowski@gmail.com> <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr> <20200331181641.anvsbczqh6ymyrrl@salvia> <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2020-03-31 23:21, Maciej Żenczykowski wrote:

>Right, this is not in 5.6 as it's only in net-next atm as it was only
>merged very recently.

Sorry. I read between the lines and had picked up "v0 is not present" 
and erroneously applied that statement to the standard kernel.
