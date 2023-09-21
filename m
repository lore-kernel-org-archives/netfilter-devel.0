Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05CCE7D0AD
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 21:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjIUVHB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbjIUVFj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 17:05:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3656DE04
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:32:35 -0700 (PDT)
Received: from [78.30.34.192] (port=50184 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qjKaF-009oVU-Jc; Thu, 21 Sep 2023 16:23:13 +0200
Date:   Thu, 21 Sep 2023 16:23:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/9] datatype: drop flags field from datatype
Message-ID: <ZQxRziOfXho5SZ7e@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-4-thaller@redhat.com>
 <ZQs1msEk15D687Rn@calendula>
 <546258d1a67ca455e0f7fdcce4c58c587324e798.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546258d1a67ca455e0f7fdcce4c58c587324e798.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 09:23:46PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-20 at 20:10 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 20, 2023 at 04:26:04PM +0200, Thomas Haller wrote:
> > > Flags are not always bad. For example, as a function argument they
> > > allow
> > > easier extension in the future. But with datatype's "flags"
> > > argument and
> > > enum datatype_flags there are no advantages of this approach.
> > > 
> > > - replace DTYPE_F_PREFIX with a "bool f_prefix" field. This could
> > > even
> > >   be a bool:1 bitfield if we cared to represent the information
> > > with
> > >   one bit only. For now it's not done because that would not help
> > > reducing
> > >   the size of the struct, so a bitfield is less preferable.
> > > 
> > > - instead of DTYPE_F_ALLOC, use the refcnt of zero to represent
> > > static
> > >   instances. Drop this redundant flag.
> > 
> > Not sure I want to rely on refcnt to zero to identify dynamic
> > datatypes. I think we need to consolidate datatype_set() to be used
> > not only where this deals with dynamic datatypes, it might help
> > improve traceability of datatype assignment.
> 
> I don't understand. Could you elaborate about datatype_set()?

I wonder if we could use datatype_set() to attach static datatypes
too, instead of manually attaching datatypes, such as:

        expr->dtype = &integer_type;

in case of future extensions, using consistently this helper function
will help to identify datatype attachments.

> Btw, for dynamically allocated instances the refcnt is always positive,
> and for static ones it's always zero. The DTYPE_F_ALLOC flag is
> redundant.

That is a correct observation, but a (hipothetical) subtle bug in
refcnt might lead to a dynamic datatype get to refcnt to zero, and
that might be harder to track?

Let me have a look if I can come up with some counter proposal to get
rid of this flag, I would prefer not to infer the datatype class from
reference counter value.
