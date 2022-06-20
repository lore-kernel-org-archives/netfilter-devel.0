Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD20C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 15:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbiFTPG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243022AbiFTPGn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 11:06:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 572212253F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 07:44:02 -0700 (PDT)
Date:   Mon, 20 Jun 2022 16:42:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH v2 1/1] conntrack: use same modifier socket for bulk ops
Message-ID: <YrCHXW+vfb97BQYe@salvia>
References: <20220609204142.54700-1-mikhail.sennikovskii@ionos.com>
 <20220609204142.54700-2-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220609204142.54700-2-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 09, 2022 at 10:41:42PM +0200, Mikhail Sennikovsky wrote:
> For bulk ct entry loads (with -R option) reusing the same mnl
> modifier socket for all entries results in reduction of entries
> creation time, which becomes especially signifficant when loading
> tens of thouthand of entries.

Applied, thanks.
