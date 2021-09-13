Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910F0C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 751AD61056
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbhIMRVR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhIMRVQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 13:21:16 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCCCC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 10:19:59 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 3274D586B1ADE; Mon, 13 Sep 2021 19:19:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2EFDD6168D59E;
        Mon, 13 Sep 2021 19:19:55 +0200 (CEST)
Date:   Mon, 13 Sep 2021 19:19:55 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: Re: [xtables-addons 0/4] IPv6 support for xt_ipp2p
In-Reply-To: <20210913092051.79743-1-jeremy@azazel.net>
Message-ID: <83548n8s-q86s-7ps7-p054-n887o729o629@vanv.qr>
References: <20210913092051.79743-1-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2021-09-13 11:20, Jeremy Sowden wrote:

>* The first patch short-circuits searches if the packet is empty.
>* The second and third patches refactor the ipv4 code in anticipation of
>  adding ipv6 support.
>* The fourth patch adds ipv6 support.

Added it.
