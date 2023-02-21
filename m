Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989F5C636D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 18:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBUSs6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBUSs6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 13:48:58 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1821E233FA
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 10:48:56 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pUXh7-0007GY-R3; Tue, 21 Feb 2023 19:48:53 +0100
Date:   Tue, 21 Feb 2023 19:48:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] netlink_delinearize: Sanitize concat data element
 decoding
Message-ID: <Y/USFZ6LEo3zaB/n@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230221182133.11746-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221182133.11746-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 21, 2023 at 07:21:33PM +0100, Phil Sutter wrote:
> The call to netlink_get_register() might return NULL, catch this before
> dereferencing the pointer.
> 
> Fixes: db59a5c1204c9 ("netlink_delinearize: fix decoding of concat data element")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
