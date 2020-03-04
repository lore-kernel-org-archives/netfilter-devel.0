Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6FDC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 08:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC31B20866
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 08:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgCDIQy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:16:54 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40950 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726957AbgCDIQy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 03:16:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j9PD1-0006Ce-9v; Wed, 04 Mar 2020 09:16:51 +0100
Date:   Wed, 4 Mar 2020 09:16:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] connlabel: Allow numeric labels even if
 connlabel.conf exists
Message-ID: <20200304081651.GE979@breakpoint.cc>
References: <20200304022459.6433-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304022459.6433-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Existing code is a bit quirky: If no connlabel.conf was found, the local
> function connlabel_value_parse() is called which tries to interpret
> given label as a number. If the config exists though,
> nfct_labelmap_get_bit() is called instead which doesn't care about
> "undefined" connlabel names. So unless installed connlabel.conf contains
> entries for all possible numeric labels, rules added by users may stop
> working if a connlabel.conf is created. Fix this by falling back to
> connlabel_value_parse() function also if connlabel_open() returned 0 but
> nfct_labelmap_get_bit() returned an error.

Acked-by: Florian Westphal <fw@strlen.de>
