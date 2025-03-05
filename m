Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817EE1A5BB7
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741194584; cv=none; b=dr4ovUROyclWg3HrrpWDdQGUQkOgVkLYbESBg6N69UKOhKLd5SL70ZmXRbNd32JscR3LwfiaPxM4C6GHw8B3zxqBJq/49fR0YpaspyjBoY3y/3CnHtxn3aHIu3IAVMbEG3L26RaYL7KddKQZrr0HPg0WewYsnfKPnblxYCk7qIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741194584; c=relaxed/simple;
	bh=irFcCVMJ+YoW6k8byXnRJIVW9wTUS4yGDTwhsoaB6Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HC89aS4MyyK0qOx+5rO5csPyNPei8FowBaP85b97Z8D+6MeJdd0oIYw4yWZ7CN6C1/ugm3Z4a/Wa0nkBngnG6C1pe6gekERxbwBLUxowmI8+o9riUusVs5QgsbIPhHA9y0lLIdxZDqt5/ri3NE+t/q+K7pMcQNhUd1sTXGLAmGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P1p3UOO0; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P1p3UOO0"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-43bbb440520so41616285e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Mar 2025 09:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741194579; x=1741799379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Xwduz/qNPiyy4RhwG9d9PScJsmgmVdCqCQSC6jOGw4=;
        b=P1p3UOO0b9YDJTFpWR4YE+ZSKZf6Xcn52yudVG+sPHwyBxBtardW009r9baCZcBeB4
         4YrBwUNx2JnWKUZCwE8P5GXIHIEPQ0jNvCevdy2YOChbqBHkzpHt/1wzFn5RYouw4lg7
         Ubnyj/AmJTt084JQMIhTcWp0jpVFjR0Xndt2RDe864mTy2ddPAAr0onst3U6rKkFxD45
         H0M4bgWyKxC98MlJmxb9oAlG/J9F2VNQt4FJxc+tUtjyiDfKCDHtPn8v130bldZUxkdd
         1L/Pie03mBgGdJDVfupW8ScDCv5mNHuWB5VmdaSSZ68xZEXatoTBkzENiNCy/KsCr8T5
         oqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741194579; x=1741799379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Xwduz/qNPiyy4RhwG9d9PScJsmgmVdCqCQSC6jOGw4=;
        b=IlEKFQwT6FTbsHlgoq99Lu+s4kdrf9AUyqlj10dirkITk/jpPrEQP82Bx1ALWvHMCG
         JSyOXcQCzVPx3zPGHUA2H7YO6EhYebHDBtoLfBwvJv/MhjjXB2wyCJrxfwIQUczyrqND
         tfhZMYc+fvGQYqYTmn8QA/p2NqhSOqnExj7GzU80QOBmx4mAlpqDG5iSn0adJSpJDp7f
         bt0BexHfwbviKQq0Xlm68f15iMRFRJWYb4zu6wiO8O26QEE2mDMTUvUEIlp4hSLrcjHE
         /doKJfFfPrrXmUgooBUMwePL/wFFOOiyCK4jxSEyMEy2zJmzRgOKxQ/Fvzqsddq97YpC
         Lktw==
X-Gm-Message-State: AOJu0Yzc1ob8yJAenSGQotr1R+WWoYvX4sLBH/6mUJ99VH7dRd7Fq83J
	HrLHehGKMveEz863ZTC2jrNDi4TIof1gC1AkUC0OFYyg0JfVssCNCDUNAEhHMu++okqX8OMiz6m
	roimiCA==
