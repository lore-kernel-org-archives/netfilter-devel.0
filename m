Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA25C61DAB
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbjKVVpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344369AbjKVVpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34021B9
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GPHnKpi5FXgxsAHyGPweaxU3/3bR/P21ZEzVOirDJAA=; b=IV/5QlSWAo2KkNKu2vXi//Y+/c
        22yN0QifxrYyng4zUVpscJrSIaIaiiqV4bxBv6Hvd7sovt1L996nxdZkQSjxEn9UWVKt4UYgO4qWk
        PlBq1A7xOKKfu3WbRRVzo44u2Q7803UlJUV4Fa3UR1hI5wAI/gHCT446PyLa5D1JOdxIudOI65Yve
        y0y07VrHmIFb9OtIxHqRfo7k6bK5gbW+5ok1EfGvpBd99dvG/QnNqkIOpXCvYIRnGfo1Pp81TJ61/
        TfYkjiGseDAoX2ydxLB1NJzqroq2mVMwTgplaEMLXa49zDx/hksc4i0h/dNR99STlsgvz75hzDUie
        0dMa8L5Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1l-0003ht-6A
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/6] libxtables: Introduce xtables_strtoul_base()
Date:   Wed, 22 Nov 2023 22:52:58 +0100
Message-ID: <20231122215301.15725-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Semantically identical to xtables_strtoul() but accepts the base as
parameter so callers may force it irrespective of number prefix. The old
xtables_strtoul() becomes a shallow wrapper.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h    |  2 ++
 libxtables/xtables.c | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 087a1d600f9ae..1a9e08bb131ab 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -486,6 +486,8 @@ extern void xtables_register_matches(struct xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
 extern void xtables_register_targets(struct xtables_target *, unsigned int);
 
+extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
+	uintmax_t, uintmax_t, unsigned int);
 extern bool xtables_strtoul(const char *, char **, uintmax_t *,
 	uintmax_t, uintmax_t);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ba9ceaeb3da41..b4339e8d31275 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -580,23 +580,23 @@ int xtables_load_ko(const char *modprobe, bool quiet)
 }
 
 /**
- * xtables_strtou{i,l} - string to number conversion
+ * xtables_strtoul_base - string to number conversion
  * @s:	input string
  * @end:	like strtoul's "end" pointer
  * @value:	pointer for result
  * @min:	minimum accepted value
  * @max:	maximum accepted value
+ * @base:	assumed base of value
  *
  * If @end is NULL, we assume the caller wants a "strict strtoul", and hence
  * "15a" is rejected.
  * In either case, the value obtained is compared for min-max compliance.
- * Base is always 0, i.e. autodetect depending on @s.
  *
  * Returns true/false whether number was accepted. On failure, *value has
  * undefined contents.
  */
-bool xtables_strtoul(const char *s, char **end, uintmax_t *value,
-                     uintmax_t min, uintmax_t max)
+bool xtables_strtoul_base(const char *s, char **end, uintmax_t *value,
+			  uintmax_t min, uintmax_t max, unsigned int base)
 {
 	uintmax_t v;
 	const char *p;
@@ -608,7 +608,7 @@ bool xtables_strtoul(const char *s, char **end, uintmax_t *value,
 		;
 	if (*p == '-')
 		return false;
-	v = strtoumax(s, &my_end, 0);
+	v = strtoumax(s, &my_end, base);
 	if (my_end == s)
 		return false;
 	if (end != NULL)
@@ -625,6 +625,12 @@ bool xtables_strtoul(const char *s, char **end, uintmax_t *value,
 	return false;
 }
 
+bool xtables_strtoul(const char *s, char **end, uintmax_t *value,
+		     uintmax_t min, uintmax_t max)
+{
+	return xtables_strtoul_base(s, end, value, min, max, 0);
+}
+
 bool xtables_strtoui(const char *s, char **end, unsigned int *value,
                      unsigned int min, unsigned int max)
 {
-- 
2.41.0

