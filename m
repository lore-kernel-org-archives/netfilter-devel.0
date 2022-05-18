Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4077C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 13:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiERN4u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 09:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbiERN4Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 09:56:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3A54B29
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 06:56:24 -0700 (PDT)
Date:   Wed, 18 May 2022 15:56:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ritaro Takenaka <ritarot634@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nf_flowtable: move dst_check to packet path
Message-ID: <YoT7BaLzml2Y8L+L@salvia>
References: <20220517100041.966527-1-ritarot634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517100041.966527-1-ritarot634@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 07:00:43PM +0900, Ritaro Takenaka wrote:
> Fixes sporadic IPv6 packet loss when flow offloading is enabled.
> 
> IPv6 route GC and flowtable GC are not synchronized.
> When dst_cache becomes stale and a packet passes through the flow before
> the flowtable GC teardowns it, the packet can be dropped.
> So, it is necessary to check dst every time in packet path.

Applied to nf.git, thanks
