Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEE3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Mar 2022 20:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbiCHUYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 15:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242196AbiCHUYV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 15:24:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CC4535870
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2022 12:23:24 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 27CC2608F3;
        Tue,  8 Mar 2022 21:21:30 +0100 (CET)
Date:   Tue, 8 Mar 2022 21:23:21 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH v2 0/3] conntrack: use libmnl for various operations
Message-ID: <Yie7OUJHUYePnhVn@salvia>
References: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 16, 2022 at 07:58:23PM +0100, Mikhail Sennikovsky wrote:
> Hi Pablo and all,
> 
> Here is the second version of the patches to switch to libmnl
> the remaining set of conntrack tool commands used in the load-file
> operation, adjusted to the latest master.

Applied, thanks for your patience.

I added a two extra preparation patches and rebased on top.
