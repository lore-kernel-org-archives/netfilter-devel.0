Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D67C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 15:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbiFTPHL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiFTPGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 11:06:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F81E22BF0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 07:44:30 -0700 (PDT)
Date:   Mon, 20 Jun 2022 16:44:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Bill Wendling <morbo@google.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 12/12] netfilter: conntrack: use correct format characters
Message-ID: <YrCHtmZlK384yiCo@salvia>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609221702.347522-13-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220609221702.347522-13-morbo@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 09, 2022 at 10:16:31PM +0000, Bill Wendling wrote:
> From: Bill Wendling <isanbard@gmail.com>
> 
> When compiling with -Wformat, clang emits the following warnings:
> 
> net/netfilter/nf_conntrack_helper.c:168:18: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
>                 request_module(mod_name);
>                                ^~~~~~~~
> 
> Use a string literal for the format string.

Should I handle this through the netfilter tree? Or you prefer a
different path?

Thanks
