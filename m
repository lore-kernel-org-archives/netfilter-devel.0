Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26FF2673B7;
	Thu, 10 Apr 2025 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744281419; cv=none; b=XpxCDK06K6Up5eapHDJW9dbjMJl+6JbBF0OBlgtqsXiPUgiszzMEDkp2XiKPq2yEmXLVPGcMNMYI/QyN9LGINLZZVcRbb7EgF8DcWI+d8DVWzfu1IT66ePODhX7dHc4Xif2TUOqfTTM6SVVyAnm6mV5G+jzpNQtVCmZ9C7QEYVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744281419; c=relaxed/simple;
	bh=A5x2Lni6MiA4kqStl42vT0HC7NupGO7M0BBzEbokItM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sZMikmY/erwl61P+4KzPSiEe/88uyq+EjcVdSQwPgbCtlaGnIdLRC3njtquZe1OBoeMO/flf5vlIEQozelJ1pl4dp8SE4jsWmmV8WC0jzSz1OjqnhwiFTzFnHa01th+pOL6BjIEgEx50hxtMgJXv+NaDBdSrrXVnlfUtE982NCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fPjOzkYV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U+MkvXF/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fPjOzkYV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U+MkvXF/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2F436606BA; Thu, 10 Apr 2025 12:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281415;
	bh=9a3rtdGbc9VzUJM9n8G8ZvoAHHLZvqAo0jjONxdIEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPjOzkYVmB6SuyIGnexuxznGGap/RCozNu1pqIpl3kD4s8A7hKGudycbdqRbN1ms9
	 tfP/4F4USnL1Mv7vWwm22RxYhwUVXFl15E0RiVtgnkJ73eIBOyIWgJzG94iPZytB+Z
	 6lR9pJG1aFjGOEoXi03TfwFVKis8VHBnk86D/pSkIHuO7GocceRO7CqlEXHLX6rVC/
	 vMf4qzWuhMDm1Puvt0CydIR3wnwJ84JmztDORPrSmODFE/Tmbv+2dNLlZZjfavUkVZ
	 fhLhT5SHmC64B8M43xusN3ktWtWcT0UZHYN0ryXN/hAvabKTIVILIJ2VnEMLWAxtzp
	 5z9VjCW+3KF7g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4072C606AC;
	Thu, 10 Apr 2025 12:36:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281414;
	bh=9a3rtdGbc9VzUJM9n8G8ZvoAHHLZvqAo0jjONxdIEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+MkvXF/N6z+BPW5xZ1fE4we//j0VCGV2xIwcWDIT4hDewbT//g9UeYWq80yE7JTp
	 ga/MZ2/BfURNecFQoVHNaDIcEC/EQVFdUyn/KyEE+aWhQ4mRnXruSx698NhQkLFb/0
	 /5qdpyUDp4JOc1993Gxe8hVa7GEvb0nTLvPokXGYOX/mx3RkjO1bYyIXo4ADSucuNW
	 CjN+zOu8Wn9wgTMT2jT26tJfUGoKS7ozEyyUcWVTmXCFyV19YoO+5hFynkRHB7irQh
	 OpPr9UvFXJYcGT+IlcZa+yQvgr2/6yWMHk5Rrj1YSx4tHX1B/omvA1oMa0hPy/5ynP
	 GZVGKEgRGPDKQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/2] selftests: netfilter: add test case for recent mismatch bug
Date: Thu, 10 Apr 2025 12:36:47 +0200
Message-Id: <20250410103647.1030244-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250410103647.1030244-1-pablo@netfilter.org>
References: <20250410103647.1030244-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Without 'nft_set_pipapo: fix incorrect avx2 match of 5th field octet"
this fails:

TEST: reported issues
  Add two elements, flush, re-add    1s  [ OK ]
  net,mac with reload                0s  [ OK ]
  net,port,proto                     3s  [ OK ]
  avx2 false match                   0s  [FAIL]
False match for fe80:dead:01fe:0a02:0b03:6007:8009:a001

Other tests do not detect the kernel bug as they only alter parts in
the /64 netmask.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/netfilter/nft_concat_range.sh         | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 47088b005390..1f5979c1510c 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -387,6 +387,25 @@ race_repeat	0
 
 perf_duration	0
 "
+
+TYPE_avx2_mismatch="
+display		avx2 false match
+type_spec	inet_proto . ipv6_addr
+chain_spec	meta l4proto . ip6 daddr
+dst		proto addr6
+src
+start		1
+count		1
+src_delta	1
+tools		ping
+proto		icmp6
+
+race_repeat	0
+
+perf_duration	0
+"
+
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1629,6 +1648,24 @@ test_bug_net_port_proto_match() {
 	nft flush ruleset
 }
 
+test_bug_avx2_mismatch()
+{
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	local a1="fe80:dead:01ff:0a02:0b03:6007:8009:a001"
+	local a2="fe80:dead:01fe:0a02:0b03:6007:8009:a001"
+
+	nft "add element inet filter test { icmpv6 . $a1 }"
+
+	dst_addr6="$a2"
+	send_icmp6
+
+	if [ "$(count_packets)" -gt "0" ]; then
+		err "False match for $a2"
+		return 1
+	fi
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.30.2

