Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39709C07E95
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 15:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B43161CBF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 15:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhGGPmq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 11:42:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54960 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhGGPmq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 11:42:46 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 02E1E61836;
        Wed,  7 Jul 2021 17:39:52 +0200 (CEST)
Date:   Wed, 7 Jul 2021 17:40:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: uapi: refer to nfnetlink_conntrack.h, not
 nf_conntrack_netlink.h
Message-ID: <20210707154002.GA19799@salvia>
References: <20210706224657.GA12859@salvia>
 <20210707005751.12108-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210707005751.12108-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 07, 2021 at 10:57:51AM +1000, Duncan Roe wrote:
> nf_conntrack_netlink.h does not exist, refer to nfnetlink_conntrack.h instead.

Applied to nf, thanks.
