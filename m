Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBE1C4BA0B
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78A624687
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W94VeEfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgBZLyT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:54:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727277AbgBZLyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582718057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Zy8GPcvbnxCVprmkjy97xsy3uJ/jS3Yk70iM6+/ypU=;
        b=W94VeEfd4aTdqL3Xmdd8bWxEJF9S2CZe+jTYqvTahUXfEHsgdhbCSPMDbp3MfC37GLaObS
        GY+7m1OSBN0pji4ZkfKmzTLe3t6tyxjdbvn0yPkwE/ykoXCJ74aHlhyFWXb6/DCbFnUOjU
        dTOTlViJYCYEtIfOFu+QVwfInXKCP+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-H3kPKCl5PjKkzQCkrwqkHg-1; Wed, 26 Feb 2020 06:54:15 -0500
X-MC-Unique: H3kPKCl5PjKkzQCkrwqkHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB093801A06;
        Wed, 26 Feb 2020 11:54:13 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53A5E5D9CD;
        Wed, 26 Feb 2020 11:54:12 +0000 (UTC)
Date:   Wed, 26 Feb 2020 12:54:07 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200226125407.6f5bfa5e@redhat.com>
In-Reply-To: <20200226123926.3c5b1831@redhat.com>
References: <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
        <20200225213815.3c0a1caa@redhat.com>
        <20200225205847.s5pjjp652unj6u7v@salvia>
        <20200226115924.461f2029@redhat.com>
        <20200226111056.5fultu3onan2vttd@salvia>
        <20200226121924.4194f31d@redhat.com>
        <20200226113443.vudkkqzxj5qussqz@salvia>
        <20200226123926.3c5b1831@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 26 Feb 2020 12:39:26 +0100
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Wed, 26 Feb 2020 12:34:43 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > I mean, to catch elements that represents subsets/supersets of another
> > element (like in this example above), pipapo would need to make a
> > lookup for already matching rules for this new element?  
> 
> Right, and that's what those two pipapo_get() calls in
> nft_pipapo_insert() do.

Specifically, on re-reading your question: those find sets including
the subset that we would be about to insert, and forbid the insertion.

But, given an already existing proper subset with none of the bounds
overlapping ("more specific entry", by any measure), they won't return
it, so insertion can proceed.

-- 
Stefano

