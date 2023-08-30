Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC07C83F18
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbjH3SjG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245482AbjH3PSO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:18:14 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF831A3;
        Wed, 30 Aug 2023 08:18:11 -0700 (PDT)
Received: from [78.30.34.192] (port=40966 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbMxK-002KUx-7F; Wed, 30 Aug 2023 17:18:09 +0200
Date:   Wed, 30 Aug 2023 17:18:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wander Lairson Costa <wander@redhat.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Jan Engelhardt <jengelh@gmx.de>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter/xt_u32: validate user space input
Message-ID: <ZO9dreEK8SCsgQz4@calendula>
References: <20230828132107.18376-1-wander@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230828132107.18376-1-wander@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 10:21:07AM -0300, Wander Lairson Costa wrote:
> The xt_u32 module doesn't validate the fields in the xt_u32 structure.
> An attacker may take advantage of this to trigger an OOB read by setting
> the size fields with a value beyond the arrays boundaries.
> 
> Add a checkentry function to validate the structure.
> 
> This was originally reported by the ZDI project (ZDI-CAN-18408).

Applied to nf, thanks
