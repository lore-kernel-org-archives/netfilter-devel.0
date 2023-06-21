Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2A0EB64D8
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 08:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjFUIpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 04:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjFUIpA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 04:45:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1669710E6;
        Wed, 21 Jun 2023 01:44:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qBtSL-0005d4-9f; Wed, 21 Jun 2023 10:44:49 +0200
Date:   Wed, 21 Jun 2023 10:44:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Sohom <sohomdatta1@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sohom <sohomdatta1+git@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Don't parse CTCP message if shorter than
 minimum length
Message-ID: <20230621084449.GD3799@breakpoint.cc>
References: <20230621032953.107143-1-sohomdatta1+git@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621032953.107143-1-sohomdatta1+git@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sohom <sohomdatta1@gmail.com> wrote:
> If the CTCP message is shorter than 10 + 21 + MINMATCHLEN
> then exit early and don't parse the rest of the message.

Please send a v2 explaining why, not what.

> +	if (data >= data_limit - (10 + 21 + MINMATCHLEN)) {
> +		goto out;
> +	}

Please run your patches through scripts/checkpatch.pl,
we don't use { } for single-line conditional bodies.

>  	/* Skip any whitespace */
> -	while (data < data_limit - 10) {
> +	while (data < data_limit) {

Why this change?
