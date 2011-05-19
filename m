From: JP Abgrall <jpa@google.com>
Subject: xtoptions + quota: parse and store 64bit values?
Date: Wed, 18 May 2011 20:26:14 -0700
Message-ID: <BANLkTi=cn4RQSDt3bAGrpSxdd7A4FttVew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:27361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1ESD0g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 23:26:36 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p4J3QZY9021307
	for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2011 20:26:35 -0700
Received: from ywf9 (ywf9.prod.google.com [10.192.6.9])
	by wpaz37.hot.corp.google.com with ESMTP id p4J3QLui009024
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2011 20:26:34 -0700
Received: by ywf9 with SMTP id 9so914593ywf.36
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2011 20:26:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this change, my kernel's xt_quota.c::quota_mt_check() doesn't
see the values.


>From b65b9fe5096bd49a9ec2f0f6c2f23d274cfc88ee Mon Sep 17 00:00:00 2001
From: JP Abgrall <jpa@google.com>
Date: Wed, 18 May 2011 20:19:39 -0700
Subject: [PATCH] xtoptions + quota: parse and store 64bit values

The xtables_strtoul() would cram a long long into a long.
The parse_int would try to cram a UINT64 into a long.
The quota_parse would just ignore whatever value was parsed.

Change-Id: Ie1f05e98e974a255d962dd757a5592458f942f8b
---
 extensions/libxt_quota.c |    1 +
 include/xtables.h.in     |    2 +-
 xtables.c                |    4 ++--
 xtoptions.c              |    4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 988f404..dc9b3b0 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -47,6 +47,7 @@ static void quota_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	if (cb->invert)
 		info->flags |= XT_QUOTA_INVERT;
+	info->quota = cb->val.u64;
 }

 static struct xtables_match quota_match = {
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 38c0e5e..5e9dec7 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -408,7 +408,7 @@ extern void xtables_register_matches(struct
xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
 extern void xtables_register_targets(struct xtables_target *, unsigned int);

-extern bool xtables_strtoul(const char *, char **, unsigned long *,
+extern bool xtables_strtoul(const char *, char **, unsigned long long *,
 	unsigned long, unsigned long);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
diff --git a/xtables.c b/xtables.c
index 9038f89..69e79b1 100644
--- a/xtables.c
+++ b/xtables.c
@@ -426,7 +426,7 @@ int xtables_load_ko(const char *modprobe, bool quiet)
  * Returns true/false whether number was accepted. On failure, *value has
  * undefined contents.
  */
-bool xtables_strtoul(const char *s, char **end, unsigned long *value,
+bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
                      unsigned long min, unsigned long max)
 {
 	unsigned long v;
@@ -454,7 +454,7 @@ bool xtables_strtoul(const char *s, char **end,
unsigned long *value,
 bool xtables_strtoui(const char *s, char **end, unsigned int *value,
                      unsigned int min, unsigned int max)
 {
-	unsigned long v;
+	unsigned long long v;
 	bool ret;

 	ret = xtables_strtoul(s, end, &v, min, max);
diff --git a/xtoptions.c b/xtoptions.c
index 8d54dd8..7a35ffa 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -105,7 +105,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
 	unsigned long long lmin = 0, lmax = UINT32_MAX;
-	unsigned int value;
+	unsigned long long value;

 	if (entry->type == XTTYPE_UINT8)
 		lmax = UINT8_MAX;
@@ -118,7 +118,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	if (cb->entry->max != 0)
 		lmax = cb->entry->max;

-	if (!xtables_strtoui(cb->arg, NULL, &value, lmin, lmax))
+	if (!xtables_strtoul(cb->arg, NULL, &value, lmin, lmax))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
 			"or out of range (%llu-%llu).\n",
-- 
1.7.3.1
