Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E00BC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 09:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjJXJ4c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 05:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbjJXJ4b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 05:56:31 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9C483
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 02:56:28 -0700 (PDT)
Received: from [78.30.35.151] (port=48282 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvE9A-005kut-GO; Tue, 24 Oct 2023 11:56:26 +0200
Date:   Tue, 24 Oct 2023 11:56:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] tests/shell: inline input data in
 "single_anon_set" test
Message-ID: <ZTeUxwvWSL+rq03G@calendula>
References: <20231023161319.781725-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023161319.781725-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 23, 2023 at 06:13:15PM +0200, Thomas Haller wrote:
> The file "optimizations/dumps/single_anon_set.nft.input" was laying
> around, and it was unclear how it was used.
> 
> Let's extend "check-patch.sh" to flag all unused files. But the script
> cannot understand how "single_anon_set.nft.input" is used (aside allow
> listing it).
> 
> Instead, inline the script to keep it inside the test (script).
> 
> We still write the data to a separate file and don't use `nft -f -`
> (because reading stdin uses a different code path we want to cover).

Series applied, thanks
