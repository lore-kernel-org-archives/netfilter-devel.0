Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513E2C35E04
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 19:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A3520CC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 19:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZ+aZQoW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgBYTdd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:33:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49372 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728714AbgBYTdd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 14:33:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582659211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mI+GfseGla2p090SpD16PYhsYGOsDsHLshPDGwKt9gY=;
        b=eZ+aZQoWl441s9Kv+StFQfqkhNXqqrLRmlRsk8HLYMJe80dHD3ydERRgubgqrSUZ2/E160
        vXc4M/FTDFkDre9mPRp1n6MORXwFn4ERQ/7J+GkK6oJmr51hCQinyNZ/OhPGb0SbFbQbso
        udUH8lTZkHebVEpPzWG69klAWe2PpZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-v_Lqe0MmO-6ozvQVe96NSg-1; Tue, 25 Feb 2020 14:33:29 -0500
X-MC-Unique: v_Lqe0MmO-6ozvQVe96NSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF3F2800D5A;
        Tue, 25 Feb 2020 19:33:28 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0368091824;
        Tue, 25 Feb 2020 19:33:25 +0000 (UTC)
Date:   Tue, 25 Feb 2020 20:33:19 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200225203319.5ba95a62@redhat.com>
In-Reply-To: <20200225184857.GC9532@orbyte.nwl.cc>
References: <cover.1582250437.git.sbrivio@redhat.com>
        <20200221211704.GM20005@orbyte.nwl.cc>
        <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225184857.GC9532@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020 19:48:57 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
> 
> Sorry for jumping back into the discussion this late.
> 
> On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
> [...]
> > Or also simply with:
> > 
> > # nft add element t s '{ 20-30 . 40 }'
> > # nft add element t s '{ 25-35 . 40 }'
> > 
> > the second element is silently ignored. I'm returning -EEXIST from
> > nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> > is not set.
> > 
> > Are you suggesting that this is consistent and therefore not a problem?
> > 
> > Or are you proposing that I should handle this in userspace as it's done
> > for non-concatenated ranges?  
> 
> The problem is that user tried to add a new element which is not yet
> contained and the 'add element' command is the same as if it was
> identical to an existing one. We must not ignore this situation as the
> user needs to know: In the above case e.g., element '35 . 40' won't
> match after the zero-return from 'add element' command.
> 
> At first I assumed we could merge e.g.:
> 
> | { 20-30 . 40-50, 25-35 . 45-55 }
> 
> into:
> 
> | { 20-35 . 40-55 }
> 
> But now I realize this is wrong. We would match e.g. '{ 20 . 55 }', a
> combination the user never specified.
> 
> Given that merging multiple concatenated ranges is a non-trivial task, I
> guess the only sane thing to do (for now at least) is to perform overlap
> detection in user space and reject the command if an overlap is
> detected. Stefano, do you see any problems with that?

Functionally, it's doable. The downsides I see are:

1. This logic is already implemented by pipapo, so I would duplicate
   it.

   Other than code duplication itself, the worst part is the risk of
   (accidental) mismatch between the two implementations, and the fact
   that if we ever want to change this logic, we'll have to change it in
   two places (taking care of not breaking API, etc.)

2. It's going to be a bit more complicated than interval_overlap(),
   expect perhaps 50 LoCs, plus conditionals to select
   interval_overlap() or something_else_overlap()

3. [very, very debatable] I consider accepting already existing
   entries, without returning -EEXIST, a bug, no matter if NLM_F_EXCL
   was not passed: NLM_F_EXCL should simply mean what RFC 3549 says,
   that is, "Don't replace the config object if it already exists.". By
   leaving that "error clearing" in the API, we maintain this. On the
   other hand, even in the unlikely case we agree it's a bug, "fixing"
   it comes with UAPI breakage risks, too.

So, yes, I would like to avoid that, but if:

a. I can't return anything else than -EEXIST from nft_pipapo_insert()

b. I can't remove that "if (err == -EEXIST) err = 0;" part

then I don't see any other solution than implementing it in userspace.
I hope somebody had better ideas, but if not, I would go ahead and
implement it in userspace.

-- 
Stefano

