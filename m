Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F2C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiF1RCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiF1RCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 13:02:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E30E286DE
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 10:01:55 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:01:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: avoid skb access on nf_stolen
Message-ID: <Yrsz88r5osn6nirQ@salvia>
References: <20220622144357.20162-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220622144357.20162-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 22, 2022 at 04:43:57PM +0200, Florian Westphal wrote:
> When verdict is NF_STOLEN, the skb might have been freed.
> 
> When tracing is enabled, this can result in a use-after-free:
> 1. access to skb->nf_trace
> 2. access to skb->mark
> 3. computation of trace id
> 4. dump of packet payload
> 
> To avoid 1, keep a cached copy of skb->nf_trace in the
> trace state struct.
> Refresh this copy whenever verdict is != STOLEN.
> 
> Avoid 2 by skipping skb->mark access if verdict is STOLEN.
> 
> 3 is avoided by precomputing the trace id.
> 
> Only dump the packet when verdict is not "STOLEN".

Applied, thanks
