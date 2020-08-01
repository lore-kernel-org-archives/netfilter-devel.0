Return-Path: <SRS0=dQO5=BL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB8FC433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 00:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EE720829
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 00:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgHAACS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 20:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHAACS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 20:02:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC11C06174A
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 17:02:18 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k1eyb-0003Wl-Hm; Sat, 01 Aug 2020 02:02:13 +0200
Date:   Sat, 1 Aug 2020 02:02:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200801000213.GN13697@orbyte.nwl.cc>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731173028.GA16302@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 07:30:28PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> > On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> [...]
> > The less predictable echo output behaves, the harder it is to write code
> > that makes use of it.
> 
> What is it making the output less predictible? The kernel should
> return an input that is equal to the output plus the handle. Other
> than that, it's a bug.

In tests/py, I see 330 lines explicitly stating the expected output as
it differs from the input ('grep "ok;" */*.t | wc -l'). Can we fix those
bugs first before we assume what the kernel returns is identical to user
input?

Say a script manages a rule (in JSON-equivalent) of:

| ip protocol tcp tcp dport '{ 22 - 23, 24 - 25}'

Both matches are elements in an array resembling the rule's "expr"
attribute. Nftables drops the first match, so if the script wants to
edit the ports in RHS of the second match, it won't find it anymore.
Also, the two port ranges are combined into a single one, so removing
one of the two ranges turns into a non-trivial problem.

Right now a script may apply its ruleset snippet and retrieve the
handles by:

| rc, ruleset, err = nftables.json_cmd(ruleset)

If the returned ruleset is not identical (apart from added attributes),
scripts will likely resort to a fire-n-forget type of usage pattern.

> This is also saving quite a bit of code and streamlining this further:
> 
>  4 files changed, 49 insertions(+), 153 deletions(-)

Proudly presenting reduced code size by dropping functionality is
cheating. Assume nobody needs the JSON interface, easily drop 5k LoC.

Cheers, Phil
