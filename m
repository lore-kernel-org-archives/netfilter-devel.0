Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E00EC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 11:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjKGLcO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 06:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjKGLcO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 06:32:14 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B7CED
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 03:32:11 -0800 (PST)
Received: from [78.30.35.151] (port=38586 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r0KJR-002yRu-Uk; Tue, 07 Nov 2023 12:32:08 +0100
Date:   Tue, 7 Nov 2023 12:32:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/6] add and check dump files for JSON in
 tests/shell
Message-ID: <ZUogNGTVOP4SlKbU@calendula>
References: <20231103182901.3795263-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231103182901.3795263-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I am splitting a few tests and extending features to allow to run this
in 5.4 (and older kernels). Let me submit these then let me ask you to
rebase this series on top.

Thanks.
