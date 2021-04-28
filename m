Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0B8C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F08D161151
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhD1NYZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbhD1NYZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:24:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F805C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:23:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lbkAE-0004Tm-CG; Wed, 28 Apr 2021 15:23:38 +0200
Date:   Wed, 28 Apr 2021 15:23:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST check
Message-ID: <20210428132338.GF975@breakpoint.cc>
References: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ali Abdallah <ali.abdallah@suse.com> wrote:
> In 'commit b303e7b80ff1 ("Reset the max ACK flag on SYN in ignore state")'
> we reset the max ACK number to avoid dropping valid RST that is a
> response to a SYN.
> 
> Unfortunately that might not be enough, an out of order ACK in origin
> might reset it back, and we might end up again dropping valid RST.
> 
> This patch disables the RST check when we are not in established state
> and  we receive an RST with SEQ=0 that is most likely a response to a
> SYN we had let it go through.
> 
> Signed-off-by: Ali Abdallah <aabdallah@suse.de>

Looks good, thanks!

Acked-by: Florian Westphal <fw@strlen.de>
