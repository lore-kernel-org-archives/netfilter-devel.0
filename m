Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AF5E810DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 12:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjI0M26 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjI0M25 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 08:28:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F65CDD
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 05:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695817680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6zPZkdyL1liFdZ+66KuD1fo9txHGpcUGHW0oJH8m6M=;
        b=Y7iIy0AF2KG7wN1Am4Ge0MERPig4keNM+jlfQlSmd7b255vaQFUNZC8vovaxb+yba4fYaU
        vT3rSirOCB+iawhYcN3tGqvvraO24WyWuYEu2ZFvSzA8pwQMMA4fktOhJuFuVib7FCpyow
        IknbkeTIVRToMpUrp+GkkrFvY3/FHeE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-YlSY5MhmOSuRiWlynX4RRA-1; Wed, 27 Sep 2023 08:27:57 -0400
X-MC-Unique: YlSY5MhmOSuRiWlynX4RRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 017A13821360
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:27:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EE9840C6EA8;
        Wed, 27 Sep 2023 12:27:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid "-Wstrict-overflow" warning
Date:   Wed, 27 Sep 2023 14:23:27 +0200
Message-ID: <20230927122744.3434851-3-thaller@redhat.com>
In-Reply-To: <20230927122744.3434851-1-thaller@redhat.com>
References: <20230927122744.3434851-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We almost can compile everything with "-Wstrict-overflow" (which depends
on the optimization level). In a quest to make that happen, rework
nf_osf_parse_opt(). Previously, gcc-13.2.1-1.fc38.x86_64 warned:

    $ gcc -Iinclude "-DDEFAULT_INCLUDE_PATH=\"/usr/local/etc\"" -c -o tmp.o src/nfnl_osf.c -Werror -Wstrict-overflow=5 -O3
    src/nfnl_osf.c: In function ‘nfnl_osf_load_fingerprints’:
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
      356 | int nfnl_osf_load_fingerprints(struct netlink_ctx *ctx, int del)
          |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
    src/nfnl_osf.c:356:5: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
    cc1: all warnings being treated as errors

The previous code was needlessly confusing. Keeping track of an index
variable "i" and a "ptr" was redundant. The signed "i" variable caused a
"-Wstrict-overflow" warning, but it can be dropped completely.

While at it, there is also almost no need to ever truncate the bits that
we parse. Only the callers of the new skip_delim_trunc() required the
truncation.

Also, introduce new skip_delim() and skip_delim_trunc() methods, which
point right *after* the delimiter to the next word.  Contrary to
nf_osf_strchr(), which leaves the pointer at the end of the previous
part.

Also, the parsing code using strchr() requires that the overall buffer
(obuf[olen]) is NUL terminated. And the caller in fact ensured that too.
There is no point in having a "olen" parameter, we require the string to
be NUL terminated (which already was implicitly required).  Drop the
"olen" parameter. On the other hand, it's unclear what ensures that we
don't overflow the "opt" output buffer. Pass a "optlen" parameter and
ensure we don't overflow the buffer.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/nfnl_osf.c | 128 ++++++++++++++++++++++---------------------------
 1 file changed, 58 insertions(+), 70 deletions(-)

diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index 38a27a3683e2..f2b50fa9fc8e 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -74,6 +74,33 @@ static struct nf_osf_opt IANA_opts[] = {
 	{ .kind=26, .length=1,},
 };
 
+static char *skip_delim(char *ptr, char c)
+{
+	char *tmp;
+
+	tmp = strchr(ptr, c);
+	if (tmp) {
+		tmp++;
+		while (isspace(tmp[0]))
+			tmp++;
+	}
+	return tmp;
+}
+
+static char *skip_delim_trunc(char *ptr, char c)
+{
+	char *tmp;
+
+	tmp = strchr(ptr, c);
+	if (tmp) {
+		tmp[0] = '\0';
+		tmp++;
+		while (isspace(tmp[0]))
+			tmp++;
+	}
+	return tmp;
+}
+
 static char *nf_osf_strchr(char *ptr, char c)
 {
 	char *tmp;
@@ -88,54 +115,34 @@ static char *nf_osf_strchr(char *ptr, char c)
 	return tmp;
 }
 
