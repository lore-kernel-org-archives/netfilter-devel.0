Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE6EC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 17:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC212073B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 17:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6kpV0rH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgEZRRQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 13:17:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbgEZRRQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 13:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FULuzJ4x2OBTJeWiDpwUlM6g3nXZC9Pi9Sku/EYMvVU=;
        b=I6kpV0rHEZTWSsKNK96BQIH2uIqEu0ZKRyWzYEeCOtztNeDM9ub7+V5MPJ5DsgQvvtKXLP
        SPrHlF7vY5lxMmWMMulmrc7Pr/TVJG4YxgSW0R9ocSdeHLS+3V7Zruvs4DJ6Jdj2ZRjKJX
        OFxwAudY14qV/Uv5v8HhIDthPA5xTpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-oqqp8QbGNi6fnHSFA9zzMw-1; Tue, 26 May 2020 13:17:10 -0400
X-MC-Unique: oqqp8QbGNi6fnHSFA9zzMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 775EE107ACF8;
        Tue, 26 May 2020 17:17:09 +0000 (UTC)
Received: from localhost (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C7F60C81;
        Tue, 26 May 2020 17:17:07 +0000 (UTC)
Date:   Tue, 26 May 2020 19:17:03 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: Introduce test for concatenated
 ranges in anonymous sets
Message-ID: <20200526191703.7603a6e7@redhat.com>
In-Reply-To: <20200526133952.GX17795@orbyte.nwl.cc>
References: <cover.1590324033.git.sbrivio@redhat.com>
        <5735155a0e98738cdc5507385d6225e05c225465.1590324033.git.sbrivio@redhat.com>
        <20200525154834.GU17795@orbyte.nwl.cc>
        <20200526011247.71f5c6e1@redhat.com>
        <20200526133952.GX17795@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 26 May 2020 15:39:52 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
> 
> On Tue, May 26, 2020 at 01:12:47AM +0200, Stefano Brivio wrote:
> > On Mon, 25 May 2020 17:48:34 +0200
> > Phil Sutter <phil@nwl.cc> wrote:
> >   
> > > On Sun, May 24, 2020 at 03:00:27PM +0200, Stefano Brivio wrote:  
> > > > Add a simple anonymous set including a concatenated range and check
> > > > it's inserted correctly. This is roughly based on the existing
> > > > 0025_anonymous_set_0 test case.    
> > > 
> > > I think this is pretty much redundant to what tests/py/inet/sets.t tests
> > > if you simply enable the anonymous set rule I added in commit
> > > 64b9aa3803dd1 ("tests/py: Add tests involving concatenated ranges").  
> > 
> > Nice, I wasn't aware of that one. Anyway, this isn't really redundant
> > as it also checks that sets are reported back correctly (which I
> > expected to break, even if it didn't) by comparing with the dump file,
> > instead of just checking netlink messages.
> > 
> > So I'd actually suggest that we keep this and I'd send another patch
> > (should I repost this series? A separate patch?) to enable the rule you
> > added for py tests.  
> 
> But nft-test.py does check ruleset listing, that's what the optional
> third part of a rule line is for. The syntax is roughly:
> 
> | <rule>;(fail|ok[;<rule_out>])
> 
> It allows us to cover for asymmetric rule listings.

Oh, sorry, I didn't realise that... the README actually mentions it
(section C), Line 5, Part 3 of example), but I skipped that part.

> A simple example from any/ct.t is:
> 
> | ct mark or 0x23 == 0x11;ok;ct mark | 0x00000023 == 0x00000011
> 
> So nft reports mark values with leading zeroes (don't ask me why ;).

I guess it's actually neater that way for 32-bit fields :)

> Am I missing some extra your test does?

No, nothing. I'll replace this patch by one that simply enables the
case you already added.

-- 
Stefano

