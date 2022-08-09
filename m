Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259E7C25B0C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 17:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbiHIRvv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 13:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiHIRvv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 13:51:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D2DD140A3;
        Tue,  9 Aug 2022 10:51:49 -0700 (PDT)
Date:   Tue, 9 Aug 2022 19:51:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [RESEND (v2) PATCH] netfilter: Fix a typo in a comment
Message-ID: <YvKesQmKUM5SyvVq@salvia>
References: <ad1d4dafc856ace9613050e6ac60c9f297f0a87d.1659799260.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad1d4dafc856ace9613050e6ac60c9f297f0a87d.1659799260.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 06, 2022 at 05:39:20PM +0200, Christophe JAILLET wrote:
> s/_IPT_LOG_H/_IP6T_LOG_H/
> 
> While at it add some surrounding space to ease reading.

Applied, thanks
