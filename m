Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83057C3DA78
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 15:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjAQPUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 10:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjAQPTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 10:19:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6DFD3FF0A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 07:19:49 -0800 (PST)
Date:   Tue, 17 Jan 2023 16:19:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sbrivio@redhat.com
Subject: Re: [PATCH nf,v2 1/2] netfilter: nft_set_rbtree: Switch to node list
 walk for overlap detection
Message-ID: <Y8a8kkCJZlG58kWB@salvia>
References: <20230117112800.52379-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230117112800.52379-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 17, 2023 at 12:27:59PM +0100, Pablo Neira Ayuso wrote:
[...]
> Otherwise, with large sets, starting from rb_first() is slow (it takes
> 30s if I use rb_first() instead of this approach), because of the linear
> list walk.

This should be instead:

        Otherwise, with large sets, starting from rb_first() is slow (it takes
        30s if I use rb_first() instead of 3s), because of the linear list
        walk.

so it is 3 seconds with the speed up vs. 30 seconds starting from rb_first().
