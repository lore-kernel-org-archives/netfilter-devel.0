Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683DEC77B70
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Apr 2023 10:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDQKYm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Apr 2023 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDQKYl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2023 06:24:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 857795FD8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Apr 2023 03:23:47 -0700 (PDT)
Date:   Mon, 17 Apr 2023 12:22:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix ifdef to also consider
 nf_tables=m
Message-ID: <ZD0d1Y7/tbwipLYp@calendula>
References: <20230417082136.6123-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230417082136.6123-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 17, 2023 at 10:21:36AM +0200, Florian Westphal wrote:
> nftables can be built as a module, so fix the preprocessor conditional
> accordingly.

LGTM, applied to nf.git, thanks.
