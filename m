Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5830C7EE37
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 21:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238385AbjFFVlr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 17:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbjFFVlq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 17:41:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B961706;
        Tue,  6 Jun 2023 14:41:45 -0700 (PDT)
Date:   Tue, 6 Jun 2023 23:41:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 nf] netfilter: ipset: Add schedule point in call_ad().
Message-ID: <ZH+oFxXWzLGFUHS4@calendula>
References: <20230518173300.34531-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230518173300.34531-1-kuniyu@amazon.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 18, 2023 at 10:33:00AM -0700, Kuniyuki Iwashima wrote:
> syzkaller found a repro that causes Hung Task [0] with ipset.

Applied, thanks
