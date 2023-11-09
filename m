Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F98C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjKIXZe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjKIXZe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:25:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B262420F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:25:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1EOw-0006KK-FQ; Fri, 10 Nov 2023 00:25:30 +0100
Date:   Fri, 10 Nov 2023 00:25:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 01/12] tests: shell: export DIFF to use it from
 feature scripts
Message-ID: <20231109232530.GE8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-2-pablo@netfilter.org>
 <f887b55faf6c8467b90fb2363cb780ee7aa51f2c.camel@redhat.com>
 <ZU0vsd5zUuf3mSdm@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU0vsd5zUuf3mSdm@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I just need to move it around so I can use it from feature scripts.
> If you prefer I can just use 'diff' instead from the feature scripts.

Seems better to just use 'diff'.
