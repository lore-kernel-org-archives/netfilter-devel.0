Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE12C48BDF
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE41610A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhFRMgU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Jun 2021 08:36:20 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50236 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhFRMgU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Jun 2021 08:36:20 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 745D56425E;
        Fri, 18 Jun 2021 14:32:49 +0200 (CEST)
Date:   Fri, 18 Jun 2021 14:34:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH v2] netfilter: nft_exthdr: Search chunks in SCTP
 packets only
Message-ID: <20210618123407.GA8464@salvia>
References: <20210611170645.11245-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611170645.11245-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 11, 2021 at 07:06:45PM +0200, Phil Sutter wrote:
> Since user space does not generate a payload dependency, plain sctp
> chunk matches cause searching in non-SCTP packets, too. Avoid this
> potential mis-interpretation of packet data by checking pkt->tprot.

Applied, thanks.
