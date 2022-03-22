Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A20C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 11:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiCVLbe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiCVLbd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 07:31:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B453E7EB2B
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2022 04:30:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nWciD-00035V-4P; Tue, 22 Mar 2022 12:30:05 +0100
Date:   Tue, 22 Mar 2022 12:30:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_tables: replace unnecessary use of
 list_for_each_entry_continue()
Message-ID: <20220322113005.GE24574@breakpoint.cc>
References: <20220322105645.3667322-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322105645.3667322-1-jakobkoschel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jakob Koschel <jakobkoschel@gmail.com> wrote:

[ trimmed CC ]

> Since there is no way for list_for_each_entry_continue() to start
> interating in the middle of the list they can be replaced with a call
> to list_for_each_entry().
> 
> In preparation to limit the scope of the list iterator to the list
> traversal loop, the list iterator variable 'rule' should not be used
> past the loop.

Reviewed-by: Florian Westphal <fw@strlen.de>
