Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAB4CE7A81
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 08:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjIYIor (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 04:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjIYIoq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 04:44:46 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C27C0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 01:44:39 -0700 (PDT)
Received: from [78.30.34.192] (port=47940 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qkhCi-00FOWz-EC; Mon, 25 Sep 2023 10:44:34 +0200
Date:   Mon, 25 Sep 2023 10:44:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 7/9] expression: cleanup expr_ops_by_type() and
 handle u32 input
Message-ID: <ZRFIb4BhMdtfwe11@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-8-thaller@redhat.com>
 <ZQs2Pmq6J5ZdXDQb@calendula>
 <47d61eebc85999dbd2f5b7a038b00723dea70cae.camel@redhat.com>
 <ZQxQ2bDCBBZGGfAR@calendula>
 <988c6c1bc2a2fff3d0ab65bdd5c7bdb9e09499a1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <988c6c1bc2a2fff3d0ab65bdd5c7bdb9e09499a1.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 22, 2023 at 10:54:52AM +0200, Thomas Haller wrote:
> On Thu, 2023-09-21 at 16:19 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 20, 2023 at 09:28:29PM +0200, Thomas Haller wrote:
> > 
> > 
> > > The check "if (value > (uint32_t) EXPR_MAX)" is only here to ensure
> > > that nothing is lost while casting the uint32_t "value" to the enum
> > > expr_types.
> > 
> > Is this cast really required? This is to handle the hypothetical case
> > where EXPR_MAX ever gets a negative value?
> > 
> 
> EXPR_MAX is never negative.
> 
> If EXPR_MAX is treated as a signed integer, then it will be implicitly
> cast to unsigned when comparing with the uint32_t. The behavior will be
> correct without a cast.
> 
> But won't the compiler warn about comparing integers of different
> signedness?
> 
> The cast is probably not needed. But it doesn't hurt.

Applied, I removed the cast and I added a note in the commit that I
mangled this myself, it is really turns out we really need it, we can
recover it. Thanks.
