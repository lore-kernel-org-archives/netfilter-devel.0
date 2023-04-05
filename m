Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72554C7619A
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Apr 2023 13:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjDEN4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Apr 2023 09:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjDEN4o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2023 09:56:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6BA6CF
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Apr 2023 06:56:39 -0700 (PDT)
Date:   Wed, 5 Apr 2023 15:56:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 4/4] optimize: support for redirect and masquerade
Message-ID: <ZC1+FHKgwTsutKLH@salvia>
References: <20230405124801.365577-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230405124801.365577-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 05, 2023 at 02:48:01PM +0200, Pablo Neira Ayuso wrote:
> The redirect and masquerade statements can be handled as verdicts:
> 
> - if redirect statement specifies no ports.
> - masquerade statement, in any case.
> 
> Exceptions to the rule: If redirect statement specifies ports, then nat
> map transformation can be used iif both statements specify ports.

Now applied this series.
