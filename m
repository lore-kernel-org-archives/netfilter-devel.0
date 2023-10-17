Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C8ACDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 09:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjJQJYj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 05:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjJQJYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 05:24:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AABEB
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 02:24:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qsgJR-000785-TR; Tue, 17 Oct 2023 11:24:29 +0200
Date:   Tue, 17 Oct 2023 11:24:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/3] add "eval-exit-code" and skip tests based on
 kernel version
Message-ID: <20231017092429.GA10901@breakpoint.cc>
References: <20231017085133.1203402-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017085133.1203402-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> This is a follow-up and replaces the two patches:
> 
>   [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel patch is missing
>   [PATCH nft 2/3] tests/shell: skip "vlan_8021ad_tag" test instead of failing
> 
> Instead, add a helper script "eval-exit-code" which makes it easy(?) to
> conditionally downgrade a test failure to a SKIP (exit 77) based on the
> kernel version.

Unfortunately kernel versions are meaningless, especially for the
average commericial frankenkernels.
