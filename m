Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087D7CA9EA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 13:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB421222BD
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 13:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405337AbfJRN1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:27:52 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44100 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393118AbfJRN1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 09:27:52 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iLSII-0004uQ-6W; Fri, 18 Oct 2019 15:27:50 +0200
Date:   Fri, 18 Oct 2019 15:27:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] xtables-restore: Fix --table parameter check
Message-ID: <20191018132750.GF26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
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

Hi,

On Fri, Sep 20, 2019 at 05:49:20PM +0200, Phil Sutter wrote:
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
> 
> Fixes: f8e5ebc5986bf ("iptables: Fix crash on malformed iptables-restore")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Could anyone please review this one?

Thanks, Phil
