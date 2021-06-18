Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B08C48BE8
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1049D61369
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhFRMud (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Jun 2021 08:50:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50282 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFRMub (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Jun 2021 08:50:31 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1B9296425E;
        Fri, 18 Jun 2021 14:47:01 +0200 (CEST)
Date:   Fri, 18 Jun 2021 14:48:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nft_extdhr: Drop pointless check of
 tprot_set
Message-ID: <20210618124818.GA10141@salvia>
References: <20210611170826.11412-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611170826.11412-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 11, 2021 at 07:08:26PM +0200, Phil Sutter wrote:
> Pablo says, tprot_set is only there to detect if tprot was set to
> IPPROTO_IP as that evaluates to zero. Therefore, code asserting a
> different value in tprot does not need to check tprot_set.

Applied, thanks.
