Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D788CC4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjKITMK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjKITMK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:12:10 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C813A84
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:12:08 -0800 (PST)
Received: from [78.30.43.141] (port=36736 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r1ARe-00G11b-03; Thu, 09 Nov 2023 20:12:03 +0100
Date:   Thu, 9 Nov 2023 20:12:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] netlink: add and use _nftnl_udata_buf_alloc()
 helper
Message-ID: <ZU0vAe2mEenETxYJ@calendula>
References: <20231108182431.4005745-1-thaller@redhat.com>
 <20231108182431.4005745-2-thaller@redhat.com>
 <ZUz3Q5MNVxsXo0Wy@calendula>
 <86486aabb07912a51263c68c8cf45f338081fe5a.camel@redhat.com>
 <ZUz7my1Gawv5RSb4@calendula>
 <a81dc3f30da3055116ded96a2f4ad423e4ba7899.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a81dc3f30da3055116ded96a2f4ad423e4ba7899.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 09, 2023 at 05:48:57PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-09 at 16:32 +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 09, 2023 at 04:19:29PM +0100, Thomas Haller wrote:
> > > On Thu, 2023-11-09 at 16:14 +0100, Pablo Neira Ayuso wrote:
> > > > 
> > > > Add a wrapper function, no macro.
> > > > 
> > > 
> > > 
> > > memory_allocation_error() is itself a macro, as it uses
> > > __FILE__,__LINE__
> > 
> > In this case above, __FILE__ and __LINE__ does not provide much
> > information?
> 
> In which case? The patch changes a repeated pattern to a macro(),
> without changing any behavior and without questioning the use of
> __FILE__:__LINE__.
> .
> 
> > nftnl_expr_alloc() returns NULL when support for an expression is
> > missing in libnftnl,
> 
> The patch is not about nftnl_expr_alloc(). Do you mean
> nftnl_udata_buf_alloc()?
> 
> nftnl_udata_buf_alloc() fails exactly when malloc() fails. It's
> unrelated to missing "support for an expression".
> 
> >  that provides a hint on that, this is very rare
> > and it can only happen when developing support for new expressions.
> > 
> > Maybe simply say __func__ instead to know what function has failed
> > when performing the memory allocation is a hint that is fine enough.
> 
> I wouldn't use __func__. It consumes more strings in the binary while
> providing less exact information.

OK, then if you prefer a generic OOM error message, that's also fine.
