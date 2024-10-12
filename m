Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4D19BA6
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728747011; cv=none; b=WfKSCEeloEIuz0BIE7db7/z/NEEIIOih6G9TL8LYjJzF8r/rwAMP640pEJMyAh6NimH1MT5hl8bFyUl+FX0fjPHVLzb0vCSE3FJYPxBE22CiEFmUrvalcIb1d/YPxkFBa8fZ+VYhQKCU34oikFApTtP8RgXEeo/esQbrDhKx7uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728747011; c=relaxed/simple;
	bh=+3qN7PKYXvUaG4ydS8XMuZqph2wAYD0EO12P0bBfwqU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=h9c/7lXPAuGyZ/xFf/iwmzDeQVD12EsiNM0hT5lsP+Lo9N22EkHNLYXAThamw39jNXd68koGSC7oUBB+NO2CwIMYKv2P27DMnBwhsj1LdemT2bCzn+wQAh7mjW9fM5+O25cLmk3OIDxbcOoK8Oc1I1AcaCSNNVAbRwaGQU636wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 1/3] conntrack: improve --secmark,--id,--zone parser
Date: Sat, 12 Oct 2024 17:29:55 +0200
Message-Id: <20241012152957.30724-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strtoul() is called with no error checking at all, add a helper
function to validate input is correct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 9fa49869b553..f3725eefd5de 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1213,6 +1213,25 @@ parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask,
 		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
 }
 
+static int parse_value(const char *str, uint32_t *ret, uint64_t max)
+{
+	char *endptr;
+	uint64_t val;
+
+	errno = 0;
+	val = strtoul(str, &endptr, 0);
+	if (endptr == str ||
+	    *endptr != '\0' ||
+	    (val == ULONG_MAX && errno == ERANGE) ||
+	    (val == 0 && errno == ERANGE) ||
+	    val > max)
+		return -1;
+
+	*ret = val;
+
+	return 0;
+}
+
 static void
 parse_u32_mask(const char *arg, struct u32_mask *m)
 {
@@ -2918,6 +2937,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
+	uint32_t value;
 	int c, cmd;
 
 	/* we release these objects in the exit_error() path. */
@@ -3078,17 +3098,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'w':
 		case '(':
 		case ')':
+			if (parse_value(optarg, &value, UINT16_MAX) < 0)
+				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", optarg, c);
+
 			options |= opt2type[c];
-			nfct_set_attr_u16(tmpl->ct,
-					  opt2attr[c],
-					  strtoul(optarg, NULL, 0));
+			nfct_set_attr_u16(tmpl->ct, opt2attr[c], value);
 			break;
 		case 'i':
 		case 'c':
+			if (parse_value(optarg, &value, UINT32_MAX) < 0)
+				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", optarg, c);
+
 			options |= opt2type[c];
-			nfct_set_attr_u32(tmpl->ct,
-					  opt2attr[c],
-					  strtoul(optarg, NULL, 0));
+			nfct_set_attr_u32(tmpl->ct, opt2attr[c], value);
 			break;
 		case 'm':
 			options |= opt2type[c];
-- 
2.30.2

