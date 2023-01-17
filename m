Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1BCC3DA78
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 11:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbjAQLrV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 06:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbjAQLrT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 06:47:19 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE37830B23
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 03:47:18 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:47:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH 1/3] netfilter: conntrack: fix vtag checks for
 ABORT/SHUTDOWN_COMPLETE
Message-ID: <Y8aKxEwgkMDMvx1i@salvia>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
 <20230116093556.9437-2-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230116093556.9437-2-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 16, 2023 at 10:35:54AM +0100, Sriram Yagnaraman wrote:
> RFC 9260, Sec 8.5.1 states that for ABORT/SHUTDOWN_COMPLETE, the chunk
> MUST be accepted if the vtag of the packet matches its own tag and the
> T bit is not set OR if it is set to its peer's vtag and the T bit is set
> in chunk flags. Otherwise the packet MUST be silently dropped.
> 
> Update vtag verification for ABORT/SHUTDOWN_COMPLETE based on the above
> description.

I suspect this is broken since the beginning? Then a good Fixes: tag
candidate it...

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")

?
