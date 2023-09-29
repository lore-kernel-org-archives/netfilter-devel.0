Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC65CE7B1F
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 09:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjI2Jxl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2Jxk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 05:53:40 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764C0195
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 02:53:38 -0700 (PDT)
Received: from [78.30.34.192] (port=37266 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qmABi-008V1A-Io; Fri, 29 Sep 2023 11:53:36 +0200
Date:   Fri, 29 Sep 2023 11:53:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v3] tests: shell: fix spurious errors in
 sets/0036add_set_element_expiration_0
Message-ID: <ZRaenVh3EYWv1nKD@calendula>
References: <20230927163937.757167-1-pablo@netfilter.org>
 <ZRWUpn963dk3Eaey@orbyte.nwl.cc>
 <ZRXRQO44pxHRa53x@calendula>
 <ZRadurgX7F84B4Vb@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRadurgX7F84B4Vb@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 29, 2023 at 11:49:46AM +0200, Phil Sutter wrote:
> On Thu, Sep 28, 2023 at 09:17:20PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 28, 2023 at 04:58:46PM +0200, Phil Sutter wrote:
> > > On Wed, Sep 27, 2023 at 06:39:37PM +0200, Pablo Neira Ayuso wrote:
> > > > A number of changes to fix spurious errors:
> > > > 
> > > > - Add seconds as expiration, otherwise 14m59 reports 14m in minute
> > > >   granularity, this ensures suficient time in a very slow environment with
> > > >   debugging instrumentation.
> > > > 
> > > > - Provide expected output.
> > > > 
> > > > - Update sed regular expression to make 'ms' optional and use -E mode.
> > > > 
> > > > Fixes: adf38fd84257 ("tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > v3: - [ "$test_output" != "$EXPECTED" ], not [ "$test_output" != "$RULESET" ]
> > > >     - Make 'ms' optional in sed regular expression
> > > >     - Use -E in sed
> > > > 
> > > >  .../testcases/sets/0036add_set_element_expiration_0    | 10 +++++++---
> > > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > > index 12f10074409f..0fd016e9f857 100755
> > > > --- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > > +++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > > @@ -3,17 +3,21 @@
> > > >  set -e
> > > >  
> > > >  drop_seconds() {
> > > > -       sed 's/m[0-9]*s[0-9]*ms/m/g'
> > > > +	sed -E 's/m[0-9]*s([0-9]*ms)?/m/g'
> > > >  }
> > > 
> > > So sometimes there's no ms part in output. In theory one would have to
> > > make the seconds part optional, too. Funny how tedious these little
> > > things may become to fix.
> > > 
> > > Anyway, it should work without -E by escaping braces and the question
> > > mark. But accoring to sed(1), -E is in POSIX meanwhile so no big deal.
> > > 
> > > >  RULESET="add table ip x
> > > > +add set ip x y { type ipv4_addr; flags dynamic,timeout; }
> > > > +add element ip x y { 1.1.1.1 timeout 30m expires 15m59s }"
> > > > +
> > > > +EXPECTED="add table ip x
> > > >  add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
> > > >  add element ip x y { 1.1.1.1 timeout 30m expires 15m }"
> > > 
> > > I would have piped RULESET through drop_seconds in the $DIFF call below,
> > > but this variant surely saves a few cycles. :D
> > 
> > I am useless. I quickly tried this, but echo disregards newlines,
> > triggering a mismatch in the diff, perhaps printf can address this.
> 
> You probably forgot to quote the variable:
> 
> | $ a="foo
> | > bar"
> | $ echo $a
> | foo bar
> | $ echo "$a"
> | foo
> | bar
> 
> The following works fine for me:
> 
> | RULESET=$(drop_seconds <<< "$RULESET")
> 
> > I just wanted to make this reliable, it has been bothering me in my
> > test infrastructure which is running this in a loop and occasionally
> > triggering this false positive.
> 
> ACK. These things must get fixed, otherwise running the testsuite before
> submitting/pushing becomes useless ("it fails anyway").
> 
> Cheers, Phil
> 
> PS: I found this works fine:
>     | drop_seconds() {
>     |	sed 's/[0-9]\+m\?s//g'
>     | }
>     So just "drop all occurences of numbers followed by ms or s".
>     You have to send a follow-up anyway for the s/15m/14m59s/ change,
>     right?
> 
> PPS: The 'exit 1' is pointless: The script has 'set -e' and $DIFF
>      returns non-zero if input differs. ;)

Just follow up to refine if you feel like, but promise me this will
not barf spuriously again :).
