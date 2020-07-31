Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D85C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1AE22245C
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgGaM6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 08:58:30 -0400
Received: from correo.us.es ([193.147.175.20]:51592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbgGaM6a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 08:58:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDA0C9ED4F
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 14:58:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEB49DA78A
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 14:58:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D464BDA78C; Fri, 31 Jul 2020 14:58:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 969F3DA78A;
        Fri, 31 Jul 2020 14:58:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 14:58:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 785E442EF4E1;
        Fri, 31 Jul 2020 14:58:25 +0200 (CEST)
Date:   Fri, 31 Jul 2020 14:58:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731125825.GA12545@salvia>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731123342.GF13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Jul 31, 2020 at 11:22:12AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 31, 2020 at 02:00:22AM +0200, Jose M. Guisado Gomez wrote:
> > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > index 59347168..237b6f3e 100644
> > > --- a/src/parser_json.c
> > > +++ b/src/parser_json.c
> > > @@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
> > >
> > >  void json_print_echo(struct nft_ctx *ctx)
> > >  {
> > > -	if (!ctx->json_root)
> > > +	if (!ctx->json_echo)
> > >		return;
> 
> Why not reuse json_root?

Now that json_root is released from nft_parse_json_buffer() that is
possible, yes.

However, it is only possible to reuse ctx->json_root if the
ctx->json_root is released right after the parsing.

Otherwise the semantics of ctx->json_root starts getting confusing.

> > > -	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> > > +	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> > > +	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> > > +	printf("\n");
> > >	json_cmd_assoc_free();
> > > -	json_decref(ctx->json_root);
> > > -	ctx->json_root = NULL;
> > > +	if (ctx->json_echo) {
> > > +		json_decref(ctx->json_echo);
> > > +		ctx->json_echo = NULL;
> > > +	}
> > 
> > I think json_print_echo() should look like this - note I replaced the
> > printf("\n"); by fprintf. Also remove the if (ctx->json_echo) branch.
> > 
> > void json_print_echo(struct nft_ctx *ctx)
> > {
> > 	if (!ctx->json_echo)
> > 		return;
> > 
> > 	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> > 	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> > 	json_decref(ctx->json_echo);
> > 	ctx->json_echo = NULL;
> > 	fprintf(ctx->output.output_fp, "\n");
> > 	fflush(ctx->output.output_fp);
> > }
> > 
> > Please, include this update. I'm also attaching a patch that you can
> > squash to your v3 patch.
> > 
> > @Phil, I think the entire assoc code can just go away? Maybe you can also
> > run firewalld tests to make sure v3 works fine?  IIRC that is a heavy user
> > of --echo and --json.
> 
> Keeping JSON input in place and merely updating it with handles
> retrieved from kernel was a deliberate choice to make sure scripts can
> rely upon echo output to not differ from input unexpectedly.

Hm, this is not trusting what the kernel is sending to us via echo.
And this approach differs from what it is done for --echo with native
nft syntax.

> Given that output often deviates from input due to rule optimizing
> or loss of information, I'd say this code change will break that
> promise. Can't we enable JSON echo with non-JSON input while
> upholding it?

I would prefer to remove this code. What is your concern?
