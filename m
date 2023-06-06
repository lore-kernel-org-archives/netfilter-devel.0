Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBE4C77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 12:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjFFM0k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 08:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbjFFM0i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 08:26:38 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F210CC
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 05:26:35 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 64AF358787B8F; Tue,  6 Jun 2023 14:26:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 63D6B60C54824;
        Tue,  6 Jun 2023 14:26:34 +0200 (CEST)
Date:   Tue, 6 Jun 2023 14:26:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons v2 0/7] xt_ipp2p: support for non-linear
 packets
In-Reply-To: <20230605221044.140855-1-jeremy@azazel.net>
Message-ID: <s851r8o6-757r-q2p1-58rs-rp3691oq228@vanv.qr>
References: <20230605221044.140855-1-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2023-06-06 00:10, Jeremy Sowden wrote:

>xt_ipp2p currently requires that skb's are linear.  This series adds
>support for non-linear ones.

Applied. (Deleted some more whitespace.)
