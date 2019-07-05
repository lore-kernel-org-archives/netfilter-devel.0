Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF31EC4649B
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 12:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33EA20828
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 12:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfGEM6w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 08:58:52 -0400
Received: from mail.us.es ([193.147.175.20]:49928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGEM6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 08:58:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F6B2C4140
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 14:58:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F61BDA732
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 14:58:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84C361021A4; Fri,  5 Jul 2019 14:58:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D99CD1929;
        Fri,  5 Jul 2019 14:58:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 14:58:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6CA8A4265A2F;
        Fri,  5 Jul 2019 14:58:47 +0200 (CEST)
Date:   Fri, 5 Jul 2019 14:58:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, anon.amish@gmail.com
Subject: Re: [nft PATCH v2] evaluate: Accept ranges of N-N
Message-ID: <20190705125847.toc2sba27pcqywpo@salvia>
References: <20190705121505.26466-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705121505.26466-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 05, 2019 at 02:15:05PM +0200, Phil Sutter wrote:
> Trying to add a range of size 1 was previously not allowed:
> 
> | # nft add element ip t s '{ 40-40 }'
> | Error: Range has zero or negative size
> | add element ip t s { 40-40 }
> |                      ^^^^^
> 
> The error message is not correct: If a range 40-41 is of size 2 (it
> contains elements 40 and 41), a range 40-40 must be of size 1.
> 
> Handling this is even supported already: If a single element is added to
> an interval set, it is converted into just this range. The implication
> is that on output, previous input of '40-40' is indistinguishable from
> single element input '40'.

What kind of human is going to generate such range? :-)

I think we can place this item in the "nft ruleset optimization"
discussion during the NFWS.
