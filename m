Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qXU5iilx"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313E51A8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BIZfeMXhWjjvENrylSWL9FA5RbfMQ2Zj83oOK9K9nZQ=; b=qXU5iilxnTS5O6Snnn2UzOy+kF
	ZygsA63WMSfFlduJZIUEEq6pFTc3aXvVjphcY1XjyBM163iT9WUMjgc7q/ylHAouBdgEH4PB8NtwJ
	7DZ12ckQ6NUCBAPkGGmrBTHkxTAu8cahTCMNw4BQPHj0gX9SOKCmSsqLfhdGKj4+9O01vcoYzJTas
	p1nusBQmMBCT5NzR7uTzqKtXpc+PgBkRsVFBJbYdmkv2ECB99aqm1N9ofh/LPQh7Vqqio150YtQn5
	2JH7t0Y/l3IG9/FJmEVVyEeN8kuNayy3jNDEZ1CQwtQlO7RDLU2kr89vyRzxjTP5CrDiMs8H3dfiS
	4QDHOzVA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPj-0001jD-HI
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/13] xshared: Support rule range deletion in do_parse()
Date: Wed, 29 Nov 2023 14:28:19 +0100
Message-ID: <20231129132827.18166-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a distinct ebtables feature. Introduce struct
xt_cmd_parse::rule_ranges boolean indicating support for it and bail
otherwise if a range was specified by the user.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 34 +++++++++++++++++++++++++++++++++-
 iptables/xshared.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 177f3ddd1c19e..62ae4141325ed 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -903,6 +903,38 @@ static int parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
+static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
+{
+	char *colon = strchr(argv, ':'), *buffer;
+
+	if (colon) {
+		if (!p->rule_ranges)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Rule ranges are not supported");
+
+		*colon = '\0';
+		if (*(colon + 1) == '\0')
+			p->rulenum_end = -1; /* Until the last rule */
+		else {
+			p->rulenum_end = strtol(colon + 1, &buffer, 10);
+			if (*buffer != '\0' || p->rulenum_end == 0)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Invalid rule range end`%s'",
+					      colon + 1);
+		}
+	}
+	if (colon == argv)
+		p->rulenum = 1; /* Beginning with the first rule */
+	else {
+		p->rulenum = strtol(argv, &buffer, 10);
+		if (*buffer != '\0' || p->rulenum == 0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid rule number `%s'", argv);
+	}
+	if (!colon)
+		p->rulenum_end = p->rulenum;
+}
+
 /* list the commands an option is allowed with */
 #define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
 			CMD_APPEND | CMD_CHECK
@@ -1411,7 +1443,7 @@ void do_parse(int argc, char *argv[],
 			add_command(&p->command, CMD_DELETE, CMD_NONE, invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv)) {
-				p->rulenum = parse_rulenumber(argv[optind++]);
+				parse_rule_range(p, argv[optind++]);
 				p->command = CMD_DELETE_NUM;
 			}
 			break;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 69f50e505cb9b..2fd15c725faaf 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -280,6 +280,7 @@ struct xt_cmd_parse_ops {
 struct xt_cmd_parse {
 	unsigned int			command;
 	unsigned int			rulenum;
+	unsigned int			rulenum_end;
 	char				*table;
 	const char			*chain;
 	const char			*newname;
@@ -287,6 +288,7 @@ struct xt_cmd_parse {
 	bool				restore;
 	int				line;
 	int				verbose;
+	bool				rule_ranges;
 	struct xt_cmd_parse_ops		*ops;
 };
 
-- 
2.41.0

