Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F281AC2D0E8
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 10:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C323820737
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 10:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNxBarwQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390647AbgDCKns (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 06:43:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgDCKnr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 06:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585910626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1OWBQ7fYkr2G70wHyyKCnl2D2lcMsGhcnQlDQ0s64g=;
        b=XNxBarwQqXmJ2mv/wzab1u0J+9v8IKYPKJU/2/3odCa6jYfa34pOQJimUuJx3IaTY0MyZ8
        s/ZqKI548nDXBhn6oBV/HohPDUjWVpDZOIWLiiqhNvOYT4vsO197zAPs3zpl7Syp0srowi
        1yfQQ6NEalP6fODMbFexXvWUmDy6cWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-riprelAYPwq-rIdCe6o2Pg-1; Fri, 03 Apr 2020 06:43:31 -0400
X-MC-Unique: riprelAYPwq-rIdCe6o2Pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 916401005509;
        Fri,  3 Apr 2020 10:43:30 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54EF91001925;
        Fri,  3 Apr 2020 10:43:27 +0000 (UTC)
Date:   Fri, 3 Apr 2020 12:43:20 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403124320.4c2c62e8@elisabeth>
In-Reply-To: <20200403103954.jwmk5ijfoi7ggaxe@salvia>
References: <20200402214941.60097-1-pablo@netfilter.org>
        <20200403025453.7c5f00ba@elisabeth>
        <20200403103954.jwmk5ijfoi7ggaxe@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 3 Apr 2020 12:39:54 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi,
> 
> On Fri, Apr 03, 2020 at 02:54:53AM +0200, Stefano Brivio wrote:
> > Hi,
> > 
> > On Thu,  2 Apr 2020 23:49:41 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > This patch adds a lazy check to validate that the first element is not a
> > > concatenation. The segtree code does not support for concatenations,
> > > bail out with EOPNOTSUPP.
> > > 
> > >  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > >  Error: Could not process rule: Operation not supported
> > >  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > Otherwise, the segtree code barfs with:
> > > 
> > >  BUG: invalid range expression type concat
> > > 
> > > Reported-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>  
> > 
> > I know you both reported this to me, sorry, I still have to polish up
> > the actual fix before posting it. I'm not very familiar with this code
> > yet, and it's taking ages.
> > 
> > It might be a few more days before I get to it, so I guess this patch
> > might make sense for the moment being.  
> 
> I think this one might not be worth to look further. This only happens
> with old kernel and new nft binary.
>
> [...]
>
> Not related to this patch, Phil reported this one is still broken:
> 
>         ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept

Grrr, yes, I mixed up the two problems, and it was you and Phil, not
Florian, reporting this.

This is what my message really was about, sorry for the confusion.

-- 
Stefano

