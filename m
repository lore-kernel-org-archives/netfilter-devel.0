Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BD6C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jun 2023 01:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjFMBDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 21:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjFMBDU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 21:03:20 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5852F101
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 18:03:19 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7118258765BCB; Tue, 13 Jun 2023 03:03:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 6DD7160C594EF;
        Tue, 13 Jun 2023 03:03:17 +0200 (CEST)
Date:   Tue, 13 Jun 2023 03:03:17 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] xt_ipp2p: change text-search algo to
 KMP
In-Reply-To: <20230612173133.795980-1-jeremy@azazel.net>
Message-ID: <0n5793p-s419-3n8q-r29p-57nspn92s981@vanv.qr>
References: <20230612173133.795980-1-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2023-06-12 19:31, Jeremy Sowden wrote:

>The kernel's Boyer-Moore text-search implementation may miss matches in
>non-linear skb's, so use Knuth-Morris-Pratt instead.

Applied
