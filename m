Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431BFC4708E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 16:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjABQTv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 11:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbjABQTq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 11:19:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95CFDB1E0
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 08:19:45 -0800 (PST)
Date:   Mon, 2 Jan 2023 17:19:42 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_conntrack 1/2] conntrack: fix BPF code for
 filtering on big-endian architectures
Message-ID: <Y7MEHg8GCgxCO7Xb@salvia>
References: <20221223162441.2692988-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221223162441.2692988-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 04:24:40PM +0000, Jeremy Sowden wrote:
> The BPF for checking the subsystem ID looks for it in the righthand byte of
> `nlh->nlmsg_type`.  However, it will only be there on little-endian archi-
> tectures.  The result is that on big-endian architectures the subsystem ID
> doesn't match, all packets are immediately accepted, and all filters are
> ignored.

Applied, thanks
