Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93D8C4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C3C24685
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKRO5Rjo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBZLTl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:19:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42094 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728157AbgBZLTl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582715980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyF1WhtnQ0JN8TQJr+2ER5gT8GebTpu2xXu3unYwDjQ=;
        b=OKRO5RjohhCupCETkJOij0/pd32FGm8FhAh6PfRJCOhhnhmiaNcIfZHzIIcfCVnoO04hPr
        kTm+YhqO3i+1bLBd3kGNy3YSVlX6X4v+f6xiti3yWoO4pVyTjOtuJzBe7T/oH0zF0HdTOP
        NnEe0Os9LLc8t2lzoEoSKE0q3+feoiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-2j--k-i3Nq6kBlbxnptb9w-1; Wed, 26 Feb 2020 06:19:38 -0500
X-MC-Unique: 2j--k-i3Nq6kBlbxnptb9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03BDC800D54;
        Wed, 26 Feb 2020 11:19:37 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1967360BEF;
        Wed, 26 Feb 2020 11:19:34 +0000 (UTC)
Date:   Wed, 26 Feb 2020 12:19:24 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200226121924.4194f31d@redhat.com>
In-Reply-To: <20200226111056.5fultu3onan2vttd@salvia>
References: <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
        <20200225213815.3c0a1caa@redhat.com>
        <20200225205847.s5pjjp652unj6u7v@salvia>
        <20200226115924.461f2029@redhat.com>
        <20200226111056.5fultu3onan2vttd@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 26 Feb 2020 12:10:56 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Wed, Feb 26, 2020 at 11:59:24AM +0100, Stefano Brivio wrote:
> [...]
> > One detail, unrelated to this patch, that I should probably document in
> > man pages and Wiki (I forgot, it occurred to me while testing): it is
> > allowed to insert an entry if a proper subset of it, with no
> > overlapping bounds, is already inserted. The reverse sequence is not
> > allowed. This can be used without ambiguity due to strict guarantees
> > about ordering. That is:
> > 
> > # nft add element t s '{ 1.0.0.20-1.0.0.21 . 3.3.3.3 }'
> > # nft add element t s '{ 1.0.0.10-1.0.0.100 . 3.3.3.3 }'  
> 
> OK, so first element "shadows" the second one. And the first element
> will matching in case that address is 1.0.0.20 and 10.0.0.21. Right?

Correct.

> Your patch looks good to me, BTW.

Thanks for checking! Let me know how to proceed.

-- 
Stefano

