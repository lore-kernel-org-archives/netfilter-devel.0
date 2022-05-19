Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AC1C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 20:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiESUkh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244778AbiESUkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 16:40:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B2CD986EE
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 13:40:35 -0700 (PDT)
Date:   Thu, 19 May 2022 22:40:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com
Subject: Re: [PATCH nf-next] netfilter: conntrack: re-fetch conntrack after
 insertion
Message-ID: <YoarP+OgDgvs5bMn@salvia>
References: <20220517194918.20555-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517194918.20555-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 09:49:18PM +0200, Florian Westphal wrote:
> In case the conntrack is clashing, insertion can free skb->_nfct and
> set skb->_nfct to the already-confirmed entry.
> 
> This wasn't found before because the conntrack entry and the extension
> space used to free'd after an rcu grace period, plus the race needs
> events enabled to trigger.

Applied, thanks
