Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8691FC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 09:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjJXJ6R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 05:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbjJXJ6Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 05:58:16 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B2F83
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 02:58:14 -0700 (PDT)
Received: from [78.30.35.151] (port=35216 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvEAj-005l0x-Db; Tue, 24 Oct 2023 11:58:12 +0200
Date:   Tue, 24 Oct 2023 11:57:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
Message-ID: <ZTeVIzWLhSWn4wsA@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023170058.919275-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Series aplied, thanks.

After all these updates I see this failure:

W: [FAILED]     1/1 testcases/sets/elem_opts_compat_0

I: results: [OK] 0 [SKIPPED] 0 [FAILED] 1 [TOTAL] 1

when running tests.
