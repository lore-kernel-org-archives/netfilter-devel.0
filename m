Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4C6C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3094E613FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhD0UhI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 16:37:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54236 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhD0UhH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 16:37:07 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BF12363E85;
        Tue, 27 Apr 2021 22:35:45 +0200 (CEST)
Date:   Tue, 27 Apr 2021 22:36:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] netfilter: nft_socket: fix build with
 CONFIG_SOCK_CGROUP_DATA=n
Message-ID: <20210427203620.GB14154@salvia>
References: <20210427194528.2325108-1-arnd@kernel.org>
 <20210427194528.2325108-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427194528.2325108-2-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 27, 2021 at 09:45:19PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> In some configurations, the sock_cgroup_ptr() function is not available:
> 
> net/netfilter/nft_socket.c: In function 'nft_sock_get_eval_cgroupv2':
> net/netfilter/nft_socket.c:47:16: error: implicit declaration of function 'sock_cgroup_ptr'; did you mean 'obj_cgroup_put'? [-Werror=implicit-function-declaration]
>    47 |         cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
>       |                ^~~~~~~~~~~~~~~
>       |                obj_cgroup_put
> net/netfilter/nft_socket.c:47:14: error: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
>    47 |         cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
>       |              ^
> 
> Change the caller to match the same #ifdef check, only calling it
> when the function is defined.
> 
> Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I don't actually know what the right fix is for this, I only checked
> that my patch fixes the build failure. Is is possible that the function
> should always be defined.
> 
> Please make sure you review carefully before applying.

LGTM.

Applied, thanks Arnd.
