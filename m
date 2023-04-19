Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4BCC6FD18
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Apr 2023 05:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDSFU5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Apr 2023 01:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjDSFU4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2023 01:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF5469F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 22:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1E7763ADB
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2023 05:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED88DC433D2;
        Wed, 19 Apr 2023 05:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681881652;
        bh=0dpZ+HsxaLXu33LZljupLpJFp81trJLKLY+pKE8b/iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVV21Dzs2zgghwkuoDxz2K/YGYSfKhqq70MhOw7uk3reb4SbeV8TylqOIPKv/7l1G
         Buoa0Z4KhL9VaB8lNQfLOxvACtJNbjNSGhoq2Mr3tkZOtZ7Fkw40+GVlVlooPrFWrN
         eDFfbQgdnrhbQ4/xUg2XrhcM6L7MapMywSHGNh4fbzIMhITSzl1u1yz9UxrU4Gd+RH
         njSfbl05RmT0Rs1xXkt+s9zNxWKMNMkzK7H81vVvhuu+FQgXXxObNY7NMlBDmxJO3b
         m8aactTZnw0qn3SbF9v3NaLSPYvyoPg/9kFDMVJ6ru2Y5DpwchtB4+/3UbwdlrMCrI
         EM4rsQR2w7xQw==
Date:   Wed, 19 Apr 2023 13:20:48 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZD96MN2H45qj6bhb@google.com>
References: <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
 <ZDfFmMfS406teiUj@calendula>
 <ZDjN4gyv0x1aewgm@google.com>
 <ZDkK3ktVcBaykTVT@calendula>
 <ZDy/9WEIQRyIPSNo@google.com>
 <ZD5SHAuK23E+DD2C@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD5SHAuK23E+DD2C@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 18, 2023 at 10:17:32AM +0200, Pablo Neira Ayuso wrote:
> Then, on top of what I suggest, my recommendation is to skip the
> ctnetlink_dump_timeout() call for !nf_ct_confirmed(ct).
> 
> Or, you add some special handling for ctnetlink_dump_timeout() for the
> !nf_ct_confirmed(ct) case.

Sent a v3[6] for this and hope it makes more sense.

[6]: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230419051526.3170053-1-tzungbi@kernel.org/
