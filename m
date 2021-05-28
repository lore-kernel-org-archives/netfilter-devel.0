Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AD5C2B9F7
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 19:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E69CE613ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 19:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhE1TMI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 15:12:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58040 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhE1TMI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 15:12:08 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3995E644EE
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 21:09:29 +0200 (CEST)
Date:   Fri, 28 May 2021 21:10:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: rebasing nf-next
Message-ID: <20210528191028.GA26767@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

There's currently a small conflict between nf-next and net-next,
specifically, the most recent pipapo fix for nf and the retpoline
updates for the set infrastructure.

I'm going to rebase the nf-next to send a simple pull request for
net-next.

So I'm rebase nf-next, please rebase any pending work in your
working copies too.

Sorry for the inconvenience.
