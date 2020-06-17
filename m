Return-Path: <SRS0=x4zc=76=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7614EC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 20:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52DD521532
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 20:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enAP2bK4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFQUSc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 16:18:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgFQUSb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 16:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592425110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4bJTJR9XuKtiAcblECZwADM/7VJUpBh+AZo2MHSQCo=;
        b=enAP2bK4Zp328Oi9yjAm4j6gYnMe7jEvAlrQ8/wtSMFIs0Ob6ElObsXytAMKzlZ5i/tods
        nhQ+R2Ysnan/bbR8ce++boriujPlO/U9v5LY1YtJZY3ECe3FOjZQkdhOor3wpyc1UZQMDE
        iVKczl9BOQQ4px03MfuuOZqp3XHAzr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-2xlVf-oHPemd_IY0EH7Gig-1; Wed, 17 Jun 2020 16:18:28 -0400
X-MC-Unique: 2xlVf-oHPemd_IY0EH7Gig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3C561B18BD2;
        Wed, 17 Jun 2020 20:18:26 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C9A5D9EF;
        Wed, 17 Jun 2020 20:18:23 +0000 (UTC)
Date:   Wed, 17 Jun 2020 22:17:39 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] nft_set_pipapo: Drop useless assignment of
 scratch map index on insert
Message-ID: <20200617221739.7a5bf4f5@redhat.com>
In-Reply-To: <20200617200705.GA31049@salvia>
References: <033bc756cdecd4e8cbe01be3bcd50e59a844665c.1592167414.git.sbrivio@redhat.com>
        <20200617200705.GA31049@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 17 Jun 2020 22:07:05 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sun, Jun 14, 2020 at 11:42:07PM +0200, Stefano Brivio wrote:
> > In nft_pipapo_insert(), we need to reallocate scratch maps that will
> > be used for matching by lookup functions, if they have never been
> > allocated or if the bucket size changes as a result of the insertion.
> > 
> > As pipapo_realloc_scratch() provides a pair of fresh, zeroed out
> > maps, there's no need to select a particular one after reallocation.
> > 
> > Other than being useless, the existing assignment was also troubled
> > by the fact that the index was set only on the CPU performing the
> > actual insertion, as spotted by Florian.
> > 
> > Simply drop the assignment.
> > 
> > Reported-by: Florian Westphal <fw@strlen.de>
> > Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")  
> 
> Hm.
> 
> It has a Fixes: tag.
> 
> Probably route this through nf.git instead?

I wouldn't, because it just removes a redundant assignment (so I
consider it a fix) but it doesn't fix any functional issue. Is there a
specific reason why I should?

-- 
Stefano

