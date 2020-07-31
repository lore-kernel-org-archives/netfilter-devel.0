Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CE3C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 14:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA0F2206DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 14:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgGaOS5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:18:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30868 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728697AbgGaOS5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 10:18:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-EDlVJD2GOaKaSCaNhOXycQ-1; Fri, 31 Jul 2020 10:17:47 -0400
X-MC-Unique: EDlVJD2GOaKaSCaNhOXycQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A93DD800470;
        Fri, 31 Jul 2020 14:17:45 +0000 (UTC)
Received: from localhost (ovpn-115-201.rdu2.redhat.com [10.10.115.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79E6210013C4;
        Fri, 31 Jul 2020 14:17:43 +0000 (UTC)
Date:   Fri, 31 Jul 2020 10:17:42 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731141742.so3oklljvtuad2cl@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731134828.GG13697@orbyte.nwl.cc>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> > > Hi,
> > > 
> > > On Fri, Jul 31, 2020 at 11:22:12AM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Jul 31, 2020 at 02:00:22AM +0200, Jose M. Guisado Gomez wrote:
> > > > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > > > index 59347168..237b6f3e 100644
> > > > > --- a/src/parser_json.c
> > > > > +++ b/src/parser_json.c
> > > > > @@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
> > > > >
> > > > >  void json_print_echo(struct nft_ctx *ctx)
> > > > >  {
> > > > > -	if (!ctx->json_root)
> > > > > +	if (!ctx->json_echo)
> > > > >		return;
> > > 
> > > Why not reuse json_root?
> > 
> > Now that json_root is released from nft_parse_json_buffer() that is
> > possible, yes.
> > 
> > However, it is only possible to reuse ctx->json_root if the
> > ctx->json_root is released right after the parsing.
> > 
> > Otherwise the semantics of ctx->json_root starts getting confusing.
> 
> Hmm. Maybe I miss something, I just noticed that json_print_echo()
> doesn't make use of json_root anymore.
> 
> [...]
> > > > @Phil, I think the entire assoc code can just go away? Maybe you can also
> > > > run firewalld tests to make sure v3 works fine?  IIRC that is a heavy user
> > > > of --echo and --json.
> > > 
> > > Keeping JSON input in place and merely updating it with handles
> > > retrieved from kernel was a deliberate choice to make sure scripts can
> > > rely upon echo output to not differ from input unexpectedly.
> > 
> > Hm, this is not trusting what the kernel is sending to us via echo.
> > And this approach differs from what it is done for --echo with native
> > nft syntax.
> 
> We agreed that regular nft output is made for humans, not machines.
> Hence why we have libnftables and JSON API. Very simple scripts may get
> by with regular output, grepping for 'handle <NUM>' and ignoring the
> rest. When loading more than a single command, this quickly becomes
> inconvenient.
> 
> > > Given that output often deviates from input due to rule optimizing
> > > or loss of information, I'd say this code change will break that
> > > promise. Can't we enable JSON echo with non-JSON input while
> > > upholding it?
> > 
> > I would prefer to remove this code. What is your concern?
> 
> The less predictable echo output behaves, the harder it is to write code
> that makes use of it. The whole handle semantics assumes scripts will be
> able to fetch handles from echo output. With output being identical to
> input apart from added handles, scripts may just replace their input
> with received output and will find everything where it is supposed to
> be. The alternative means extracting handles from output and updating
> the stored input based on array indexes. Basically libnftables does this
> updating for users as a service, and the code in commit 50b5b71ebeee3
> ("parser_json: Rewrite echo support") is probably more efficient than
> what any Python script could do.
> 
> Maybe I am over-estimating the importance of handle usability. The fact
> that people have to use a rule's handle in order to remove it means to
> me that they will either find a way to get the handle of the rule they
> added or fall back into a write-only usage-pattern which means dropping
> the whole chain/table/ruleset for each change. Basically what iptables
> does internally.

Agreed. This would be very bad for usability.

> I'm assuming scripts will work directly with the Python data structures
> that are later passed to libnftables as JSON. If they want to change a
> rule, e.g. add a statement, it is no use if other statements disappear
> or new ones are added by the commit->retrieve action.
> 
> Maybe Eric can shed some light on how Firewalld uses echo mode and
> whether my concerns are relevant or not.

How it stands today is exactly as you described above. firewalld relies
on the output (--echo) being in the same order as the input. At the
time, and I think still today, this was the _only_ way to reliably get
the rule handles. It's mostly due to the fact that input != output.

In the past we discussed allowing a user defined cookie/handle. This
would allow applications to perform in a write only manner. They would
not need to parse back the JSON since they already know the
cookie/handle. IMO, this would be ideal for firewalld's use case.

