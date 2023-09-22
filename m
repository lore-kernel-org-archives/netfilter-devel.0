Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC87CD4F33
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 08:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjIVI4M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjIVI4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 04:56:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA43CF
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 01:56:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qjbxB-0006dG-Mw; Fri, 22 Sep 2023 10:56:01 +0200
Date:   Fri, 22 Sep 2023 10:56:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/9] Misc JSON parser fixes
Message-ID: <ZQ1WodBDLS6kTMJ2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 10:57:18PM +0200, Phil Sutter wrote:
> This is a series of memory corruption fixes kindly reported by Secunet.
> The first six patches fix severe issues, patches seven and eight
> moderate problems and the last one a minor issue noticed along the way.
> 
> Phil Sutter (9):
>   parser_json: Catch wrong "reset" payload
>   parser_json: Fix typo in json_parse_cmd_add_object()
>   parser_json: Proper ct expectation attribute parsing
>   parser_json: Fix flowtable prio value parsing
>   parser_json: Fix limit object burst value parsing
>   parser_json: Fix synproxy object mss/wscale parsing
>   parser_json: Wrong check in json_parse_ct_timeout_policy()
>   parser_json: Catch nonsense ops in match statement
>   parser_json: Default meter size to zero

Series applied.
