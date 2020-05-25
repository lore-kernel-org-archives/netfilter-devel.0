Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C1FC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DD96207CB
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrTRGFK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbgEYXM7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 19:12:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388013AbgEYXM6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 19:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590448377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23yZX1zUbmHuoJVCxOAtiEg+gBPm9DsAUbx53XNyBPM=;
        b=FrTRGFK0alWQVZ6pynMUd5xHF2W+hevPRs7Pe3/SgCzTiqTWLzRhfB1gX+pCvITBkclrz1
        G/bkR3uPP84J0rlFItQrb6B9nTc2Rrl/E7S1yRTTW/CvZjOVgEV/9I2+qiTJuzFAKX1G5j
        xx7i2jSk+iphigoQg1sL5s8/IMLDzWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-QUZDZEVjPu2li5Q5aPqSOQ-1; Mon, 25 May 2020 19:12:53 -0400
X-MC-Unique: QUZDZEVjPu2li5Q5aPqSOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD6E980B72F;
        Mon, 25 May 2020 23:12:52 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4B9610013D2;
        Mon, 25 May 2020 23:12:51 +0000 (UTC)
Date:   Tue, 26 May 2020 01:12:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: Introduce test for concatenated
 ranges in anonymous sets
Message-ID: <20200526011247.71f5c6e1@redhat.com>
In-Reply-To: <20200525154834.GU17795@orbyte.nwl.cc>
References: <cover.1590324033.git.sbrivio@redhat.com>
        <5735155a0e98738cdc5507385d6225e05c225465.1590324033.git.sbrivio@redhat.com>
        <20200525154834.GU17795@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 May 2020 17:48:34 +0200
Phil Sutter <phil@nwl.cc> wrote:

> On Sun, May 24, 2020 at 03:00:27PM +0200, Stefano Brivio wrote:
> > Add a simple anonymous set including a concatenated range and check
> > it's inserted correctly. This is roughly based on the existing
> > 0025_anonymous_set_0 test case.  
> 
> I think this is pretty much redundant to what tests/py/inet/sets.t tests
> if you simply enable the anonymous set rule I added in commit
> 64b9aa3803dd1 ("tests/py: Add tests involving concatenated ranges").

Nice, I wasn't aware of that one. Anyway, this isn't really redundant
as it also checks that sets are reported back correctly (which I
expected to break, even if it didn't) by comparing with the dump file,
instead of just checking netlink messages.

So I'd actually suggest that we keep this and I'd send another patch
(should I repost this series? A separate patch?) to enable the rule you
added for py tests.

-- 
Stefano

