Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FB4C282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12E421871
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391612AbfEXUpT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 16:45:19 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44932 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389927AbfEXUpT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 16:45:19 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUH40-0007Be-1k; Fri, 24 May 2019 22:45:18 +0200
Date:   Fri, 24 May 2019 22:45:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [nft PATCH v3 0/2] JSON schema for nftables.py
Message-ID: <20190524204514.4tf77x2ugqay5e5c@salvia>
References: <20190522161453.23096-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522161453.23096-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 22, 2019 at 06:14:51PM +0200, Phil Sutter wrote:
> Round three of JSON validation enhancement.
> 
> Changes since v2:
> - Make enhancement to nftables module Python3 compliant.
> - Complain in nft-test.py if --schema was given without --json.
> 
> Changes since v1:
> - Fix patch 2 commit message, thanks to Jones Desougi who reported the
>   inconsistency.
> 
> Changes since RFC:
> - Import builtin traceback module unconditionally.
> 
> Phil Sutter (2):
>   py: Implement JSON validation in nftables module
>   tests/py: Support JSON validation
> 
>  py/Makefile.am       |  2 +-
>  py/nftables.py       | 29 +++++++++++++++++++++++++++++
>  py/schema.json       | 17 +++++++++++++++++
>  py/setup.py          |  1 +
>  tests/py/nft-test.py | 25 ++++++++++++++++++++++++-

Where is ruleset-schema.json?

+       "id": "http://netfilter.org/nftables/ruleset-schema.json",
+       "description": "libnftables JSON API schema",
