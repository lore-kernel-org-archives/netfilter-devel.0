Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA07C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 07:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjHCH6h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjHCH6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 03:58:00 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ECC9EDF
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 00:45:10 -0700 (PDT)
Received: from [46.6.133.208] (port=5822 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qRT16-0083h1-Qb; Thu, 03 Aug 2023 09:45:07 +0200
Date:   Thu, 3 Aug 2023 09:45:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Brennan Paciorek <bpaciore@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] doc: document add chain device parameter
Message-ID: <ZMta/rpB92PqLHev@calendula>
References: <20230802182947.24789-1-bpaciore@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230802182947.24789-1-bpaciore@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 02, 2023 at 02:29:47PM -0400, Brennan Paciorek wrote:
> nft add chain lacked documentation of its optional device parameter,
> specifically what values the parameter accepted, what it did and
> when to use it.

Applied, thanks
