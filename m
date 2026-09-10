Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6DC49B1E6;
	Thu, 10 Sep 2026 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057294; cv=none; b=X92EbavSZ/aYWXl8k2okRSF5NHacpsROMwG2V1VShbAtUvStESMFN20NB2wE4AmHnJchbsjhp3O6pe0gALi5ejlZljWjg7MBdP9uQlIPdy2a8c//sUUWNUw+k4VtgAFLLH1WS+6eiBsn1choCPA4lUVuvzHvDnChJXjzJIJUZc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057294; c=relaxed/simple;
	bh=vAoWxmIXfcMtyP+ms08hVvqa3Q2PRsi3ooBQ6PyJaO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u6671FEwfwwB5p/Mhsc0kvbTjQjsht7GB4keQzu7lt0A3KapqgVFhkTaqMiEtti5JYb2wZ9I18OdZAYJ8G0fFVCLH4nyD4DfalxNojpOVguFDKlHp3w7KTqZmnMd+d2IRg6TCMeeFC3CW9Q2zDt5HQH6jcicMsQrFmwO0nXTO1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.im; spf=pass smtp.mailfrom=fastmail.im; dkim=pass (2048-bit key) header.d=fastmail.im header.i=@fastmail.im header.b=blFX3zvA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JnJ7KFHz; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.im
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.im
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.im header.i=@fastmail.im header.b="blFX3zvA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JnJ7KFHz"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 373161D000CF;
	Thu, 10 Sep 2026 12:21:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 10 Sep 2026 12:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.im; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1789057290; x=1789143690; bh=aK26Kj7/Vof7Uk4cW7XLc
	z6Ht3tIE8qS1gygr/ggYJg=; b=blFX3zvAgKu/B21syoBjc/V4bfMcQEaJet5cb
	Qfnir4aK4zZNRFjwMtBqVDnVp8tUfVxYLa3/h86GE8d6yBceTcYfg6yL/xVkH0YR
	E+/sk2INQLwgaZR0pNPmXimXcH9p4CMxuOAdKwt0JhoMEvDKgrPcUdrnDWi/t8y8
	kDMeTXJEm+iTIpn2K3LmeKgg3JrKwVH2s/7iaqtdrzMbFmy/QSNW5Ig3RlKN8Pg8
	kspxl34bvmTrPvQlG2W74N7VwxQBtqCNBkfcahvUFayxcl1BE92HxCoNd0+Q+MOl
	IqphY5QbX0hnesP+vgoqk1WS8zY/PDwz5adVvXY9FvlcK/KHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789057290; x=1789143690; bh=aK26Kj7/Vof7Uk4cW7XLcz6Ht3tIE8qS1gy
	gr/ggYJg=; b=JnJ7KFHzJa0JkgGfUrs3w5z6f1yc79WAJaB39fkPDZakE8MtCFZ
	Yk9hncxxZ+u5jcAWRpuG/IOe6+hIPkcJr/Sjog/zi96SNAdCFa5O2PScA7a0xTlf
	HfY9bo4HXcYqrq+ZpHT9QRR4ebXJYxGLAy60kMFHHUvhKX33CnMqVnkDyua0vL2V
	oImivRJeJfiPhAES8f002fKXPKsZ4wqbxoXJnLyQwxCk52QwAURCF0fxIffJKHGw
	k1dJLg1oTX0ch8S1k4pp/GHT7lMUpmhiJ1+0VzWjnkn80gaDKdZmEm+nNHoHNXSv
	DZuv+SKh2WCxcCmbu2XHg3lbEs+vV+VS4cQ==
X-ME-Sender: <xms:Cdmiah5JWLrCX_8lZ3FHB4pC8xmWTmN93TOm7P_gC6TGuxJqw9XyRw>
    <xme:CdmiakFdcEV0Dq2AgTMrZE_eNNRvi8xOMHk4zXcNvxLqy6tZrTe4FPmYMdx7M4HaR
    HsMeL07eqzMFn4dluvF6AbYALIMYnD2TXFj-gfq3wL4dgu1ltE9O5x->
