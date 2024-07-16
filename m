Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA3199E83
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132894; cv=none; b=dm7IGZ8stLTlNz9wKLofzC4SbcDZ7z2M1skPTOTASHckCKVttWwEtCYXlYhEL6IX+TA/k3KW68XxVUS/yKyNeP8aTZ0QeDMt4Ssmj/DG8R8Z6vOYS9QDXszMqAZZX1HrkkbVdJRtMtXAs7t5DIc1euJLHEN1umsJ35tOCgao2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132894; c=relaxed/simple;
	bh=Y8mFIXVmQ5ZHUtbnCEwP9KKOepaZukGjbjJHELHN2V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQJ+uUw5cjR+aIVoMFm+vkRbRtw/fqhxaiVDjkqtf2o/9eW8pDthKnYfQ6dIqRjEC0dx+KXyA3CRmmtdxnKqUGCAVkJUBI6y7ZMXy2jER/MB/hJEybb+ITkeNWUPyPpyjh3uxu4EBTR3eyD80EVEULRLwUlpCcSuANbHVm2OwLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NLNvXj2B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NLNvXj2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WZhbIJbFqqnuMyluYResKMnT+NalK7R9sGZZOeuy+GU=; b=NLNvXj2BlPtbASN6laeiNFZy0T
	ZbLel0LnU1T0l5C1V82O+TTc+JVu5ck1rewnVIuqiwR8J5mpF6VKnVD2dqjQGk8j0X4fhm45iOxYl
	Ri5sUwY99dbRZMsURNlDfnxXUhNjkbRnBzz4B9gHq+uA1S8ZM3ux0gq1jpDzLWmJazscTegTxQkN+
	Hk8z9e3placKp7i5mvsgEcImyYfQFf87MQHGVfivuOG3OPdw0NZD7h4fQwiQb+amEwtldZZE37khQ
	vUUAUTKk9T3mMeNEHzY6zBOSy6+Bz/HhUCQT0rpoB9AkAvB7B49cL+3Jj4DJYje426ZQkmkiwNbct
	6+nzHwYQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHu-000000007t8-160w;
	Tue, 16 Jul 2024 14:28:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 5/8] tests: shell: New xtables-monitor test
Date: Tue, 16 Jul 2024 14:28:02 +0200
Message-ID: <20240716122805.22331-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only events monitoring for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/nft-only/0012-xtables-monitor_0 | 149 ++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0

