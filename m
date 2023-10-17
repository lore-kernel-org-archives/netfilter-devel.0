Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D1ECDB483
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 09:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbjJQJjT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 05:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjJQJjR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 05:39:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46B011A;
        Tue, 17 Oct 2023 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ML44Fb1WqO6BSc+1qTVe1pdjfiswW3uaeburkbZxk40=; b=Mmrwmd8NlEjCUMcRI0L5WUIEfU
        JkwXrz6h+WCxfjMtH+IGoV4MY+2KYbFn788M68NUHZmgFHM+T1Rm6i5tXFliWtvoL9FpWzs32RuCD
        cnX5A/Mk/1Ii3xn+GQ2j4eQxdyefliPrPcpxad1hoaUEC/qaKa71eWJveYPLBmpH3XmfcJXwySHK+
        rs/xhBPNW4//gUMGOId+uzR+0PkDrKiPorhxs/P/ZI41S7yV9AsiFpQ739Fhc3QZbpPRQ6yuK3D0c
        EflrPfP4aCgN2Y56ZiWH3+JInfJJ+eawbFoScEwzNg5IwfQk5ai6HcCmZ8/vJdMMyJHT/Udff+s5E
        JQZyxyug==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qsgXe-0008Jt-EM; Tue, 17 Oct 2023 11:39:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [net-next PATCH v2] net: skb_find_text: Ignore patterns extending past 'to'
Date:   Tue, 17 Oct 2023 11:39:06 +0200
Message-ID: <20231017093906.26310-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assume that caller's 'to' offset really represents an upper boundary for
the pattern search, so patterns extending past this offset are to be
rejected.

The old behaviour also was kind of inconsistent when it comes to
fragmentation (or otherwise non-linear skbs): If the pattern started in
between 'to' and 'from' offsets but extended to the next fragment, it
was not found if 'to' offset was still within the current fragment.

Test the new behaviour in a kselftest using iptables' string match.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: f72b948dcbb8 ("[NET]: skb_find_text ignores to argument")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Hook test into respective Makefile
- Reduce checkpatch.pl output by "fixing" Fixes: tag ref to 12 chars of
  hash from 13
---
 net/core/skbuff.c                             |   3 +-
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../testing/selftests/netfilter/xt_string.sh  | 128 ++++++++++++++++++
 3 files changed, 131 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/xt_string.sh

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0401f40973a5..975c9a6ffb4a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4267,6 +4267,7 @@ static void skb_ts_finish(struct ts_config *conf, struct ts_state *state)
 unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
 			   unsigned int to, struct ts_config *config)
 {
+	unsigned int patlen = config->ops->get_pattern_len(config);
 	struct ts_state state;
 	unsigned int ret;
 
@@ -4278,7 +4279,7 @@ unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
 	skb_prepare_seq_read(skb, from, to, TS_SKB_CB(&state));
 
 	ret = textsearch_find(config, &state);
-	return (ret <= to - from ? ret : UINT_MAX);
+	return (ret + patlen <= to - from ? ret : UINT_MAX);
 }
 EXPORT_SYMBOL(skb_find_text);
 
diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index ef90aca4cc96..bced422b78f7 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -7,7 +7,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
 	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
 	conntrack_vrf.sh nft_synproxy.sh rpath.sh nft_audit.sh \
-	conntrack_sctp_collision.sh
+	conntrack_sctp_collision.sh xt_string.sh
 
 HOSTPKG_CONFIG := pkg-config
 
diff --git a/tools/testing/selftests/netfilter/xt_string.sh b/tools/testing/selftests/netfilter/xt_string.sh
new file mode 100755
index 000000000000..1802653a4728
--- /dev/null
+++ b/tools/testing/selftests/netfilter/xt_string.sh
@@ -0,0 +1,128 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# return code to signal skipped test
+ksft_skip=4
+rc=0
+
+if ! iptables --version >/dev/null 2>&1; then
+	echo "SKIP: Test needs iptables"
+	exit $ksft_skip
+fi
+if ! ip -V >/dev/null 2>&1; then
+	echo "SKIP: Test needs iproute2"
+	exit $ksft_skip
+fi
+if ! nc -h >/dev/null 2>&1; then
+	echo "SKIP: Test needs netcat"
+	exit $ksft_skip
+fi
+
+pattern="foo bar baz"
+patlen=11
+hdrlen=$((20 + 8)) # IPv4 + UDP
+ns="ns-$(mktemp -u XXXXXXXX)"
+trap 'ip netns del $ns' EXIT
+ip netns add "$ns"
+ip -net "$ns" link add d0 type dummy
+ip -net "$ns" link set d0 up
+ip -net "$ns" addr add 10.1.2.1/24 dev d0
+
+#ip netns exec "$ns" tcpdump -npXi d0 &
+#tcpdump_pid=$!
+#trap 'kill $tcpdump_pid; ip netns del $ns' EXIT
+
+add_rule() { # (alg, from, to)
+	ip netns exec "$ns" \
+		iptables -A OUTPUT -o d0 -m string \
+			--string "$pattern" --algo $1 --from $2 --to $3
+}
+showrules() { # ()
+	ip netns exec "$ns" iptables -v -S OUTPUT | grep '^-A'
+}
+zerorules() {
+	ip netns exec "$ns" iptables -Z OUTPUT
+}
+countrule() { # (pattern)
+	showrules | grep -c -- "$*"
+}
+send() { # (offset)
+	( for ((i = 0; i < $1 - $hdrlen; i++)); do
+		printf " "
+	  done
+	  printf "$pattern"
+	) | ip netns exec "$ns" nc -w 1 -u 10.1.2.2 27374
+}
+
+add_rule bm 1000 1500
+add_rule bm 1400 1600
+add_rule kmp 1000 1500
+add_rule kmp 1400 1600
+
+zerorules
+send 0
+send $((1000 - $patlen))
+if [ $(countrule -c 0 0) -ne 4 ]; then
+	echo "FAIL: rules match data before --from"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send 1000
+send $((1400 - $patlen))
+if [ $(countrule -c 2) -ne 2 ]; then
+	echo "FAIL: only two rules should match at low offset"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send $((1500 - $patlen))
+if [ $(countrule -c 1) -ne 4 ]; then
+	echo "FAIL: all rules should match at end of packet"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send 1495
+if [ $(countrule -c 1) -ne 1 ]; then
+	echo "FAIL: only kmp with proper --to should match pattern spanning fragments"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send 1500
+if [ $(countrule -c 1) -ne 2 ]; then
+	echo "FAIL: two rules should match pattern at start of second fragment"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send $((1600 - $patlen))
+if [ $(countrule -c 1) -ne 2 ]; then
+	echo "FAIL: two rules should match pattern at end of largest --to"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send $((1600 - $patlen + 1))
+if [ $(countrule -c 1) -ne 0 ]; then
+	echo "FAIL: no rules should match pattern extending largest --to"
+	showrules
+	((rc--))
+fi
+
+zerorules
+send 1600
+if [ $(countrule -c 1) -ne 0 ]; then
+	echo "FAIL: no rule should match pattern past largest --to"
+	showrules
+	((rc--))
+fi
+
+exit $rc
-- 
2.41.0

