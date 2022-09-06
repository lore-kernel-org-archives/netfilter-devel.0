Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C991ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Sep 2022 08:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiIFIMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Sep 2022 04:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiIFIMP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2022 04:12:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7A8845F66
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2022 01:12:10 -0700 (PDT)
Date:   Tue, 6 Sep 2022 10:12:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] json: fix empty statement list output in sets and
 maps
Message-ID: <YxcA1UPjZDaofklI@salvia>
References: <20220904171826.74525-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220904171826.74525-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 04, 2022 at 07:18:26PM +0200, Fernando Fernandez Mancera wrote:
> JSON output of sets and map should not include the statements list if is
> empty. The statement output should be stateless also.
> 
> In addition, removes duplicated code.

Applied, thanks
