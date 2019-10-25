Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB25CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 20:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8992C205F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 20:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfJYUgu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 16:36:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43840 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727008AbfJYUgu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 16:36:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iO6KF-00067B-Sz; Fri, 25 Oct 2019 22:36:47 +0200
Date:   Fri, 25 Oct 2019 22:36:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-arp: Use xtables_ipparse_multiple()
Message-ID: <20191025203647.GZ25052@breakpoint.cc>
References: <20191025163733.28576-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025163733.28576-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Use the same code for parsing source and destination IP addresses as
> iptables and drop all the local functions dealing with that.
> 
> While being at it, call free() for 'saddrs' and 'daddrs' unconditionally
> (like iptables does), they are NULL if not used.

Acked-by: Florian Westphal <fw@strlen.de>
