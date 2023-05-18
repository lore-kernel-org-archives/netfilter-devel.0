Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806C0C7EE24
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjERJcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjERJce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:32:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33574211F
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:32:25 -0700 (PDT)
Date:   Thu, 18 May 2023 11:32:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrackd 1/3] build: don't suppress various warnings
Message-ID: <ZGXwpTAEY2r7jBEw@calendula>
References: <20230518091803.90494-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230518091803.90494-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 18, 2023 at 11:17:59AM +0200, Pablo Neira Ayuso wrote:
> From: Sam James <sam@gentoo.org>
> 
> These will become fatal with Clang 16 and GCC 14 anyway, but let's
> address the real problem (followup commit).
> 
> We do have to keep one wrt yyerror() & const char * though, but
> the issue is contained to the code Bison generates.

Scratch this, this one is old, sorry for the noise.
