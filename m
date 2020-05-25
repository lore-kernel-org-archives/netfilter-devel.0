Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C00C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8DB207CB
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DO0FRoPe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbgEYXMr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 19:12:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388013AbgEYXMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 19:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590448366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYjxaNeNBibG8lz78iOtPvMI6dqNtbb5Rr/4tHDYLtI=;
        b=DO0FRoPeFVMVM6pwBCXBE7HLJa1jqucYj4dRDGA9WszAjX7GP/nK9R0kBHSuYwVbt/grxg
        wAVCW84QWBlLaJGXBaoUgN72YNUQ3GZkvwzHC8Ck1jdUtwPk/D/vmh0ElRC8vtEsybkrWO
        xmr2SoYUAqa49YnDqzDWCMrcGkg3UUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-gjY0uO9WNRStdKsQcfNvoQ-1; Mon, 25 May 2020 19:12:43 -0400
X-MC-Unique: gjY0uO9WNRStdKsQcfNvoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C81DC1005510;
        Mon, 25 May 2020 23:12:41 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A63E6648DB;
        Mon, 25 May 2020 23:12:40 +0000 (UTC)
Date:   Tue, 26 May 2020 01:12:36 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Avoid breaking basic connectivity
 when run
Message-ID: <20200526011236.2fe8ae7b@redhat.com>
In-Reply-To: <20200525155952.GW17795@orbyte.nwl.cc>
References: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
        <20200525155952.GW17795@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 May 2020 17:59:52 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
> 
> On Sun, May 24, 2020 at 02:59:57PM +0200, Stefano Brivio wrote:
> > It might be convenient to run tests from a development branch that
> > resides on another host, and if we break connectivity on the test
> > host as tests are executed, we con't run them this way.
> > 
> > To preserve connectivity, for shell tests, we can simply use the
> > 'forward' hook instead of 'input' in chains/0036_policy_variable_0
> > and transactions/0011_chain_0, without affecting test coverage.
> > 
> > For py tests, this is more complicated as some test cases install
> > chains for all the available hooks, and we would probably need a
> > more refined approach to avoid dropping relevant traffic, so I'm
> > not covering that right now.  
> 
> This is a recurring issue, iptables testsuites suffer from this problem
> as well. There it was solved by running everything in a dedicated netns:
> 
> iptables/tests/shell: Call testscripts via 'unshare -n <file>'.
> iptables-test.py: If called with --netns, 'ip netns exec <foo>' is
> added as prefix to any of the iptables commands.

Funny, I thought about doing that in the past and stopped before I could
even type 'unshare'. Silly, everything will break, I thought.

Nope, not at all, now that you say that... both 'unshare -n
./nft-test.py' and 'unshare -n ./run-tests.sh' worked flawlessly.

A minor concern I have is that if CONFIG_NETNS is not set we can't do
that. But we could add a check and run them in the init namespace if
namespaces are not available, that looks reasonable enough.

> I considered doing the same in nftables testsuites several times but
> never managed to keep me motivated enough. Maybe you want to give it a
> try?

I would do that from the main script itself (and figure out how it
should be done in Python, too), just once, it looks cleaner and we
don't change how test scripts are invoked. Something like this:
	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/testing/selftests/netfilter/nft_concat_range.sh#n1463

-- 
Stefano

