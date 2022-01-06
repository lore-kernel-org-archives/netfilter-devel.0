Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1528DC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 09:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiAFJkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 04:40:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:34702 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiAFJkY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 04:40:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C7A7263F4F;
        Thu,  6 Jan 2022 10:37:35 +0100 (CET)
Date:   Thu, 6 Jan 2022 10:40:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: fix refcount leak in
 clusterip_tg_check()
Message-ID: <Yda5AhpTTnsTnNp5@salvia>
References: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 23, 2021 at 10:48:12AM +0800, Xin Xiong wrote:
> The issue takes place in one error path of clusterip_tg_check(). When
> memcmp() returns nonzero, the function simply returns the error code,
> forgetting to decrease the reference count of a clusterip_config
> object, which is bumped earlier by clusterip_config_find_get(). This
> may incur reference count leak.
> 
> Fix this issue by decrementing the refcount of the object in specific
> error path.

Applied
