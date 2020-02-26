Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB15C4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8B324684
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFG5lFE6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgBZLDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:03:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42694 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727362AbgBZLDH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582714986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yISX8OrkxfmsmeY3SzFIS/Eqjq+YoJCosZCI/7ItrU=;
        b=AFG5lFE6gvaQO0dVlpuPNO7u6jzgWPU4G5TYdOljRkwWvFDeIE9o+AybA1kGtqfoV0z3xR
        kEsFKPVfLNZktNwXU5RJGC993AM/E6pMYbIpK3Ji2xpi7tg3JwjLa1dz+DQE+fRluCgsxU
        lwLEiNukE2+XSNkGfMhGtQJTlEOnWM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-TAKt7iWgM_GBsf-I0nFQOw-1; Wed, 26 Feb 2020 06:03:02 -0500
X-MC-Unique: TAKt7iWgM_GBsf-I0nFQOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2607B13E2;
        Wed, 26 Feb 2020 11:03:01 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 819E060BE1;
        Wed, 26 Feb 2020 11:02:59 +0000 (UTC)
Date:   Wed, 26 Feb 2020 12:02:53 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200226120253.71e9f0e0@redhat.com>
In-Reply-To: <20200226105804.xramr6duqkvrtop3@salvia>
References: <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
        <20200225213815.3c0a1caa@redhat.com>
        <20200225205847.s5pjjp652unj6u7v@salvia>
        <20200226105804.xramr6duqkvrtop3@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 26 Feb 2020 11:58:04 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, Feb 25, 2020 at 09:58:47PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Feb 25, 2020 at 09:38:15PM +0100, Stefano Brivio wrote:  
> > > On Tue, 25 Feb 2020 21:21:43 +0100
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >   
> > > > Hi Stefano,
> > > > 
> > > > On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
> > > > [...]  
> > > > > This is the problem Phil reported:    
> > > > [...]  
> > > > > Or also simply with:
> > > > > 
> > > > > # nft add element t s '{ 20-30 . 40 }'
> > > > > # nft add element t s '{ 25-35 . 40 }'
> > > > > 
> > > > > the second element is silently ignored. I'm returning -EEXIST from
> > > > > nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> > > > > is not set.
> > > > > 
> > > > > Are you suggesting that this is consistent and therefore not a problem?    
> > > > 
> > > >                         NLM_F_EXCL      !NLM_F_EXCL
> > > >         exact match       EEXIST             0 [*]
> > > >         partial match     EEXIST           EEXIST
> > > > 
> > > > The [*] case would allow for element timeout/expiration updates from
> > > > the control plane for exact matches.  
> > > 
> > > A-ha. I didn't even consider that.
> > >   
> > > > Note that element updates are not
> > > > supported yet, so this check for !NLM_F_EXCL is a stub. I don't think
> > > > we should allow for updates on partial matches
> > > > 
> > > > I think what it is missing is a error to report "partial match" from
> > > > pipapo. Then, the core translates this "partial match" error to EEXIST
> > > > whether NLM_F_EXCL is set or not.  
> > > 
> > > Yes, given what you explained, I also think it's the case.
> > >   
> > > > Would this work for you?  
> > > 
> > > It would. I need to write a few more lines in nft_pipapo_insert(),
> > > because right now I don't have a special case for "entirely
> > > overlapping". Something on the lines of:
> > > 
> > > 	dup = pipapo_get(net, set, start, genmask);
> > > 	if (PTR_ERR(dup) == -ENOENT) {
> > >   
> > > -->		compare start and end key for this entry with  
> > > 		start and end key from 'ext'
> > > 
> > > Let me know if you want me to post a patch with a placeholder for
> > > whatever you have in mind, or if I can help implementing this, etc.  
> > 
> > Please, go ahead with the placeholder, it might be faster. I'll jump
> > on it.  
> 
> Sorry, I just realized I can be probably quicker on the core side.
> Here is my proposal.
> 
> I'm attaching a patch for the core. This is handling -ENOTEMPTY which
> is (ab)used to report the partial element matching.
> 
> if NLM_F_EXCL is set off, then -EEXIST becomes 0.
>                           then -ENOTEMPTY becomes -EEXIST.
> 
> Would this work for you?

Oops, I sent you my patch 80 seconds later it seems. Yes, we just need
to s/TTY/TEMPTY/ :)

Let me know how to proceed, if you want me to post that or you want to
post that (as a series?).

-- 
Stefano

