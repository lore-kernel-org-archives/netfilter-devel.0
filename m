Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539591;
	b=TkrDpCWhd5rP9TrpKmcxaxIrh/LoAVbeztLi5DQKMRZ50W/QqKUE4EP7+RRefv9K0e5q
	 XwjKvIJUJueUVkCrP/hSjGFARgvbRp+ZDx0Hoeeq1/OCbJjreUjbatMoHFcQyaDmdgMo0
	 CYdkABAgovzdCMVZInFrjp3N5MHBUrigsbhOR5/xj5WwhWFeZAp8key8Cuc7nDsfHAxVr
	 Tdi5YeQb4kcOKgVjjK2QO26IS4JwzjrotYNtvh7Lc1bCE2ed1nF2uXbdktnxMGMhgN++W
	 wmH2p8WwDo5PlHZCACAq+LqQPq42W/jj7b+T5Gytae6gPKVFt9iyABcUjBpeUhwEr/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=WelIR0F7YD/FJ/8bWUoOOir8JE2QhOx6M1KWLomVR3Q=;
	b=xxFSXnqpmkjmUOmb8/w/esjirP0zk5cYBOs+52U5KIM2lT1bpzv0Qm90yiB19LMLDcKF
	 VFq15+Ze8uYop2ctJlR1UMS8YW7KzT646raCWfqA2Y6CVL1U8nAVqWHqtIVbbzN2uIJth
	 4LbkUI/YlAMnJUw3ga++h5R9sjwbICUECcVdE+icLzrDtgbDGKqPGt8Uq+uFCp/WZYkar
	 FmvnD9mbW11LjrAGfdTWmFyYqYQs2NAPBW+rR9vCDNj2R2W1Ec4l/rPsZWt6gpF2WCuIR
	 IKwJGRKdW8nSHaDraY6ycXh9Zt105baI7wmn2baoRshlIWihiAkaK1bwI6vmPEim2Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=s+jxe6kR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E9606A884;
	Fri, 13 Nov 2026 03:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 600E9606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=s+jxe6kR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539589;
	bh=WelIR0F7YD/FJ/8bWUoOOir8JE2QhOx6M1KWLomVR3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+jxe6kRoX7cWJG5ZoUIq6r6ZunP+gN14F060GHjIut2K9qSTNJrvC8toHyhnXl+5
	 dqnvJ+gt92MVQabvTeyeQQi10drnWMN9zWmDfF2ISweSphuBD5x/br11o3AxrMFDNa
	 Ao0BnJK9STX2kyFQqTJiqZiLa8qt6vifYC28vPiOo6O/OH6+ZFqM7K7mC9TiELlKNT
	 uNU+12tLType2w0Na/yR8TcZfaWn9TnjtlyRC/75+wFQqvGxVC2Krv45F5xBdxbR7v
	 nkj4jqQ0DNMlsgCv13X0cPHLbVdP9PcIQdwJYgHeEzRvNwmXPAXU3NbXmjOOXLL7pF
	 9jsfBzDKHFxuQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B2B7602A5;
	Fri, 13 Nov 2026 04:13:09 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 10/15] selftests: netfilter: nf_queue: drop the no-op loop initializer
Date: Fri, 13 Nov 2026 04:12:46 +0100
Message-ID: <20261113031251.2437074-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sasha Levin <sashal@kernel.org>

The out-of-order verdict loop starts with "for (ooo_count; ...", and
clang warns about the unused expression:

  nf_queue.c:354:10: warning: expression result unused [-Wunused-value]

Leave the initializer empty.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index cca6c3cfa9e4..bc0b2f601a0a 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -351,7 +351,7 @@ static int mainloop(void)
 		if (opts.out_of_order) {
 			ooo_ids[ooo_count] = id;
 			if (ooo_count >= 15) {
-				for (ooo_count; ooo_count >= 0; ooo_count--) {
+				for (; ooo_count >= 0; ooo_count--) {
 					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
 								opts.queue_num, opts.verdict);
 					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-- 
2.47.3