diff --git a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0 b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
new file mode 100755
index 0000000000000..7b028ba7a9ca5
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
@@ -0,0 +1,149 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+log=$(mktemp)
+trap "rm -f $log" EXIT
+echo "logging into file $log"
+rc=0
+
+# Filter monitor output:
+# - NEWGEN event is moot:
+#   - GENID/PID are arbitrary,
+#   - NAME always "xtables-nft-mul"
+# - handle is arbitrary as well
+logfilter() { # (logfile)
+	grep -v '^NEWGEN:' "$1" | sed -e 's/handle [0-9]\+/handle 0/'
+}
+
+# Compare monitor output for given command against content of the global $EXP
+monitorcheck() { # (cmd ...)
+	$XT_MULTI xtables-monitor -e >"$log"&
+	monpid=$!
+	sleep 0.5
+
+	$XT_MULTI "$@" || {
+		echo "Error: command failed: $@"
+		let "rc++"
+		kill $monpid
+		wait
+		return
+	}
+	sleep 0.5
+	kill $monpid
+	wait
+	diffout=$(diff -u <(echo "$EXP") <(logfilter "$log")) || {
+		echo "Fail: unexpected result for command: '$@':"
+		grep -v '^\(---\|+++\|@@\)' <<< "$diffout"
+		let "rc++"
+	}
+}
+
+EXP="\
+ EVENT: nft: NEW table: table filter ip flags 0 use 1 handle 0
+ EVENT: nft: NEW chain: ip filter FORWARD use 1 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1
+ EVENT: -4 -t filter -A FORWARD -j ACCEPT"
+monitorcheck iptables -A FORWARD -j ACCEPT
+
+EXP="\
+ EVENT: nft: NEW table: table filter ip6 flags 0 use 1 handle 0
+ EVENT: nft: NEW chain: ip6 filter FORWARD use 1 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1
+ EVENT: -6 -t filter -A FORWARD -j ACCEPT"
+monitorcheck ip6tables -A FORWARD -j ACCEPT
+
+# FIXME
+EXP="\
+ EVENT: nft: NEW table: table filter bridge flags 0 use 1 handle 0
+ EVENT: nft: NEW chain: bridge filter FORWARD use 1 type filter hook forward prio -200 policy accept packets 0 bytes 0 flags 1
+ EVENT: "
+monitorcheck ebtables -A FORWARD -j ACCEPT
+
+EXP="\
+ EVENT: nft: NEW table: table filter arp flags 0 use 1 handle 0
+ EVENT: nft: NEW chain: arp filter INPUT use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
+ EVENT: -0 -t filter -A INPUT -j ACCEPT"
+monitorcheck arptables -A INPUT -j ACCEPT
+
+EXP=" EVENT: -4 -t filter -N foo"
+monitorcheck iptables -N foo
+
+EXP=" EVENT: -6 -t filter -N foo"
+monitorcheck ip6tables -N foo
+
+# FIXME
+EXP="\
+ EVENT: nft: NEW chain: bridge filter foo use 1
+ EVENT: "
+monitorcheck ebtables -N foo
+
+EXP=" EVENT: -0 -t filter -N foo"
+monitorcheck arptables -N foo
+
+# meta l4proto matches require proper nft_handle:family value
+EXP=" EVENT: -4 -t filter -A FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
+monitorcheck iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
+
+EXP=" EVENT: -6 -t filter -A FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
+monitorcheck ip6tables -A FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
+
+# FIXME
+EXP=" EVENT: "
+monitorcheck ebtables -A FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
+
+EXP=" EVENT: -0 -t filter -A INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
+monitorcheck arptables -A INPUT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06 -j ACCEPT
+
+EXP=" EVENT: -4 -t filter -D FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
+monitorcheck iptables -D FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
+
+EXP=" EVENT: -6 -t filter -D FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
+monitorcheck ip6tables -D FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
+
+# FIXME
+EXP=" EVENT: "
+monitorcheck ebtables -D FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
+
+EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
+monitorcheck arptables -D INPUT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06 -j ACCEPT
+
+EXP=" EVENT: -4 -t filter -X foo"
+monitorcheck iptables -X foo
+
+EXP=" EVENT: -6 -t filter -X foo"
+monitorcheck ip6tables -X foo
+
+# FIXME
+EXP="\
+ EVENT: 
+ EVENT: nft: DEL chain: bridge filter foo use 0"
+monitorcheck ebtables -X foo
+
+EXP=" EVENT: -0 -t filter -X foo"
+monitorcheck arptables -X foo
+
+EXP=" EVENT: -4 -t filter -D FORWARD -j ACCEPT"
+monitorcheck iptables -F FORWARD
+
+EXP=" EVENT: -6 -t filter -D FORWARD -j ACCEPT"
+monitorcheck ip6tables -F FORWARD
+
+# FIXME
+EXP=" EVENT: "
+monitorcheck ebtables -F FORWARD
+
+EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT"
+monitorcheck arptables -F INPUT
+
+EXP=" EVENT: nft: DEL chain: ip filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1"
+monitorcheck iptables -X FORWARD
+
+EXP=" EVENT: nft: DEL chain: ip6 filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1"
+monitorcheck ip6tables -X FORWARD
+
+EXP=" EVENT: nft: DEL chain: bridge filter FORWARD use 0 type filter hook forward prio -200 policy accept packets 0 bytes 0 flags 1"
+monitorcheck ebtables -X FORWARD
+
+EXP=" EVENT: nft: DEL chain: arp filter INPUT use 0 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1"
+monitorcheck arptables -X INPUT
+
+exit $rc
-- 
2.43.0

