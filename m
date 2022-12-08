Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BA5C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLHVXc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHVX3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:23:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 166E6F6E
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:23:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:23:25 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] scanner: handle files with CRLF line terminators
Message-ID: <Y5JVzQjSLS9UsDOn@salvia>
References: <20221208014151.529052-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208014151.529052-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 02:41:51AM +0100, Pablo Neira Ayuso wrote:
> Extend scanner.l to deal with CRLF, otherwise -f fails to load:
> 
>  # file test.nft
>  test.nft: ASCII text, with CRLF, LF line terminators
>  # nft -f test.nft
>  test.nft:1:13-13: Error: syntax error, unexpected junk
>  table ip x {
>              ^
> 
> Update full comment line to take CRLF too.
> 
> Add test to cover this usecase.

I am considering to keep back this patch. At quick glance, other
existing userspace tooling in Linux do not support for CRLF files.

I might follow up with a different approach: provide a more meaningful
error message, instead of saying "unexpected junk", report to the
users that the file contains CRLF and that needs to be fixed.
