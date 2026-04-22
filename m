Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897E63D171D
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 13:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776863921; cv=none; b=EXwxqRtNftu5qcjkUecKp2EDMz7CiAvkuB3S0sP2ad0mWUTv8UDQmNICvJ6Vh/zghHtpzfa7K77TVtVZpRiTeHBW2+jreHcl/SP9s8SfazRbgeSWw1+PUEbTU5kVbIAUCzh144OQAHVdfNJKZHgUub3OsByapFhAcUTKHBYpXPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776863921; c=relaxed/simple;
	bh=S3w2SiBkuP+XZ0VGSoPCvw5mDdlWVPD5qe2D5ZB+nfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHadpqY/JvBr25Ykwyutg0NMb1CUBQOiwdYIDGA2Qz67q7GAAK4R2CiywdS2gZTXufpB+wZTJ4BeeBtYhxtkLzk7VORwhsI8WIivpvSNYfvjC7Dv/K3GrsK1A59j8KVdiajIUx4TUzXaeXXI+KioVAmMNkevGkp09cWzo8Xhxls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=szUHn4++; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szUHn4++"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59e4989dacdso5974007e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 06:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776863918; x=1777468718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmGAlvlxWs8/umIxWqRxtuHab2nnEuxDktgVlQFqEV8=;
        b=szUHn4++z3GJzi2Txn+Ldmc60J7pOo7qwtoQ3R0ONuAkYzldtNortZAa25H/X/TpMd
         kv78ulhMYU4k1go4ohy80HA6jluH+PwDyNd02warn8GJmJoxlLZNEdo0cvGpucy3zj39
         CWEtCiItlIHDNaw3NtounrE8fAEA+x5nD535hhuMyR7m1nvBWN5rMMWmPw7zOJdVWnJV
         9A47xlraGzS3LFQl/P5JrquJ9kN8lQvxb4tQ+bq+B7uuqzhtvERAWrm0fdU7cS7JJoBj
         b8J7JZhTn4KpeCYuYz2h8wmNkEBSNP5BVj48mq7igAMMgZpQftcxhmuCNbyezrgju+DX
         ajTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776863918; x=1777468718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vmGAlvlxWs8/umIxWqRxtuHab2nnEuxDktgVlQFqEV8=;
        b=qWi8MLrPDhEc9K+SEgk7iWlGTLN7taQaVMsrfUawU0iHaiLJlm4+2xYtc8Ds7XdXJJ
         k5YlfjezTWuXVuo/4Kp+zezkqLpua8aYHaileupf9JyIVmLJYXMO21skOtoEpaVTZQwE
         xfbeakWTgUhyf2bFQBSFs7fhrTfWkhLdnIU6VUXbshy5tGbSXgOYZZMbX9yBd5hmav8i
         1KbBI3W1LaSgU7WYFguIOZPmigcq+2wwykc1wv8ffIpAykLw7IRY7LBNvuMWUFnAQX99
         bhXCo2+jwgfmrZQdCRhIQBxfrAGzgntnMneyy/GdZ9Fr8iJNFYg+2gAg+f46sJs8FuYF
         73Pg==
X-Gm-Message-State: AOJu0Yz8OIMyYNAJo1RHXDzXq0pIQAl58NfHW75F9zZLxIWNNMRaryZu
	yLwheIn8TShOI+hpAWW56DDscBd/7MQXJ9tfIxC9phHm5uSiqGmvDfRfNMJpC7N1rpluSBIwC9c
	=
X-Gm-Gg: AeBDieuiMoT6VDdD4Y/JBF/TYTZY+BzVN1TEBZWaCt6hZwu+UITxzpncqdAJ/thJXFy
	NxZv1oS1VxCOhTJzG1kq0EpIVypLPWs8zBTf88HTyQ+ul3xnTeq1OcNLVZUmuJPh1rA2t+5Jo8j
	NBHdctvtmA827Zl/VNDH/92TGAYbINXVu4o5nzRbaPGCgamwdifvf7fCtVfoY9FA7WCtWR4864R
	LHUnb+68bO84rtgAEew01Dr2wEtipx8ISqZk9AbVz3MkUpAyBz4bUHi7IW/6hH8lNcFCFBx0Xor
	PA3rV64MLBRhH2kleWAYjr7UjL/chaY9Ly3jedj7IqdK9XUYvDk10j7kW9cHmZNdmFSoXu8aqzT
	Qshm0kDj9Did5Z+yXIf8QJIY1l/tCG/XIbWZMNILd4KsxawDGJr7oEhhcppfTuq5jJlylEOF0au
	MuwqNuh49BYCUNS+9cMC/cs6Sg357rlbWbJvPWyNcl5IThJ4FDYShT07YIXIPvgjeR6os141I=
X-Received: by 2002:a05:6512:2248:b0:5a4:992:e8b2 with SMTP id 2adb3069b0e04-5a4172e1c8bmr8319129e87.21.1776863917376;
        Wed, 22 Apr 2026 06:18:37 -0700 (PDT)
