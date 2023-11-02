Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1241AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 15:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbjKBPy5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjKBPy4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 11:54:56 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66D913E
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 08:54:51 -0700 (PDT)
Received: from [78.30.35.151] (port=59060 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qya1v-009l1X-D9; Thu, 02 Nov 2023 16:54:49 +0100
Date:   Thu, 2 Nov 2023 16:54:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <ZUPGRh7JZFGXfGgE@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 03:09:42PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 12:27 +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 02, 2023 at 12:20:29PM +0100, Thomas Haller wrote:
> > > By now, all "struct expr_ops" have a json() hook set. Thus, drop
> > > handling the possibility that they might not. From now on, it's a
> > > bug
> > > to create a ops without the hook.
> > > 
> > > It's not clear what the code tried to do. It bothered to implement
> > > a
> > > fallback via fmemopen(), but apparently that fallback is no
> > > considered a
> > > good solution as it also printed a "warning". Either the fallback
> > > is
> > > good and does not warrant a warning. Or the condition is to be
> > > avoided
> > > to begin with, which we should do by testing the expr_ops
> > > structures.
> > > 
> > > As the fallback path has an overhead to create the memory stream,
> > > the
> > > fallback path is indeed not great. That is the reason to outlaw a
> > > missing json() hook, to require that all hooks are present, and to
> > > drop
> > > the fallback path.
> > > 
> > > A missing hook is very easy to cover with unit tests. Such a test
> > > shall
> > > be added soon.
> > 
> > That's fine to simplify code.
> > 
> > But then, in 1/2 you better set some STUB that hits BUG() because we
> > should not ever see variable and symbol expression from json listing
> > path ever.
> > 
> 
> I think BUG() would not work. This does happen, as the tests in patches
> 
> Subject:	[PATCH nft 0/7] add and check dump files for JSON in tests/shell
> Date:	Tue, 31 Oct 2023 19:53:26 +0100
> 
> expose.

No listing from the kernel would use the variable expression.

What example would be triggering bug?
