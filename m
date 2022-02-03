Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193F8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Feb 2022 12:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiBCMn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 07:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiBCMn5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 07:43:57 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A2EC061714
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Feb 2022 04:43:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nFbSt-0000Yv-Ix; Thu, 03 Feb 2022 13:43:56 +0100
Date:   Thu, 3 Feb 2022 13:43:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Vimal Agrawal <avimalin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        fw@strlen.dea, vimal.agrawal@sophos.com
Subject: Re: [PATCH] netfilter: nat: limit port clash resolution attempts
Message-ID: <20220203124355.GA19591@breakpoint.cc>
References: <20220203051329.118778-1-vimal.agrawal@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203051329.118778-1-vimal.agrawal@sophos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vimal Agrawal <avimalin@gmail.com> wrote:
> commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 ("netfilter: nat:
> limit port clash resolution attempts")

I've forwarded this to stable@ for inclusion into 4.14.y.

I've also sent a request for 4.19.y (applies with no changes) and
a backported version for 4.9.y.

4.4.y is EOL, so no action done in that department.