Received: from va-HP-Pavilion-Desktop-595-p0xxx.mshome.net ([193.0.150.248])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a418376d0asm4447656e87.0.2026.04.22.06.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 06:18:37 -0700 (PDT)
From: Vastargazing <vebohr@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	Vastargazing <vebohr@gmail.com>
Subject: [PATCH 1/1] selftests: netfilter: add nft_ct timeout destroy race test
Date: Wed, 22 Apr 2026 16:18:18 +0300
Message-ID: <20260422131818.106417-2-vebohr@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422131818.106417-1-vebohr@gmail.com>
References: <20260422131818.106417-1-vebohr@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a netfilter kselftest for the nft_ct timeout object destroy race
fixed by commit f8dca15a1b19 ("netfilter: nft_ct: fix use-after-free in
timeout object destroy").

Keep creating new TCP connections from one namespace while repeatedly
flushing and recreating the table that owns a ct timeout object. This
exercises concurrent packet processing against the timeout object
teardown path without requiring external traffic tools beyond bash,
nft and ip.

On a KASAN kernel, a regression in the RCU lifetime handling should
show up as a slab-use-after-free report in nf_conntrack_tcp_packet().

Assisted-by: GitHub Copilot:claude-sonnet-4-6
Signed-off-by: Vastargazing <vebohr@gmail.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../netfilter/nft_ct_timeout_concurrency.sh   | 116 ++++++++++++++++++
 2 files changed, 117 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/nft_ct_timeout_concurrency.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ee2d1a5254f8..bcf53a1ef7ec 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -25,6 +25,7 @@ TEST_PROGS := \
 	nft_audit.sh \
 	nft_concat_range.sh \
 	nft_conntrack_helper.sh \
+	nft_ct_timeout_concurrency.sh \
 	nft_fib.sh \
 	nft_flowtable.sh \
 	nft_interface_stress.sh \
diff --git a/tools/testing/selftests/net/netfilter/nft_ct_timeout_concurrency.sh b/tools/testing/selftests/net/netfilter/nft_ct_timeout_concurrency.sh
new file mode 100644
index 000000000000..79876cdfb2df
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_ct_timeout_concurrency.sh
@@ -0,0 +1,116 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Stress nftables ct timeout object destruction while new TCP flows keep
+# attaching the object.
+
+net_netfilter_dir=$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")
+source "$net_netfilter_dir/lib.sh"
+
+checktool "nft --version" "run test without nft tool"
+
+read kernel_tainted < /proc/sys/kernel/tainted
+
+# Default to 80% of the global timeout but keep this stress test short.
+TEST_RUNTIME=$((${kselftest_timeout:-30} * 8 / 10))
+[[ $TEST_RUNTIME -gt 20 ]] && TEST_RUNTIME=20
+
+PORT=12345
+
+cleanup()
+{
+	cleanup_all_ns
+}
+
+load_ruleset()
+{
+	ip netns exec "$ns1" nft -f - <<EOF
+table ip ct_test {
+	ct timeout tcptime {
+		protocol tcp
+		policy = { established: 5s }
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+		ct state new ip daddr 10.0.1.2 tcp dport $PORT counter ct timeout set "tcptime"
+	}
+}
+EOF
+}
+
+flush_table()
+{
+	ip netns exec "$ns1" nft flush table ip ct_test 2>/dev/null || true
+	ip netns exec "$ns1" nft delete table ip ct_test 2>/dev/null || true
+}
+
+rule_packets()
+{
+	local packets
+
+	packets=$(ip netns exec "$ns1" nft list chain ip ct_test output 2>/dev/null |
+		sed -n 's/.*counter packets \([0-9][0-9]*\) bytes.*/\1/p' |
+		head -n1)
+
+	if [ -n "$packets" ]; then
+		echo "$packets"
+	else
+		echo 0
+	fi
+}
+
+trap cleanup EXIT
+
+setup_ns ns1 ns2 || exit $ksft_skip
+
+if ! ip link add veth0 netns "$ns1" type veth peer name veth0 netns "$ns2" > /dev/null 2>&1; then
+	echo "SKIP: No virtual ethernet pair device support in kernel"
+	exit $ksft_skip
+fi
+
+ip -net "$ns1" link set veth0 up
+ip -net "$ns2" link set veth0 up
+
+ip -net "$ns1" addr add 10.0.1.1/24 dev veth0
+ip -net "$ns2" addr add 10.0.1.2/24 dev veth0
+
+if ! load_ruleset; then
+	echo "SKIP: Could not load ct timeout ruleset"
+	exit $ksft_skip
+fi
+
+ip netns exec "$ns1" bash -c '
+	while :; do
+		exec 3<>/dev/tcp/10.0.1.2/'"$PORT"' 2>/dev/null || true
+		exec 3<&- 3>&-
+	done
+' > /dev/null 2>&1 &
+traffic_pid=$!
+
+if ! busywait_for_counter "$BUSYWAIT_TIMEOUT" 1 rule_packets > /dev/null; then
+	echo "FAIL: Did not observe TCP traffic hitting ct timeout rule"
+	exit $ksft_fail
+fi
+
+end_time=$((SECONDS + TEST_RUNTIME))
+while [ "$SECONDS" -lt "$end_time" ]; do
+	flush_table
+
+	if ! load_ruleset; then
+		echo "FAIL: Could not recreate ct timeout ruleset"
+		exit $ksft_fail
+	fi
+done
+
+flush_table
+
+kill "$traffic_pid" 2>/dev/null
+wait "$traffic_pid" 2>/dev/null
+
+if [[ $kernel_tainted -eq 0 && $(</proc/sys/kernel/tainted) -ne 0 ]]; then
+	echo "FAIL: Kernel is tainted"
+	exit $ksft_fail
+fi
+
+exit $ksft_pass
-- 
2.51.0

