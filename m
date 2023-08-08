Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204D7C04FE1
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 16:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjHHQYo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjHHQXH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 12:23:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51164A5C1
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 08:49:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qTNK2-0000h3-6S; Tue, 08 Aug 2023 16:04:30 +0200
Date:   Tue, 8 Aug 2023 16:04:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 6/6] py: add Nftables.{get,set}_input() API
Message-ID: <ZNJLbiVq6QolAOvi@orbyte.nwl.cc>
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

Which would be easier if there were dedicated setter/getter pairs for
each flag. The code for debug flags optimizes for setting multiple flags
at once ("get me all the debugging now!"). Not a veto from my side
though, adding getter/setter pairs after the fact is still possible
without breaking anything.

Thanks, Phil
