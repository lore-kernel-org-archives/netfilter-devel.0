Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFCFC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A597610A8
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhHELtp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 07:49:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58762 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhHELto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 07:49:44 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5542160030;
        Thu,  5 Aug 2021 13:48:53 +0200 (CEST)
Date:   Thu, 5 Aug 2021 13:49:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: ctnetlink: allow to filter dumps
 via ct->status
Message-ID: <20210805114926.GA13014@salvia>
References: <20210730131422.16958-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210730131422.16958-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 30, 2021 at 03:14:20PM +0200, Florian Westphal wrote:
> Currently its not possibe to only dump entries that are e.g. in
> UNREPLIED state.
> 
> Patches to extend libnetfilter_conntrack and conntrack-tools will be
> sent separately.

Series applied, thanks.
