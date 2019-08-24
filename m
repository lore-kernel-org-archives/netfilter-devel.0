Return-Path: <SRS0=H+Om=WU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABC6C3A59E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 16:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C7920870
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 16:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfHXQld (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Aug 2019 12:41:33 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:60023 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfHXQld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Aug 2019 12:41:33 -0400
Received: from [47.60.33.188] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i1Z6U-0001JO-JI; Sat, 24 Aug 2019 18:41:32 +0200
Date:   Sat, 24 Aug 2019 18:41:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 04/14] nft: Eliminate pointless calls to
 nft_family_ops_lookup()
Message-ID: <20190824164125.4hijyippojc3qlth@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821092602.16292-5-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 11:25:52AM +0200, Phil Sutter wrote:
> If nft_handle is available, use its 'ops' field instead of performing a
> new lookup. For the same reason, there is no need to pass ops pointer to
> __nft_print_header().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
