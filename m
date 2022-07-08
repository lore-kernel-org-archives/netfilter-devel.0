Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F7BC43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 11:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiGHLTy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbiGHLTy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 07:19:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B1F7904C6
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 04:19:53 -0700 (PDT)
Date:   Fri, 8 Jul 2022 13:19:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH v2 0/3] conntrack: -A command implementation
Message-ID: <YsgS1igc2tqiV6Z+@salvia>
References: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 07:09:38PM +0200, Mikhail Sennikovsky wrote:
> Hi Pablo & all,
> 
> As discussed, here is an updated patch set for the -A command
> support.
> As you requested it introduces a separate CT_ADD command now.
> In order to do that cleanly and error-safe I had to do two
> preparation steps, which are included as two separate commits
> with detailed description on each.

Series applied, thanks
