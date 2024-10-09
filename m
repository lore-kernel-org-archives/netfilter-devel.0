Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2AD10E4
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728494871; cv=none; b=n02D1ZsF2I/uvqDA1iSxg94We/jEwGVGKnysKIdfM1Tu0THi4xB7PINCIDx2prV+MW04bgT9MEVOaio1FmLdNLKEtoAGP15vf/LfJVAJfLv+Nhv8acIYpX3COHAMwWrol2i8BRGCejSNip1DA/PSSRFBvECoNILlaWKFfjsQmGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728494871; c=relaxed/simple;
	bh=9P9DlbwFDifS6udPToAyh+LRcGIn/N2XPdQ+aqq+O2g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5H20JR7G/mqXV20O+nHIw5iIRLmpo7XUHewtKoTht1pTCJ8cb6pNvvE2vR/8D6dC7zabShWhy3B3TJUzuchukQoOpMfvaxp6KumbsXHt4sqDZhSOh6BJd7jPBK8+9TS0IEahGyo0ovc3OksAxPiB9f6vPk6zsGNUhXzEw9nCMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VUryLBEO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VUryLBEO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hd4CUxQHg6GU0W/YqsYn8dAS3fg5bJcnRxwRfU0rfVc=; b=VUryLBEOs/wango6SddkhPfVhS
	poezgZB4dGDK//Ed9lE1D53R2dNMsfuVfss+qglRqdjKr36tMO8sl3yoQLfgRV5W0WyQFCCX/DgGU
	lrCEXtmpjKMJrIndxKS1HT5ELJPXwU0OwPoQnIxeW3+C7bWfauFjwvFVEzeqW38ZSdF5BrIxWqQqW
	/IjAJiAbkvpBb+gisV1hgrXEmIUSjI4DfSCCSAeAf4cLoz7NxCr45v4IWizrVflXCArBL/vPfCFYe
	DqbVpYZZpC+8sgED/aVVjHTIwraqLqgkIcv0BKIU6h8n24mO2JpdNRJlMwbWWYNjwdG5vObV3/XaF
	+R9P41LA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syaTQ-000000007Ck-2rfn
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 19:27:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] tests: shell: Test some commands involving rule numbers
Date: Wed,  9 Oct 2024 19:27:40 +0200
Message-ID: <20241009172740.2369-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009172740.2369-1-phil@nwl.cc>
References: <20241009172740.2369-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip on ip6tables and arptables as they share the relevant code with
iptables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ebtables/0011-rulenum_0   | 104 ++++++++++++++++++
 .../shell/testcases/iptables/0011-rulenum_0   |  93 ++++++++++++++++
 2 files changed, 197 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0011-rulenum_0
 create mode 100755 iptables/tests/shell/testcases/iptables/0011-rulenum_0

