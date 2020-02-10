Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DB8C352A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 11:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4299220733
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 11:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgBJLum (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 06:50:42 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56576 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgBJLum (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 06:50:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j17aL-0004Dl-2n; Mon, 10 Feb 2020 12:50:41 +0100
Date:   Mon, 10 Feb 2020 12:50:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 1/5] icmp: introduce helper for NAT'd source address
 in ndo context
Message-ID: <20200210115041.GF2991@breakpoint.cc>
References: <20200209143143.151632-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)

CONFIG_NF_NAT would be preferrable even though it makes little
difference in practice I guess.
