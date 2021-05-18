Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC4AC43460
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7610E61261
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350565AbhERQVx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 12:21:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43194 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbhERQVt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 12:21:49 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 90BD56415E;
        Tue, 18 May 2021 18:19:35 +0200 (CEST)
Date:   Tue, 18 May 2021 18:20:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, horms@verge.net.au, ja@ssi.bg,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        juergh@canonical.com
Subject: Re: [PATCH] netfilter: Remove leading spaces in Kconfig
Message-ID: <20210518162027.GB24332@salvia>
References: <20210517095850.82083-1-juergh@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210517095850.82083-1-juergh@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 17, 2021 at 11:58:50AM +0200, Juerg Haefliger wrote:
> Remove leading spaces before tabs in Kconfig file(s) by running the
> following command:
> 
>   $ find net/netfilter -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Applied, thanks.
