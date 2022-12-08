Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E5DC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLHVpa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHVp3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:45:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56A4E76804
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:45:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:45:25 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Robert O'Brien <robrien@foxtrot-research.com>
Subject: Re: [PATCH ulogd2 2/3] output: add missing support for int64_t values
Message-ID: <Y5Ja9cH4A5MXRViS@salvia>
References: <20221127002300.191936-1-jeremy@azazel.net>
 <20221127002300.191936-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221127002300.191936-3-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 27, 2022 at 12:22:59AM +0000, Jeremy Sowden wrote:
> Some of the output plug-ins don't handle 64-bit signed values.
> 
> Fix formatting of OPRINT switch.

Also applied, thanks
