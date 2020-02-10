Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3318C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCF420733
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="eKoaFtl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJKR0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:17:26 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:64782 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgBJKRZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 05:17:25 -0500
Date:   Mon, 10 Feb 2020 10:17:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581329842;
        bh=DLhmtBnje8OsvZk21CsGsHd4FtAgFv1EJVLfkO9TU7c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=eKoaFtl8umBPoWqA5YSLQZ7t8Y689016xVWL6xseYXbhdMtyTrA7MO/s5DAMOX5xY
         Njatjz2bupF96tPYhYpI46ExX2qtk6ykf9RM09bQrlUy2pjLApu19YB9sszS7SrtKo
         fVs086xeqER0SmDYya8K6iSkPodUO1KYG0u+kQUE=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft include v2 2/7] scanner: move the file descriptor to be in the input_descriptor structure
Message-ID: <20200210101709.9182-3-fasnacht@protonmail.ch>
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

This prevents a static allocation of file descriptors array, thus allows
more flexibility.

Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
---
 include/nftables.h |  3 ++-
 src/scanner.l      | 17 ++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 90d33196..ca0fbcaf 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -122,7 +122,6 @@ struct nft_ctx {
 =09void=09=09=09*scanner;
 =09struct scope=09=09*top_scope;
 =09void=09=09=09*json_root;
-=09FILE=09=09=09*f[MAX_INCLUDE_DEPTH];
 };
=20
 enum nftables_exit_codes {
@@ -176,6 +175,7 @@ enum input_descriptor_types {
  * struct input_descriptor
  *
  * @location:=09=09location, used for include statements
+ * @f:          file descriptor
  * @type:=09=09input descriptor type
  * @name:=09=09name describing the input
  * @union:=09=09buffer or file descriptor, depending on type
@@ -186,6 +186,7 @@ enum input_descriptor_types {
  */
 struct input_descriptor {
 =09struct list_head=09=09list;
+=09FILE*                   f;
 =09struct location=09=09=09location;
 =09enum input_descriptor_types=09type;
 =09const char=09=09=09*name;
diff --git a/src/scanner.l b/src/scanner.l
index 99ee8355..2016acd5 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -691,13 +691,13 @@ static void scanner_pop_buffer(yyscan_t scanner)
 }
=20
 static void scanner_push_file(struct nft_ctx *nft, void *scanner,
-=09=09=09      const char *filename, const struct location *loc)
+=09=09=09=09  FILE *f, const char *filename, const struct location *loc)
 {
 =09struct parser_state *state =3D yyget_extra(scanner);
 =09struct input_descriptor *indesc;
 =09YY_BUFFER_STATE b;
=20
-=09b =3D yy_create_buffer(nft->f[state->indesc_idx], YY_BUF_SIZE, scanner)=
;
+=09b =3D yy_create_buffer(f, YY_BUF_SIZE, scanner);
 =09yypush_buffer_state(b, scanner);
=20
 =09indesc =3D xzalloc(sizeof(struct input_descriptor));
@@ -706,6 +706,7 @@ static void scanner_push_file(struct nft_ctx *nft, void=
 *scanner,
 =09=09indesc->location =3D *loc;
 =09indesc->type=09=3D INDESC_FILE;
 =09indesc->name=09=3D xstrdup(filename);
+=09indesc->f =3D f;
 =09init_pos(indesc);
=20
 =09scanner_push_indesc(state, indesc);
@@ -731,8 +732,7 @@ static int include_file(struct nft_ctx *nft, void *scan=
ner,
 =09=09=09     filename, strerror(errno));
 =09=09goto err;
 =09}
-=09nft->f[state->indesc_idx] =3D f;
-=09scanner_push_file(nft, scanner, filename, loc);
+=09scanner_push_file(nft, scanner, f, filename, loc);
 =09return 0;
 err:
 =09erec_queue(erec, state->msgs);
@@ -944,6 +944,10 @@ static void input_descriptor_list_destroy(struct parse=
r_state *state)
 =09struct input_descriptor *indesc, *next;
=20
 =09list_for_each_entry_safe(indesc, next, &state->indesc_list, list) {
+=09=09if (indesc->f) {
+=09=09=09fclose(indesc->f);
+=09=09=09indesc->f =3D NULL;
+=09=09}
 =09=09list_del(&indesc->list);
 =09=09input_descriptor_destroy(indesc);
 =09}
@@ -955,11 +959,6 @@ void scanner_destroy(struct nft_ctx *nft)
=20
 =09do {
 =09=09yypop_buffer_state(nft->scanner);
-
-=09=09if (nft->f[state->indesc_idx]) {
-=09=09=09fclose(nft->f[state->indesc_idx]);
-=09=09=09nft->f[state->indesc_idx] =3D NULL;
-=09=09}
 =09} while (state->indesc_idx--);
=20
 =09input_descriptor_list_destroy(state);
--=20
2.20.1


