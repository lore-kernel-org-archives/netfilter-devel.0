Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E4DC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 15:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FA760EBD
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 15:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241940AbhHJPdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:33:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42370 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242999AbhHJPdI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 11:33:08 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 583BF6003A;
        Tue, 10 Aug 2021 17:32:03 +0200 (CEST)
Date:   Tue, 10 Aug 2021 17:32:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_queue: move hookfn registration
 out of struct net
Message-ID: <20210810153239.GA2636@salvia>
References: <20210805100243.21249-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210805100243.21249-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 05, 2021 at 12:02:43PM +0200, Florian Westphal wrote:
> This was done to detect when the pernet->init() function was not called
> yet, by checking if net->nf.queue_handler is NULL.
> 
> Once the nfnetlink_queue module is active, all struct net pointers
> contain the same address.  So place this back in nf_queue.c.
> 
> Handle the 'netns error unwind' test by checking nfnl_queue_net for a
> NULL pointer and add a comment for this.

Applied, thanks.
