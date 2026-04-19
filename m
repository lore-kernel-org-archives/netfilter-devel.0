Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3DB37BE87
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776605893; cv=none; b=qwtOxA9arGNOzY77OUNLI9axwsRZzIBjAkxehBrjABlDJChsVosmdAW12oZFge37VTIhu9G8wf4O3ibcu5Pk+sZoB6lrymjjIqh0L0DfiNlkjf/6bsHQCtCde6FDS5VloA78AJJXAMd4tvqg9dShcRQRe/4QGUMQ2X+waQ48OHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776605893; c=relaxed/simple;
	bh=RBsrRCkgzv3ZIjXHHOPbj8oY3UIhHlnafgODE+J/thk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TKCPBtPBObGDftGKOywcpq2zjd6Uq9lzqtO9UHcuvS2yL8L1Aupu2LXB42Xf8l5arfGygGsDJ4HJPVVmfVl8Gg8Soc4PLA/sIZT9dlfhSEAD48lCc21C6l4Z0UaeOtTAJfOmokg4caiI/agX7qtM+iOABpi+B/WpbGT/VOIaiSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6930060681; Sun, 19 Apr 2026 15:38:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] tests: shell: add test case for checkentry hook validations
Date: Sun, 19 Apr 2026 15:37:47 +0200
Message-ID: <20260419133803.46227-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few matches/targets reject based on the calling hook mask
from their checkentry functions.  Some are cosmetic (reject
nonsensical rule that would not work, but others are mandatory
rejects, in particular TCPMSS which may need skb_dst()
depending on the requested mode of operation.

For -legacy this yields:
xt_TCPMSS: path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks
xt_addrtype: output interface limitation not valid in PREROUTING and INPUT
xt_addrtype: input interface limitation not valid in POSTROUTING and OUTPUT
xt_physdev: --physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic
xt_physdev: --physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic
xt_policy: input policy not valid in POSTROUTING and OUTPUT
xt_policy: output policy not valid in PREROUTING and INPUT

... in dmesg.  -j SET is currently missing, could be added
later (needs an existing ipset).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../iptables/0012-bad-matches-and-targets_0   | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/iptables/0012-bad-matches-and-targets_0

diff --git a/iptables/tests/shell/testcases/iptables/0012-bad-matches-and-targets_0 b/iptables/tests/shell/testcases/iptables/0012-bad-matches-and-targets_0
new file mode 100755
index 000000000000..08a1411ecddc
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0012-bad-matches-and-targets_0
@@ -0,0 +1,102 @@
+#!/bin/sh
+
+set -x
+
+die() {
+
+	echo "$1: $2 was accepted"
+	$XT_MULTI "$flavor-save"
+	exit 1
+}
+
+die_err() {
+	echo "$1: $2 should work"
+	$XT_MULTI "$flavor-save"
+	exit 1
+}
+
+do_link() {
+	local flavor="$1"
+	local chain="$2"
+
+	$XT_MULTI "$flavor" -t mangle -A "$chain" -j USERCHAIN && die "$flavor" "PREROUTING -j USERCHAIN"
+
+	$XT_MULTI "$flavor" -t mangle -F USERCHAIN || die_err "$flavor" "flush USERCHAIN"
+}
+
+do_link_prerouting() {
+	do_link "$1" "PREROUTING"
+}
+
+do_link_output() {
+	do_link "$1" "OUTPUT"
+}
+
+check_TCPMSS() {
+	local flavor="$1"
+
+	$XT_MULTI "$flavor" -t mangle -A PREROUTING -p tcp --syn -j TCPMSS --clamp-mss-to-pmtu && die "$flavor" "TCPMSS in PREROUTING"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -p tcp --syn -j TCPMSS --clamp-mss-to-pmtu || die_err "$flavor" "TCPMSS in USERCHAIN"
+	do_link_prerouting "$flavor"
+}
+
+check_addrtype() {
+	local flavor="$1"
+
+	$XT_MULTI "$flavor" -t mangle -A PREROUTING -m addrtype --limit-iface-out --src-type UNICAST && die "$flavor" "addrtype iface-out in PREROUTING"
+
+	$XT_MULTI "$flavor" -t mangle -A OUTPUT -m addrtype --limit-iface-in  --src-type UNICAST && die "$flavor" "addrtype in iface-in OUTPUT"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m addrtype --limit-iface-out --src-type UNICAST || die_err "$flavor" "addrtype iface-out in USERCHAIN"
+	do_link_prerouting "$flavor"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m addrtype --limit-iface-in  --src-type UNICAST || die_err "$flavor" "addrtype iface-in in USERCHAIN"
+	do_link_output "$flavor"
+}
+
+check_devgroup() {
+	local flavor="$1"
+
+	$XT_MULTI "$flavor" -t mangle -A PREROUTING -m devgroup --dst-group 1 && die "$flavor" "dst-group in PREROUTING"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m devgroup --dst-group 1 || die_err  "$flavor" "dst-group in USERCHAIN"
+	do_link_prerouting "$flavor"
+
+	$XT_MULTI "$flavor" -t mangle -A OUTPUT -m devgroup --src-group 1 && die "$flavor" "src-group in PREROUTING"
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m devgroup --src-group 1 || die_err "$flavor" "src-group in USERCHAIN"
+	do_link_output "$flavor"
+}
+
+check_physdev() {
+	local flavor="$1"
+
+	$XT_MULTI "$flavor" -t mangle -A OUTPUT -m physdev --physdev-out "foo" && die "$flavor" "physdev-out in OUTPUT"
+	$XT_MULTI "$flavor" -t mangle -A OUTPUT -m physdev --physdev-out "foo" --physdev-is-out && die "$flavor" "physdev-out in OUTPUT"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m physdev --physdev-out "foo" || die_err "$flavor" "physdev-out in USERCHAIN"
+	do_link_output "$flavor"
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m physdev --physdev-out "foo" --physdev-is-out || die_err "$flavor" "physdev-out in USERCHAIN"
+	do_link_output "$flavor"
+}
+
+check_policy() {
+	local flavor="$1"
+
+	$XT_MULTI "$flavor" -t mangle -A OUTPUT -m policy --dir in --pol none && die "$flavor" "policy dir in OUTPUT"
+	$XT_MULTI "$flavor" -t mangle -A PREROUTING -m policy --dir out --pol none && die "$flavor" "policy dir out PREROUTING"
+
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m policy --dir in --pol none || die_err "$flavor" "policy dir in USERCHAIN"
+	do_link_output "$flavor"
+	$XT_MULTI "$flavor" -t mangle -A USERCHAIN -m policy --dir out --pol none || die_err "$flavor" "policy dir out USERCHAIN"
+	do_link_prerouting "$flavor"
+}
+
+for f in "iptables" "ip6tables";do
+	$XT_MULTI "$f" -t mangle -N USERCHAIN || die_err "$f" "cannot create USERCHAIN"
+	check_TCPMSS "$f"
+	check_addrtype "$f"
+	check_devgroup "$f"
+	check_physdev "$f"
+	check_policy "$f"
+done
-- 
2.53.0

