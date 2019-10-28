Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9282CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9600220830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbfJ1Psy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:48:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40128 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfJ1Psy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:48:54 -0400
Received: from localhost ([::1]:53218 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7GH-00026Z-67; Mon, 28 Oct 2019 16:48:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 03/10] xshared: Share a common implementation of parse_rulenumber()
Date:   Mon, 28 Oct 2019 16:48:11 +0100
Message-Id: <20191028154818.31257-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is really small, but still copied four times.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 13 -------------
 iptables/iptables.c    | 12 ------------
 iptables/xshared.c     | 12 ++++++++++++
 iptables/xshared.h     |  1 +
 iptables/xtables-arp.c | 13 -------------
 iptables/xtables.c     | 12 ------------
 6 files changed, 13 insertions(+), 50 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 9a9d71f1cdadc..f4ccfc60de953 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -352,19 +352,6 @@ static int is_exthdr(uint16_t proto)
 		proto == IPPROTO_DSTOPTS);
 }
 
-/* Can't be zero. */
-static int
-parse_rulenumber(const char *rule)
-{
-	unsigned int rulenum;
-
-	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid rule number `%s'", rule);
-
-	return rulenum;
-}
-
 static void
 parse_chain(const char *chainname)
 {
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 5fec25376c24f..df371f410a9c2 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -343,18 +343,6 @@ opt2char(int option)
 */
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
-/* Can't be zero. */
-static int
-parse_rulenumber(const char *rule)
-{
-	unsigned int rulenum;
-
-	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid rule number `%s'", rule);
-
-	return rulenum;
-}
 
 static void
 parse_chain(const char *chainname)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 3baa805c64e6d..2a0077d9da846 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -759,3 +759,15 @@ void add_command(unsigned int *cmd, const int newcmd,
 			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
 	*cmd |= newcmd;
 }
+
+/* Can't be zero. */
+int parse_rulenumber(const char *rule)
+{
+	unsigned int rulenum;
+
+	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			   "Invalid rule number `%s'", rule);
+
+	return rulenum;
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 0b9b357c7bdaa..85bbfa1250aa3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -186,5 +186,6 @@ void command_jump(struct iptables_command_state *cs, const char *jumpto);
 char cmd2char(int option);
 void add_command(unsigned int *cmd, const int newcmd,
 		 const int othercmds, int invert);
+int parse_rulenumber(const char *rule);
 
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 584b6f0646821..79cc83d354fc5 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -518,19 +518,6 @@ parse_interface(const char *arg, char *vianame, unsigned char *mask)
 	}
 }
 
-/* Can't be zero. */
-static int
-parse_rulenumber(const char *rule)
-{
-	unsigned int rulenum;
-
-	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Invalid rule number `%s'", rule);
-
-	return rulenum;
-}
-
 static void
 set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
 	   int invert)
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 6dfa3f1171183..bb76e6a7a1ce8 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -327,18 +327,6 @@ opt2char(int option)
 */
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
-/* Can't be zero. */
-static int
-parse_rulenumber(const char *rule)
-{
-	unsigned int rulenum;
-
-	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid rule number `%s'", rule);
-
-	return rulenum;
-}
 
 static void
 set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
-- 
2.23.0

