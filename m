Return-Path: <SRS0=t5ds=XV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51562C432C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 09:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C4D206B7
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 09:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfIZJHE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:07:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44680 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729018AbfIZJHE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Sep 2019 05:07:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iDPjq-00021u-W6; Thu, 26 Sep 2019 11:07:03 +0200
Date:   Thu, 26 Sep 2019 11:07:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 02/24] tests/shell: Speed up
 ipt-restore/0004-restore-race_0
Message-ID: <20190926090702.GC12491@breakpoint.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
 <20190925212605.1005-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925212605.1005-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> This test tended to cause quite excessive load on my system, sometimes
> taking longer than all other tests combined. Even with the reduced
> numbers, it still fails reliably after reverting commit 58d7de0181f61
> ("xtables: handle concurrent ruleset modifications").

Acked-by: Florian Westphal <fw@strlen.de>

