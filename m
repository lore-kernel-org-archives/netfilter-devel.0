Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FA3C83F17
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbjH3SjJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbjH3PSc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:18:32 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B92EE8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 08:18:30 -0700 (PDT)
Received: from [78.30.34.192] (port=59760 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbMxe-002KW8-4m; Wed, 30 Aug 2023 17:18:28 +0200
Date:   Wed, 30 Aug 2023 17:18:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xiao Liang <shaw.leon@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf v2] netfilter: nft_exthdr: Fix non-linear header
 modification
Message-ID: <ZO9dwR4MAVbHhqkV@calendula>
References: <20230825053330.7838-1-shaw.leon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230825053330.7838-1-shaw.leon@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 01:33:27PM +0800, Xiao Liang wrote:
> Fix skb_ensure_writable() size. Don't use nft_tcp_header_pointer() to
> make it explicit that pointers point to the packet (not local buffer).

Applied to nf, thanks
