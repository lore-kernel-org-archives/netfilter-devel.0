Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE29C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 20:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjFEUgi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 16:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjFEUgh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 16:36:37 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE8E94
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 13:36:35 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 0F08F587493C2; Mon,  5 Jun 2023 22:36:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0D22760D48F85;
        Mon,  5 Jun 2023 22:36:34 +0200 (CEST)
Date:   Mon, 5 Jun 2023 22:36:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 5/8] xt_ipp2p: rearrange some conditionals
 and a couple of loops
In-Reply-To: <20230605191735.119210-6-jeremy@azazel.net>
Message-ID: <9qn76633-qp55-3q8n-osn7-p26s3ss2rsqq@vanv.qr>
References: <20230605191735.119210-1-jeremy@azazel.net> <20230605191735.119210-6-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2023-06-05 21:17, Jeremy Sowden wrote:

>Reduce indentation and improve the readability of the code.

Applying patch extensions/xt_ipp2p.c with 3 rejects...
Hunk #1 applied cleanly.
Hunk #2 applied cleanly.
Rejected hunk #3.
Hunk #4 applied cleanly.
Hunk #5 applied cleanly.
Hunk #6 applied cleanly.
Hunk #7 applied cleanly.
Rejected hunk #8.
Hunk #9 applied cleanly.
Rejected hunk #10.
Hunk #11 applied cleanly.
Hunk #12 applied cleanly.
Hunk #13 applied cleanly.
Hunk #14 applied cleanly.
Patch failed at 0001 xt_ipp2p: rearrange some conditionals and a couple of loops
hint: Use 'git am --show-current-patch=diff' to see the failed patch
