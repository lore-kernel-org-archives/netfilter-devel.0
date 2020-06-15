Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEC5C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 10:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E1B206B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 10:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NO4q17BR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgFOKSf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 06:18:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgFOKSc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 06:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592216311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Fl7xRua9BD202T1dF88kN+Uk1vFmU2y81flPZHp5Go=;
        b=NO4q17BRA9QwkL5q4usXgY1gzZ1fpDDW2XYmc5oSOgJt8gDUmQ2iFRKtbRMmfA2rRZyGQ+
        3oMCLbpnAhZ7UWXKxmamcVWLrW/LX1a2Q52gZJov59J1OE9nu0JtaiaPF7/OP+Hi6VTOel
        L3pOZIDFK51vOO4Njp8IRFLDAw7alks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-01XHvmKsOEinut_-ZiEfpg-1; Mon, 15 Jun 2020 06:18:18 -0400
X-MC-Unique: 01XHvmKsOEinut_-ZiEfpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 008E41883604;
        Mon, 15 Jun 2020 10:18:17 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80D1E1A8EC;
        Mon, 15 Jun 2020 10:18:15 +0000 (UTC)
Date:   Mon, 15 Jun 2020 12:18:11 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?UTF-8?B?R2FyY8OtYSBM?= =?UTF-8?B?acOpYmFuYQ==?= 
        <nevola@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Message-ID: <20200615121811.08c347e2@redhat.com>
In-Reply-To: <20200615090044.GH23632@orbyte.nwl.cc>
References: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
        <20200615090044.GH23632@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Mon, 15 Jun 2020 11:00:44 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi Stefano,
> 
> On Sun, Jun 14, 2020 at 11:41:49PM +0200, Stefano Brivio wrote:
> > Commit 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")
> > introduced the definition of DIFF at the top of run-tests.sh, to make
> > it visually part of the configuration section. Commit 68310ba0f9c2
> > ("tests: shell: Search diff tool once and for all") override this
> > definition.
> > 
> > Drop the unexpected redefinition of DIFF.  
> 
> I would fix it the other way round, dropping the first definition.

Then it's not visibly configurable anymore. It was in 2018, so it
looks like a regression to me.

> It's likely a missing bit from commit 68310ba0f9c20, the second
> definition is in line with FIND and MODPROBE definitions immediately
> preceding it.

I see a few issues with those blocks:

- that should be a single function called (once or multiple times) for
  nft, find, modprobe, diff, anything else we'll need in the future.
  It would avoid any oversight of this kind and keep the script
  cleaner. For example, what makes sort(1) special here?

- quotes are applied inconsistently. If you expect multiple words from
  which(1), then variables should also be quoted when used, otherwise
  the check might go through, and we fail later

- we should use 'command -v', which is the standard and standardised
  way of doing this rather than which(1): 'which' has many different
  and inconsistent implementations. Will it check aliases? Should you
  suppress stdout or stderr? How do you... 'which which'?

- we should extend the configurability for single commands to all of
  them. I need to export NFT, 'diff' I can edit on top of the file, the
  rest is not configurable at all. It's easy with a single function.

...so I started rewriting that, then realised I didn't have time at the
moment and just fixed the obvious issue I saw.

If the definition on the top is not actually useful, then I'd rather
keep things this way instead of just proposing a cosmetic change for
things that would actually need a small rework.

-- 
Stefano

