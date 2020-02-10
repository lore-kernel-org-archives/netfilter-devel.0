Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19465C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D2120661
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJZ/bVPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgBJPJJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:09:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbgBJPJJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581347348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+D+BBxGcSs0uQSMfygFD/KR7tIcPePfrffZeb+n+bg=;
        b=HJZ/bVPv/lwNnwzGaj0AirktylmPa+g7C9+Za5lPYC69FQ9Snt6yKBVILqhq0/LEmQgVTe
        VQ16xhEQ6c4IgQaGMvgJqzs/tq2T4AXCxf6e2nn2EulkHIMqLekWOP7YeQzFw+yCJ4s1+z
        dzMKuU719KCeler1aAmsEZ8SSBGrx5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-xl2yFSy5Pw-CBD2AOrNgYQ-1; Mon, 10 Feb 2020 10:08:50 -0500
X-MC-Unique: xl2yFSy5Pw-CBD2AOrNgYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9521E800D4E;
        Mon, 10 Feb 2020 15:08:48 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE2A68ED05;
        Mon, 10 Feb 2020 15:08:45 +0000 (UTC)
Date:   Mon, 10 Feb 2020 16:08:40 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 4/4] tests: Introduce test for set with
 concatenated ranges
Message-ID: <20200210160840.695a031c@redhat.com>
In-Reply-To: <20200207103442.3fnk6rrxzny7hvoa@salvia>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <6f1dbaf2ab5a98b2616b14d93ee589a7e741e5f9.1580342294.git.sbrivio@redhat.com>
 <20200207103442.3fnk6rrxzny7hvoa@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 Feb 2020 11:34:42 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Jan 30, 2020 at 01:16:58AM +0100, Stefano Brivio wrote:
> > This test checks that set elements can be added, deleted, that
> > addition and deletion are refused when appropriate, that entries
> > time out properly, and that they can be fetched by matching values
> > in the given ranges.  
> 
> I'll keep this back so Phil doesn't have to do some knitting work
> meanwhile the tests finishes for those 3 minutes.

But I wanted to see his production :(

> If this can be shortened, better. Probably you can add a parameter to
> enable the extra torture test mode not that is away from the
> ./run-test.sh path.

I can't think of an easy way to remove that sleep(1), I could decrease
the timeouts passed to nft but then there's no portable way to wait for
less than one second.

Probably a good way to make it faster and still retain coverage would
be to decrease the amount of combinations. Right now, most of the 6 ^ 3
combinations (six "types", three values each to have: single, prefix,
range -- where allowed) are tested. I could stop after the first 3 x 3
matrix instead, if we come from run-tests.sh.

Let me know if you have other ideas, otherwise I'd send a patch doing
this.

-- 
Stefano

