Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ED6C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 13:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948742076A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 13:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgFONVk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbgFONVk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 09:21:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865FBC061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 06:21:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jkp3O-0007Du-P4; Mon, 15 Jun 2020 15:21:34 +0200
Date:   Mon, 15 Jun 2020 15:21:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Message-ID: <20200615132134.GK23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
 <20200615090044.GH23632@orbyte.nwl.cc>
 <20200615121811.08c347e2@redhat.com>
 <20200615115424.GJ23632@orbyte.nwl.cc>
 <20200615144055.31bbfd66@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615144055.31bbfd66@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jun 15, 2020 at 02:40:55PM +0200, Stefano Brivio wrote:
> On Mon, 15 Jun 2020 13:54:24 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > Hi Stefano,
> > 
> > On Mon, Jun 15, 2020 at 12:18:11PM +0200, Stefano Brivio wrote:
> > > On Mon, 15 Jun 2020 11:00:44 +0200
> > > Phil Sutter <phil@nwl.cc> wrote:
> > >   
> > > > Hi Stefano,
> > > > 
> > > > On Sun, Jun 14, 2020 at 11:41:49PM +0200, Stefano Brivio wrote:  
> > > > > Commit 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")
> > > > > introduced the definition of DIFF at the top of run-tests.sh, to make
> > > > > it visually part of the configuration section. Commit 68310ba0f9c2
> > > > > ("tests: shell: Search diff tool once and for all") override this
> > > > > definition.
> > > > > 
> > > > > Drop the unexpected redefinition of DIFF.    
> > > > 
> > > > I would fix it the other way round, dropping the first definition.  
> > > 
> > > Then it's not visibly configurable anymore. It was in 2018, so it
> > > looks like a regression to me.  
> > 
> > Hmm? Commit 68310ba0f9c2 is from January this year?!
> 
> Commit 7d93e2c2fbc7 (which makes it "configurable") is from March 2018.

I think you're misinterpreting that commit regarding an attempt at
making diff binary configurable.

> > > > It's likely a missing bit from commit 68310ba0f9c20, the second
> > > > definition is in line with FIND and MODPROBE definitions immediately
> > > > preceding it.  
> > > 
> > > I see a few issues with those blocks:
> > > 
> > > - that should be a single function called (once or multiple times) for
> > >   nft, find, modprobe, diff, anything else we'll need in the future.
> > >   It would avoid any oversight of this kind and keep the script
> > >   cleaner. For example, what makes sort(1) special here?  
> > 
> > It is simply grown and therefore a bit inconsistent.
> 
> Yes, hence worth a minor rework perhaps? I can take care of this at
> some point.

Sure, why not. For now it works just fine, apart from the duplicate
line which is merely a cosmetic issue.

> > > - quotes are applied inconsistently. If you expect multiple words from
> > >   which(1), then variables should also be quoted when used, otherwise
> > >   the check might go through, and we fail later  
> > 
> > There are needless quotes around $(...) but within single brackets we
> > need them if we expect empty or multi-word strings. Typical output would
> > be 'diff not found' and using '[ ! -x "$DIFF" ]' we check if which
> > returned diff's path or said error message. We don't expect diff's path
> > to contain spaces, hence no quoting afterwards.
> 
> Probably stupid but:
> 
> [ break nft ]
> 
> # mkdir "my secret binaries"
> # cp /usr/bin/diff "my secret binaries/"
> # export PATH="my secret binaries:$PATH"
> # nftables/tests/shell/run-tests.sh nftables/tests/shell/testcases/listing/0003table_0
> I: using nft command: nftables/tests/shell/../../src/nft

Yes, I mentioned we don't expect $PATH contents to contain spaces.
Having such a thing would probably break more things than just
nftables testsuite. :)

> W: [FAILED]	nftables/tests/shell/testcases/listing/0003table_0: got 127
> nftables/tests/shell/testcases/listing/0003table_0: line 15: my: command not found
> 
> I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
> 
> or, perhaps more reasonable:
> 
> # grep DIFF=\" nftables/tests/shell/run-tests.sh
> DIFF="diff -y"

This is no guaranteed functionality. There's no comment or anything
stating you could change the DIFF definition atop the script to
customize diff behaviour. So strictly speaking you're on your own if you
do that and a broken testsuite is not unexpected.

> # nftables/tests/shell/run-tests.sh nftables/tests/shell/testcases/listing/0003table_0
> I: using nft command: nftables/tests/shell/../../src/nft
> 
> W: [FAILED]	nftables/tests/shell/testcases/listing/0003table_0: got 1
> 
> I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
> 
> Personally, this bothers me more than some cheap, extra quotes. If the
> general agreement is that it's not worth to add quotes to fix this,
> fine, I would skip this the day I have time to propose the single
> checking function rework I mentioned. Just let me know.

As said, the quotes are there to cover the expected 'which' output, no
more and no less. Supporting user-defined diff-command (or custom
options) is new functionality IMO. I'm totally fine with that and merely
want to point out we're not talking about fixing a bug here.

Cheers, Phil
