Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66BAEB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 09:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjGRJdw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 05:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjGRJdv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 05:33:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CC41BE
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 02:33:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qLh5W-0007tb-9d; Tue, 18 Jul 2023 11:33:46 +0200
Date:   Tue, 18 Jul 2023 11:33:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft v2 PATCH 1/3] nftables: add input flags for nft_ctx
Message-ID: <ZLZcepeCgDVLQLKG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <ZKxG23yJzlRRPpsO@calendula>
 <20230714084943.1080757-1-thaller@redhat.com>
 <ZLEgaNIH/ZD4hnf3@orbyte.nwl.cc>
 <98298234d31a02f10cfd022ce59140db80ca8750.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98298234d31a02f10cfd022ce59140db80ca8750.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 18, 2023 at 11:05:45AM +0200, Thomas Haller wrote:
> On Fri, 2023-07-14 at 12:16 +0200, Phil Sutter wrote:
> > On Fri, Jul 14, 2023 at 10:48:51AM +0200, Thomas Haller wrote:
> > [...]
> > > +=== nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
> > > +The flags setting controls the input format.
> > 
> > Note how we turn on JSON input parsing if JSON output is enabled.
> > 
> > I think we could tidy things up by introducing NFT_CTX_INPUT_JSON and
> > flip it from nft_ctx_output_set_flags() to match NFT_CTX_OUTPUT_JSON
> > for
> > compatibility?
> 
> The doc says:
> 
> doc/libnftables.adoc:NFT_CTX_OUTPUT_JSON::
> doc/libnftables.adoc-    If enabled at compile-time, libnftables accepts input in JSON format and is able to print output in JSON format as well.
> doc/libnftables.adoc-    See *libnftables-json*(5) for a description of the supported schema.
> doc/libnftables.adoc-    This flag controls JSON output format, input is auto-detected.
> 
> which is a bit inaccurate, as JSON is auto-detect if-and-only-if
> NFT_CTX_OUTPUT_JSON is set.

Yes, I'd even call it incorrect. :)

> src/libnftables.c:  if (nft_output_json(&nft->output))
> src/libnftables.c-       rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
> src/libnftables.c-  if (rc == -EINVAL)
> src/libnftables.c-       rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
> src/libnftables.c-                          &indesc_cmdline);
> 
> 
> I think, that toggling the input flag when setting an output flag
> should not be done. It's confusing to behave differently depending on
> the order in which nft_ctx_output_set_flags() and
> nft_ctx_input_set_flags() are called. And it's confusing that setting
> output flags would mangle input flags.

That's a valid point, indeed.

> And for the sake of backwards compatibility, the current behavior must
> be kept anyway. So there is only a place for overruling the current
> automatism via some NFT_CTX_INPUT_NO_JSON (aka
> NFT_CTX_INOUT_FORCE_BISON) or NFT_CTX_INPUT_FORCE_JSON flags, like
> 
>     try_json = TRUE;
>     try_bison = TRUE;
>     if (nft_ctx_input_get_flags(ctx) & NFT_CTX_INPUT_NO_JSON)
>         try_json = FALSE;
>     else if (nft_ctx_input_get_flags(ctx) & NFT_CTX_INPUT_FORCE_JSON)
>         try_bison = FALSE;
>     else if (nft_output_json(&ctx->output)) {
>         /* try both, JSON first */
>     } else
>         try_json = FALSE;
> 
>     if (try_json)
>         rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
>     if (try_bison && (!try_json || rc == -EINVAL))
>         rc = nft_parse_bison_buffer(nft, nlbuf, ...);
> 
> 
> This would not require to mangle input flags during
> nft_ctx_output_set_flags().
> 
>  
> But I find those two flags unnecessary. Both can be added any time
> later when needed. The addition of nft_ctx_input_set_flags() does not
> force a resolution now.
> 
> 
> Also, depending on the semantics, I don't understand how
> NFT_CTX_INPUT_JSON extends the current behavior in a backward
> compatible way. The default would be to not have that flag set, which
> already means to enable JSON parsing depending on NFT_CTX_OUTPUT_JSON.
> If NFT_CTX_INPUT_JSON merely means to explicitly enable JSON input,
> then that is already fully configurable today. Having this flag does
> not provide something new (unlike NO_JSON/FORCE_BISON or FORCE_JSON
> flags would).

The use-case I had in mind was to enable JSON parsing while keeping
standard output. This was possible with setting NFT_CTX_INPUT_JSON and
keeping NFT_CTX_OUTPUT_JSON unset.

The reason for libnftables' odd behaviour probably stems from nft using
just a single flag ('-j') to control JSON "mode" and I wanted to still
support non-JSON input - I tend to (mis-)use it as JSON-translator in
the testsuite and personally. ;)

You're right, we may just leave JSON input/output toggles alone for now.
I also didn't intend to block the patches - giving it a thought (as you
did) is fine from my side.

Thanks, Phil
