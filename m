Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A553CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 02:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbjILCr2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239949AbjILCrQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 22:47:16 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F806412E2
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 19:12:38 -0700 (PDT)
Received: from [31.221.198.239] (port=5802 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qfofZ-009h0C-Fv; Mon, 11 Sep 2023 23:42:12 +0200
Date:   Mon, 11 Sep 2023 23:42:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] parser_bison: include <nft.h> for base C
 environment to "parser_bison.y"
Message-ID: <ZP+Jr5PE7Dhl0RYn@calendula>
References: <20230908173226.1182353-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230908173226.1182353-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 08, 2023 at 07:32:19PM +0200, Thomas Haller wrote:
> All our C sources should include <nft.h> as first. This prepares an
> environment of things that we expect to have available in all our C
> sources (and indirectly in our internal header files, because internal
> header files are always indirectly from a C source).

Applied, thanks
