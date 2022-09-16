Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5E3ECAAD8
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Sep 2022 07:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIPHjm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Sep 2022 03:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiIPHjl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Sep 2022 03:39:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EAAD10FFB
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2022 00:39:40 -0700 (PDT)
Date:   Fri, 16 Sep 2022 09:39:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: add stateful object comment support
Message-ID: <YyQoOllugfksZDjQ@salvia>
References: <20220910221114.74863-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220910221114.74863-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 11, 2022 at 12:11:14AM +0200, Fernando Fernandez Mancera wrote:
> When listing a stateful object with JSON support, the comment was ignored.
> 
> Output example:
> 
> {
>   "counter": {
>     "family": "inet",
>     "name": "mycounter",
>     "table": "t",
>     "handle": 1,
>     "comment": "my comment in counter",
>     "packets": 0,
>     "bytes": 0
>   }
> }

Applied, thanks
