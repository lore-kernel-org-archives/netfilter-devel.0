Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB61C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 14:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2C152077D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 14:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+tokmwq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgDCOM0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 10:12:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727431AbgDCOM0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 10:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585923144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JysG2Cfhvfh0JctcYoKMUX09HxGB/ZU0fO72eGyNkFY=;
        b=I+tokmwqtewxlpcSAt1zo4kcz90gbPDE2sbtQwclwQIMrYbAhRZLrdegROj8hXoNIRYAnS
        US4Vca8PglDmdtl6bYfb7aeTFmELSTrEz9VAIhFkUz88bX+Bts8bjppYASj04GM3BTZlFu
        xrrwVVqEM3MwthM4BhPKqhCeDvmBwPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-gfPedJH-OIyvwaukLjf2FA-1; Fri, 03 Apr 2020 10:12:10 -0400
X-MC-Unique: gfPedJH-OIyvwaukLjf2FA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49FEC18A6EC1;
        Fri,  3 Apr 2020 14:12:09 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E88E319756;
        Fri,  3 Apr 2020 14:12:07 +0000 (UTC)
Date:   Fri, 3 Apr 2020 16:12:02 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403161202.4d1b2322@elisabeth>
In-Reply-To: <20200403153331.53e1bbec@elisabeth>
References: <20200402214941.60097-1-pablo@netfilter.org>
        <20200403120351.cxhcdcwfpylven4k@salvia>
        <20200403142705.59f2e7d7@elisabeth>
        <20200403125029.pb2emvu24aspprw5@salvia>
        <20200403153331.53e1bbec@elisabeth>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 3 Apr 2020 15:33:31 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Fri, 3 Apr 2020 14:50:29 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Fri, Apr 03, 2020 at 02:27:05PM +0200, Stefano Brivio wrote:  
> > > On Fri, 3 Apr 2020 14:03:51 +0200
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >     
> > > > On Thu, Apr 02, 2020 at 11:49:41PM +0200, Pablo Neira Ayuso wrote:    
> > > > > This patch adds a lazy check to validate that the first element is not a
> > > > > concatenation. The segtree code does not support for concatenations,
> > > > > bail out with EOPNOTSUPP.
> > > > >
> > > > >  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > > > >  Error: Could not process rule: Operation not supported
> > > > >  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > > > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > >
> > > > > Otherwise, the segtree code barfs with:
> > > > >
> > > > >  BUG: invalid range expression type concat      
> > > > 
> > > > Hm.
> > > > 
> > > > I'm afraid this patch is not enough, the following ruleset crashes
> > > > in old kernels with recent nft:
> > > > 
> > > > flush ruleset
> > > > 
> > > > table inet filter {
> > > >         set test {
> > > >                 type ipv4_addr . ipv4_addr . inet_service
> > > >                 flags interval,timeout
> > > >                 elements = { 1.1.1.1 . 2.2.2.2 . 30 ,
> > > >                              2.2.2.2 . 3.3.3.3 . 40 ,
> > > >                              3.3.3.3 . 4.4.4.4 . 50 }
> > > >         }
> > > > 
> > > >         chain output {
> > > >                 type filter hook output priority 0; policy accept;
> > > >                 ip saddr . ip daddr . tcp dport @test counter
> > > >         }
> > > > }    
> > > 
> > > First off, sorry, it didn't occur to me to run new tests on older
> > > kernels. :/
> > > 
> > > I can't quickly run that on some older kernel right now. For my
> > > understanding, where is it crashing?    
> > 
> > When listing via
> > 
> >         nft list ruleset
> > 
> > The segtree does not know how to handle this concatenation.  
> 
> Ouch, I see.
> 
> > The only way I found to prevent this error is to bail out when adding
> > the set, ie. old kernel checks that NFT_SET_CONCAT is not supported,
> > hence it bails out.  
> 
> Right, it took me a while to realise you're referring to the flag that
> was present until v2 and I dropped in v3 (gold medal goes to truly
> yours -- I actually proposed that :/).
> 
> > I'm going to prepare patches to submit this to nf.git.  
> 
> I'm still wondering if we can come up with a userspace-only fix by
> understanding kernel support level somehow (not via flags) and refuse
> to add that type of set. I'm still checking.

Nope, sorry, I can't think of anything better than what you already
proposed.

-- 
Stefano

