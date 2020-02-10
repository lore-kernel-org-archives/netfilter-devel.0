Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8E5C3B186
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1D420733
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="AbsRZokG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBJKR3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:17:29 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:61447 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbgBJKR3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 05:17:29 -0500
Date:   Mon, 10 Feb 2020 10:17:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581329847;
        bh=I5NxXTkkcFaQvr19k4LqK2yoldwm2/ufCmM9/vT/YGk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=AbsRZokGTHLV1ZsuCA23fElsAxRZBDev/EoSYh1fauQLqvCGbUXQ1GNjs3+LfUzvI
         jlibtmQb8WvRf0QVG89PMTBUX6YCRW/k+IE7yvHjPTb0kXOKPqGZAfSvpL+UAYiyxE
         S8cdQI06m/+vTwionf1xD5iAaOvN6sWAUTb1DWLw=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft include v2 4/7] scanner: remove parser_state->indescs static array
Message-ID: <20200210101709.9182-5-fasnacht@protonmail.ch>
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

This static array is redundant wth the indesc_list structure, but
is less flexible.

Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
---
 include/parser.h |  1 -
 src/scanner.l    | 12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 949284d9..66db92d8 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -15,7 +15,6 @@
=20
 struct parser_state {
 =09struct input_descriptor=09=09*indesc;
-=09struct input_descriptor=09=09*indescs[MAX_INCLUDE_DEPTH];
 =09unsigned int=09=09=09indesc_idx;
 =09struct list_head=09=09indesc_list;
=20
diff --git a/src/scanner.l b/src/scanner.l
index 37b01639..8397846b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -668,19 +668,19 @@ addrstring=09({macaddr}|{ip4addr}|{ip6addr})
 static void scanner_push_indesc(struct parser_state *state,
 =09=09=09=09struct input_descriptor *indesc)
 {
-=09state->indescs[state->indesc_idx] =3D indesc;
-=09state->indesc =3D state->indescs[state->indesc_idx++];
 =09list_add_tail(&indesc->list, &state->indesc_list);
+=09state->indesc =3D indesc;
+=09state->indesc_idx++;
 }
=20
 static void scanner_pop_indesc(struct parser_state *state)
 {
 =09state->indesc_idx--;
-
-=09if (state->indesc_idx > 0)
-=09=09state->indesc =3D state->indescs[state->indesc_idx - 1];
-=09else
+=09if (!list_empty(&state->indesc_list)) {
+=09=09state->indesc =3D list_entry(state->indesc->list.prev, struct input_=
descriptor, list);
+=09} else {
 =09=09state->indesc =3D NULL;
+=09}
 }
=20
 static void scanner_pop_buffer(yyscan_t scanner)
--=20
2.20.1