-static void nf_osf_parse_opt(struct nf_osf_opt *opt, __u16 *optnum, char *obuf,
-			     int olen)
+static void nf_osf_parse_opt(struct nf_osf_opt *opt, __u16 optlen, __u16 *optnum, char *obuf)
 {
-	int i, op;
-	char *ptr, wc;
-	unsigned long val;
-
-	ptr = &obuf[0];
-	i = 0;
-	while (ptr != NULL && i < olen && *ptr != 0) {
-		val = 0;
-		wc = OSF_WSS_PLAIN;
-		switch (obuf[i]) {
+	char *ptr = &obuf[0];
+
+	while (ptr && ptr[0] != '\0') {
+		char *const ptr0 = ptr;
+		unsigned long val = 0;
+		char wc = OSF_WSS_PLAIN;
+		int op;
+
+		switch (ptr0[0]) {
 		case 'N':
 			op = OSFOPT_NOP;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
-			if (ptr) {
-				*ptr = '\0';
-				ptr++;
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+			ptr = skip_delim(&ptr0[1], OPTDEL);
 			break;
 		case 'S':
 			op = OSFOPT_SACKP;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
-			if (ptr) {
-				*ptr = '\0';
-				ptr++;
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+			ptr = skip_delim(&ptr0[1], OPTDEL);
 			break;
 		case 'T':
 			op = OSFOPT_TS;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
-			if (ptr) {
-				*ptr = '\0';
-				ptr++;
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+			ptr = skip_delim(&ptr0[1], OPTDEL);
 			break;
 		case 'W':
 			op = OSFOPT_WSO;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
+			ptr = skip_delim_trunc(&ptr0[1], OPTDEL);
 			if (ptr) {
-				switch (obuf[i + 1]) {
+				switch (ptr0[1]) {
 				case '%':
 					wc = OSF_WSS_MODULO;
 					break;
@@ -149,56 +156,37 @@ static void nf_osf_parse_opt(struct nf_osf_opt *opt, __u16 *optnum, char *obuf,
 					wc = OSF_WSS_PLAIN;
 					break;
 				}
-
-				*ptr = '\0';
-				ptr++;
-				if (wc)
-					val = strtoul(&obuf[i + 2], NULL, 10);
+				if (wc != OSF_WSS_PLAIN)
+					val = strtoul(&ptr0[2], NULL, 10);
 				else
-					val = strtoul(&obuf[i + 1], NULL, 10);
-				i += (int)(ptr - &obuf[i]);
-
-			} else
-				i++;
+					val = strtoul(&ptr0[1], NULL, 10);
+			}
 			break;
 		case 'M':
 			op = OSFOPT_MSS;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
+			ptr = skip_delim_trunc(&ptr0[1], OPTDEL);
 			if (ptr) {
-				if (obuf[i + 1] == '%')
+				if (ptr0[1] == '%')
 					wc = OSF_WSS_MODULO;
-				*ptr = '\0';
-				ptr++;
-				if (wc)
-					val = strtoul(&obuf[i + 2], NULL, 10);
+				if (wc != OSF_WSS_PLAIN)
+					val = strtoul(&ptr0[2], NULL, 10);
 				else
-					val = strtoul(&obuf[i + 1], NULL, 10);
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+					val = strtoul(&ptr0[1], NULL, 10);
+			}
 			break;
 		case 'E':
 			op = OSFOPT_EOL;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
-			if (ptr) {
-				*ptr = '\0';
-				ptr++;
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+			ptr = skip_delim(&ptr0[1], OPTDEL);
 			break;
 		default:
 			op = OSFOPT_EMPTY;
-			ptr = nf_osf_strchr(&obuf[i], OPTDEL);
-			if (ptr) {
-				ptr++;
-				i += (int)(ptr - &obuf[i]);
-			} else
-				i++;
+			ptr = skip_delim(&ptr0[0], OPTDEL);
 			break;
 		}
 
 		if (op != OSFOPT_EMPTY) {
+			if (*optnum >= optlen)
+				return;
 			opt[*optnum].kind = IANA_opts[op].kind;
 			opt[*optnum].length = IANA_opts[op].length;
 			opt[*optnum].wc.wc = wc;
@@ -235,7 +223,7 @@ static int osf_load_line(char *buffer, int len, int del,
 		return -EINVAL;
 	}
 
-	memset(obuf, 0, sizeof(obuf));
+	obuf[0] = '\0';
 
 	pbeg = buffer;
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
@@ -320,7 +308,7 @@ static int osf_load_line(char *buffer, int len, int del,
 		pbeg = pend + 1;
 	}
 
-	nf_osf_parse_opt(f.opt, &f.opt_num, obuf, sizeof(obuf));
+	nf_osf_parse_opt(f.opt, NFT_ARRAY_SIZE(f.opt), &f.opt_num, obuf);
 
 	memset(buf, 0, sizeof(buf));
 
-- 
2.41.0

