Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1777BC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 20:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E127320772
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 20:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LkiFBjBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgCaUd4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 16:33:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55779 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727852AbgCaUd4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 16:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585686835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69V0ADVKCvG54UsGZuLRynVVE0ktQx7x6a9aKVjx7Z0=;
        b=LkiFBjBR0DTTbuAHd3NUyQV8YVHosHxTaLG/Fg4q4S/+Ozdt0qr0Q7+essy4W69WDo/Fix
        t/VskacMZjE7vIY3a9/RuS20bhgyDvKVqkTpZqQuYt8Z+aM98UorXpwi0/goSJhnyEtbTq
        TqsLVjlMg7JRAPZM/1ZR5EN0HsC//Cc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-4OnmkooDN7eByM6_tY2BgQ-1; Tue, 31 Mar 2020 16:33:53 -0400
X-MC-Unique: 4OnmkooDN7eByM6_tY2BgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45EA4800D5C;
        Tue, 31 Mar 2020 20:33:52 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3FD319C6A;
        Tue, 31 Mar 2020 20:33:49 +0000 (UTC)
Date:   Tue, 31 Mar 2020 22:33:42 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 4/4] nft_set_rbtree: Detect partial overlaps on
 insertion
Message-ID: <20200331223342.03e5f9e6@elisabeth>
In-Reply-To: <20200331201209.trdh3b4r3a5fd2fe@salvia>
References: <cover.1584841602.git.sbrivio@redhat.com>
        <fa9efa91cb1fb670f6fb248db3182c7c97fa3f70.1584841602.git.sbrivio@redhat.com>
        <20200331201209.trdh3b4r3a5fd2fe@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 31 Mar 2020 22:12:27 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Sun, Mar 22, 2020 at 03:22:01AM +0100, Stefano Brivio wrote:
> > ...and return -ENOTEMPTY to the front-end in this case, instead of
> > proceeding. Currently, nft takes care of checking for these cases
> > and not sending them to the kernel, but if we drop the set_overlap()
> > call in nft we can end up in situations like:
> > 
> >  # nft add table t
> >  # nft add set t s '{ type inet_service ; flags interval ; }'
> >  # nft add element t s '{ 1 - 5 }'
> >  # nft add element t s '{ 6 - 10 }'
> >  # nft add element t s '{ 4 - 7 }'
> >  # nft list set t s
> >  table ip t {
> >  	set s {
> >  		type inet_service
> >  		flags interval
> >  		elements = { 1-3, 4-5, 6-7 }
> >  	}
> >  }
> > 
> > This change has the primary purpose of making the behaviour
> > consistent with nft_set_pipapo, but is also functional to avoid
> > inconsistent behaviour if userspace sends overlapping elements for
> > any reason.  
> 
> nftables/tests/py is reporting a regression that is related to this
> patch. If I locally revert this patch here, tests/py works fine here.

Grrr, did I really run tests/shell only after this... :(

Sorry, I'm on it.

-- 
Stefano

