Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21999C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51252082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="tABcrlRu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgBJKR2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:17:28 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:41724 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgBJKR2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 05:17:28 -0500
Date:   Mon, 10 Feb 2020 10:17:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581329846;
        bh=c7vUsjv2CY9Dl/s3ppU+etJ5V/3OglCeMHIj1CT/h4U=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=tABcrlRu/8WT+D136Qsjmrq1xAKLw1HphUEpBAfEnGkN/YgZlY5IzI2JqIkBwZIU6
         eFXqrK1yGqbF7WIDilABRZZvdGA0xjvLdqQ09pC9p0rTogMr/X7RvJs3QBwzrzmG+W
         VCJX+W+gzzPIIxuELmPNGcSMeTX2vOSWPYTtJ9QY=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft include v2 3/7] scanner: move indesc list append in scanner_push_indesc
Message-ID: <20200210101709.9182-4-fasnacht@protonmail.ch>
In-Reply-To: <20200210101709.9182-1-fasnacht@protonmail.ch>
References: <20200210101709.9182-1-fasnacht@protonmail.ch>
Feedback-ID: 67Kw-YMwrBchoIMLcnFuA64ZnJub6AgnNvfJUjsgbTTSp4dmymKgGy_PLLqmOsJ9F58iClONCeGYaqp9YPx84w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Having a single point makes refactoring easier.

Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
---
 src/scanner.l | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 2016acd5..37b01639 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -670,6 +670,7 @@ static void scanner_push_indesc(struct parser_state *st=
ate,
 {
 =09state->indescs[state->indesc_idx] =3D indesc;
 =09state->indesc =3D state->indescs[state->indesc_idx++];
+=09list_add_tail(&indesc->list, &state->indesc_list);
 }
=20
 static void scanner_pop_indesc(struct parser_state *state)
@@ -710,7 +711,6 @@ static void scanner_push_file(struct nft_ctx *nft, void=
 *scanner,
 =09init_pos(indesc);
=20
 =09scanner_push_indesc(state, indesc);
-=09list_add_tail(&indesc->list, &state->indesc_list);
 }
=20
 static int include_file(struct nft_ctx *nft, void *scanner,
@@ -907,15 +907,14 @@ void scanner_push_buffer(void *scanner, const struct =
input_descriptor *indesc,
 {
 =09struct parser_state *state =3D yyget_extra(scanner);
 =09YY_BUFFER_STATE b;
+=09struct input_descriptor *new_indesc;
=20
-=09state->indesc =3D xzalloc(sizeof(struct input_descriptor));
-=09state->indescs[state->indesc_idx] =3D state->indesc;
-=09state->indesc_idx++;
+=09new_indesc =3D xzalloc(sizeof(struct input_descriptor));
=20
-=09memcpy(state->indesc, indesc, sizeof(*state->indesc));
-=09state->indesc->data =3D buffer;
-=09state->indesc->name =3D NULL;
-=09list_add_tail(&state->indesc->list, &state->indesc_list);
+=09memcpy(new_indesc, indesc, sizeof(*new_indesc));
+=09new_indesc->data =3D buffer;
+=09new_indesc->name =3D NULL;
+=09scanner_push_indesc(state, new_indesc);
=20
 =09b =3D yy_scan_string(buffer, scanner);
 =09assert(b !=3D NULL);
--=20
2.20.1


