Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59923C072A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2476220851
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfEVIst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 04:48:49 -0400
Received: from mail.us.es ([193.147.175.20]:43870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfEVIst (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 04:48:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72941120047
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 10:48:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63A3CDA711
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 10:48:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 594B3DA712; Wed, 22 May 2019 10:48:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FC16DA71F;
        Wed, 22 May 2019 10:48:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 May 2019 10:48:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 079A84265A32;
        Wed, 22 May 2019 10:48:43 +0200 (CEST)
Date:   Wed, 22 May 2019 10:48:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [nft PATCH v2 0/2] JSON schema for nftables.py
Message-ID: <20190522084843.d5lx7223gi2pfiul@salvia>
References: <20190517201758.1576-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517201758.1576-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 17, 2019 at 10:17:56PM +0200, Phil Sutter wrote:
> This is basically identical to the RFC sent earlier. The only change is
> in second patch: As suggested by Eric, 'traceback' module is standard so
> there's no need to import it conditionally.
> 
> The schema is still in its minimalistic form, I decided to extend it in
> follow-up patches.

I'm fine with this JSON validation, if no objections I'll push this
out.

Only one thing: I think it would be good if -s checks for -j in
nft-test.py, but not a deal breaker: this can be done in a follow up
patch.

Thanks.

> Changes since v1:
> - Fix patch 2 commit message, thanks to Jones Desougi who reported the
>   inconsistency.
> 
> Phil Sutter (2):
>   py: Implement JSON validation in nftables module
>   tests/py: Support JSON validation
> 
>  py/Makefile.am       |  2 +-
>  py/nftables.py       | 30 ++++++++++++++++++++++++++++++
>  py/schema.json       | 17 +++++++++++++++++
>  py/setup.py          |  1 +
>  tests/py/nft-test.py | 21 ++++++++++++++++++++-
>  5 files changed, 69 insertions(+), 2 deletions(-)
>  create mode 100644 py/schema.json
> 
> -- 
> 2.21.0
> 
