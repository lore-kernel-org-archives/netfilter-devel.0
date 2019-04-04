Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FB5C10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4014F205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfDDKNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:13:19 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36414 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfDDKNS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 06:13:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hBzMu-0006bg-SL; Thu, 04 Apr 2019 12:13:12 +0200
Date:   Thu, 4 Apr 2019 12:13:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        eric.dumazet@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next,RFC 1/8] net: use kfree_skb_list() from
 ip_do_fragment()
Message-ID: <20190404101312.a3l4xgzs3jxwfmer@breakpoint.cc>
References: <20190403154001.8177-1-pablo@netfilter.org>
 <20190403154001.8177-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403154001.8177-2-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Just like 46cfd725c377 ("net: use kfree_skb_list() helper in more places").

Acked-by: Florian Westphal <fw@strlen.de>

Please consider submitting this as-is as standalone patch.
