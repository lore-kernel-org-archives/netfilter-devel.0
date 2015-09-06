From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: [PATCH] iptables: Spelling fixes
Date: Sun,  6 Sep 2015 09:22:30 +0300
Message-ID: <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
References: <20150905210746.GA13600@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35811 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbIFGWg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2015 02:22:36 -0400
Received: by lagj9 with SMTP id j9so35550632lag.2
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Sep 2015 23:22:34 -0700 (PDT)
Received: from viper.bobcat.mine.nu (62-78-200-229.bb.dnainternet.fi. [62.78.200.229])
        by smtp.gmail.com with ESMTPSA id bx5sm1955191lbc.36.2015.09.05.23.22.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2015 23:22:33 -0700 (PDT)
In-Reply-To: <20150905210746.GA13600@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While at it, update comment format for the respective blocks.

Signed-off-by: Ville Skytt=C3=A4 <ville.skytta@iki.fi>
---
 iptables/ip6tables.c    | 15 +++++++++------
 iptables/iptables-xml.c | 18 ++++++++++--------
 iptables/iptables.c     | 15 +++++++++------
 iptables/iptables.xslt  |  2 +-
 libiptc/libiptc.c       |  2 +-
 libxtables/xtables.c    |  2 +-
 6 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 8db13b4..5a6699d 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1046,7 +1046,8 @@ static int print_match_save(const struct xt_entry=
_match *e,
 	return 0;
 }
=20
-/* print a given ip including mask if neccessary */
+/* Print a given ip including mask if necessary.
+ */
 static void print_ip(const char *prefix, const struct in6_addr *ip,
 		     const struct in6_addr *mask, int invert)
 {
@@ -1067,8 +1068,9 @@ static void print_ip(const char *prefix, const st=
ruct in6_addr *ip,
 		printf("/%d", l);
 }
=20
-/* We want this to be readable, so only print out neccessary fields.
- * Because that's the kind of world I want to live in.  */
+/* We want this to be readable, so only print out necessary fields.
+ * Because that's the kind of world I want to live in.
+ */
 void print_rule6(const struct ip6t_entry *e,
 		       struct xtc_handle *h, const char *chain, int counters)
 {
@@ -1840,10 +1842,11 @@ int do_command6(int argc, char *argv[], char **=
table,
 		}
=20
 		if (!cs.target) {
-			/* it is no chain, and we can't load a plugin.
+			/* It is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
-			 * existant OR if the user just misspelled a
-			 * chain. */
+			 * existent OR if the user just misspelled a
+			 * chain.
+			 */
 #ifdef IP6T_F_GOTO
 			if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 7461412..740a563 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -131,8 +131,9 @@ free_argv(void)
 	oldargc =3D 0;
 }
=20
-/* save parsed rule for comparison with next rule=20
-   to perform action agregation on duplicate conditions */
+/* Save parsed rule for comparison with next rule to perform action ag=
gregation
+ * on duplicate conditions.
+ */
 static void
 save_argv(void)
 {
@@ -527,12 +528,13 @@ do_rule_part(char *leveltag1, char *leveltag2, in=
t part, int argc,
 static int
 compareRules(void)
 {
-	/* compare arguments up to -j or -g for match.
-	   NOTE: We don't want to combine actions if there were no criteria=20
-	   in each rule, or rules didn't have an action=20
-	   NOTE: Depends on arguments being in some kind of "normal" order wh=
ich=20
-	   is the case when processing the ACTUAL output of actual iptables-s=
ave=20
-	   rather than a file merely in a compatable format */
+	/* Compare arguments up to -j or -g for match.
+	 * NOTE: We don't want to combine actions if there were no criteria
+	 * in each rule, or rules didn't have an action.
+	 * NOTE: Depends on arguments being in some kind of "normal" order wh=
ich
+	 * is the case when processing the ACTUAL output of actual iptables-s=
ave
+	 * rather than a file merely in a compatible format.
+	 */
=20
 	unsigned int old =3D 0;
 	unsigned int new =3D 0;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 88953c4..4ff9053 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1037,7 +1037,8 @@ static int print_match_save(const struct xt_entry=
_match *e,
 	return 0;
 }
=20
-/* print a given ip including mask if neccessary */
+/* Print a given ip including mask if necessary.
+ */
 static void print_ip(const char *prefix, uint32_t ip,
 		     uint32_t mask, int invert)
 {
@@ -1067,8 +1068,9 @@ static void print_ip(const char *prefix, uint32_t=
 ip,
 		printf("/%u.%u.%u.%u", IP_PARTS(mask));
 }
=20
-/* We want this to be readable, so only print out neccessary fields.
- * Because that's the kind of world I want to live in.  */
+/* We want this to be readable, so only print out necessary fields.
+ * Because that's the kind of world I want to live in.
+ */
 void print_rule4(const struct ipt_entry *e,
 		struct xtc_handle *h, const char *chain, int counters)
 {
@@ -1838,10 +1840,11 @@ int do_command4(int argc, char *argv[], char **=
table,
 		}
=20
 		if (!cs.target) {
-			/* it is no chain, and we can't load a plugin.
+			/* It is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
-			 * existant OR if the user just misspelled a
-			 * chain. */
+			 * existent OR if the user just misspelled a
+			 * chain.
+			 */
 #ifdef IPT_F_GOTO
 			if (cs.fw.ip.flags & IPT_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
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
