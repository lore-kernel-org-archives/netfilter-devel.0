Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C20BC35254
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 12:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC8021741
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 12:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="YSuPCPiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBEMa3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 07:30:29 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:50105 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgBEMa3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 07:30:29 -0500
Date:   Wed, 05 Feb 2020 12:30:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1580905826;
        bh=Td9w2OyOJ9tUMILfcXlJwlIdaloibEZm2JV9sKaCca0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=YSuPCPiQQ+hy/HTkfC20jFt7zdk/AgeRW0frglewUrOjb/jGkMSnwBoGuv/v5xt6/
         Nc+1KSbPvcJgn1zWKsteH1GU2FABqnPSNFQzKAZ1ELFl7CIIBr/Ra6r6DegLHRkvT7
         H+4ytwmRmCqcmFZhgmzIseullF8w0TG2ohr9JjEQ=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft 3/3] scanner: remove indescs and indescs_idx attributes from the parser, and directly use indesc_list
Message-ID: <20200205122858.20575-4-fasnacht@protonmail.ch>
In-Reply-To: <20200205122858.20575-1-fasnacht@protonmail.ch>
References: <20200205122858.20575-1-fasnacht@protonmail.ch>
Feedback-ID: 67Kw-YMwrBchoIMLcnFuA64ZnJub6AgnNvfJUjsgbTTSp4dmymKgGy_PLLqmOsJ9F58iClONCeGYaqp9YPx84w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

parser_state.indescs (static array) and parser_state.indesc_list are in fac=
t duplicating information.

This commit removes the static array and uses the list for everything.

Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
---
 include/parser.h |  2 --
 src/scanner.l    | 58 ++++++++++++++++++++----------------------------
 2 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 949284d9..636d1c88 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -15,8 +15,6 @@
=20
 struct parser_state {
 =09struct input_descriptor=09=09*indesc;
-=09struct input_descriptor=09=09*indescs[MAX_INCLUDE_DEPTH];
-=09unsigned int=09=09=09indesc_idx;
 =09struct list_head=09=09indesc_list;
=20
 =09struct list_head=09=09*msgs;
diff --git a/src/scanner.l b/src/scanner.l
index 837bc476..4b06cb99 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -668,18 +668,23 @@ addrstring=09({macaddr}|{ip4addr}|{ip6addr})
 static void scanner_push_indesc(struct parser_state *state,
 =09=09=09=09struct input_descriptor *indesc)
 {
-=09state->indescs[state->indesc_idx] =3D indesc;
-=09state->indesc =3D state->indescs[state->indesc_idx++];
+=09list_add_tail(&indesc->list, &state->indesc_list);
+=09state->indesc =3D indesc;
 }
=20
 static void scanner_pop_indesc(struct parser_state *state)
 {
-=09state->indesc_idx--;
-
-=09if (state->indesc_idx > 0)
-=09=09state->indesc =3D state->indescs[state->indesc_idx - 1];
-=09else
+=09struct input_descriptor *indesc;
+=09indesc =3D state->indesc;
+=09if (!list_empty(&state->indesc_list)) {
+=09=09state->indesc =3D list_entry(state->indesc->list.prev, struct input_=
descriptor, list);
+=09} else {
 =09=09state->indesc =3D NULL;
+=09}
+=09if (indesc->f) {
+=09=09fclose(indesc->f);
+=09=09indesc->f =3D NULL;
+=09}
 }
=20
 static void scanner_pop_buffer(yyscan_t scanner)
@@ -716,7 +721,6 @@ static void scanner_push_file(struct nft_ctx *nft, void=
 *scanner,
 =09init_pos(indesc);
=20
 =09scanner_push_indesc(state, indesc);
-=09list_add_tail(&indesc->list, &state->indesc_list);
 }
=20
 static int include_file(struct nft_ctx *nft, void *scanner,
@@ -915,15 +919,14 @@ void scanner_push_buffer(void *scanner, const struct =
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
@@ -940,35 +943,22 @@ void *scanner_init(struct parser_state *state)
 =09return scanner;
 }
=20
-static void input_descriptor_destroy(const struct input_descriptor *indesc=
)
-{
-=09if (indesc->name)
-=09=09xfree(indesc->name);
-=09xfree(indesc);
-}
=20
-static void input_descriptor_list_destroy(struct parser_state *state)
+static void input_descriptor_list_destroy(yyscan_t *scanner)
 {
+=09struct parser_state *state =3D yyget_extra(scanner);
 =09struct input_descriptor *indesc, *next;
=20
 =09list_for_each_entry_safe(indesc, next, &state->indesc_list, list) {
-=09=09if (indesc->f) {
-=09=09=09fclose(indesc->f);
-=09=09=09indesc->f =3D NULL;
-=09=09}
+=09=09if (indesc->name)
+=09=09=09xfree(indesc->name);
 =09=09list_del(&indesc->list);
-=09=09input_descriptor_destroy(indesc);
+=09=09xfree(indesc);
 =09}
 }
=20
 void scanner_destroy(struct nft_ctx *nft)
 {
-=09struct parser_state *state =3D yyget_extra(nft->scanner);
-
-=09do {
-=09=09yypop_buffer_state(nft->scanner);
-=09} while (state->indesc_idx--);
-
-=09input_descriptor_list_destroy(state);
+=09input_descriptor_list_destroy(nft->scanner);
 =09yylex_destroy(nft->scanner);
 }
--=20
2.20.1


