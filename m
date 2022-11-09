Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31405C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 09:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKIJGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiKIJGV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 04:06:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD5B20982
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 01:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5dD+uOSWO1DYZ75msP2eqebaXXOj9jZIsRkoAvkZiqc=; b=fkZtQ9h7Wa3bbtfI396bKvKFW2
        AK2sdg2FD2wl9CPFv1Ln6ivzGgCNuD0DbamtTgRB1+ugW3LUTY24w+DhI3558BAXbrmmKMvUxYuT2
        IQRHTVo1+G9aG05O2JglMh/Dt8Hgov/79rO9X7yUlokO8SLt21UxL1/78ZHRvNjd6AG0X+tuflfTp
        lfPEngcZBrZOq1NkR9TINz0O4t0Agq4GGstR9iFq7ye2sAHoYizDYtz1xrlTfn6WxvP8w8q6rW+Mm
        kmF9aI5R6KiigdhOsG2YfXwK5SbetlL4q4N4ubj2iu+02mePEV/DP30tFUezYI+49f9NP9wyltBX3
        aP0zQU2g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1osh2D-0005T2-Ax; Wed, 09 Nov 2022 10:06:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf PATCH] selftests: netfilter: Fix and review rpath.sh
Date:   Wed,  9 Nov 2022 10:06:04 +0100
Message-Id: <20221109090604.18439-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Address a few problems with the initial test script version:

* On systems with ip6tables but no ip6tables-legacy, testing for
  ip6tables was disabled by accident.
* Firewall setup phase did not respect possibly unavailable tools.
* Consistently call nft via '$nft'.

Fixes: 6e31ce831c63b ("selftests: netfilter: Test reverse path filtering")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/netfilter/rpath.sh | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index 2d8da7bd8ab74..f7311e66d2193 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -15,7 +15,7 @@ fi
 
 if ip6tables-legacy --version >/dev/null 2>&1; then
 	ip6tables='ip6tables-legacy'
-elif ! ip6tables --version >/dev/null 2>&1; then
+elif ip6tables --version >/dev/null 2>&1; then
 	ip6tables='ip6tables'
 else
 	ip6tables=''
@@ -62,9 +62,11 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-ip netns exec "$ns2" "$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-ip netns exec "$ns2" "$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
-ip netns exec "$ns2" nft -f - <<EOF
+[ -n "$iptables" ] && ip netns exec "$ns2" \
+	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
+[ -n "$ip6tables" ] && ip netns exec "$ns2" \
+	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
 		type filter hook prerouting priority raw;
@@ -106,8 +108,8 @@ testrun() {
 	if [ -n "$nft" ]; then
 		(
 			echo "delete table inet t";
-			ip netns exec "$ns2" nft -s list table inet t;
-		) | ip netns exec "$ns2" nft -f -
+			ip netns exec "$ns2" $nft -s list table inet t;
+		) | ip netns exec "$ns2" $nft -f -
 	fi
 
 	# test 1: martian traffic should fail rpfilter matches
-- 
2.38.0

