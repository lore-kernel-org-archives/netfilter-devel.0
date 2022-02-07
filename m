Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FA8C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 17:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiBGRrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240490AbiBGRfj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 12:35:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AA6AC0401EE
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 09:35:38 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19AD560028;
        Mon,  7 Feb 2022 18:35:33 +0100 (CET)
Date:   Mon, 7 Feb 2022 18:35:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] json: add flow statement json export + parser
Message-ID: <YgFYZhicqRheSz/i@salvia>
References: <20220207132816.21129-1-fw@strlen.de>
 <20220207132816.21129-2-fw@strlen.de>
 <20220207132915.GB25000@breakpoint.cc>
 <YgEm4OBHhQ0L+0bD@salvia>
 <20220207145313.GD25000@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220207145313.GD25000@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 07, 2022 at 03:53:13PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Feb 07, 2022 at 02:29:15PM +0100, Florian Westphal wrote:
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > flow statement has no export, its shown as:
> > > > ".. }, "flow add @ft" ] } }"
> > > > 
> > > > With this patch:
> > > > 
> > > > ".. }, {"flow": {"op": "add", "flowtable": "@ft"}}]}}"
> > > 
> > > This is based on the 'set' statement.  If you prefer the @ to
> > > be removed let me know.
> > 
> > Then, it is consistent with the existing syntax. So either we consider
> > deprecating the @ on the 'set' statement (while retaining backward
> > compatibility) or flowtable also includes it as in your patch.
> 
> Ok, then lets keep it as-is; the @ might help humans to find a
> set/flowtable name more quickly this way.

OK.
