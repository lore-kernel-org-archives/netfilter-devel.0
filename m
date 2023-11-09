Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4F2C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjKIPcu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjKIPct (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:32:49 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FC81BD
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:32:47 -0800 (PST)
Received: from [78.30.43.141] (port=36988 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r171P-00FAQU-Px; Thu, 09 Nov 2023 16:32:45 +0100
Date:   Thu, 9 Nov 2023 16:32:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] netlink: add and use _nftnl_udata_buf_alloc()
 helper
Message-ID: <ZUz7my1Gawv5RSb4@calendula>
References: <20231108182431.4005745-1-thaller@redhat.com>
 <20231108182431.4005745-2-thaller@redhat.com>
 <ZUz3Q5MNVxsXo0Wy@calendula>
 <86486aabb07912a51263c68c8cf45f338081fe5a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86486aabb07912a51263c68c8cf45f338081fe5a.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 09, 2023 at 04:19:29PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-09 at 16:14 +0100, Pablo Neira Ayuso wrote:
> > On Wed, Nov 08, 2023 at 07:24:25PM +0100, Thomas Haller wrote:
> > > We don't want to handle allocation errors, but crash via
> > > memory_allocation_error().
> > > Also, we usually just allocate NFT_USERDATA_MAXLEN buffers.
> > > 
> > > Add a helper for that and use it.
> > > 
> > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > ---
> > >  include/netlink.h       |  3 +++
> > >  src/mnl.c               | 16 ++++------------
> > >  src/netlink.c           |  7 ++-----
> > >  src/netlink_linearize.c |  4 +---
> > >  4 files changed, 10 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/include/netlink.h b/include/netlink.h
> > > index 6766d7e8563f..15cbb332c8dd 100644
> > > --- a/include/netlink.h
> > > +++ b/include/netlink.h
> > > @@ -260,4 +260,7 @@ struct nft_expr_loc *nft_expr_loc_find(const
> > > struct nftnl_expr *nle,
> > >  
> > >  struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx);
> > >  
> > > +#define _nftnl_udata_buf_alloc() \
> > > +	memory_allocation_check(nftnl_udata_buf_alloc(NFT_USERDATA
> > > _MAXLEN))
> > 
> > Add a wrapper function, no macro.
> > 
> 
> Hi,
> 
> memory_allocation_error() is itself a macro, as it uses
> __FILE__,__LINE__

In this case above, __FILE__ and __LINE__ does not provide much
information?

nftnl_expr_alloc() returns NULL when support for an expression is
missing in libnftnl, that provides a hint on that, this is very rare
and it can only happen when developing support for new expressions.

Maybe simply say __func__ instead to know what function has failed
when performing the memory allocation is a hint that is fine enough.

> This is also a macro, to preserve those parameters.
> 
> Thomas
> 
