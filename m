Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A62CE7B1F
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 09:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjI2Jtw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI2Jtv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 05:49:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01696195
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 02:49:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmA82-00071Y-Lm; Fri, 29 Sep 2023 11:49:46 +0200
Date:   Fri, 29 Sep 2023 11:49:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v3] tests: shell: fix spurious errors in
 sets/0036add_set_element_expiration_0
Message-ID: <ZRadurgX7F84B4Vb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230927163937.757167-1-pablo@netfilter.org>
 <ZRWUpn963dk3Eaey@orbyte.nwl.cc>
 <ZRXRQO44pxHRa53x@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRXRQO44pxHRa53x@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 09:17:20PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 28, 2023 at 04:58:46PM +0200, Phil Sutter wrote:
> > On Wed, Sep 27, 2023 at 06:39:37PM +0200, Pablo Neira Ayuso wrote:
> > > A number of changes to fix spurious errors:
> > > 
> > > - Add seconds as expiration, otherwise 14m59 reports 14m in minute
> > >   granularity, this ensures suficient time in a very slow environment with
> > >   debugging instrumentation.
> > > 
> > > - Provide expected output.
> > > 
> > > - Update sed regular expression to make 'ms' optional and use -E mode.
> > > 
> > > Fixes: adf38fd84257 ("tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v3: - [ "$test_output" != "$EXPECTED" ], not [ "$test_output" != "$RULESET" ]
> > >     - Make 'ms' optional in sed regular expression
> > >     - Use -E in sed
> > > 
> > >  .../testcases/sets/0036add_set_element_expiration_0    | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > index 12f10074409f..0fd016e9f857 100755
> > > --- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > +++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > > @@ -3,17 +3,21 @@
> > >  set -e
> > >  
> > >  drop_seconds() {
> > > -       sed 's/m[0-9]*s[0-9]*ms/m/g'
> > > +	sed -E 's/m[0-9]*s([0-9]*ms)?/m/g'
> > >  }
> > 
> > So sometimes there's no ms part in output. In theory one would have to
> > make the seconds part optional, too. Funny how tedious these little
> > things may become to fix.
> > 
> > Anyway, it should work without -E by escaping braces and the question
> > mark. But accoring to sed(1), -E is in POSIX meanwhile so no big deal.
> > 
> > >  RULESET="add table ip x
> > > +add set ip x y { type ipv4_addr; flags dynamic,timeout; }
> > > +add element ip x y { 1.1.1.1 timeout 30m expires 15m59s }"
> > > +
> > > +EXPECTED="add table ip x
> > >  add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
> > >  add element ip x y { 1.1.1.1 timeout 30m expires 15m }"
> > 
> > I would have piped RULESET through drop_seconds in the $DIFF call below,
> > but this variant surely saves a few cycles. :D
> 
> I am useless. I quickly tried this, but echo disregards newlines,
> triggering a mismatch in the diff, perhaps printf can address this.

You probably forgot to quote the variable:

| $ a="foo
| > bar"
| $ echo $a
| foo bar
| $ echo "$a"
| foo
| bar

The following works fine for me:

| RULESET=$(drop_seconds <<< "$RULESET")

> I just wanted to make this reliable, it has been bothering me in my
> test infrastructure which is running this in a loop and occasionally
> triggering this false positive.

ACK. These things must get fixed, otherwise running the testsuite before
submitting/pushing becomes useless ("it fails anyway").

Cheers, Phil

PS: I found this works fine:
    | drop_seconds() {
    |	sed 's/[0-9]\+m\?s//g'
    | }
    So just "drop all occurences of numbers followed by ms or s".
    You have to send a follow-up anyway for the s/15m/14m59s/ change,
    right?

PPS: The 'exit 1' is pointless: The script has 'set -e' and $DIFF
     returns non-zero if input differs. ;)
