Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5892CC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31CA7206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AN5d6ZFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgFNVnx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:43:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33948 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727939AbgFNVnw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592171031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qd7LHchc9/98Rsp1VNt1fYy053m+42VuixLxJq7uKCY=;
        b=AN5d6ZFZbjCFyyYIKmFg3ItlU3uuJTIHm0y6fgT5IKXdq/kJA69ms0tm5qIIAQfjjQlxEl
        +lE5NsF8Evn6NpGWi3XaRGLTFwV3M0lM3CxveRH9dusQ1/MH5/BpBZErKIPQjH3U8ySquc
        HMGpi1MVnXHvco6SytOCkcglL+4Xtso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-9z9HAw8INTOT67ATW-6qmg-1; Sun, 14 Jun 2020 17:43:42 -0400
X-MC-Unique: 9z9HAw8INTOT67ATW-6qmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2D181005512;
        Sun, 14 Jun 2020 21:43:41 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DF419CA0;
        Sun, 14 Jun 2020 21:43:39 +0000 (UTC)
Date:   Sun, 14 Jun 2020 23:43:35 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Avoid breaking basic connectivity
 when run
Message-ID: <20200614234335.3b3f6dc0@redhat.com>
In-Reply-To: <20200526135249.GY17795@orbyte.nwl.cc>
References: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
        <20200525155952.GW17795@orbyte.nwl.cc>
        <20200526011236.2fe8ae7b@redhat.com>
        <20200526135249.GY17795@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[I was going once more over your comments before sending the new patch,
realised I didn't answer...]

On Tue, 26 May 2020 15:52:49 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
> 
> On Tue, May 26, 2020 at 01:12:36AM +0200, Stefano Brivio wrote:
> > On Mon, 25 May 2020 17:59:52 +0200
> > Phil Sutter <phil@nwl.cc> wrote:  
> > > On Sun, May 24, 2020 at 02:59:57PM +0200, Stefano Brivio wrote:  
> > > > It might be convenient to run tests from a development branch that
> > > > resides on another host, and if we break connectivity on the test
> > > > host as tests are executed, we con't run them this way.
> > > > 
> > > > To preserve connectivity, for shell tests, we can simply use the
> > > > 'forward' hook instead of 'input' in chains/0036_policy_variable_0
> > > > and transactions/0011_chain_0, without affecting test coverage.
> > > > 
> > > > For py tests, this is more complicated as some test cases install
> > > > chains for all the available hooks, and we would probably need a
> > > > more refined approach to avoid dropping relevant traffic, so I'm
> > > > not covering that right now.    
> > > 
> > > This is a recurring issue, iptables testsuites suffer from this problem
> > > as well. There it was solved by running everything in a dedicated netns:
> > > 
> > > iptables/tests/shell: Call testscripts via 'unshare -n <file>'.
> > > iptables-test.py: If called with --netns, 'ip netns exec <foo>' is
> > > added as prefix to any of the iptables commands.  
> > 
> > Funny, I thought about doing that in the past and stopped before I could
> > even type 'unshare'. Silly, everything will break, I thought.
> > 
> > Nope, not at all, now that you say that... both 'unshare -n
> > ./nft-test.py' and 'unshare -n ./run-tests.sh' worked flawlessly.
> > 
> > A minor concern I have is that if CONFIG_NETNS is not set we can't do
> > that. But we could add a check and run them in the init namespace if
> > namespaces are not available, that looks reasonable enough.  
> 
> Sounds like over-engineering, although your point is valid, of course.
> In iptables shell testsuite was changed to always call unshare back in
> 2018, I don't think anyone has complained yet. So either everyone has
> netns support already (likely, given the container inflation) or nobody
> apart from hardliners actually run those tests (even more likely). :)

On embedded systems, in my experience, even in the post-modern era,
it's quite common to run kernels without support for networking
namespaces, or a busybox build without the unshare(1) applet (which was
implemented not so long ago, in 2016). And one might want to run tests
there because of some specific peculiarities (say, endianness, word
size, or just debugging).

Perhaps more commonly, Python bindings for unshare() might not be
installed.

The check is quite straigthforward, so I would rather add it.

> > > I considered doing the same in nftables testsuites several times but
> > > never managed to keep me motivated enough. Maybe you want to give it a
> > > try?  
> > 
> > I would do that from the main script itself (and figure out how it
> > should be done in Python, too), just once, it looks cleaner and we
> > don't change how test scripts are invoked. Something like this:
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/testing/selftests/netfilter/nft_concat_range.sh#n1463  
> 
> Maybe support a hidden parameter and do a self-call wrapped by 'unshare'
> unless that parameter was passed?

Yes, it's what the example I quoted does. Well, I hope you meant the
same thing. :)

-- 
Stefano

