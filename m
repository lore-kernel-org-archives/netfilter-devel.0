Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A83C77B7C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 May 2023 10:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjEIKAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 May 2023 06:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjEIKAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2023 06:00:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C7A1703
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 03:00:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pwK9H-0004Ny-Su; Tue, 09 May 2023 12:00:47 +0200
Date:   Tue, 9 May 2023 12:00:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Patryk Sondej <patryk.sondej@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, eric_sage@apple.com
Subject: Re: [PATCH 0/2] netfilter: nfnetlink_log & nfnetlink_queue: enable
 cgroup id socket info
Message-ID: <20230509100047.GA15670@breakpoint.cc>
References: <20230508031424.55383-1-patryk.sondej@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508031424.55383-1-patryk.sondej@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patryk Sondej <patryk.sondej@gmail.com> wrote:
> Hi all,
> 
> I'd like to propose this patchset that adds support for retrieving cgroupv2 ID.
> This functionality is useful for processing per-cgroup packets in userspace using nfnetlink_log,
> or writing per-cgroup rules using nfnetlink_queue.
> 
> This is my first contribution to the kernel, so I would greatly appreciate any feedback or suggestions for improvement.

Please fix the build error reported for 2/2 and resubmit.

Your subject line for v2 should contain '[PATCH nf-next v2]'.

Thanks.
