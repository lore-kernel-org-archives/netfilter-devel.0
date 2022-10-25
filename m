Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1804C38A2D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 10:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiJYKhn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 06:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiJYKhl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 06:37:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C36C8BA260
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2022 03:37:39 -0700 (PDT)
Date:   Tue, 25 Oct 2022 12:37:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ian Pilcher <arequipeno@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] libnftnl: Fix res_id byte order
Message-ID: <Y1e8blqSWB9p86KB@salvia>
References: <20221018164528.250049-1-arequipeno@gmail.com>
 <20221018164528.250049-2-arequipeno@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221018164528.250049-2-arequipeno@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 18, 2022 at 11:45:28AM -0500, Ian Pilcher wrote:
> The res_id member of struct nfgenmsg is supposed to be in network
> byte order (big endian).  Call htons() in __nftnl_nlmsg_build_hdr()
> to ensure that this is true on little endian systems.

Applied to libnftnl, thanks.
