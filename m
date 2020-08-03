Return-Path: <SRS0=uIll=BN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72784C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 12:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583682064B
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 12:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgHCMwX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgHCMwT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 08:52:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEECAC061756
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2020 05:52:18 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k2Zwo-0002ay-SD; Mon, 03 Aug 2020 14:52:10 +0200
Date:   Mon, 3 Aug 2020 14:52:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200803125210.GR13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
 <20200731173028.GA16302@salvia>
 <20200801000213.GN13697@orbyte.nwl.cc>
 <20200801192730.GA5485@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801192730.GA5485@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Aug 01, 2020 at 09:27:30PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 01, 2020 at 02:02:13AM +0200, Phil Sutter wrote:
> > On Fri, Jul 31, 2020 at 07:30:28PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> > > > On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> > > [...]
> > > > The less predictable echo output behaves, the harder it is to write code
> > > > that makes use of it.
> > > 
> > > What is it making the output less predictible? The kernel should
> > > return an input that is equal to the output plus the handle. Other
> > > than that, it's a bug.
> > 
> > In tests/py, I see 330 lines explicitly stating the expected output as
> > it differs from the input ('grep "ok;" */*.t | wc -l'). Can we fix those
> > bugs first before we assume what the kernel returns is identical to user
> > input?
> 
> Semantically speaking those lines are equivalent, it's just that input
> and the output representation differ in some scenarios because the
> decompilation routine differ in the way it builds the expressions.

Obviously, yes, but irrelevant for this discussion. A script won't be
able to identify two different looking rules as identical because of
semantics.

> BTW, why do you qualify this as a bug?

I was just picking up your argument: Above, you wrote "Other than that,
it's a bug". I assume that in "return an input that is equal to the
output plus the handle", equal really means equal and not equivalent.

> > Say a script manages a rule (in JSON-equivalent) of:
> > 
> > | ip protocol tcp tcp dport '{ 22 - 23, 24 - 25}'
> > 
> > Both matches are elements in an array resembling the rule's "expr"
> > attribute. Nftables drops the first match, so if the script wants to
> > edit the ports in RHS of the second match, it won't find it anymore.
> > Also, the two port ranges are combined into a single one, so removing
> > one of the two ranges turns into a non-trivial problem.
> > 
> > Right now a script may apply its ruleset snippet and retrieve the
> > handles by:
> > 
> > | rc, ruleset, err = nftables.json_cmd(ruleset)
> > 
> > If the returned ruleset is not identical (apart from added attributes),
> > scripts will likely resort to a fire-n-forget type of usage pattern.
> 
> You mean, the user in that JSON script is comparing the input and
> output strings to find the rule handle?

I am assuming that a script that uses echo mode wants to update the
input ruleset (snippet) with handles for later reference to the added
rules. Other than copying output to input completely, it will have to
iterate through output and extract the handle properties, identifying
it's own rules based on current index. More or less what libnftables is
doing when updating JSON input with handles.

> If so, we should explore a better way to do this, eg. expose some user
> defined identifier in JSON that userspace sets on when sending the
> batch to identify the object coming back from the kernel.

Eric suggested to accept a "cookie" property with arbitrary value to
stay in place at least for echo output. He even suggested to accept this
as an alternative to the handle for rule referencing. The latter would
need kernel support, though.

> > > This is also saving quite a bit of code and streamlining this further:
> > > 
> > >  4 files changed, 49 insertions(+), 153 deletions(-)
> > 
> > Proudly presenting reduced code size by dropping functionality is
> > cheating. Assume nobody needs the JSON interface, easily drop 5k LoC.
> 
> The existing approach ignores the kernel echo netlink message almost
> entirely, it only takes the handle.

I know, I wrote the code.

> We need an unified way to deal with --json --echo, whether the input
> is native nft or json syntax.

We don't need, but seems we want. We have JSON output and JSON echo for
a while now and code for both is distinct. I fail to see why this was OK
but is no longer. From my perspective, Jose simply failed to see that
JSON output code should be used for JSON echo if input is not JSON.

I could come up with a patch implementing that if all this is merely
about the missing feature.

> If the problem is described in the question I made above, how will
> users passing native nft syntax and requesing json output will
> identify the rule? They cannot make string matching comparison in that
> case since there is no input JSON representation.

That is not a sensible use-case. For once, I would assume native syntax
to be used by humans, so if this is combined with JSON output, the goal
is translation. If input really comes from a script, it is likely not
retaining the input for later reuse but will take whatever it receives
back.

Cheers, Phil
