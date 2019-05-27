Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB924C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 16:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A616208C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 16:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfE0Q4y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 12:56:54 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:45772 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfE0Q4y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 12:56:54 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hVIva-00023v-65; Mon, 27 May 2019 18:56:52 +0200
Date:   Mon, 27 May 2019 18:56:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] parser_json: Fix and simplify verdict expression
 parsing
Message-ID: <20190527165649.2vxl7yehmwc2frfv@salvia>
References: <20190527113700.8541-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527113700.8541-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 27, 2019 at 01:37:00PM +0200, Phil Sutter wrote:
> Parsing of the "target" property was flawed in two ways:
> 
> * The value was extracted twice. Drop the first unconditional one.
> * Expression allocation required since commit f1e8a129ee428 was broken,
>   The expression was allocated only if the property was not present.

Applied, thanks.
