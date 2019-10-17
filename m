Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DD6ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A416220854
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439692AbfJQL3M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:29:12 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41460 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405872AbfJQL3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:29:12 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iL3xu-0004Hd-Mh; Thu, 17 Oct 2019 13:29:10 +0200
Date:   Thu, 17 Oct 2019 13:29:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/4] rule: Fix for single line ct timeout printing
Message-ID: <20191017112910.GK12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-5-phil@nwl.cc>
 <20191017111437.6rhllpyuw3wbti56@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017111437.6rhllpyuw3wbti56@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 01:14:37PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2019 at 01:03:22AM +0200, Phil Sutter wrote:
> > Commit 43ae7a48ae3de ("rule: do not print semicolon in ct timeout")
> > removed an extra semicolon at end of line, but thereby broke single line
> > output. The correct fix is to use opts->stmt_separator which holds
> > either newline or semicolon chars depending on output mode.
> 
> What output mode this breaks? It looks indeed like I overlook
> something while fixing up this.

It breaks syntax of monitor and echo output. We don't propagate it, but
the goal always has been for those to print syntactically correct
commands.

The concrete test case in tests/monitor/testcases/object.t is:

| add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15, replied : 12 }; }

Omitting the semicolon before 'l3proto' is illegal syntax.

Cheers, Phil
