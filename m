Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41227C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 22:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbiAIWbf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 17:31:35 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41964 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbiAIWbf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 17:31:35 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 42ECB62BD8;
        Sun,  9 Jan 2022 23:28:44 +0100 (CET)
Date:   Sun, 9 Jan 2022 23:31:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] netfilter: conntrack: Use max() instead of doing it
 manually
Message-ID: <YdtiQdssBCOwAxyX@salvia>
References: <20211225171241.119887-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211225171241.119887-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Dec 26, 2021 at 01:12:41AM +0800, Jiapeng Chong wrote:
> Fix following coccicheck warning:
> 
> ./include/net/netfilter/nf_conntrack.h:282:16-17: WARNING opportunity
> for max().

Applied to nf-next.
