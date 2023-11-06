Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2E2C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 14:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjKFOEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 09:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjKFOET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 09:04:19 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699D3BF
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 06:04:16 -0800 (PST)
Received: from [78.30.35.151] (port=58184 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r00D6-00FNaj-Kh; Mon, 06 Nov 2023 15:04:14 +0100
Date:   Mon, 6 Nov 2023 15:04:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v2 3/6] tests/shell: add JSON dump files
Message-ID: <ZUjyW5Kx40Z8TUYo@calendula>
References: <20231103182901.3795263-1-thaller@redhat.com>
 <20231103182901.3795263-4-thaller@redhat.com>
 <a26297c51f49e2f8af1c6eb3f2f18a54b5cd347b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a26297c51f49e2f8af1c6eb3f2f18a54b5cd347b.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 06, 2023 at 02:56:18PM +0100, Thomas Haller wrote:
> On Fri, 2023-11-03 at 19:26 +0100, Thomas Haller wrote:
> > Generate and add ".json-nft" files. These files contain the output of
> > `nft -j list ruleset` after the test. Also, "test-wrapper.sh" will
> > compare the current ruleset against the ".json-nft" files and test
> > them
> > with "nft -j --check -f $FILE`. These are useful extra tests, that we
> > almost get for free.
> > 
> > Note that for some JSON dumps, `nft -f --check` fails (or prints
> > something). For those tests no *.json-nft file is added. The bugs
> > needs
> > to be fixed first.
> > 
> > An example of such an issue is:
> > 
> >     $ DUMPGEN=all ./tests/shell/run-tests.sh
> > tests/shell/testcases/maps/nat_addr_port
> > 
> > which gives a file "rc-failed-chkdump" with
> > 
> >     Command `./tests/shell/../../src/nft -j --check -f
> > "tests/shell/testcases/maps/dumps/nat_addr_port.json-nft"` failed
> >     >>>>
> >     internal:0:0-0: Error: Invalid map type 'ipv4_addr .
> > inet_service'.
> > 
> >     internal:0:0-0: Error: Parsing command array at index 3 failed.
> > 
> >     internal:0:0-0: Error: unqualified type integer specified in map
> > definition. Try "typeof expression" instead of "type datatype".
> > 
> >     <<<<
> > 
> > Tests like "tests/shell/testcases/nft-f/0012different_defines_0" and
> > "tests/shell/testcases/nft-f/0024priority_0" also don't get a .json-
> > nft
> > dump yet, because their output is not stable. That needs fixing too.
> > 
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> ...
> >  tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft    | 
> ...
> > tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
> >  create mode 100644
> 
> 
> "tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft" need to
> be dropped from this patch.
> 
> Otherwise,
> 
>   make && ./tests/shell/run-tests.sh tests/shell/testcases/sets/0062set_connlimit_0 -V
> 
> fails (in valgrind mode).

I have to fix 0062set_connlimit_0, the listing fails because the GC is
fast enough to remove the entry that just got added, because it has no
conntrack entries.

Maybe valgrind is just getting things slowier there to trigger what
I can already reproduce here on a VM?
