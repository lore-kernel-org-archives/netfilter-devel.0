Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE39D2AE74
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2025 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754491110; cv=none; b=avfgYnUv9IH5nrBczreQiQMAl+visxGg2BQJiyP+dEYY3bZJXM6cczJWZ/mP3cLsono/TV8lipI3IlOrQVw+EWkOQcrWvPSWqZn77SU7sWhe/HEIhR3khcZlf6Ppzznqbs/ghMfmKCEnqsCoIdFAkG0V9oJAVMf9Yx41UU2aag4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754491110; c=relaxed/simple;
	bh=aCP6U+5+42WlB3kSrtO1x2IrCgypWcqgDdPzqS5u1i4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bP+lJjhytUz9BwiJU8/wyp9epOQgH9IrMVseHtlZtFSyqU/zhKdTUXh7BYEW1iyfzbd0gDn1wV7m2RyIi3fg4V3YmCfGCiL98+TKgUkD32k750sIomlQiQqqvTKcTdmv9eh2jzDtg6quNbESsFwerenSFW83lp6kE+n6UndbCfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Qtav5NZD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qtav5NZD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=od8XMI64uQFyb++6lnXZJmC7d/TmOl2W2YEOD4k+y2U=; b=Qtav5NZDehR70fBGXyHhlDwYAx
	htmHXIZZOn8pTuHGhgvizJra4ve4OT7TLv4LqwXY7UnIvJToHoLKFXC+Mmcrn2JgRITxOuEAUDBOV
	jJJYm+NcB/r/TmXY//HCigIqT+rmH7PLl+ch8d4v29ljmf7cXHtAx/5mcsNkmkPUf+72wL8L/gkb3
	BPxNzsPdA9MuM847kYX9f8ZQTyAAwoyMetwfZ12cB/nRlq9UF7BPvqqWBdzeQUQDBHyGX3W24CTMZ
	8VzlTcNmfgrGZEcaRoCyd0wzzbooTem8l8IzishiiQcGHoWdSMR6BhDjhDhDrL1r3Va0fcBmWHf9c
	6ohoZbxg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ujfHX-000000004Dy-3uBU;
	Wed, 06 Aug 2025 16:38:19 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [nft PATCH] tests: shell: Fix packetpath/rate_limit for old socat
Date: Wed,  6 Aug 2025 16:38:14 +0200
Message-ID: <20250806143814.4003-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test would spuriously fail on RHEL9 due to the penultimate socat
call exiting 0 despite the connection being expected to fail. Florian
writes:

| It's the socat version in rhel9. With plain reject (icmp error):
|
|   read(0, "AAA\n", 8192)                  = 4
|   recvfrom(3, 0x7ffd59cf1ab0, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
| [..]
|   write(5, "AAA\n", 4)                    = 4
|   recvfrom(3, 0x7ffd59cf1f90, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
| [..]
|   read(0, "", 8192)                       = 0
|   recvfrom(3, 0x7ffd59cf1ab0, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
|   shutdown(5, SHUT_WR)                    = 0
|   shutdown(5, SHUT_RDWR)                  = 0
|   recvfrom(3, 0x7ffd59cf2260, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
|   exit_group(0)
|
| ---> indicates success, even though it did not receive any data.
[...]
| Replacing "reject" with a "reject with tcp reset" gives:
|   read(0, "AAA\n", 8192)                  = 4
|   recvfrom(3, 0x7ffcffd04220, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
| [..]
|   write(5, "AAA\n", 4)                    = -1 ECONNREFUSED (Connection refused)
|   recvfrom(3, 0x7ffcffd04700, 519, MSG_DONTWAIT, NULL, NULL) = -1
| EAGAIN (Resource temporarily unavailable)
| [..]                               = 10212
|   write(2, "2025/08/06 08:34:29 socat[10212]"..., 832025/08/06
| 08:34:29 socat[10212] E write(5, 0x55a4f0652000, 4): Connection
| refused
|   ) = 83
|   shutdown(5, SHUT_RDWR)                  = -1 ENOTCONN (Transport
| endpoint is not connected)
|   exit_group(1)                           = ?
|
| -> so failure is detected and the script passes.

While this is likely a bug in socat, working around it is simple so
let's tackle it on this side, too.

Note: The second chunk is sufficient to resolve the issue, probably
because the initial ruleset's rate limiter does not trigger during TCP
handshake. Adjust it anyway to keep things consistent.

Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 9352fa7fb0a31 ("test: shell: Add rate_limit test case for 'limit statement'.")
Cc: Yi Chen <yiche@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/rate_limit | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/packetpath/rate_limit b/tests/shell/testcases/packetpath/rate_limit
index 10cb8f422b1a6..e0a8abc96ae3d 100755
--- a/tests/shell/testcases/packetpath/rate_limit
+++ b/tests/shell/testcases/packetpath/rate_limit
@@ -55,7 +55,7 @@ table ip filter {
 		ip protocol tcp  counter jump in_tcp
 	}
 	chain in_tcp {
-		iifname "s_c" tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/minute burst 5 packets } counter reject
+		iifname "s_c" tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/minute burst 5 packets } counter reject with tcp reset
 		iifname "s_c" tcp dport 80 counter accept
 	}
 
@@ -120,7 +120,7 @@ assert_pass result "flush chain"
 ip netns exec $S $NFT flush set filter http1
 assert_pass result "flush set"
 
-ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/second burst 1 packets} counter reject
+ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/second burst 1 packets} counter reject with tcp reset
 assert_pass result "add rule limit rate over 1/second burst 1"
 ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 counter accept
 
-- 
2.49.0

