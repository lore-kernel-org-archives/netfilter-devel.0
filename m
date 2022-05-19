Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFB5C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 20:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244712AbiESUlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 16:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244702AbiESUlQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 16:41:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CC0318B18
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 13:41:15 -0700 (PDT)
Date:   Thu, 19 May 2022 22:41:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        syzbot+4903218f7fba0a2d6226@syzkaller.appspotmail.com,
        syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com
Subject: Re: [PATCH nf-next] netfilter: nfnetlink: fix warn in
 nfnetlink_unbind
Message-ID: <YoaraJtfL87/xy5/@salvia>
References: <20220517192111.2080-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517192111.2080-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 09:21:11PM +0200, Florian Westphal wrote:
> syzbot reports following warn:
> WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694
> 
> The syzbot generated program does this:
> 
> socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER) = 3
> setsockopt(3, SOL_NETLINK, NETLINK_DROP_MEMBERSHIP, [1], 4) = 0
> 
> ... which triggers 'WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0)' check.
> 
> Instead of counting, just enable reporting for every bind request
> and check if we still have listeners on unbind.
> 
> While at it, also add the needed bounds check on nfnl_group2type[]
> access.

Also applied
