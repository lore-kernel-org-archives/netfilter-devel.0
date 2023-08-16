Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2142C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbjHPQKw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344554AbjHPQKh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:10:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809B5E2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:10:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qWJ6Q-00017x-Pn; Wed, 16 Aug 2023 18:10:34 +0200
Date:   Wed, 16 Aug 2023 18:10:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 6/6] py: add Nftables.{get,set}_input() API
Message-ID: <ZNz0+hTYXVqvozX+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-13-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803193940.1105287-13-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:35:24PM +0200, Thomas Haller wrote:
> Similar to the existing Nftables.{get,set}_debug() API.
> 
> Only notable (internal) difference is that nft_ctx_input_set_flags()
> returns the old value already, so we don't need to call
> Nftables.get_input() first.
> 
> The benefit of this API, is that it follows the existing API for debug
> flags. Also, when future flags are added it requires few changes to the
> python code.
> 
> The disadvantage is that it looks different from the underlying C API,
> which is confusing when reading the C API. Also, it's a bit cumbersome
> to reset only one flag. For example:
> 
>      def _drop_flag_foo(flag):
>         if isinstance(flag, int):
>             return flag & ~FOO_NUM
>         if flag == 'foo':
>             return 0
>         return flag
> 
>      ctx.set_input(_drop_flag_foo(v) for v in ctx.get_input())

IMO the name is too short. While I find it works with debug ("set_debug"
as in "enable_debugging") but with input I expect something to follow.
So I suggest renaming to (get|set)_input_flags(), similar to
__(get|set)_output_flag() (which get/set a single flag instead of
multiple).

Cheers, Phil
