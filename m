Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Oj9aqZsh"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F2ED67
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JjQ/8KKwJxFgvvLJeiYSKpE3wLDnJgNvps4S+O0PhEE=; b=Oj9aqZsh6YGDNGnENijwG2XQRo
	DpNlmIhMKGFrpXyrtXdp928OzYj6bw4ay66PXDJTU4Ydg/BLMZ+Jw3kfW3WjJapWOOGIGamUH7a4G
	1wjoMUOwRdX6PVkAPdDFirfmwfI5Rz9DeotWj9UFGJUUEMS6PKPVF36T2NF30BgEqjEiS1AJuUmKf
	Mq2qmogPDBcWcO7nk01Pch//XKjrPMk++sysm33TZdjDThUn9aKUJ2D5VDXMEUBMO60z0L0AY7/Ue
	XgC9lE1fxDXsVYSSGHn1xaLdoe/ldPl5WV86BcM9JlFL/7EeVuYbvaeRBcMuQerdAa+C4nN9T8lPp
	A/QOOurw==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6Typ-0002Iz-Vq
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:04:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] xshared: Simplify generic_opt_check()
Date: Fri, 24 Nov 2023 12:13:25 +0100
Message-ID: <20231124111325.5221-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124111325.5221-1-phil@nwl.cc>
References: <20231124111325.5221-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The option/command matrix does not contain any '+' entries anymore, so
each option/command combination is either allowed (and optional) or not.

Reduce the matrix to an array of unsigned ints which specify the
commands a given option is allowed with.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 77 +++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 49 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index f939a988fa59d..ca17479811df3 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -920,67 +920,46 @@ static int parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
-/* Table of legal combinations of commands and options.  If any of the
- * given commands make an option legal, that option is legal (applies to
- * CMD_LIST and CMD_ZERO only).
- * Key:
- *  +  compulsory
- *  x  illegal
- *     optional
- */
-static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
-/* Well, it's better than "Re: Linux vs FreeBSD" */
-{
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -f 2 3 l 4 5 6 */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x','x','x','x','x','x','x','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x','x','x','x','x','x','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
-/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
+/* list the commands an option is allowed with */
+#define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
+			CMD_APPEND | CMD_CHECK
+static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
+/*OPT_NUMERIC*/		CMD_LIST,
+/*OPT_SOURCE*/		CMD_IDRAC,
+/*OPT_DESTINATION*/	CMD_IDRAC,
+/*OPT_PROTOCOL*/	CMD_IDRAC,
+/*OPT_JUMP*/		CMD_IDRAC,
+/*OPT_VERBOSE*/		UINT_MAX,
+/*OPT_EXPANDED*/	CMD_LIST,
+/*OPT_VIANAMEIN*/	CMD_IDRAC,
+/*OPT_VIANAMEOUT*/	CMD_IDRAC,
+/*OPT_LINENUMBERS*/	CMD_LIST,
+/*OPT_COUNTERS*/	CMD_INSERT | CMD_REPLACE | CMD_APPEND | CMD_SET_POLICY,
+/*OPT_FRAGMENT*/	CMD_IDRAC,
+/*OPT_S_MAC*/		CMD_IDRAC,
+/*OPT_D_MAC*/		CMD_IDRAC,
+/*OPT_H_LENGTH*/	CMD_IDRAC,
+/*OPT_OPCODE*/		CMD_IDRAC,
+/*OPT_H_TYPE*/		CMD_IDRAC,
+/*OPT_P_TYPE*/		CMD_IDRAC,
 };
+#undef CMD_IDRAC
 
 static void generic_opt_check(struct xt_cmd_parse_ops *ops,
 			      int command, int options)
 {
-	int i, j, legal = 0;
+	int i, optval;
 
 	/* Check that commands are valid with options. Complicated by the
 	 * fact that if an option is legal with *any* command given, it is
 	 * legal overall (ie. -z and -l).
 	 */
-	for (i = 0; i < NUMBER_OF_OPT; i++) {
-		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
-
-		for (j = 0; j < NUMBER_OF_CMD; j++) {
-			if (!(command & (1<<j)))
-				continue;
-
-			if (!(options & (1<<i))) {
-				if (commands_v_options[j][i] == '+')
-					xtables_error(PARAMETER_PROBLEM,
-						      "You need to supply the `%s' option for this command",
-						      ops->option_name(1<<i));
-			} else {
-				if (commands_v_options[j][i] != 'x')
-					legal = 1;
-				else if (legal == 0)
-					legal = -1;
-			}
-		}
-		if (legal == -1)
+	for (i = 0, optval = 1; i < NUMBER_OF_OPT; optval = (1 << ++i)) {
+		if ((options & optval) &&
+		    (options_v_commands[i] & command) != command)
 			xtables_error(PARAMETER_PROBLEM,
 				      "Illegal option `%s' with this command",
-				      ops->option_name(1<<i));
+				      ops->option_name(optval));
 	}
 }
 
-- 
2.41.0

