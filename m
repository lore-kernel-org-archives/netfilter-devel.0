Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D323BC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jul 2021 12:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779B360ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jul 2021 12:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhGWLnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jul 2021 07:43:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56886 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhGWLnJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jul 2021 07:43:09 -0400
Received: from netfilter.org (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id CE95B64119;
        Fri, 23 Jul 2021 14:23:15 +0200 (CEST)
Date:   Fri, 23 Jul 2021 14:23:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: adjust stop timestamp to real
 expiry value
Message-ID: <20210723122344.GA14579@salvia>
References: <20210718163600.220854-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210718163600.220854-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 18, 2021 at 06:36:00PM +0200, Florian Westphal wrote:
> In case the entry is evicted via garbage collection there is
> delay between the timeout value and the eviction event.
> 
> This adjusts the stop value based on how much time has passed.

Applied, thanks.
