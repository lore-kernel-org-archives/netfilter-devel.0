Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0045C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 12:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbiDZNBZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 09:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350326AbiDZNBP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 09:01:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6616525588
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 05:58:05 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:58:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] configure: add an option to compile the examples
Message-ID: <YmfsWQ++9p5PdeGp@salvia>
References: <20220425160513.5343-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220425160513.5343-1-dariobin@libero.it>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 25, 2022 at 06:05:13PM +0200, Dario Binacchi wrote:
> Using a configure option to compile the examples is a more common
> practice. This can also increase library usage (e.g. buildroot would
> now be able to install such applications on the created rootfs).

From context, I assume this is for libmnl.

If you run `make' it does not compile the examples.
