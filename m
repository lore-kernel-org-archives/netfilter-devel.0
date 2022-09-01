Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E725ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 12:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiIAMq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiIAMqV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 08:46:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1115872EFA
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 05:46:20 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:46:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] json: add set statement list support
Message-ID: <YxCpmbRsuZmtGvY7@salvia>
References: <20220901103143.87974-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220901103143.87974-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 01, 2022 at 12:31:43PM +0200, Fernando Fernandez Mancera wrote:
> When listing a set with statements with JSON support, the statements were
> ignored.
> 
> Output example:
> 
> {
>   "set": {
>     "op": "add",
>     "elem": {
>       "payload": {
>         "protocol": "ip",
>         "field": "saddr"
>       }
>     },
>     "stmt": [
>       {
>         "limit": {
>           "rate": 10,
>           "burst": 5,
>           "per": "second"
>         }
>       },
>       {
>         "counter": {
>           "packets": 0,
>           "bytes": 0
>         }
>       }
>     ],
>     "set": "@my_ssh_meter"
>   }
> }

Applied, thanks
