Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309FAC04E69
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbjHPQDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbjHPQDp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:03:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E1FE2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:03:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qWIzl-00011Y-FS; Wed, 16 Aug 2023 18:03:41 +0200
Date:   Wed, 16 Aug 2023 18:03:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 4/6] py: fix exception during cleanup of
 half-initialized Nftables
Message-ID: <ZNzzXYeE8iTnL6mK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-9-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803193940.1105287-9-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:35:20PM +0200, Thomas Haller wrote:
> When we create a Nftables instance against an older library version,
> we might not find a symbol and fail with an exception when initializing
> the context object.
> 
> Then, __del__() is still called, but resulting in a second exception
> because self.__ctx is not set. Avoid that second exception.
> 
>     $ python -c 'import nftables; nftables.Nftables()'
>     Traceback (most recent call last):
>       File "<string>", line 1, in <module>
>       File "/data/src/nftables/py/nftables.py", line 90, in __init__
>         self.nft_ctx_input_get_flags = lib.nft_ctx_input_get_flags
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>       File "/usr/lib64/python3.11/ctypes/__init__.py", line 389, in __getattr__
>         func = self.__getitem__(name)
>                ^^^^^^^^^^^^^^^^^^^^^^
>       File "/usr/lib64/python3.11/ctypes/__init__.py", line 394, in __getitem__
>         func = self._FuncPtr((name_or_ordinal, self))
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>     AttributeError: /lib64/libnftables.so.1: undefined symbol: nft_ctx_input_get_flags
>     Exception ignored in: <function Nftables.__del__ at 0x7f6315a2c540>
>     Traceback (most recent call last):
>       File "/data/src/nftables/py/nftables.py", line 166, in __del__
>         self.nft_ctx_free(self.__ctx)
>         ^^^^^^^^^^^^^^^^^
>     AttributeError: 'Nftables' object has no attribute 'nft_ctx_free'
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
