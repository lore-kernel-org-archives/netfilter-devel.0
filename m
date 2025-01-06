Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD69524B0
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2025 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203321; cv=none; b=aweKBrHqfqNgZ/GiC8vtZxZ//4uL/0oc7GFSg8Vhyjj+d4AgBlrpNAVY64WVjQogw4X83+atP6amPhYwAq/Bgygxl9toCF+MnAJVbUWCumdhDyAN9D671HyWs9Pk+dB+qicwpapZW0Bx6fBusapodY6HikeQSvcjSC09bBQW5TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203321; c=relaxed/simple;
	bh=CySgq5XWW1Sfk/E//TMf97URmygAfwlsz5lZd0p3GWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e+kcfFmN9G5bbNAz1xNTk0Gv9JUysDNq7F7hgV1f6a3Z7n/PTqo6Zl0iYKxcrrl+Ex/k6l0P9D49LSjizICOH2cwcj6Gft2zBJ8482XaRef2dXXZE5lM3/eNawzHNzlt6BXTG7WRiKtm03TMiqogG1QhHz0x+CVavznmYyoxNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft 2/2] tests: shell: random interval set with size
Date: Mon,  6 Jan 2025 23:41:52 +0100
Message-Id: <20250106224152.202624-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250106224152.202624-1-pablo@netfilter.org>
References: <20250106224152.202624-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generate a random set with intervals to validate set size, try one that
should fit and then subtract one to set size and retry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/sets/interval_size_random | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)
 create mode 100755 tests/shell/testcases/sets/interval_size_random

diff --git a/tests/shell/testcases/sets/interval_size_random b/tests/shell/testcases/sets/interval_size_random
new file mode 100755
index 000000000000..52014ebb1a79
--- /dev/null
+++ b/tests/shell/testcases/sets/interval_size_random
@@ -0,0 +1,113 @@
+#!/bin/bash
+
+generate_ip() {
+    local first=($1)
+    echo -n "$first.$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
+}
+
+ip_to_int() {
+    local IFS='.'
+    local ip=($1)
+    printf '%d' "$((${ip[0]}<<24 | ${ip[1]}<<16 | ${ip[2]}<<8 | ${ip[3]}))"
+}
+
+compare_ips() {
+    local ip1=$(ip_to_int $1)
+    local ip2=$(ip_to_int $2)
+    if [ "$ip1" -lt "$ip2" ]; then
+        echo "$1"
+    elif [ "$ip1" -gt "$ip2" ]; then
+        echo "$2"
+    else
+        echo "$1"
+    fi
+}
+
+generate_range() {
+    start=$(generate_ip $1)
+    end=$(generate_ip $1)
+    result=$(compare_ips $start $end)
+    if [[ "$result" != "$start" ]]
+    then
+        temp=$start
+        start=$end
+        end=$temp
+    fi
+    echo -n "$start-$end"
+}
+
+generate_prefix() {
+    prefix=$(generate_ip $1 | cut -d. -f1-3)
+    echo -n "$prefix.0/24"
+}
+
+generate_intervals() {
+echo "define x = {"
+    # not so random, first octet in IP address is $i, this cannot go over 255
+    iter=$((RANDOM % 255 + 1))
+
+    [ $(($RANDOM % 2)) -eq 0 ] && echo "0.0.0.0,"
+
+    for ((i=0; i<iter; i++)); do
+        case $((RANDOM % 3)) in
+            0) generate_ip $i;;
+            1) generate_range $i;;
+            2) generate_prefix $i;;
+        esac
+	echo ","
+    done
+
+    [ $(($RANDOM % 2)) -eq 0 ] && echo "255.255.255.255,"
+
+echo "}"
+}
+
+run_test() {
+    local count=($1)
+    local elems=($2)
+    local ruleset=($3)
+    echo "table inet x {
+	set y {
+		include \"$elems\"
+		typeof ip saddr
+		flags interval
+		size $count
+		elements = { \$x }
+	}
+      }" > $ruleset
+}
+
+count_elems() {
+    local elems=($2)
+    count=$(wc -l $elems_file | cut -f1 -d' ')
+    # subtract enclosing define lines
+    count=$(($count-2))
+    echo $count
+}
+
+elems_file=$(mktemp /tmp/elems-XXXXX.nft)
+ruleset_file=$(mktemp /tmp/ruleset-XXXXX.nft)
+
+if [ ! -w "$elems_file" ] ; then
+    # cwd might be readonly, mark as skip.
+    echo "Failed to create tmp file" >&2
+    exit 77
+fi
+
+trap "rm -rf $elems_file $ruleset_file" EXIT
+
+generate_intervals > $elems_file
+count=$(count_elems $elems_file)
+
+run_test $count $elems_file $ruleset_file
+$NFT -f $ruleset_file || exit 1
+
+$NFT flush ruleset
+
+# subtract 1 to size, too small, it should fail
+count=$(($count-1))
+
+run_test $count $elems_file $ruleset_file
+$NFT -f $ruleset_file && exit 1
+
+exit 0
-- 
2.30.2

