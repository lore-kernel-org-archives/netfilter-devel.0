Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE217C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 10:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6E561157
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 10:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhEFKBe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 May 2021 06:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhEFKBd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 May 2021 06:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620295233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzCAqmjnuZ4XxbV4ziGCB3WGqSEk94VXz3GHn4i6PMU=;
        b=bmdNWribzcBXYbQEwjOn65HnxDhCevjShNIvfYI5R3wPMoRTY24ZdJkcmh0dwkwIeVScQZ
        a3Q0dSLy+XBQd05fR6oqtOZ04/oyZkv0rd6a3kLZXCNhCo7ADlyrZIjOVj8zFJ/hZtwc+5
        /r847cFOpmeM3eZkyjz/ZyorH9WIm6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-YehGp6GrNBWK9gRNThPv2A-1; Thu, 06 May 2021 06:00:27 -0400
X-MC-Unique: YehGp6GrNBWK9gRNThPv2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E7B80059E;
        Thu,  6 May 2021 10:00:26 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3376D348AF;
        Thu,  6 May 2021 10:00:24 +0000 (UTC)
Date:   Thu, 6 May 2021 12:00:21 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] segtree: Fix range_mask_len() for subnet ranges
 exceeding unsigned int
Message-ID: <20210506120021.1bd82275@elisabeth>
In-Reply-To: <20210506091814.GG12403@orbyte.nwl.cc>
References: <cover.1620252768.git.sbrivio@redhat.com>
        <5ff3ceab3d3a547ab23144adbfa2000f1604c39f.1620252768.git.sbrivio@redhat.com>
        <20210506091814.GG12403@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 6 May 2021 11:18:14 +0200
Phil Sutter <phil@nwl.cc> wrote:

> On Thu, May 06, 2021 at 12:23:13AM +0200, Stefano Brivio wrote:
> > As concatenated ranges are fetched from kernel sets and displayed to
> > the user, range_mask_len() evaluates whether the range is suitable for
> > display as netmask, and in that case it calculates the mask length by
> > right-shifting the endpoints until no set bits are left, but in the
> > existing version the temporary copies of the endpoints are derived by
> > copying their unsigned int representation, which doesn't suffice for
> > IPv6 netmask lengths, in general.
> > 
> > PetrB reports that, after inserting a /56 subnet in a concatenated set
> > element, it's listed as a /64 range. In fact, this happens for any
> > IPv6 mask shorter than 64 bits.
> > 
> > Fix this issue by simply sourcing the range endpoints provided by the
> > caller and setting the temporary copies with mpz_init_set(), instead
> > of fetching the unsigned int representation. The issue only affects
> > displaying of the masks, setting elements already works as expected.
> 
> Fixes: 8ac2f3b2fca38 ("src: Add support for concatenated set ranges")

Thanks Phil! I even looked it up and forgot to paste it ;)

> > Reported-by: PetrB <petr.boltik@gmail.com>
> > Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1520
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  src/segtree.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/segtree.c b/src/segtree.c
> > index ad199355532e..353a0053ebc0 100644
> > --- a/src/segtree.c
> > +++ b/src/segtree.c
> > @@ -838,8 +838,8 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
> >  	mpz_t tmp_start, tmp_end;
> >  	int ret;
> >  
> > -	mpz_init_set_ui(tmp_start, mpz_get_ui(start));
> > -	mpz_init_set_ui(tmp_end, mpz_get_ui(end));
> > +	mpz_init_set(tmp_start, start);
> > +	mpz_init_set(tmp_end, end);  
> 
> The old code is a bit funny, was there a specific reason why you
> exported the values into a C variable intermediately?

Laziness, ultimately: I didn't remember the name of gmp_printf(),
didn't look it up, and used a fprintf() instead to check 'start' and
'end'... and then whoops, I left the mpz_get_ui() calls there.

-- 
Stefano

