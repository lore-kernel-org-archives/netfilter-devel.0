Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DC8C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC7F2067B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJI2IRD1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgFOMlw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:41:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728285AbgFOMlw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 08:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592224910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8/yikCvs0xoMeewjzCW267u7ytKoVNUNFotazMivs64=;
        b=iJI2IRD1Fgty54L2nR0P4sOOm9AcUK5zW1JlHFjJQN70ko2XaLt9B8VX9+2W1VjwfNWRoN
        zowR4co4RGs70Gzyy1ZgXYKGpkQFcF7slk5IRjGjymoRMiNqcByor+hJ20rEqGNGAEYhDt
        6/iFo5q8CTLPxGhyDlmjQmO7nKfv/8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-tQ3cRJtRO3GcA05XSxZEzA-1; Mon, 15 Jun 2020 08:41:45 -0400
X-MC-Unique: tQ3cRJtRO3GcA05XSxZEzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 426E2835B73;
        Mon, 15 Jun 2020 12:41:02 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D57687FE82;
        Mon, 15 Jun 2020 12:41:00 +0000 (UTC)
Date:   Mon, 15 Jun 2020 14:40:55 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?UTF-8?B?R2FyY8OtYSBM?= =?UTF-8?B?acOpYmFuYQ==?= 
        <nevola@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Message-ID: <20200615144055.31bbfd66@redhat.com>
In-Reply-To: <20200615115424.GJ23632@orbyte.nwl.cc>
References: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
        <20200615090044.GH23632@orbyte.nwl.cc>
        <20200615121811.08c347e2@redhat.com>
        <20200615115424.GJ23632@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 15 Jun 2020 13:54:24 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi Stefano,
> 
> On Mon, Jun 15, 2020 at 12:18:11PM +0200, Stefano Brivio wrote:
> > On Mon, 15 Jun 2020 11:00:44 +0200
> > Phil Sutter <phil@nwl.cc> wrote:
> >   
> > > Hi Stefano,
> > > 
> > > On Sun, Jun 14, 2020 at 11:41:49PM +0200, Stefano Brivio wrote:  
> > > > Commit 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")
> > > > introduced the definition of DIFF at the top of run-tests.sh, to make
> > > > it visually part of the configuration section. Commit 68310ba0f9c2
> > > > ("tests: shell: Search diff tool once and for all") override this
> > > > definition.
> > > > 
> > > > Drop the unexpected redefinition of DIFF.    
> > > 
> > > I would fix it the other way round, dropping the first definition.  
> > 
> > Then it's not visibly configurable anymore. It was in 2018, so it
> > looks like a regression to me.  
> 
> Hmm? Commit 68310ba0f9c2 is from January this year?!

Commit 7d93e2c2fbc7 (which makes it "configurable") is from March 2018.

> > > It's likely a missing bit from commit 68310ba0f9c20, the second
> > > definition is in line with FIND and MODPROBE definitions immediately
> > > preceding it.  
> > 
> > I see a few issues with those blocks:
> > 
> > - that should be a single function called (once or multiple times) for
> >   nft, find, modprobe, diff, anything else we'll need in the future.
> >   It would avoid any oversight of this kind and keep the script
> >   cleaner. For example, what makes sort(1) special here?  
> 
> It is simply grown and therefore a bit inconsistent.

Yes, hence worth a minor rework perhaps? I can take care of this at
some point.

> > - quotes are applied inconsistently. If you expect multiple words from
> >   which(1), then variables should also be quoted when used, otherwise
> >   the check might go through, and we fail later  
> 
> There are needless quotes around $(...) but within single brackets we
> need them if we expect empty or multi-word strings. Typical output would
> be 'diff not found' and using '[ ! -x "$DIFF" ]' we check if which
> returned diff's path or said error message. We don't expect diff's path
> to contain spaces, hence no quoting afterwards.

Probably stupid but:

[ break nft ]

# mkdir "my secret binaries"
# cp /usr/bin/diff "my secret binaries/"
# export PATH="my secret binaries:$PATH"
# nftables/tests/shell/run-tests.sh nftables/tests/shell/testcases/listing/0003table_0
I: using nft command: nftables/tests/shell/../../src/nft

W: [FAILED]	nftables/tests/shell/testcases/listing/0003table_0: got 127
nftables/tests/shell/testcases/listing/0003table_0: line 15: my: command not found

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1

or, perhaps more reasonable:

# grep DIFF=\" nftables/tests/shell/run-tests.sh
DIFF="diff -y"
# nftables/tests/shell/run-tests.sh nftables/tests/shell/testcases/listing/0003table_0
I: using nft command: nftables/tests/shell/../../src/nft

W: [FAILED]	nftables/tests/shell/testcases/listing/0003table_0: got 1

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1

Personally, this bothers me more than some cheap, extra quotes. If the
general agreement is that it's not worth to add quotes to fix this,
fine, I would skip this the day I have time to propose the single
checking function rework I mentioned. Just let me know.

-- 
Stefano

