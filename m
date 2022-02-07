Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB68C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 15:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiBGPTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 10:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352811AbiBGPEk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 10:04:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96085C0401C3
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 07:04:40 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nH5ZG-0008Mb-UI; Mon, 07 Feb 2022 16:04:38 +0100
Date:   Mon, 7 Feb 2022 16:04:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] flowtable json fixes
Message-ID: <YgE1BlC5EpwYfByV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220207132816.21129-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207132816.21129-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 07, 2022 at 02:28:13PM +0100, Florian Westphal wrote:
> json doesn't export the flow statement.
> First patch resolves this, the other two patches resolve
> import problems with flowtable json format.
> 
> Florian Westphal (3):
>   json: add flow statement json export + parser
>   parser_json: fix flowtable device datatype
>   parser_json: permit empty device list

Series:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
