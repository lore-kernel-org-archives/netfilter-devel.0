Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4821C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 10:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiF0KEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiF0KET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 06:04:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB6CBDE8
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 03:04:18 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:04:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH v2 0/3] conntrack: fixes for handling unknown protocols
Message-ID: <YrmAnaL6vkPPwmen@salvia>
References: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 24, 2022 at 05:01:23PM +0200, Mikhail Sennikovsky wrote:
[...]
> Here is the updated patch set addressing your comments.

Series applied, thanks
