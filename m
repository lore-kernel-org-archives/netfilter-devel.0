Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CDBC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 20:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLHUqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 15:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHUqR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 15:46:17 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E435818E32;
        Thu,  8 Dec 2022 12:46:16 -0800 (PST)
Date:   Thu, 8 Dec 2022 21:46:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: really fix NAT IPv6 offload
Message-ID: <Y5JNFcUp2JrmgVfR@salvia>
References: <20221208123529.567883-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208123529.567883-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 08:35:29PM +0800, Qingfang DENG wrote:
> The for-loop was broken from the start. It translates to:
> 
> 	for (i = 0; i < 4; i += 4)
> 
> which means the loop statement is run only once, so only the highest
> 32-bit of the IPv6 address gets mangled.
> 
> Fix the loop increment.

Applied, thanks
