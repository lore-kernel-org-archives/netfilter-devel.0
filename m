Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E65FC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D30206FA
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgGaMdr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 08:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732916AbgGaMdq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 08:33:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832A5C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 05:33:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k1UEI-0002XI-KM; Fri, 31 Jul 2020 14:33:42 +0200
Date:   Fri, 31 Jul 2020 14:33:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731123342.GF13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731092212.GA1850@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Jul 31, 2020 at 11:22:12AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 31, 2020 at 02:00:22AM +0200, Jose M. Guisado Gomez wrote:
> > diff --git a/src/parser_json.c b/src/parser_json.c
> > index 59347168..237b6f3e 100644
> > --- a/src/parser_json.c
> > +++ b/src/parser_json.c
> > @@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
> >
> >  void json_print_echo(struct nft_ctx *ctx)
> >  {
> > -	if (!ctx->json_root)
> > +	if (!ctx->json_echo)
> >		return;

Why not reuse json_root?

> > -	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> > +	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> > +	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> > +	printf("\n");
> >	json_cmd_assoc_free();
> > -	json_decref(ctx->json_root);
> > -	ctx->json_root = NULL;
> > +	if (ctx->json_echo) {
> > +		json_decref(ctx->json_echo);
> > +		ctx->json_echo = NULL;
> > +	}
> 
> I think json_print_echo() should look like this - note I replaced the
> printf("\n"); by fprintf. Also remove the if (ctx->json_echo) branch.
> 
> void json_print_echo(struct nft_ctx *ctx)
> {
> 	if (!ctx->json_echo)
> 		return;
> 
> 	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> 	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> 	json_decref(ctx->json_echo);
> 	ctx->json_echo = NULL;
> 	fprintf(ctx->output.output_fp, "\n");
> 	fflush(ctx->output.output_fp);
> }
> 
> Please, include this update. I'm also attaching a patch that you can
> squash to your v3 patch.
> 
> @Phil, I think the entire assoc code can just go away? Maybe you can also
> run firewalld tests to make sure v3 works fine?  IIRC that is a heavy user
> of --echo and --json.

Keeping JSON input in place and merely updating it with handles
retrieved from kernel was a deliberate choice to make sure scripts can
rely upon echo output to not differ from input unexpectedly. Given that
output often deviates from input due to rule optimizing or loss of
information, I'd say this code change will break that promise. Can't we
enable JSON echo with non-JSON input while upholding it?

Cheers, Phil
