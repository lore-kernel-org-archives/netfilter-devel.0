From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 14/17] v4: rename print_rule() to print_rule4()
Date: Thu, 31 Mar 2011 21:27:30 -0700
Message-ID: <1301632053-3694-14-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1DAE2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:34 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:33 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/iptables.h |    2 +-
 iptables-save.c    |    2 +-
 iptables.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/iptables.h b/include/iptables.h
index 4e9ae19..204c92e 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -15,7 +15,7 @@ extern int flush_entries4(const ipt_chainlabel chain,=
 int verbose,
 			struct iptc_handle *handle);
 extern int for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct=
 iptc_handle *),
 		int verbose, int builtinstoo, struct iptc_handle *handle);
-extern void print_rule(const struct ipt_entry *e,
+extern void print_rule4(const struct ipt_entry *e,
 		struct iptc_handle *handle, const char *chain, int counters);
=20
 /* kernel revision handling */
diff --git a/iptables-save.c b/iptables-save.c
index a0aa5d8..dee1752 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -107,7 +107,7 @@ static int do_output(const char *tablename)
 			/* Dump out rules */
 			e =3D iptc_first_rule(chain, h);
 			while(e) {
-				print_rule(e, h, chain, show_counters);
+				print_rule4(e, h, chain, show_counters);
 				e =3D iptc_next_rule(e, h);
 			}
 		}
diff --git a/iptables.c b/iptables.c
index 5af832e..b7c9498 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1101,7 +1101,7 @@ static void print_ip(const char *prefix, uint32_t=
 ip,
=20
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-void print_rule(const struct ipt_entry *e,
+void print_rule4(const struct ipt_entry *e,
 		struct iptc_handle *h, const char *chain, int counters)
 {
 	const struct ipt_entry_target *t;
@@ -1224,7 +1224,7 @@ list_rules(const ipt_chainlabel chain, int rulenu=
m, int counters,
 		while(e) {
 			num++;
 			if (!rulenum || num =3D=3D rulenum)
-			    print_rule(e, handle, this, counters);
+			    print_rule4(e, handle, this, counters);
 			e =3D iptc_next_rule(e, handle);
 		}
 		found =3D 1;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
