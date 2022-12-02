Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F3FC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Dec 2022 09:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiLBJSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Dec 2022 04:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBJSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2022 04:18:51 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3ECA47E1;
        Fri,  2 Dec 2022 01:18:47 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C1323586FABC1; Fri,  2 Dec 2022 10:18:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C06EC60D33E5A;
        Fri,  2 Dec 2022 10:18:44 +0100 (CET)
Date:   Fri, 2 Dec 2022 10:18:44 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
cc:     Li Qiong <liqiong@nfschina.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] netfilter: initialize 'ret' variable
In-Reply-To: <Y4mljMYvNh7zHlOh@ZenIV>
Message-ID: <3p77q27-8495-sss2-3r38-r1448nqsoop@vanv.qr>
References: <20221202070331.10865-1-liqiong@nfschina.com> <Y4mljMYvNh7zHlOh@ZenIV>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Friday 2022-12-02 08:13, Al Viro wrote:

>On Fri, Dec 02, 2022 at 03:03:31PM +0800, Li Qiong wrote:
>> The 'ret' should need to be initialized to 0, in case
>> return a uninitialized value.
>
>Why is 0 the right value?  And which case would it be?
>We clearly need to know that to figure out which return
>value would be correct for it...

Judging from the error-handling branches,
it should be ret = NF_ACCEPT.

