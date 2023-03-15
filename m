Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77144C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 11:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCOLk1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 07:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOLk0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 07:40:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53C29E1AF
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 04:40:25 -0700 (PDT)
Date:   Wed, 15 Mar 2023 12:40:22 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnftnl] expr: meta: introduce broute meta expression
Message-ID: <ZBGuphuuWYuLXDD3@salvia>
References: <20230226095308.12940-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230226095308.12940-1-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 26, 2023 at 10:53:08AM +0100, Sriram Yagnaraman wrote:
> libnftnl support for broute meta statement introduced in [1].
> [1]:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230224095251.11249-1-sriram.yagnaraman@est.tech/

Applied to libnftnl, thanks
