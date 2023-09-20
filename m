Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B612C04AA9
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 15:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbjITPuU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 11:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjITPuT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 11:50:19 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A454EAF
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 08:50:12 -0700 (PDT)
Received: from [78.30.34.192] (port=35976 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qizSq-004ViM-PZ; Wed, 20 Sep 2023 17:50:10 +0200
Date:   Wed, 20 Sep 2023 17:50:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Subject: Re: [PATCH nft 3/3] tests/shell: run `nft --check` on persisted dump
 files
Message-ID: <ZQsUr2WyabtFCt9C@calendula>
References: <20230918195933.318893-1-thaller@redhat.com>
 <20230918195933.318893-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230918195933.318893-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 18, 2023 at 09:59:24PM +0200, Thomas Haller wrote:
> "nft --check" will trigger a rollback in kernel. The existing dump files
> might hit new code paths. Take the opportunity to call the command on
> the existing files.
> 
> And alternative would be to write a separate tests, that iterates over
> all files. However, then we can only run all the commands sequentially
> (unless we do something smart). That might be slower than the
> opportunity to run the checks in parallel. More importantly, it would be
> nice if the check for the dump file is clearly tied to the file's test.
> So run it right after the test, from the test wrapper.

I am already using this patch in my tests.

Applied, thanks.
