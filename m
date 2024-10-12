Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FB817579
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770440; cv=none; b=UJe8P8GaoGq1EqAfHwVi9KnCHI0S5nV5+ebecQXsonNC4v4VyZ0mdpOt7AaHoTFj5SYXLylYRbefX3PGJWJi0ELRNevjlnoiVv0b8HSyXTnIUXfBGmI7GNrLqZ4fp/5Pqk9E5x9S0HBHg6g+NACOQ+Dz0ZvaDcyYBuyr5DoJcNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770440; c=relaxed/simple;
	bh=DU8scetYoE7qvgQxEyzArtALivZkHiGDO3szM+V0b24=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z3IENabBE/pQNBuiY7jZj8yaETbp9k6pUf7ss16tlvxVYtHFE/b7EdUwgHO1o21iNnCptEjVCZDaTFEk3vEhXfigGRzyx/998zF63CorZrmWH6xHWd0qfq22eNtIIeV2eihppjMHvfGRArkK/BgmF/9yrTvMe8HejB0Kh+i1VXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH conntrack,v2 1/2] conntrack: improve --secmark,--id,--zone parser
Date: Sun, 13 Oct 2024 00:00:29 +0200
Message-Id: <20241012220030.51402-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strtoul() is called with no error checking at all, add a helper
function to validate input is correct for values less than
UINT32_MAX.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - remove value == 0 && errno == ERANGE check
    - add assert to remember this only supports max up to UINT32_MAX

 src/conntrack.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 9fa49869b553..18829dbf79bc 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1213,6 +1213,26 @@ parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask,
 		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
 }
 
+static int parse_value(const char *str, uint32_t *ret, uint64_t max)
+{
+	char *endptr;
+	uint64_t val;
+
+	assert(max <= UINT32_MAX);
+
+	errno = 0;
+	val = strtoul(str, &endptr, 0);
+	if (endptr == str ||
+	    *endptr != '\0' ||
+	    (val == ULONG_MAX && errno == ERANGE) ||
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
@@ -2918,6 +2938,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
+	uint32_t value;
 	int c, cmd;
 
 	/* we release these objects in the exit_error() path. */
@@ -3078,17 +3099,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
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

