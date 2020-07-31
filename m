Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ACEC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 13:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB79208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 13:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgGaNse (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgGaNsc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 09:48:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E8FC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 06:48:31 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k1VOe-0004Te-1G; Fri, 31 Jul 2020 15:48:28 +0200
Date:   Fri, 31 Jul 2020 15:48:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731134828.GG13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731125825.GA12545@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Fri, Jul 31, 2020 at 11:22:12AM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 31, 2020 at 02:00:22AM +0200, Jose M. Guisado Gomez wrote:
> > > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > > index 59347168..237b6f3e 100644
> > > > --- a/src/parser_json.c
> > > > +++ b/src/parser_json.c
> > > > @@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
> > > >
> > > >  void json_print_echo(struct nft_ctx *ctx)
> > > >  {
> > > > -	if (!ctx->json_root)
> > > > +	if (!ctx->json_echo)
> > > >		return;
> > 
> > Why not reuse json_root?
> 
> Now that json_root is released from nft_parse_json_buffer() that is
> possible, yes.
> 
> However, it is only possible to reuse ctx->json_root if the
> ctx->json_root is released right after the parsing.
> 
> Otherwise the semantics of ctx->json_root starts getting confusing.

Hmm. Maybe I miss something, I just noticed that json_print_echo()
doesn't make use of json_root anymore.

[...]
> > > @Phil, I think the entire assoc code can just go away? Maybe you can also
> > > run firewalld tests to make sure v3 works fine?  IIRC that is a heavy user
> > > of --echo and --json.
> > 
> > Keeping JSON input in place and merely updating it with handles
> > retrieved from kernel was a deliberate choice to make sure scripts can
> > rely upon echo output to not differ from input unexpectedly.
> 
> Hm, this is not trusting what the kernel is sending to us via echo.
> And this approach differs from what it is done for --echo with native
> nft syntax.

We agreed that regular nft output is made for humans, not machines.
Hence why we have libnftables and JSON API. Very simple scripts may get
by with regular output, grepping for 'handle <NUM>' and ignoring the
rest. When loading more than a single command, this quickly becomes
inconvenient.

> > Given that output often deviates from input due to rule optimizing
> > or loss of information, I'd say this code change will break that
> > promise. Can't we enable JSON echo with non-JSON input while
> > upholding it?
> 
> I would prefer to remove this code. What is your concern?

The less predictable echo output behaves, the harder it is to write code
that makes use of it. The whole handle semantics assumes scripts will be
able to fetch handles from echo output. With output being identical to
input apart from added handles, scripts may just replace their input
with received output and will find everything where it is supposed to
be. The alternative means extracting handles from output and updating
the stored input based on array indexes. Basically libnftables does this
updating for users as a service, and the code in commit 50b5b71ebeee3
("parser_json: Rewrite echo support") is probably more efficient than
what any Python script could do.

Maybe I am over-estimating the importance of handle usability. The fact
that people have to use a rule's handle in order to remove it means to
me that they will either find a way to get the handle of the rule they
added or fall back into a write-only usage-pattern which means dropping
the whole chain/table/ruleset for each change. Basically what iptables
does internally.

I'm assuming scripts will work directly with the Python data structures
that are later passed to libnftables as JSON. If they want to change a
rule, e.g. add a statement, it is no use if other statements disappear
or new ones are added by the commit->retrieve action.

Maybe Eric can shed some light on how Firewalld uses echo mode and
whether my concerns are relevant or not.

Cheers, Phil
