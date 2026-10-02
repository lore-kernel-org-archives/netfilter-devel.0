Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C89280CD5
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790945371; cv=none; b=n7MqQsxNmv3iDdTzbwN05usaNvP+2E1NKV/0ULp4sIsJNgIhk4glfS24rc1Nxs4Stsvw7BzXdCONeENOEw9mELkACvXIqdRLPzSomEJGVWiBaIQmZuIgEQGtcT5ztpMdO1ZY1NJdkjpY2FrEw6EiSeVmcZMUUjUq0ZfN8dt4EnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790945371; c=relaxed/simple;
	bh=Wm7NKBiLy6S58M6qF3zyy0+eo3Ht4yDiFhVGS9E00u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REgsfcAqCuONKVC5a6Gy+WE5bFMOll1E3Lb3APfVtXhPaHev8Y9dxhM7RVWn9OZhZx/7CrLnc/Ou9cpJZuJFh0aN0DtxpaaIfhp1Yob32TfsnF/dRbv5IjCzi8UrwZ6F88Cfw7D/FPaN3r06yDWxmw4TF1HODlaUQIutrFlSAkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gfO/F0p+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gfO/F0p+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yo3/Owbp//kN0GX3+OkKK0KD6mY1ZXO7C1q7UuSKvKE=; b=gfO/F0p+6xmDhgN+0ZJVW7B7KR
	qdAviqU7bkgbdbbuO6bOdoePE+vHsiXiKmyNmfCsA9ovOVe5RKSE7WVAB2l4pnlR3sfG/6lq8VXvo
	yl48Zg/azJA4XkFe+B7bJl69W4JSWB+ZTJtiqeu0Ub1AskXOcIc9yPS8l7RGqeqHdi0Yqd6ey22if
	9AtwVQyIaNJarmPRhzI0Iq7foLkcX5X2nwsBOh68mp9OBrcGCmb09RB4pdJMDtsATGfjZ4RD2fKWh
	7f7c5NSHj08Fj2sg3rgZ03Q0lYjGwxwa+fzucNynV517pmwaiY26kkIciLj/UHYhzlrazXg5HIMPr
	TdeMSTDw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xCchV-000000007i8-1Mdj;
	Fri, 02 Oct 2026 14:49:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Evgeniy Gorbanyov <esgor@altlinux.org>
Subject: [iptables PATCH 3/3] xshared: fix crash when -4/-6 follows a restore command
Date: Fri,  2 Oct 2026 14:49:16 +0200
Message-ID: <20261002124916.2264622-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002124916.2264622-1-phil@nwl.cc>
References: <20261002124916.2264622-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Evgeniy Gorbanyov <esgor@altlinux.org>

iptables-restore returns early on -6, and ip6tables-restore on -4, so
a rule for the other family is ignored. A command already parsed on
that line is still executed. replace_entry() then dereferences NULL
address pointers because post_parse() never ran.

Clear the command before returning so the line is dropped.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1864
Signed-off-by: Evgeniy Gorbanyov <esgor@altlinux.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../0019-family-flag-after-command_0          | 29 +++++++++++++++++++
 iptables/xshared.c                            |  8 +++--
 2 files changed, 35 insertions(+), 2 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0019-family-flag-after-command_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0019-family-flag-after-command_0 b/iptables/tests/shell/testcases/ipt-restore/0019-family-flag-after-command_0
new file mode 100755
index 0000000000000..4e1bed1e984fe
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0019-family-flag-after-command_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# -4/-6 during restore skips the whole line. If the flag appears after a
+# command has already been parsed, that command must be discarded.
+# Otherwise iptables-restore executes it without post_parse() and crashes
+# on NULL address pointers in replace_entry.
+
+set -e
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-A FORWARD -m comment --comment keep -j ACCEPT
+-R FORWARD 1 -6 -m comment --comment gone -j DROP
+-F FORWARD -6
+COMMIT
+EOF
+
+EXPECT='-A FORWARD -m comment --comment keep -j ACCEPT'
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables -S | grep -v '^-P')
+
+$XT_MULTI ip6tables-restore <<EOF
+*filter
+-A FORWARD -m comment --comment keep -j ACCEPT
+-R FORWARD 1 -4 -m comment --comment gone -j DROP
+-F FORWARD -4
+COMMIT
+EOF
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI ip6tables -S | grep -v '^-P')
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 263dcc32e5eb1..bb3da97be9fd3 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1903,8 +1903,10 @@ void do_parse(int argc, char *argv[],
 			if (args->family == AF_INET)
 				break;
 
-			if (p->restore && args->family == AF_INET6)
+			if (p->restore && args->family == AF_INET6) {
+				p->command = CMD_NONE;
 				return;
+			}
 
 			exit_tryhelp(2, p->line);
 
@@ -1912,8 +1914,10 @@ void do_parse(int argc, char *argv[],
 			if (args->family == AF_INET6)
 				break;
 
-			if (p->restore && args->family == AF_INET)
+			if (p->restore && args->family == AF_INET) {
+				p->command = CMD_NONE;
 				return;
+			}
 
 			exit_tryhelp(2, p->line);
 
-- 
2.54.0

