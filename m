Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EF2C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107B6207C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f9X3Zt7n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHVJX4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:23:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20913 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgHVJX4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 05:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598088234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZWOSFCMDjVSt1hLIR8oE9GfBXF3AHL0fEQN23wkZFM=;
        b=f9X3Zt7n/XbE9FJlXFJTIFEx2icPhDnetpqKucLhi6VlE6V6zVKd+TzZls3sUS0O6ToxRk
        Q5Ykk8FNj+ky0MR54G+kUdHfL1KDoYdb9tBlsYy2lu2wtIuNdeRK2Uxc2LMo9lqTfja2gK
        BRwtBLW4N2wSML6gqZtCEE/zXp7oHhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-GkT6iRIrMx-C-F9O6BH6OA-1; Sat, 22 Aug 2020 05:23:51 -0400
X-MC-Unique: GkT6iRIrMx-C-F9O6BH6OA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08FD781CAFA;
        Sat, 22 Aug 2020 09:23:51 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6DC050AC5;
        Sat, 22 Aug 2020 09:23:49 +0000 (UTC)
Date:   Sat, 22 Aug 2020 11:23:44 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 1/4] socket: add support for "wildcard" key
Message-ID: <20200822112344.7fdbe34f@elisabeth>
In-Reply-To: <20200822062203.3617-2-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
        <20200822062203.3617-2-bazsi77@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 22 Aug 2020 08:22:00 +0200
Balazs Scheidler <bazsi77@gmail.com> wrote:

> iptables had a "-m socket --transparent" which didn't match sockets that are
> bound to all addresses (e.g.  0.0.0.0 for ipv4, and ::0 for ipv6).  It was
> possible to override this behavior by using --nowildcard, in which case it
> did match zero bound sockets as well.
> 
> The issue is that nftables never included the wildcard check, so in effect
> it behaved like "iptables -m socket --transparent --nowildcard" with no
> means to exclude wildcarded listeners.
> 
> This is a problem as a user-space process that binds to 0.0.0.0:<port> that
> enables IP_TRANSPARENT would effectively intercept traffic going in _any_
> direction on the specific port, whereas in most cases, transparent proxies
> would only need this for one specific address.
> 
> The solution is to add "socket wildcard" key to the nft_socket module, which
> makes it possible to match on the wildcardness of a socket from
> one's ruleset.
> 
> This is how to use it:
> 
> table inet haproxy {
> 	chain prerouting {
>         	type filter hook prerouting priority -150; policy accept;
> 		socket transparent 1 socket wildcard 0 mark set 0x00000001
> 	}
> }
> 
> This patch effectively depends on its counterpart in the kernel.
> 
> Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
> ---
>  src/evaluate.c     | 5 ++++-
>  src/parser_bison.y | 2 ++
>  src/parser_json.c  | 2 ++
>  src/scanner.l      | 1 +
>  src/socket.c       | 6 ++++++
>  5 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b64ed3c0..28dade8a 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1999,8 +1999,11 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
>  static int expr_evaluate_socket(struct eval_ctx *ctx, struct expr **expr)
>  {
>  	int maxval = 0;
> +	
> +	enum nft_socket_keys key = (*expr)->socket.key;

The empty line before this isn't needed: it's another declaration.

>  
> -	if((*expr)->socket.key == NFT_SOCKET_TRANSPARENT)
> +	if (key == NFT_SOCKET_TRANSPARENT ||
> +	    key == NFT_SOCKET_WILDCARD)
>  		maxval = 1;
>  	__expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->byteorder,
>  			   (*expr)->len, maxval);
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index d4e99417..fff941e5 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -213,6 +213,7 @@ int nft_lex(void *, void *, void *);
>  
>  %token SOCKET			"socket"
>  %token TRANSPARENT		"transparent"
> +%token WILDCARD			"wildcard"
>  
>  %token TPROXY			"tproxy"
>  
> @@ -4591,6 +4592,7 @@ socket_expr		:	SOCKET	socket_key
>  
>  socket_key 		: 	TRANSPARENT	{ $$ = NFT_SOCKET_TRANSPARENT; }
>  			|	MARK		{ $$ = NFT_SOCKET_MARK; }
> +			|	WILDCARD	{ $$ = NFT_SOCKET_WILDCARD; }
>  			;
>  
>  offset_opt		:	/* empty */	{ $$ = 0; }
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 59347168..ac89166e 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -427,6 +427,8 @@ static struct expr *json_parse_socket_expr(struct json_ctx *ctx,
>  		keyval = NFT_SOCKET_TRANSPARENT;
>  	else if (!strcmp(key, "mark"))
>  		keyval = NFT_SOCKET_MARK;
> +	else if (!strcmp(key, "wildcard"))
> +		keyval = NFT_SOCKET_WILDCARD;
>  
>  	if (keyval == -1) {
>  		json_error(ctx, "Invalid socket key value.");
> diff --git a/src/scanner.l b/src/scanner.l
> index 45699c85..90b36615 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -268,6 +268,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  
>  "socket"		{ return SOCKET; }
>  "transparent"		{ return TRANSPARENT;}
> +"wildcard"		{ return WILDCARD;}

For consistency, { return WILDCARD; } (TRANSPARENT is an exception).

>  
>  "tproxy"		{ return TPROXY; }
>  
> diff --git a/src/socket.c b/src/socket.c
> index d78a163a..673e5d0f 100644
> --- a/src/socket.c
> +++ b/src/socket.c
> @@ -26,6 +26,12 @@ const struct socket_template socket_templates[] = {
>  		.len		= 4 * BITS_PER_BYTE,
>  		.byteorder	= BYTEORDER_HOST_ENDIAN,
>  	},
> +	[NFT_SOCKET_WILDCARD] = {
> +		.token		= "wildcard",
> +		.dtype		= &integer_type,

You could also use boolean_type for this, see e.g. the meta ipsec
attribute.

-- 
Stefano

