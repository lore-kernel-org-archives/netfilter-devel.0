Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5031CC64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 09:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCIJ1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 04:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCIJ1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 04:27:22 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56344E190D
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2023 01:27:21 -0800 (PST)
Date:   Thu, 9 Mar 2023 10:27:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 0/4] NAT fixes
Message-ID: <ZAmmdikdFvL6rYhy@salvia>
References: <20230307232259.2681135-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307232259.2681135-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 07, 2023 at 11:22:55PM +0000, Jeremy Sowden wrote:
> These bug-fixes were originally part of a larger series adding shifted
> port-ranges to nft NAT and targetting nf-next, but Florian suggested
> sending them via nf instead to get them upstream more quickly.

Applied to nf.git, thanks
