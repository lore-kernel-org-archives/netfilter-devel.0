Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04F6C71153
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 08:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbjIDIxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 04:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjIDIxH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 04:53:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2064D12A
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 01:53:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qd5KP-000095-JM; Mon, 04 Sep 2023 10:53:01 +0200
Date:   Mon, 4 Sep 2023 10:53:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC] tests: add feature probing
Message-ID: <20230904085301.GC11802@breakpoint.cc>
References: <20230831135112.30306-1-fw@strlen.de>
 <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> > +check_features()
> > +{
> > +       for ffilename in features/*.nft; do
> > +               feature=${ffilename#*/}
> > +               feature=${feature%*.nft}
> > +               eval NFT_HAVE_${feature}=0
> > +               $NFT -f "$ffilename" 2>/dev/null
> 
> is the "--check" option here missing? At least, the commit message says

Yes, added.

> I think it should run in a separate netns too.

Should not make a difference due to --check, nothing
is altered.

> OK, that's nice, to see in the output.
> 
> But why this "nft -f" specific detection? Why not just executable
> scripts?

Because I want it to be simple, it will be enough to drop a ruleset
with the feature into features/ durectory and run-tests.sh would do the
reset.

While its possible to launch nft as a script via

 #!/usr/bin/env nft

This would use the system nft, not the newly built one.  And fudging
with $PATH seems ugly...

> Also, why should "run-tests.sh" pre-evaluate those NFT_HAVE_* features?
> Just let each tests:
> 
>      if ! "$BASEDIR/features/chain-binding" ; then
>          echo " defaultchain"
>          return
>      fi
> 
> then the checks are more flexible (arbitrary executables).

I could do that, but I don't see the need for arbitrary scripts so far.

> Downside, if the check is time consuming (which it shouldn't),

Agree, it should not.

> then
> tests might call it over and over. Workaround for that: have "run-
> tests.sh" prepare a temporary directory and export it as
> $NFT_TEST_TMPDIR". Then "features/chain-binding" can cache the result
> there. "run-tests.sh" would delete the directory afterwards.
> 
> If you want to print those features, you can still let run-tests.sh
> iterate over "$BASEDIR"/features/* and print the result.

Yes, thats a working alternative but I don't see the need for this.

> > diff --git a/tests/shell/testcases/transactions/30s-stress
> > b/tests/shell/testcases/transactions/30s-stress
> > index 4d3317e22b0c..924e7e28f97e 100755
> > --- a/tests/shell/testcases/transactions/30s-stress
> > +++ b/tests/shell/testcases/transactions/30s-stress
> > @@ -16,6 +16,18 @@ if [ x = x"$NFT" ] ; then
> >         NFT=nft
> >  fi
> >  
> > +if [ -z $NFT_HAVE_chain_binding ];then
> > +       NFT_HAVE_chain_binding=0
> > +       mydir=$(dirname $0)
> 
> I think run-tests.sh should export the base directory, like "$BASEDIR",
> or "$NFT_TEST_BASEDIR". Tests should use it (and rely to have it).

Can do that.

> ah, you'd have each tests re-implement the check? So that they can run
> without the "run-tests.sh" wrapper?

No, just 30s-stress.  This test is special because its random by nature
and it makes sense to run it for multiple hours once in a while.

> The point here is, that if the "run-tests.sh" wrapper can provide
> something useful, then tests should be able to rely on it (and don't
> implement a fallback path).

Yes, no other script will do this.
I'll send an updated batch soon to see how this looks like with more
feature tests in place.