X-Gm-Gg: ASbGnct6F3ZbKM1NV0ecy3r4sCMarbSDSVcoXfaIkZzbBshNMAV7HFIOH0G9azYI0rf
	qn4DEIr8FL1yiPncMHxxcwoNuybjcNR9QgLKEfiW1k9JaxlMQKe5xV7IEgXW6nLuJsxPM+rex68
	lQRQ3QpYL3pgTVkdLsKRAzzXWjzEIdBEEMLcWvwWZ0TFbkBylVsJiumvR+PtygD1rpkbGHXMbPy
	6V7w57Yai7vSk54Y4VfQQpdLji5RnbcEvhEzI0+owqAkqI8SAAAk3DYUhBnv+URLEeckUUWtVxL
	OMDf86FzcCWW9soYtvt/TlGYD/eY764kXW7qySqDskgjoWg=
X-Google-Smtp-Source: AGHT+IHtALOlZRY8OEkAfMy/8LP4eO3WEczzKfPhSQDmbP+zhNlJTZUTR0mJ/R+5FMnzK/l5vhD0mw==
X-Received: by 2002:a05:600c:1d01:b0:43b:cf12:2ca6 with SMTP id 5b1f17b1804b1-43bd292e1cemr28484335e9.1.1741194578635;
        Wed, 05 Mar 2025 09:09:38 -0800 (PST)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b6ceesm21323862f8f.45.2025.03.05.09.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 09:09:38 -0800 (PST)
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	cgroups@vger.kernel.org,
	Jan Engelhardt <ej@inai.de>,
	Florian Westphal <fw@strlen.de>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH v2] netfilter: Make xt_cgroup independent from net_cls
Date: Wed,  5 Mar 2025 18:09:35 +0100
Message-ID: <20250305170935.80558-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The xt_group matching supports the default hierarchy since commit
c38c4597e4bf3 ("netfilter: implement xt_cgroup cgroup2 path match").
The cgroup v1 matching (based on clsid) and cgroup v2 matching (based on
path) are rather independent. Downgrade the Kconfig dependency to
mere CONFIG_SOCK_GROUP_DATA so that xt_group can be built even without
CONFIG_NET_CLS_CGROUP for path matching.
Also add a message for users when they attempt to specify any
non-trivial clsid.

Link: https://lists.opensuse.org/archives/list/kernel@lists.opensuse.org/thread/S23NOILB7MUIRHSKPBOQKJHVSK26GP6X/
Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 net/netfilter/Kconfig     |  2 +-
 net/netfilter/xt_cgroup.c | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

Changes from v1 (https://lore.kernel.org/r/20250228165216.339407-1-mkoutny@suse.com)
- terser guard (Jan)
- verboser message (Florian)
- better select !CGROUP_BPF (kernel test robot)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df2dc21304efb..346ac2152fa18 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1180,7 +1180,7 @@ config NETFILTER_XT_MATCH_CGROUP
 	tristate '"control group" match support'
 	depends on NETFILTER_ADVANCED
 	depends on CGROUPS
-	select CGROUP_NET_CLASSID
+	select SOCK_CGROUP_DATA
 	help
 	Socket/process control group matching allows you to match locally
 	generated packets based on which net_cls control group processes
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index c0f5e9a4f3c65..c3055e74aa0ea 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -23,6 +23,13 @@ MODULE_DESCRIPTION("Xtables: process control group matching");
 MODULE_ALIAS("ipt_cgroup");
 MODULE_ALIAS("ip6t_cgroup");
 
+#define NET_CLS_CLASSID_INVALID_MSG "xt_cgroup: classid invalid without net_cls cgroups\n"
+
+static bool possible_classid(u32 classid)
+{
+	return IS_ENABLED(CONFIG_CGROUP_NET_CLASSID) || classid == 0;
+}
+
 static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct xt_cgroup_info_v0 *info = par->matchinfo;
@@ -30,6 +37,11 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 	if (info->invert & ~1)
 		return -EINVAL;
 
+	if (!possible_classid(info->id)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -51,6 +63,11 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	if (!possible_classid(info->classid)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	info->priv = NULL;
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);
@@ -83,6 +100,11 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	if (info->has_classid && !possible_classid(info->classid)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	info->priv = NULL;
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);

base-commit: dd83757f6e686a2188997cb58b5975f744bb7786
-- 
2.48.1

