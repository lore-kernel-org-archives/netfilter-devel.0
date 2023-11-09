Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620F4C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjKIXVs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIXVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:21:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85348420F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:21:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1ELH-0006I7-QO; Fri, 10 Nov 2023 00:21:43 +0100
Date:   Fri, 10 Nov 2023 00:21:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 01/12] tests: shell: export DIFF to use it from
 feature scripts
Message-ID: <20231109232143.GC8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-2-pablo@netfilter.org>
 <f887b55faf6c8467b90fb2363cb780ee7aa51f2c.camel@redhat.com>
 <ZU0vsd5zUuf3mSdm@calendula>
 <3b81fb7a25e8daf8a6c2c76ab0672207cf2c09c0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b81fb7a25e8daf8a6c2c76ab0672207cf2c09c0.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> I think one day,
> 
>    sed 's/\$DIFF\>/diff/g' -i $(git grep -l DIFF tests/shell/)
> 
> should be done.

FWIW I agree with this.
