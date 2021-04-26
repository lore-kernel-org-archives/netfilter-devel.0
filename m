Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAACC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88BE161076
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhDZPjP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:39:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51246 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhDZPjP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:39:15 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F35F63085;
        Mon, 26 Apr 2021 17:37:56 +0200 (CEST)
Date:   Mon, 26 Apr 2021 17:38:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: allow to turn off xtables compat layer
Message-ID: <20210426153829.GA2350@salvia>
References: <20210426101440.25335-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210426101440.25335-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 12:14:40PM +0200, Florian Westphal wrote:
> The compat layer needs to parse untrusted input (the ruleset)
> to translate it to a 64bit compatible format.
> 
> We had a number of bugs in this department in the past, so allow users
> to turn this feature off.
> 
> Add CONFIG_NETFILTER_XTABLES_COMPAT kconfig knob and make it default to y
> to keep existing behaviour.

Applied, thanks.
