Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E9BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbjKIXLI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbjKIXKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:10:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4386646BD
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:10:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1EAd-0006E9-V0; Fri, 10 Nov 2023 00:10:43 +0100
Date:   Fri, 10 Nov 2023 00:10:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] parser: don't mark "string" as const
Message-ID: <20231109231043.GB8000@breakpoint.cc>
References: <20231109190032.669575-1-thaller@redhat.com>
 <ZU0xWPO9YpItvKTz@calendula>
 <0da07d8c11797fdbc52a20dc59b819aae632c24c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0da07d8c11797fdbc52a20dc59b819aae632c24c.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> ifname_expr_alloc() calls `free(name)`, destroying the thing that is
> pointed at. That's a modification.
> 
> The code required to cast away the constness, which also indicates that
> it is not actually const.

It it.  I hate that free() isn't const void *.

I prefer to have const used as much as humanly possible.
