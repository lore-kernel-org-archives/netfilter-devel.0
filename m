Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55E3C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 14:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BABE238A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 14:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbhAUO7I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 09:59:08 -0500
Received: from correo.us.es ([193.147.175.20]:38654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732009AbhAUO6r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 09:58:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDA2119190D
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 15:57:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF45ADA78F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 15:57:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4EEFDA78D; Thu, 21 Jan 2021 15:57:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9F7CDA722;
        Thu, 21 Jan 2021 15:57:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Jan 2021 15:57:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A05D42EF9E1;
        Thu, 21 Jan 2021 15:57:06 +0100 (CET)
Date:   Thu, 21 Jan 2021 15:57:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] json: limit: set default burst to 5
Message-ID: <20210121145759.GA4087@salvia>
References: <20210121135510.14941-1-fw@strlen.de>
 <20210121135510.14941-3-fw@strlen.de>
 <20210121144414.GQ3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210121144414.GQ3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Jan 21, 2021 at 03:44:14PM +0100, Phil Sutter wrote:
> Hi!
> 
> On Thu, Jan 21, 2021 at 02:55:08PM +0100, Florian Westphal wrote:
> > The tests fail because json printing omits a burst of 5 and
> > the parser treats that as 'burst 0'.
> 
> While this patch is correct in that it aligns json and bison parser
> behaviours, I think omitting burst value in JSON output is a bug by
> itself: We don't care about output length and users are supposed to
> parse (and thus filter) the information anyway, so there's no gain from
> omitting such info. I'll address this in a separate patch, though.

The listing of:

nft list ruleset

is already omitting this. Would you prefer this is also exposed there?

Thanks.
