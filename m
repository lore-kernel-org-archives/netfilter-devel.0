Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12B2EC8750
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 18:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjIGSgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344206AbjIGSgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 14:36:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A719B0
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 11:36:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qeJrS-0001e9-Hu; Thu, 07 Sep 2023 20:36:14 +0200
Date:   Thu, 7 Sep 2023 20:36:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v5 00/19] tests/shell: allow running tests as non-root
Message-ID: <20230907183614.GE20947@breakpoint.cc>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> Sorry for the branch getting bigger and the fast resend. But this should be the
> final version.

Series applied, thanks.
