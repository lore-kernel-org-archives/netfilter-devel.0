Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0668830C1FD;
	Mon,  5 May 2025 23:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488534; cv=none; b=h7AHHU7DgqlJOgyVWdMXwnbZ2O9qesps9RW2WfnUtiFIo5xLLTRXhf5LVP+dJmZBcFfNNfoZaXlSmGlETPXQ4bnFEU61rklRLt/Eh9xqIPoR9WPk8Rwq+Rjv6R7loMkRlO5mqsjp+9olFgu2n3nWF5a1CehTu6k77pGIiDu8apM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488534; c=relaxed/simple;
	bh=YBKt0MNfFUPhTQ5pPrpKdZS2i7hIYYUL2Qo+eR0JkRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ewV87jk96yi3B6ECroZV/53CDcp7R9wZ+BqSbXqlg7mXQFyggDv1T7MXsSVixdO/bTVYXUiS6FgR1F1eUeFvegn9h4flktgsel6q1lwAPetL2V6Y8mu4xSeODfXbXd9FcOeB9IaoBuhnsPHYjKq+IDvDkUNMzNofjupIdsBrxH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YSzbt0dU; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b/kkMkyi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YSzbt0dU";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b/kkMkyi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7276760654; Tue,  6 May 2025 01:42:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488530;
	bh=s6cSq5pM3sPILW7lGQC/3IynDjBjciqctcy7gTDh4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSzbt0dUKvuyVTK0z8N7yvLYu/hLzlggnNInz+YmuWRTxmbJQn9bbO6KOyCNzqz9z
	 +TDQMNWTxrfb2/PCl5UWGI/r+9yythKYI7OdOoZOu2W3Hb7F6tghiUKKMS/zQuP3QP
	 P160WOkNSjSeTducBs2/BbxVEl8Uy0OpT0/1JZIgUq5ZkXwf2eYCebYTSEa09lPCX+
	 wXUkjSnXGSwl71Rb4HcyhUCSUlSNA7+FPsJ3Z4ZTdG+xwE7uZHg2NiVJJMs8HnBtzk
	 T9dm/YWX0WGoTzH/+tMTjXPc/EpX8Z93yPm6Ps6o1oUnp9KKvDthUGUA56I0gMaUpl
	 k4Nn0kDbCpVbQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2D3E660654;
	Tue,  6 May 2025 01:42:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488521;
	bh=s6cSq5pM3sPILW7lGQC/3IynDjBjciqctcy7gTDh4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/kkMkyi51zZ+u57DP0wueNCwgR2RtSg9Jk9Senvtdk/7G/SBUa347h8fzcnSA6o8
	 yP/7vdMqqgtDPm2YaieTjefFAklqZyNmj2RbhIiaiaMqrx+MrbCgNUmTLBIYSBVIrR
	 lGqpS2spLXTMP5WSMwsZPjyp6IXK/2Xp27t4KTtHwgT3ONwukdD60m+pyev5Hoefns
	 21jnjRJi2sBaqPcXi+lPDBbMBecUwNIkUSAaeX7mtd9SBm1MpH03ef2TAR8+nfg7ii
	 XXQ2eD76XnbxYAm0WyBHhAdgtRInciUmNPxDX8C6WlqlAMinI3NW5zUw2ib2SUFK2Y
	 2xv9x2mnt9t2Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 7/7] selftests: netfilter: nft_fib.sh: check lo packets bypass fib lookup
Date: Tue,  6 May 2025 01:41:51 +0200
Message-Id: <20250505234151.228057-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

With reverted fix:
PASS: fib expression did not cause unwanted packet drops
[   37.285169] ns1-KK76Kt nft_rpfilter: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=127.0.0.1 DST=127.0.0.1 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=32287 DF PROTO=ICMP TYPE=8 CODE=0 ID=1818 SEQ=1
FAIL: rpfilter did drop packets
FAIL: ns1-KK76Kt cannot reach 127.0.0.1, ret 0

Check for this.

Link: https://lore.kernel.org/netfilter/20250422114352.GA2092@breakpoint.cc/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_fib.sh        | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index ce1451c275fd..ea47dd246a08 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -45,6 +45,19 @@ table inet filter {
 EOF
 }
 
+load_input_ruleset() {
+	local netns=$1
+
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy accept;
+	        fib saddr . iif oif missing counter log prefix "$netns nft_rpfilter: " drop
+	}
+}
+EOF
+}
+
 load_pbr_ruleset() {
 	local netns=$1
 
@@ -165,6 +178,16 @@ check_drops || exit 1
 
 echo "PASS: fib expression did not cause unwanted packet drops"
 
+load_input_ruleset "$ns1"
+
+test_ping 127.0.0.1 ::1 || exit 1
+check_drops || exit 1
+
+test_ping 10.0.1.99 dead:1::99 || exit 1
+check_drops || exit 1
+
+echo "PASS: fib expression did not discard loopback packets"
+
 ip netns exec "$nsrouter" nft flush table inet filter
 
 ip -net "$ns1" route del default
-- 
2.30.2

