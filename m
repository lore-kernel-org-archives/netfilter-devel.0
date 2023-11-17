Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85CAC197A0
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Nov 2023 16:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjKQQ5o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 11:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjKQQ5o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 11:57:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADABD67
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 08:57:35 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r429r-0006w3-0g; Fri, 17 Nov 2023 17:57:31 +0100
Date:   Fri, 17 Nov 2023 17:57:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <ZVebe9GK7VHbc4Rm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>, Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
 <ZVSgywZtf8F7nFop@calendula>
 <20231115122105.GD23742@breakpoint.cc>
 <ZVS530oqzSu/cgQS@calendula>
 <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
 <ZVY++RiqayXOZSBQ@calendula>
 <20231116230024.GA1206@breakpoint.cc>
 <797cf41472ad1481cb3cc6e4abdbd0853d4b253c.camel@redhat.com>
 <ZVeWh0xZA30H/tVM@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZVeWh0xZA30H/tVM@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 17, 2023 at 05:36:23PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 17, 2023 at 05:16:02PM +0100, Thomas Haller wrote:
> > On Fri, 2023-11-17 at 00:00 +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Hi Thomas,
> > > > 
> > > > On Wed, Nov 15, 2023 at 01:36:40PM +0100, Thomas Haller wrote:
> > > > > On Wed, 2023-11-15 at 13:30 +0100, Pablo Neira Ayuso wrote:
> > > > [...]
> > > > > > I see _lots_ of DUMP FAIL with kernel 5.4
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > Could you provide more details?
> > > > > 
> > > > > For example,
> > > > > 
> > > > >     make -j && ./tests/shell/run-tests.sh
> > > > > tests/shell/testcases/include/0007glob_double_0 -x
> > > > >     grep ^ -a -R /tmp/nft-test.latest.*/
> > > > 
> > > > # cat [...]/ruleset-diff.json
> > > > --- testcases/include/dumps/0007glob_double_0.json-nft  2023-11-15
> > > > 13:27:20.272084254 +0100
> > > > +++ /tmp/nft-test.20231116-170617.584.lrZzMy/test-testcases-
> > > > include-0007glob_double_0.1/ruleset-after.json      2023-11-16
> > > > 17:06:18.332535411 +0100
> > > > @@ -1 +1 @@
> > > > -{"nftables": [{"metainfo": {"version": "VERSION", "release_name":
> > > > "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family":
> > > > "ip", "name": "x", "handle": 1}}, {"table": {"family": "ip",
> > > > "name": "y", "handle": 2}}]}
> > > > +{"nftables": [{"metainfo": {"version": "VERSION", "release_name":
> > > > "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family":
> > > > "ip", "name": "x", "handle": 158}}, {"table": {"family": "ip",
> > > > "name": "y", "handle": 159}}]}
> > > > 
> > > > It seems that handles are a problem in this diff.
> > > 
> > > Are you running tests with -s option?
> > > 
> > > In that case, modules are removed after each test.
> > > 
> > > I suspect its because we can then hit -EAGAIN mid-transaction
> > > because module is missing (again), then replay logic does its
> > > thing.
> > > 
> > > But the handle generator isn't transaction aware,
> > > so it has advanced vs. the aborted partial transaction.
> > 
> > > I'm not sure what to do here.
> > 
> > a combination of:
> > 
> > a) make an effort, that kernel behavior is consistent and reproducible.
> > Stable output seems important to me, and the automatic loading of a
> > kernel module should not make a difference. This is IMO a bug.
> 
> This is not a bug in the kernel. The kernel guarantees that the handle
> is unique, but the handle allocation strategy is up to the kernel.
> Userspace cannot forecast what handle will get, such thing might lead
> to easy to break assumptions from userspace.
> 
> > b) let `nft -j list ruleset` honor (the lack of) `--handle` option and
> > not print those handles. That bugfix would change behavior, so maybe
> > instead add a "--no-handle" option for `nft -j` dumps.


> 
> Will honoring -a/--handle break firewalld? I think it is the main user
> of the JSON API. That might help disentangle if this makes sense or
> not and what the chances of breaking third party applications are.
> 
> I'd prefer not to see a --no-handle that will only work for JSON and
> that is only useful for this test infrastructure (noone else asked for
> this).
> 
> > c) sanitize the output with the sed command (my other mail).
> >
> > This also means, that the .json-nft dumps won't work, if you run
> > without `unshare`. IMO, the mode without unshare should not be
> > supported anymore. But if it's deemed important, then it requires b) or
> > c) or detect the case and skip the diffs with .json-nft.

What is the problem without unshare? Looking at your patch, it seems
possible to drop the handle attributes in json-sanitize-ruleset.sh.

> a) is no-go (kernel update to make test infrastructure or to allow
> userspace application to make fragile assumptions on how handles are
> allocated is not correct).
> 
> b) needs to evaluated, you maintain firewalld, let us know.

Given the inherent importance of the handle value for ruleset
manipulations, I assume *any* application will need to be updated to
pass --handle (or the libnftables-equivalent) to remain functional.

Cheers, Phil
