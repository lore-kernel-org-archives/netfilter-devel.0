Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815A5C83F1A
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjH3Siz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245646AbjH3PrC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:47:02 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A12122
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 08:46:59 -0700 (PDT)
Received: from [78.30.34.192] (port=45654 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbNPC-002QQ5-L2; Wed, 30 Aug 2023 17:46:57 +0200
Date:   Wed, 30 Aug 2023 17:46:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 1/2] netfilter: nf_tables: Audit log setelem reset
Message-ID: <ZO9kberk3iNZv2qj@calendula>
References: <20230829175158.20202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230829175158.20202-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 07:51:57PM +0200, Phil Sutter wrote:
> Since set element reset is not integrated into nf_tables' transaction
> logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESET
> handling.
> 
> For the sake of simplicity, catchall element reset will always generate
> a dedicated log entry. This relieves nf_tables_dump_set() from having to
> adjust the logged element count depending on whether a catchall element
> was found or not.

Applied, thanks Phil
