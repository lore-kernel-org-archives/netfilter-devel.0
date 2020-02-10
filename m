Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0211C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B9820714
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Al47rbMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBJQRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:17:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727120AbgBJQRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 11:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581351422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ZamFt8wxbFYjU754FZ+09R9duFzP70MIt5gK/keTVc=;
        b=Al47rbMmUg/VfZI9IW2zkUz5A70UoMFpRD81KEroId9ffFW1NvehKWB06KhZF5CKc52Jcf
        JRYQ95VNAkgM3V4z/lw6dPzNieJVQWMnDjfRuuluEtBhPqpz7sp3M0Thf8nPfUEQIBqkr1
        AzetXjb9oJ52sxx/iCRvsi25XjQlLLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-2rQWViLaMd69boBjJhshRQ-1; Mon, 10 Feb 2020 11:16:58 -0500
X-MC-Unique: 2rQWViLaMd69boBjJhshRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41CA810054E3;
        Mon, 10 Feb 2020 16:16:56 +0000 (UTC)
Received: from elisabeth (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 109555C1D6;
        Mon, 10 Feb 2020 16:16:52 +0000 (UTC)
Date:   Mon, 10 Feb 2020 17:16:47 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft v4 4/4] tests: Introduce test for set with
 concatenated ranges
Message-ID: <20200210171647.12948007@elisabeth>
In-Reply-To: <20200210160410.GH2991@breakpoint.cc>
References: <cover.1580342294.git.sbrivio@redhat.com>
        <6f1dbaf2ab5a98b2616b14d93ee589a7e741e5f9.1580342294.git.sbrivio@redhat.com>
        <20200207103442.3fnk6rrxzny7hvoa@salvia>
        <20200210160840.695a031c@redhat.com>
        <20200210160410.GH2991@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 10 Feb 2020 17:04:10 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > On Fri, 7 Feb 2020 11:34:42 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > On Thu, Jan 30, 2020 at 01:16:58AM +0100, Stefano Brivio wrote:  
> > > > This test checks that set elements can be added, deleted, that
> > > > addition and deletion are refused when appropriate, that entries
> > > > time out properly, and that they can be fetched by matching values
> > > > in the given ranges.    
> > > 
> > > I'll keep this back so Phil doesn't have to do some knitting work
> > > meanwhile the tests finishes for those 3 minutes.  
> > 
> > But I wanted to see his production :(
> >   
> > > If this can be shortened, better. Probably you can add a parameter to
> > > enable the extra torture test mode not that is away from the
> > > ./run-test.sh path.  
> > 
> > I can't think of an easy way to remove that sleep(1), I could decrease
> > the timeouts passed to nft but then there's no portable way to wait for
> > less than one second.  
> 
> Even busybox' sleep can do 'sleep 0.01'

Wait, that's only if you build it with ENABLE_FEATURE_FANCY_SLEEP and
ENABLE_FLOAT_DURATION.

> do we really need to be *that* portable?

I don't actually know :)

However, with Phil's idea:

On Mon, 10 Feb 2020 16:51:47 +0100
Phil Sutter <phil@nwl.cc> wrote:

> You could test the timeout feature just once and for all? I doubt there
> will ever be a bug in that feature which only a certain data type
> exposes, but you may e.g. create all the sets with elements at the same
> time so waiting for the timeout once is enough.

which I think is entirely reasonable, this becomes a single
one-second sleep, so it shouldn't be a problem anymore.

I would propose that I try this first, see if it gets reasonable, if
it's not enough I'd go on and just reduce the number of combinations
depending on how the script is invoked.

-- 
Stefano

