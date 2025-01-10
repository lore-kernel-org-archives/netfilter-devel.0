Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBAB214238
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736533338; cv=none; b=Tf05DfuZB2gxP/MwBNRdVHxub47Z9sszJ2Qt4yxy4wAbZSg9Y1JmVyfjAe0oOf/iJ0v+7D1iTPBzfndnONBMeaf0k7BHJqrRwTW+9ucpp3EFBPciXMrYLYT6TvoSxL9CniGV+enXJRZWIHwWk+YNO/x1sVW36/1Q9eMDi8utX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736533338; c=relaxed/simple;
	bh=lrcJmXW8N6sEgEPk9GYcUxPejNAOgEz3gqD19seDCw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kL7cOcFp6B2D916QLDMoA0N2PT073SKz7V2iEfbgn0HkNchcLYkbWdkqqqZOIQsVD8S36xAU9O9QvO8x40fmsmcB4WHLMnRYtIWr6cGlZ8KyGdBh+F1VsriBh8vSJaxjhkgF4Sk+PTmX6o/uoXylF56yHo3DBXluHg36JH1TfII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RB0HoZQj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RB0HoZQj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GyreawI1qFcoUcN6SwSVh76mV22vmqI57ZSfmdkQsOw=; b=RB0HoZQjws5OzOvqXYLpvWemNG
	VxVl86UaLbjaS0NhgA2dYPypScYoQczfH3cqdzX2iCWXE2uZLXcQvx4P5j6Vy47fGTnVo9qxenvbu
	K0+OBovu0zdH1M00qAna/eFzSNaOqJlDw9wZK8ck+JU5VMoeOF7U+YkcMPmoWTgeIZDF3h9O1gLUP
	5LdfKqQqXPqQyIS4qxgOkldGuUNHZIX6WpMlA+RT04U+pGXSj9f8y4Wsw5c0YZDx1du07cNOQKePu
	OuwMZ/mG1RdoIWoVN1QuGrRiq+VExbQCd7cUFdjMr3kfVOY65h5oHrHAzPs7Jr2HmkIzIKhxxe0WL
	JWX78YMA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tWJe4-000000006Pt-1ACi;
	Fri, 10 Jan 2025 19:22:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [iptables PATCH] xshared: Fix for extra --list options with --zero
Date: Fri, 10 Jan 2025 19:22:04 +0100
Message-ID: <20250110182204.25548-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With commit 9c09d28102bb4 ("xshared: Simplify generic_opt_check()"),
iptables started to reject list-specific options (--numeric, --exact,
--line-numbers) if --zero was also specified: The old
generic_opt_check() implementation ignored a command's reject of an
option if an earlier command (decided by the numeric CMD_* value) had
accepted it already.

Instead of replicating the old logic and introducing an inner loop over
the bits in 'command', simply expand the respective 'options_v_commands'
fields. As a side-effect, this will make iptables accept but ignore
these list-specific options when only --zero command was specified.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: 9c09d28102bb4 ("xshared: Simplify generic_opt_check()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 2f663f9762016..cf73890ac9f86 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -943,16 +943,16 @@ static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
 #define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
 			CMD_APPEND | CMD_CHECK | CMD_CHANGE_COUNTERS
 static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
-/*OPT_NUMERIC*/		CMD_LIST,
+/*OPT_NUMERIC*/		CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
 /*OPT_SOURCE*/		CMD_IDRAC,
 /*OPT_DESTINATION*/	CMD_IDRAC,
 /*OPT_PROTOCOL*/	CMD_IDRAC,
 /*OPT_JUMP*/		CMD_IDRAC,
 /*OPT_VERBOSE*/		UINT_MAX,
-/*OPT_EXPANDED*/	CMD_LIST,
+/*OPT_EXPANDED*/	CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
 /*OPT_VIANAMEIN*/	CMD_IDRAC,
 /*OPT_VIANAMEOUT*/	CMD_IDRAC,
-/*OPT_LINENUMBERS*/	CMD_LIST,
+/*OPT_LINENUMBERS*/	CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
 /*OPT_COUNTERS*/	CMD_INSERT | CMD_REPLACE | CMD_APPEND | CMD_SET_POLICY,
 /*OPT_FRAGMENT*/	CMD_IDRAC,
 /*OPT_S_MAC*/		CMD_IDRAC,
@@ -963,9 +963,9 @@ static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
 /*OPT_P_TYPE*/		CMD_IDRAC,
 /*OPT_LOGICALIN*/	CMD_IDRAC,
 /*OPT_LOGICALOUT*/	CMD_IDRAC,
-/*OPT_LIST_C*/		CMD_LIST,
-/*OPT_LIST_X*/		CMD_LIST,
-/*OPT_LIST_MAC2*/	CMD_LIST,
+/*OPT_LIST_C*/		CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
+/*OPT_LIST_X*/		CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
+/*OPT_LIST_MAC2*/	CMD_LIST | CMD_ZERO | CMD_ZERO_NUM,
 };
 #undef CMD_IDRAC
 
-- 
2.47.1

