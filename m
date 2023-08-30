Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4D0C83F20
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjH3Si6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbjH3PR4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:17:56 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285C2B9;
        Wed, 30 Aug 2023 08:17:53 -0700 (PDT)
Received: from [78.30.34.192] (port=59344 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbMwz-002KTX-WE; Wed, 30 Aug 2023 17:17:48 +0200
Date:   Wed, 30 Aug 2023 17:17:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wander Lairson Costa <wander@redhat.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Welte <laforge@netfilter.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Lucas Leong <wmliang@infosec.exchange>, stable@kernel.org
Subject: Re: [PATCH nf] netfilter/xt_sctp: validate the flag_info count
Message-ID: <ZO9dmIXtmWGlrSDh@calendula>
References: <20230828221255.124812-1-wander@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230828221255.124812-1-wander@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 07:12:55PM -0300, Wander Lairson Costa wrote:
> sctp_mt_check doesn't validate the flag_count field. An attacker can
> take advantage of that to trigger a OOB read and leak memory
> information.
> 
> Add the field validation in the checkentry function.

Applied to nf, thanks
