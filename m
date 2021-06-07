Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79005C47094
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 12:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB9261057
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 12:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGMdc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Jun 2021 08:33:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53508 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGMdc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Jun 2021 08:33:32 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EE64C64182;
        Mon,  7 Jun 2021 14:30:28 +0200 (CEST)
Date:   Mon, 7 Jun 2021 14:31:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/2] netfilter: new hook nfnl subsystem
Message-ID: <20210607123137.GA8106@salvia>
References: <20210604102707.799-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210604102707.799-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 04, 2021 at 12:27:05PM +0200, Florian Westphal wrote:
> v2: patch 2 needs to update nfnl_lockdep_names[] in nfnetlink.c.
> 
> First patch is a required dependency to allow to check when
> its safe to treat the 'priv' pointer as a nft base chain pointer.
> 
> Second patch adds a new nfnl subsystem to enable userspace to dump
> the active hooks to userspace.
> 
> Previous patches added this to nf_tables instead, but technically
> this isn't related to nf_tables.
> 
> Using a new nfnl subsys allows to extend this later, e.g. to
> send out notifications, e.g. when a new base hook is registered.

Series applied, thanks.
