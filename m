Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE81C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 14:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbjH2OdU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 10:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbjH2OdR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 10:33:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F22F7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 07:33:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qazmJ-00024P-TM; Tue, 29 Aug 2023 16:33:11 +0200
Date:   Tue, 29 Aug 2023 16:33:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Victor Julien <victor@inliniac.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] doc: fix example of xt_cpu
Message-ID: <20230829143311.GB2029@breakpoint.cc>
References: <20230829125932.31735-1-victor@inliniac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829125932.31735-1-victor@inliniac.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Victor Julien <victor@inliniac.net> wrote:
> REDIRECT uses --to-ports instead of --to-port.

Applied, thanks Victor!