X-ME-Received: <xmr:Cdmiar2i9vnsi4FuVdHqPMAE8YeEuFg71ll-Sp_Wg1A6nkdmOcOnEE1pByz3gw>
X-ME-Proxy-Cause: dmFkZTFgmBpv1L1baKkh2brsPkB7ChxxWvmBzQe9m0O3j2ui/hmOGbG9Mxd79zEnl06omD
    ufzuKXFi3Nzqg72qslMhKDJ2zPZMh1E+Em3I25nrN3rVLRHBx9lNhM5NUJNRlBVy0NZu+0
    rlRvHJ0+3kedKDaGl9dwHSiAM5RFAU0VKV5OigWusxMyKmZkjT5uqLv9Qu363+1tkZ6R89
    uzJPqIuG7uRouurfRHlhCIQfffTrAWGRezvsJUNJ8PpURvav+JzYeKgJVIiVgwGtCe+2Fl
    PGEHOT4/V7ztJbV4OSoAPWe2IgDBNMgThqi+C64sbkA7I4HtrvR1aPcjO/W+hJdEMKeLCE
    hzqXV1544uNAwGfGQB+vU8Ol/gS2vCP3vea+N1kwicg5YfxzgXpKDU5gcewu3mf75rvFaY
    OABU1wVRyT0zzf+4ytz55YUd+7OKo5Afsg2YKYrOkeEpdY3Vz1LyYJBpTvoPMeU5YP4FT6
    FWoHvfB0s9ZFwEXmW7goXqzJrLV7hQKhXqO3r96ptpm9++B5aQ7SI75G9qbqJw1uT1iDhG
    2cnXcRn+8mYY+0KzTM6FVkgUdGxojB7KvCidqfpA9GW2JNp/ofiBPKtmy8I1tsLx7/ZcdF
    FwiVT4MS1Mfx+1fbCR07A+1eXejfsq5mCQU4rjxhaFrNLetFSny+Uo+npZ+g
X-ME-Proxy: <xmx:CdmiappXk46WwH8gO8ZrTnuojjEouajesZQRRngyhwVYyNVvYd-YaQ>
    <xmx:CdmiagM85EX_OOSvIl-VYDoLMvXN2b_Cwe8gNEIwx_cZTj4xH7IVOw>
    <xmx:CdmiajW_vP0obxqFnpHJlRomvvcqDVoPa09nfQ8Z5t6ND3NxGd_HbA>
    <xmx:CdmiaruYvhouR4tJX1UWdLFvds6nLwtJrd1lepdL-aB4tS3cmRLyVw>
    <xmx:CtmiasKk4xN2Ln0XWTu9J4wU67pIV4HNVwokbGHcuu-KWe67zjCSElqf>
Feedback-ID: i559e4809:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 12:21:28 -0400 (EDT)
From: Alice Mikityanska <alice.kernel@fastmail.im>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Alice Mikityanska <alice@isovalent.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH net] netfilter: flowtable: Saturate 16-bit flow_tuple->mtu
Date: Thu, 10 Sep 2026 19:20:52 +0300
Message-ID: <20260910162052.94648-1-alice.kernel@fastmail.im>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alice Mikityanska <alice@isovalent.com>

ip6_dst_mtu_maybe_forward clamps its return value to IP6_MAX_MTU, which
is 40 bytes bigger than U16_MAX. While it can be a valid IPv6 MTU (IPv6
payload_len doesn't include the header), this value is assigned to the
16-bit flow_tuple->mtu in flow_offload_fill_route.

To avoid the overflow, use U16_MAX for all MTUs bigger than 65535. Since
flow_tuple->mtu is just a threshold for the software flowtable fast
path, packets exceeding it won't be dropped, but rather punted to the
normal forwarding path: nf_flow_offload_ipv6_forward returns 0, and
nf_flow_offload_ipv6_hook returns NF_ACCEPT.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901195714.673548-1-alice.kernel%40fastmail.im
Fixes: 4f3780c004ef ("netfilter: nf_flow_table: cache mtu in struct flow_offload_tuple")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
---
 net/netfilter/nf_flow_table_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..8f15540ae206 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -107,7 +107,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
 	case NFPROTO_IPV6:
-		flow_tuple->mtu = ip6_dst_mtu_maybe_forward(dst, true);
+		flow_tuple->mtu = min(ip6_dst_mtu_maybe_forward(dst, true),
+				      U16_MAX);
 		break;
 	}
 
-- 
2.55.0

