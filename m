Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEE1C10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC792084E
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCFQOy convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:14:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgCFQOx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 11:14:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-v8-U1ZciNA6BFP1V-cRbtg-1; Fri, 06 Mar 2020 11:14:50 -0500
X-MC-Unique: v8-U1ZciNA6BFP1V-cRbtg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B689C100550D;
        Fri,  6 Mar 2020 16:14:48 +0000 (UTC)
Received: from egarver (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A93285DA2C;
        Fri,  6 Mar 2020 16:14:46 +0000 (UTC)
Date:   Fri, 6 Mar 2020 11:14:46 -0500
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] parser_json: Support ranges in concat expressions
Message-ID: <20200306161446.n5xm7bnxgqe55qth@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200306152210.14971-1-phil@nwl.cc>
MIME-Version: 1.0
In-Reply-To: <20200306152210.14971-1-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Thanks for taking a look at this.

On Fri, Mar 06, 2020 at 04:22:10PM +0100, Phil Sutter wrote:
> Duplicate commit 8ac2f3b2fca38's changes to bison parser into JSON
> parser by introducing a new context flag signalling we're parsing
> concatenated expressions.
> 
> Fixes: 8ac2f3b2fca38 ("src: Add support for concatenated set ranges")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---

I was able to verify this change allows "prefix" inside "concat", but it
introduces issues with other matches, e.g. payload and meta.

The below incremental allows those to work, but there are probably
issues with other match fields.

-->8--

diff --git a/src/parser_json.c b/src/parser_json.c
index 67d59458..141e4d19 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1358,11 +1358,11 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
                /* below three are multiton_rhs_expr */
                { "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
                { "range", json_parse_range_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
-               { "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP },
+               { "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
                { "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
                { "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES },
                { "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES },
-               { "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP },
+               { "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
                { "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP },
                { "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP },
                { "socket", json_parse_socket_expr, CTX_F_PRIMARY },

