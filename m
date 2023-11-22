Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912C6C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 17:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344269AbjKVRcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 12:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344075AbjKVRck (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 12:32:40 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2F319D;
        Wed, 22 Nov 2023 09:32:36 -0800 (PST)
Received: from [78.30.43.141] (port=43328 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r5r5S-00Dh8f-Na; Wed, 22 Nov 2023 18:32:32 +0100
Date:   Wed, 22 Nov 2023 18:32:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4 23/26] netfilter: nftables: update table
 flags from the commit phase
Message-ID: <ZV47LThJC3LMXmFp@calendula>
References: <20231121121333.294238-1-pablo@netfilter.org>
 <20231121121333.294238-24-pablo@netfilter.org>
 <ZV4qn2RI8a8cg3bL@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZV4qn2RI8a8cg3bL@sashalap>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 22, 2023 at 11:21:51AM -0500, Sasha Levin wrote:
> On Tue, Nov 21, 2023 at 01:13:30PM +0100, Pablo Neira Ayuso wrote:
> > commit 0ce7cf4127f14078ca598ba9700d813178a59409 upstream.
> > 
> > Do not update table flags from the preparation phase. Store the flags
> > update into the transaction, then update the flags from the commit
> > phase.
> 
> We don't seem to have this or the following commits in the 5.10 tree,
> are they just not needed there?

Let me have a look at 5.10, 23/26, 24/26 and 25/26 are likely
candidates.

But not 26/26 in this series.

Let me test them and I will send you a specific patch series in
another mail thread for 5.10 if they are required.

Thanks for the notice.
