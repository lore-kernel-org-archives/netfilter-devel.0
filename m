Return-Path: <SRS0=cUbz=XJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8A0C49ED6
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 08:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CA7420854
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 08:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfINIaW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Sep 2019 04:30:22 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57684 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726841AbfINIaW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Sep 2019 04:30:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i93Rl-0007Fg-3s; Sat, 14 Sep 2019 10:30:21 +0200
Date:   Sat, 14 Sep 2019 10:30:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-test: Support testing host binaries
Message-ID: <20190914083021.GF10656@breakpoint.cc>
References: <20190914005045.17421-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914005045.17421-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Introduce --host parameter to run the testsuite against host's binaries
> instead of built ones.

Acked-by: Florian Westphal <fw@strlen.de>
