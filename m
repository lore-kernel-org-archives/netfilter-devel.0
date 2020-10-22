Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BB2C5517A
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFE42465A
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603394218;
	bh=b+HpGV/SQiY/H5FbibSh4WTK4U78aHJqHe+3GHGYePQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=C8JMBLTTIc+BsJFracy8lLnYQe3SaPnoqBFcOBiDfDdelcqW4Puo8LNidCRQFHIWZ
	 1W+KKLCMFD1BwTRI7PD3bJvxZIGtNWYT7HLpcOBMalOtr2jN0yf9ueEiOIUhpx0noG
	 RUieVTs+l5NvzsCRGGJ2KqRpvcOxyQigCDIrLFdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370031AbgJVTQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508751AbgJVTQ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 15:16:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01A224656;
        Thu, 22 Oct 2020 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603394216;
        bh=b+HpGV/SQiY/H5FbibSh4WTK4U78aHJqHe+3GHGYePQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0gQU1GmG5L7gwBk7Wj659fEPpi94yqsY17dOdbSsdcGnLNKypv9o0twA0uIupPmd
         MDQf7aSjlEtI/Kr0JPUJzz4Qtjg+RctZ2PDqwci8MsoTL0kk0P1YDA8/C+gnAeODVc
         hTrDnM98YL45OPdcVG5mBtaAQns3kpWA+/8QRg3g=
Date:   Thu, 22 Oct 2020 12:16:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Netfilter fixes for net
Message-ID: <20201022121653.1238a843@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 22 Oct 2020 19:29:18 +0200 Pablo Neira Ayuso wrote:
> Hi Jakub,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Update debugging in IPVS tcp protocol handler to make it easier
>    to understand, from longguang.yue
> 
> 2) Update TCP tracker to deal with keepalive packet after
>    re-registration, from Franceso Ruggeri.
> 
> 3) Missing IP6SKB_FRAGMENTED from netfilter fragment reassembly,
>    from Georg Kohmann.
> 
> 4) Fix bogus packet drop in ebtables nat extensions, from
>    Thimothee Cocault.
> 
> 5) Fix typo in flowtable documentation.
> 
> 6) Reset skb timestamp in nft_fwd_netdev.

Pulled, please remember about that [PATCH net] tag if you can, thanks!
