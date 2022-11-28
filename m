Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93E7C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Nov 2022 16:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiK1QU0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 11:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiK1QU0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 11:20:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AA6810566
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2022 08:20:24 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:20:20 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_pipapo: Actually validate intervals in fields
 after the first one
Message-ID: <Y4TfxJ/Ir6Jg1t9v@salvia>
References: <20221124120437.244114-1-sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221124120437.244114-1-sbrivio@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 01:04:37PM +0100, Stefano Brivio wrote:
> Embarrassingly, nft_pipapo_insert() checked for interval validity in
> the first field only.
> 
> The start_p and end_p pointers were reset to key data from the first
> field at every iteration of the loop which was supposed to go over
> the set fields.

Applied to nf, thanks
