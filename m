From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: [PATCH] iptables: Spelling fixes
Date: Sat,  5 Sep 2015 10:04:36 +0300
Message-ID: <1441436676-10778-1-git-send-email-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35833 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbIEHEk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Sep 2015 03:04:40 -0400
Received: by lagj9 with SMTP id j9so25862757lag.2
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Sep 2015 00:04:39 -0700 (PDT)
Received: from viper.bobcat.mine.nu (62-78-200-229.bb.dnainternet.fi. [62.78.200.229])
        by smtp.gmail.com with ESMTPSA id qm6sm1142645lbb.23.2015.09.05.00.04.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2015 00:04:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ville Skytt=C3=A4 <ville.skytta@iki.fi>
---
 iptables/ip6tables.c    | 6 +++---
 iptables/iptables-xml.c | 2 +-
 iptables/iptables.c     | 6 +++---
 iptables/iptables.xslt  | 2 +-
 libiptc/libiptc.c       | 2 +-
 libxtables/xtables.c    | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 8db13b4..4a597b7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1046,7 +1046,7 @@ static int print_match_save(const struct xt_entry=
_match *e,
 	return 0;
 }
=20
-/* print a given ip including mask if neccessary */
+/* print a given ip including mask if necessary */
 static void print_ip(const char *prefix, const struct in6_addr *ip,
 		     const struct in6_addr *mask, int invert)
 {
@@ -1067,7 +1067,7 @@ static void print_ip(const char *prefix, const st=
ruct in6_addr *ip,
 		printf("/%d", l);
 }
=20
-/* We want this to be readable, so only print out neccessary fields.
+/* We want this to be readable, so only print out necessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule6(const struct ip6t_entry *e,
 		       struct xtc_handle *h, const char *chain, int counters)
@@ -1842,7 +1842,7 @@ int do_command6(int argc, char *argv[], char **ta=
ble,
 		if (!cs.target) {
 			/* it is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
-			 * existant OR if the user just misspelled a
+			 * existent OR if the user just misspelled a
 			 * chain. */
 #ifdef IP6T_F_GOTO
 			if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 7461412..f7ecdba 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -532,7 +532,7 @@ compareRules(void)
 	   in each rule, or rules didn't have an action=20
 	   NOTE: Depends on arguments being in some kind of "normal" order wh=
ich=20
 	   is the case when processing the ACTUAL output of actual iptables-s=
ave=20
-	   rather than a file merely in a compatable format */
+	   rather than a file merely in a compatible format */
=20
 	unsigned int old =3D 0;
 	unsigned int new =3D 0;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 88953c4..539dab5 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1037,7 +1037,7 @@ static int print_match_save(const struct xt_entry=
_match *e,
 	return 0;
 }
=20
-/* print a given ip including mask if neccessary */
+/* print a given ip including mask if necessary */
 static void print_ip(const char *prefix, uint32_t ip,
 		     uint32_t mask, int invert)
 {
@@ -1067,7 +1067,7 @@ static void print_ip(const char *prefix, uint32_t=
 ip,
 		printf("/%u.%u.%u.%u", IP_PARTS(mask));
 }
=20
-/* We want this to be readable, so only print out neccessary fields.
+/* We want this to be readable, so only print out necessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule4(const struct ipt_entry *e,
 		struct xtc_handle *h, const char *chain, int counters)
@@ -1840,7 +1840,7 @@ int do_command4(int argc, char *argv[], char **ta=
ble,
 		if (!cs.target) {
 			/* it is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
-			 * existant OR if the user just misspelled a
+			 * existent OR if the user just misspelled a
 			 * chain. */
 #ifdef IPT_F_GOTO
 			if (cs.fw.ip.flags & IPT_F_GOTO)
diff --git a/iptables/iptables.xslt b/iptables/iptables.xslt
index d6a432c..afe6d0d 100644
--- a/iptables/iptables.xslt
+++ b/iptables/iptables.xslt
@@ -13,7 +13,7 @@
=20
   <!-- output conditions of a rule but not an action -->
   <xsl:template match=3D"iptables-rules/table/chain/rule/conditions/*"=
>
-    <!-- <match> is the psuedo module when a match module doesn't need=
 to be loaded
+    <!-- <match> is the pseudo module when a match module doesn't need=
 to be loaded
          and when -m does not need to be inserted -->
     <xsl:if test=3D"name() !=3D 'match'">
       <xsl:text> -m </xsl:text><xsl:value-of select=3D"name()"/>
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 9c07bb4..2c66d04 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -592,7 +592,7 @@ static int iptcc_chain_index_rebuild(struct xtc_han=
dle *h)
  * There are different strategies, the simple and safe is to rebuild
  * the chain index every time.  The more advanced is to update the
  * array index to point to the next element, but that requires some
- * house keeping and boundry checks.  The advanced is implemented, as
+ * house keeping and boundary checks.  The advanced is implemented, as
  * the simple approach behaves badly when all chains are deleted
  * because list_for_each processing will always hit the first chain
  * index, thus causing a rebuild for every chain.
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 5357d12..f14d503 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1137,7 +1137,7 @@ void xtables_rule_matches_free(struct xtables_rul=
e_match **matches)
  *
  * %XTF_BAD_VALUE: bad value for option
  * @p1:		module name
- * @p2:		option with which the problem occured (e.g. "--mark")
+ * @p2:		option with which the problem occurred (e.g. "--mark")
  * @p3:		string the user passed in (e.g. "99999999999999")
  *
  * %XTF_ONE_ACTION: two mutually exclusive actions have been specified
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
