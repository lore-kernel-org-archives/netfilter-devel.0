Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8845BC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 21:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D6161075
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 21:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhCaVBP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 17:01:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49068 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhCaVAr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 17:00:47 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 97B5063E47
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 23:00:31 +0200 (CEST)
Date:   Wed, 31 Mar 2021 23:00:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: nf-next rebase...
Message-ID: <20210331210044.GA5136@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have just squashed an incremental UAF fix for the recent audit patch
as well as the small fix for the logging rework from Florian.

Please, rebase your nf-next local tree.

Sorry for the inconvenience.
