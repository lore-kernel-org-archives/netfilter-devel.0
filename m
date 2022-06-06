Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6137C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jun 2022 15:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240912AbiFFPex (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240842AbiFFPej (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 11:34:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFFEF35AA7;
        Mon,  6 Jun 2022 08:34:37 -0700 (PDT)
Date:   Mon, 6 Jun 2022 17:34:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netfilter-devel@vger.kernel.org, linux-spdx@vger.kernel.org,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: netfilter: xtables: Bring SPDX identifier back
Message-ID: <Yp4eiv4xUhWc2VEx@salvia>
References: <87ee016cji.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ee016cji.ffs@tglx>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 06, 2022 at 05:23:45PM +0200, Thomas Gleixner wrote:
> Commit e2be04c7f995 ("License cleanup: add SPDX license identifier to
> uapi header files with a license") added the correct SPDX identifier to
> include/uapi/linux/netfilter/xt_IDLETIMER.h.
> 
> A subsequent commit removed it for no reason and reintroduced the UAPI
> license incorrectness as the file is now missing the UAPI exception
> again.
> 
> Add it back and remove the GPLv2 boilerplate while at it.

LGTM.

You handle this or I place this in the nf.git tree?

Thanks
