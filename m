Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE92E810A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 08:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjI0Imo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 04:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjI0Imm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 04:42:42 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72305C0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 01:42:40 -0700 (PDT)
Received: from [78.30.34.192] (port=42136 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlQ7w-00BDQT-ND; Wed, 27 Sep 2023 10:42:38 +0200
Date:   Wed, 27 Sep 2023 10:42:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRPq/JMoVffTEDM4@calendula>
References: <20230926160216.152549-1-pablo@netfilter.org>
 <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 06:55:35PM +0200, Phil Sutter wrote:
> On Tue, Sep 26, 2023 at 06:02:16PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > diff --git a/src/parser_json.c b/src/parser_json.c
> > index 16961d6013af..78895befbc6c 100644
> > --- a/src/parser_json.c
> > +++ b/src/parser_json.c
> > @@ -2416,6 +2416,63 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
> >  	return stmt;
> >  }
> >  
> > +static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
> > +					const char *key, json_t *value)
> > +{
> > +	struct expr *expr, *expr2, *expr_data;
> > +	json_t *elem, *data, *stmt_json;
> > +	const char *opstr, *set;
> > +	struct stmt *stmt;
> > +	int op;
> > +
> > +	if (json_unpack_err(ctx, value, "{s:s, s:o, s:o, s:s}",
> > +			    "op", &opstr, "elem", &elem, "data", &data, "map", &set))
> > +		return NULL;
> > +
> > +	if (!strcmp(opstr, "add")) {
> > +		op = NFT_DYNSET_OP_ADD;
> > +	} else if (!strcmp(opstr, "update")) {
> > +		op = NFT_DYNSET_OP_UPDATE;
> > +	} else if (!strcmp(opstr, "delete")) {
> > +		op = NFT_DYNSET_OP_DELETE;
> > +	} else {
> > +		json_error(ctx, "Unknown set statement op '%s'.", opstr);
> 
> s/set/map/

Thanks, amended here and pushed it out.

Did you ever follow up on your pull request for libjansson or did you
find a way to dynamically allocate the error reporting area that they
complain about?

Error reporting with libjansson is very rudimentary, there is no way
to tell what precisely in the command that is represented in JSON is
actually causing the error, this coarse grain error reporting is too
broad.

Thanks.
