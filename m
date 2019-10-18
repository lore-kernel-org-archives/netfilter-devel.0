Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0ABCA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150F421925
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410275AbfJROFL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:05:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35264 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408654AbfJROFL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 10:05:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iLSsO-0003j3-Tw; Fri, 18 Oct 2019 16:05:08 +0200
Date:   Fri, 18 Oct 2019 16:05:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-restore: Fix --table parameter check
Message-ID: <20191018140508.GB25052@breakpoint.cc>
References: <20190920154920.7927-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920154920.7927-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Xtables-restore tries to reject rule commands in input which contain a
> --table parameter (since it is adding this itself based on the previous
> table line). Sadly getopt_long's flexibility makes it hard to get this
> check right: Since the last fix, comments starting with a dash and
> containing a 't' character somewhere later were rejected. Simple
> example:
> 
> | *filter
> | -A FORWARD -m comment --comment "- allow this one" -j ACCEPT
> | COMMIT
> 
> To hopefully sort this once and for all, introduce is_table_param()
> which should cover all possible variants of legal and illegal
> parameters. Also add a test to make sure it does what it is supposed to.

Thanks for adding a test for this.
How did you generate it?  The added code is pure voodoo magic to me,
so I wonder if we can just remove the 'test for -t in iptables-restore
files' code.