diff --git a/iptables/tests/shell/testcases/ebtables/0011-rulenum_0 b/iptables/tests/shell/testcases/ebtables/0011-rulenum_0
new file mode 100755
index 0000000000000..51302f347baf4
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0011-rulenum_0
@@ -0,0 +1,104 @@
+#!/bin/bash -x
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+set -e
+
+load_ruleset() {
+	$XT_MULTI ebtables-restore <<EOF
+*filter
+-A FORWARD --mark 0x1 -c 1 2
+-A FORWARD --mark 0x2 -c 2 3
+EOF
+}
+
+load_ruleset
+
+$XT_MULTI ebtables -L 0 && exit 1
+
+EXPECT='--mark 0x1 -j CONTINUE , pcnt = 1 -- bcnt = 2'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI ebtables -L FORWARD 1 --Lc)
+
+EXPECT='--mark 0x2 -j CONTINUE , pcnt = 2 -- bcnt = 3'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -L FORWARD 2 --Lc)
+
+[[ -z $($XT_MULTI ebtables -L FORWARD 3) ]]
+
+$XT_MULTI ebtables -S FORWARD 0 && exit 1
+
+EXPECT='[1:2] -A FORWARD --mark 0x1 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S FORWARD 1)
+
+EXPECT='[2:3] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S FORWARD 2)
+
+[[ -z $($XT_MULTI ebtables -S FORWARD 3) ]]
+
+$XT_MULTI ebtables -v -Z FORWARD 0 && exit 1
+
+[[ -z $($XT_MULTI ebtables -v -Z FORWARD 1) ]]
+EXPECT='[0:0] -A FORWARD --mark 0x1 -j CONTINUE
+[2:3] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+[[ -z $($XT_MULTI ebtables -v -Z FORWARD 2) ]]
+EXPECT='[0:0] -A FORWARD --mark 0x1 -j CONTINUE
+[0:0] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+$XT_MULTI ebtables -v -Z FORWARD 3 && exit 1
+
+load_ruleset
+
+[[ -z $($XT_MULTI ebtables -v -L -Z FORWARD 1) ]]
+EXPECT='[0:0] -A FORWARD --mark 0x1 -j CONTINUE
+[2:3] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+[[ -z $($XT_MULTI ebtables -v -L -Z FORWARD 2) ]]
+EXPECT='[0:0] -A FORWARD --mark 0x1 -j CONTINUE
+[0:0] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+load_ruleset
+
+$XT_MULTI ebtables -v -Z -L FORWARD 0 && exit 1
+
+EXPECT='--mark 0x1 -j CONTINUE
+Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -Z -L FORWARD 1)
+EXPECT='[0:0] -A FORWARD --mark 0x1 -j CONTINUE
+[0:0] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+EXPECT='--mark 0x2 -j CONTINUE
+Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -Z -L FORWARD 2)
+
+$XT_MULTI ebtables -v -Z -L FORWARD 0 && exit 1
+
+EXPECT='Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -Z -L FORWARD 3)
+
+load_ruleset
+
+[[ -z $($XT_MULTI ebtables -v -D FORWARD 1) ]]
+EXPECT='[2:3] -A FORWARD --mark 0x2 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+load_ruleset
+
+[[ -z $($XT_MULTI ebtables -v -D FORWARD 2) ]]
+EXPECT='[1:2] -A FORWARD --mark 0x1 -j CONTINUE'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -v -S | grep -v '^-P')
+
+$XT_MULTI ebtables -v -D FORWARD 3 && exit 1
+
+exit 0
diff --git a/iptables/tests/shell/testcases/iptables/0011-rulenum_0 b/iptables/tests/shell/testcases/iptables/0011-rulenum_0
new file mode 100755
index 0000000000000..4f973cdc6f378
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0011-rulenum_0
@@ -0,0 +1,93 @@
+#!/bin/bash -x
+
+set -e
+
+load_ruleset() {
+	$XT_MULTI iptables-restore <<EOF
+*filter
+-A FORWARD -m mark --mark 0x1 -c 1 2
+-A FORWARD -m mark --mark 0x2 -c 2 3
+COMMIT
+EOF
+}
+
+load_ruleset
+
+$XT_MULTI iptables -L 0 && exit 1
+
+EXPECT=' 1 2 all -- any any anywhere anywhere mark match 0x1'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI iptables -v -L FORWARD 1)
+
+EXPECT=' 2 3 all -- any any anywhere anywhere mark match 0x2'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI iptables -v -L FORWARD 2)
+
+[[ -z $($XT_MULTI iptables -L FORWARD 3) ]]
+
+$XT_MULTI iptables -S FORWARD 0 && exit 1
+
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 1 2'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S FORWARD 1)
+
+EXPECT='-A FORWARD -m mark --mark 0x2 -c 2 3'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S FORWARD 2)
+
+[[ -z $($XT_MULTI iptables -S FORWARD 3) ]]
+
+$XT_MULTI iptables -v -Z FORWARD 0 && exit 1
+
+[[ -z $($XT_MULTI iptables -v -Z FORWARD 1) ]]
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 0 0
+-A FORWARD -m mark --mark 0x2 -c 2 3'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+[[ -z $($XT_MULTI iptables -v -Z FORWARD 2) ]]
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 0 0
+-A FORWARD -m mark --mark 0x2 -c 0 0'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+$XT_MULTI iptables -v -Z FORWARD 3 && exit 1
+
+load_ruleset
+
+[[ -z $($XT_MULTI iptables -v -L -Z FORWARD 1) ]]
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 0 0
+-A FORWARD -m mark --mark 0x2 -c 2 3'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+[[ -z $($XT_MULTI iptables -v -L -Z FORWARD 2) ]]
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 0 0
+-A FORWARD -m mark --mark 0x2 -c 0 0'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+load_ruleset
+
+$XT_MULTI iptables -v -Z -L FORWARD 0 && exit 1
+
+EXPECT=' 1 2 all -- any any anywhere anywhere mark match 0x1
+Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI iptables -v -Z -L FORWARD 1)
+
+EXPECT=' 0 0 all -- any any anywhere anywhere mark match 0x2
+Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI iptables -v -Z -L FORWARD 2)
+
+$XT_MULTI iptables -v -Z -L FORWARD 0 && exit 1
+
+EXPECT='Zeroing chain `FORWARD'\'
+diff -u -b <(echo -e "$EXPECT") <($XT_MULTI iptables -v -Z -L FORWARD 3)
+
+load_ruleset
+
+[[ -z $($XT_MULTI iptables -v -D FORWARD 1) ]]
+EXPECT='-A FORWARD -m mark --mark 0x2 -c 2 3'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+load_ruleset
+
+[[ -z $($XT_MULTI iptables -v -D FORWARD 2) ]]
+EXPECT='-A FORWARD -m mark --mark 0x1 -c 1 2'
+diff -u <(echo -e "$EXPECT") <($XT_MULTI iptables -v -S | grep -v '^-P')
+
+$XT_MULTI iptables -v -D FORWARD 3 && exit 1
+
+exit 0
-- 
2.43.0

