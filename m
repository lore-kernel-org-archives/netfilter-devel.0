Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7364C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D62D2464D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfLEKxP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:53:15 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60612 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbfLEKxP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 05:53:15 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icokz-0004DC-Gz; Thu, 05 Dec 2019 11:53:13 +0100
Date:   Thu, 5 Dec 2019 11:53:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] build: nftables 0.9.3 depends on libnftnl 1.1.5
Message-ID: <20191205105313.GC14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191205093809.128045-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205093809.128045-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 05, 2019 at 10:38:09AM +0100, Pablo Neira Ayuso wrote:
> nftables 0.9.3 requires libnftnl 1.1.5, otherwise compilation breaks:
> https://bugs.gentoo.org/701976.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
