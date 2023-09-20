Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69EEC04FCD
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 18:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjITSIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjITSIE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 14:08:04 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC58AD
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 11:07:58 -0700 (PDT)
Received: from [78.30.34.192] (port=44038 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qj1cB-0053Bm-BB; Wed, 20 Sep 2023 20:07:57 +0200
Date:   Wed, 20 Sep 2023 20:07:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 8/9] datatype: use __attribute__((packed)) instead of
 enum bitfields
Message-ID: <ZQs0+hZOmDPz64/s@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-9-thaller@redhat.com>
 <ZQsXoASbR1+aimMt@calendula>
 <d8bbc221d973199e2f4cd8b13d3165db9f4c0668.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8bbc221d973199e2f4cd8b13d3165db9f4c0668.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 07:48:22PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-20 at 18:02 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 20, 2023 at 04:26:09PM +0200, Thomas Haller wrote:
> > 
> > > +       enum ops                op;
> > 
> > This is saving _a lot of space_ for us, we currently have a problem
> > with memory consumption, this is going in the opposite direction.
> > 
> > I prefer to ditch this patch.
> 
> The packed enums are only one uint8_t large. The memory-saving compared
> to a :8 bitfield is exactly the same.

I see, I am not sure yet I want to give control to the compiler on the
layout of these structures, I have been using pahole to shrink them
further, specifically struct expr is critical (I have at least one
patch to reduce the size of constant expressions to safe % memory with
very 13.5%. And location for error reporting is still consuming 48
bytes per struct expr.
