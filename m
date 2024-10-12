Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8423312C489
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770441; cv=none; b=ZQWud9pBPMGort8wIJXR0yVUufocROgS6NO8ZHTNqzegfPN3KdV0s3+gVVWo91KJBNpKtIhhcfyv83LibWv4sbTt9fdyC41xBFQwSbXI5OyZxpoKzz3vqOWppnVauyRgmichId7JgvyUEQkm9hxPLK3dgTQPZturm8Hp/Ngh+/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770441; c=relaxed/simple;
	bh=U4FFY22/b6bbjd6lMURCDc1j/jaAV4Yfc1ikJkg90NU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oSet4kbvKCTB0XgpVKtt/yPI1oORPdzOnzvN4PY9UaSugdZm0FWvnr2hFKKot01Mk1B5HfFwRtWlai0gxjuJy71WHVCQFBKiSFaZqTWeFaQwN1OHGutNrwLPVCSdoMlJwj0KFy60TpB1vcaSUWuCFRsyYk7qkQgfbfYO13TTXVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH conntrack,v2 2/2] conntrack: improve --mark parser
Date: Sun, 13 Oct 2024 00:00:30 +0200
Message-Id: <20241012220030.51402-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241012220030.51402-1-pablo@netfilter.org>
References: <20241012220030.51402-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enhance helper function to parse mark and mask (if available), bail out
if input is not correct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - remove value == 0 && errno == ERANGE check

 src/conntrack.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 18829dbf79bc..5bd966cad657 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1233,17 +1233,35 @@ static int parse_value(const char *str, uint32_t *ret, uint64_t max)
 	return 0;
 }
 
-static void
+static int
 parse_u32_mask(const char *arg, struct u32_mask *m)
 {
-	char *end;
+	uint64_t val, mask;
+	char *endptr;
+
+	val = strtoul(arg, &endptr, 0);
+	if (endptr == arg ||
+	    (*endptr != '\0' && *endptr != '/') ||
+	    (val == ULONG_MAX && errno == ERANGE) ||
+	    val > UINT32_MAX)
+		return -1;
 
-	m->value = (uint32_t) strtoul(arg, &end, 0);
+	m->value = val;
 
-	if (*end == '/')
-		m->mask = (uint32_t) strtoul(end+1, NULL, 0);
-	else
+	if (*endptr == '/') {
+		mask = (uint32_t) strtoul(endptr + 1, &endptr, 0);
+		if (endptr == arg ||
+		    *endptr != '\0' ||
+		    (val == ULONG_MAX && errno == ERANGE) ||
+		    val > UINT32_MAX)
+			return -1;
+
+		m->mask = mask;
+	} else {
 		m->mask = ~0;
+	}
+
+	return 0;
 }
 
 static int
@@ -3115,7 +3133,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			break;
 		case 'm':
 			options |= opt2type[c];
-			parse_u32_mask(optarg, &tmpl->mark);
+			if (parse_u32_mask(optarg, &tmpl->mark) < 0)
+				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", optarg, c);
+
 			tmpl->filter_mark_kernel.val = tmpl->mark.value;
 			tmpl->filter_mark_kernel.mask = tmpl->mark.mask;
 			tmpl->filter_mark_kernel_set = true;
-- 
2.30.2

