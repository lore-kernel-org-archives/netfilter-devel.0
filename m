Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A48CC352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E0120733
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="Wf2jxdlv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBJKRf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:17:35 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:45714 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbgBJKRf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 05:17:35 -0500
Date:   Mon, 10 Feb 2020 10:17:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581329853;
        bh=OTsEo27/lN2yaEMLtijnRvD/kZWU4VIszRIZE8xoPwY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=Wf2jxdlv5Iybu0YbsyXUC+q1LUlxbRpKb3ylxXaVn8QijNdGiYrIcroKHSBGNwlkD
         E7sdcj/jTfebpTnD/VYBmWRGNT67jR/X/EH/YMzKEptVjlZkXESxUm57qbdt5YXXVs
         WUuDcOZThidVCNvvrb5I+vuZ+DfnsDjcQoGpD30E=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft include v2 5/7] scanner: correctly compute include depth
Message-ID: <20200210101709.9182-6-fasnacht@protonmail.ch>
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

Inclusion depth was computed incorrectly for glob includes.

Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
---
 include/nftables.h |  2 ++
 src/scanner.l      | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index ca0fbcaf..1d423738 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -176,6 +176,7 @@ enum input_descriptor_types {
  *
  * @location:=09=09location, used for include statements
  * @f:          file descriptor
+ * @depth:      include depth of the descriptor
  * @type:=09=09input descriptor type
  * @name:=09=09name describing the input
  * @union:=09=09buffer or file descriptor, depending on type
@@ -187,6 +188,7 @@ enum input_descriptor_types {
 struct input_descriptor {
 =09struct list_head=09=09list;
 =09FILE*                   f;
+=09unsigned int            depth;
 =09struct location=09=09=09location;
 =09enum input_descriptor_types=09type;
 =09const char=09=09=09*name;
diff --git a/src/scanner.l b/src/scanner.l
index 8397846b..7f40c5c1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -692,7 +692,8 @@ static void scanner_pop_buffer(yyscan_t scanner)
 }
=20
 static void scanner_push_file(struct nft_ctx *nft, void *scanner,
-=09=09=09=09  FILE *f, const char *filename, const struct location *loc)
+=09=09=09=09  FILE *f, const char *filename, const struct location *loc,
+=09=09=09=09  const struct input_descriptor *parent_indesc)
 {
 =09struct parser_state *state =3D yyget_extra(scanner);
 =09struct input_descriptor *indesc;
@@ -707,6 +708,11 @@ static void scanner_push_file(struct nft_ctx *nft, voi=
d *scanner,
 =09=09indesc->location =3D *loc;
 =09indesc->type=09=3D INDESC_FILE;
 =09indesc->name=09=3D xstrdup(filename);
+=09if (!parent_indesc) {
+=09=09indesc->depth =3D 1;
+=09} else {
+=09=09indesc->depth =3D parent_indesc->depth + 1;
+=09}
 =09indesc->f =3D f;
 =09init_pos(indesc);
=20
@@ -714,13 +720,14 @@ static void scanner_push_file(struct nft_ctx *nft, vo=
id *scanner,
 }
=20
 static int include_file(struct nft_ctx *nft, void *scanner,
-=09=09=09const char *filename, const struct location *loc)
+=09=09=09const char *filename, const struct location *loc,
+=09=09=09const struct input_descriptor *parent_indesc)
 {
 =09struct parser_state *state =3D yyget_extra(scanner);
 =09struct error_record *erec;
 =09FILE *f;
=20
-=09if (state->indesc_idx =3D=3D MAX_INCLUDE_DEPTH) {
+=09if (parent_indesc && parent_indesc->depth =3D=3D MAX_INCLUDE_DEPTH) {
 =09=09erec =3D error(loc, "Include nested too deeply, max %u levels",
 =09=09=09     MAX_INCLUDE_DEPTH);
 =09=09goto err;
@@ -732,7 +739,7 @@ static int include_file(struct nft_ctx *nft, void *scan=
ner,
 =09=09=09     filename, strerror(errno));
 =09=09goto err;
 =09}
-=09scanner_push_file(nft, scanner, f, filename, loc);
+=09scanner_push_file(nft, scanner, f, filename, loc, parent_indesc);
 =09return 0;
 err:
 =09erec_queue(erec, state->msgs);
@@ -743,6 +750,7 @@ static int include_glob(struct nft_ctx *nft, void *scan=
ner, const char *pattern,
 =09=09=09const struct location *loc)
 {
 =09struct parser_state *state =3D yyget_extra(scanner);
+=09struct input_descriptor *indesc =3D state->indesc;
 =09struct error_record *erec =3D NULL;
 =09bool wildcard =3D false;
 =09glob_t glob_data;
@@ -803,7 +811,7 @@ static int include_glob(struct nft_ctx *nft, void *scan=
ner, const char *pattern,
 =09=09=09if (len =3D=3D 0 || path[len - 1] =3D=3D '/')
 =09=09=09=09continue;
=20
-=09=09=09ret =3D include_file(nft, scanner, path, loc);
+=09=09=09ret =3D include_file(nft, scanner, path, loc, indesc);
 =09=09=09if (ret !=3D 0)
 =09=09=09=09goto err;
 =09=09}
@@ -840,7 +848,7 @@ err:
 int scanner_read_file(struct nft_ctx *nft, const char *filename,
 =09=09      const struct location *loc)
 {
-=09return include_file(nft, nft->scanner, filename, loc);
+=09return include_file(nft, nft->scanner, filename, loc, NULL);
 }
=20
 static bool search_in_include_path(const char *filename)
--=20
2.20.1


