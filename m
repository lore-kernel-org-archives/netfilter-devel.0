Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3B1C636CC
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 16:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBPQGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 11:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjBPQGB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 11:06:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F64C64D
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 08:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0dqiQcCc7pzfDB1jH8b6t1cGt+jSHaAA5wCPBOCCV+I=; b=gorxk7rPKB96Zh24tv91hItviU
        HcMkaj3favdveBn82vWTrfSw/Lt4qJF5Q2waUGYp82/goyY2D0bqqrl4wu/gS1LdZPY7+yn+cwLQK
        J/qazOuKKu309dY8YAaTkP8HFepToMG2MprLECs7UagvXnKGbGl9bVVMrXvsT4ZnsD/I+u3aLN55n
        LxXqPpLnCbEF+ustaHavBqt0B1G99IppxfO/QjaPUEinF+KTp71uy1vFOjeZkJxJlnLYOfclijrjY
        dNEsjk2m67W/QIKimCEUTNm6q/qTciqYkTH+DkGHjyd+fodXePRxhVP/Q1qOh+JBVZerRe+4v/HRb
        d2KIn8Bg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pSglV-0005Ve-59; Thu, 16 Feb 2023 17:05:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: [nf PATCH] netfilter: Fix regression in ip6t_rpfilter with VRF interfaces
Date:   Thu, 16 Feb 2023 17:05:36 +0100
Message-Id: <20230216160536.18506-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When calling ip6_route_lookup() for the packet arriving on the VRF
interface, the result is always the real (slave) interface. Expect this
when validating the result.

Fixes: acc641ab95b66 ("netfilter: rpfilter/fib: Populate flowic_l3mdev field")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/ipv6/netfilter/ip6t_rpfilter.c         |  4 ++-
 tools/testing/selftests/netfilter/rpath.sh | 32 ++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index a01d9b842bd07..67c87a88cde4f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index f7311e66d2193..5289c8447a419 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -62,10 +62,16 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-[ -n "$iptables" ] && ip netns exec "$ns2" \
-	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-[ -n "$ip6tables" ] && ip netns exec "$ns2" \
-	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$iptables" ] && {
+	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
+}
+[ -n "$ip6tables" ] && {
+	common='-t raw -A PREROUTING -s fec0::/16'
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
+}
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
@@ -89,6 +95,11 @@ ipt_zero_rule() { # (command)
 	[ -n "$1" ] || return 0
 	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
 }
+ipt_zero_reverse_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | \
+		grep -q -- "-m rpfilter --invert -c 0 0"
+}
 nft_zero_rule() { # (family)
 	[ -n "$nft" ] || return 0
 	ip netns exec "$ns2" "$nft" list chain inet t c | \
@@ -101,8 +112,7 @@ netns_ping() { # (netns, args...)
 	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
 }
 
-testrun() {
-	# clear counters first
+clear_counters() {
 	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
 	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
 	if [ -n "$nft" ]; then
@@ -111,6 +121,10 @@ testrun() {
 			ip netns exec "$ns2" $nft -s list table inet t;
 		) | ip netns exec "$ns2" $nft -f -
 	fi
+}
+
+testrun() {
+	clear_counters
 
 	# test 1: martian traffic should fail rpfilter matches
 	netns_ping "$ns1" -I v0 192.168.42.1 && \
@@ -120,9 +134,13 @@ testrun() {
 
 	ipt_zero_rule "$iptables" || die "iptables matched martian"
 	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	ipt_zero_reverse_rule "$iptables" && die "iptables not matched martian"
+	ipt_zero_reverse_rule "$ip6tables" && die "ip6tables not matched martian"
 	nft_zero_rule ip || die "nft IPv4 matched martian"
 	nft_zero_rule ip6 || die "nft IPv6 matched martian"
 
+	clear_counters
+
 	# test 2: rpfilter match should pass for regular traffic
 	netns_ping "$ns1" 192.168.23.1 || \
 		die "regular ping 192.168.23.1 failed"
@@ -131,6 +149,8 @@ testrun() {
 
 	ipt_zero_rule "$iptables" && die "iptables match not effective"
 	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	ipt_zero_reverse_rule "$iptables" || die "iptables match over-effective"
+	ipt_zero_reverse_rule "$ip6tables" || die "ip6tables match over-effective"
 	nft_zero_rule ip && die "nft IPv4 match not effective"
 	nft_zero_rule ip6 && die "nft IPv6 match not effective"
 
-- 
2.38.0

