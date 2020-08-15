Return-Path: <SRS0=d1l0=BZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746F1C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCA920675
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHOWuN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgHOWuN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 18:50:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FEC061786;
        Sat, 15 Aug 2020 15:50:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k74zw-0005Tr-N6; Sun, 16 Aug 2020 00:50:01 +0200
Date:   Sun, 16 Aug 2020 00:50:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
Message-ID: <20200815225000.GI1660@breakpoint.cc>
References: <20200815165030.5849-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815165030.5849-1-ztong0001@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tong Zhang <ztong0001@gmail.com> wrote:
> ct_sip_parse_numerical_param can only return 0 or 1, but the caller is
> checking parsing error using < 0

Reviewed-by: Florian Westphal <fw@strlen.de>
