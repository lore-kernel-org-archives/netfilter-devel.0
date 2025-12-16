Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219732B982;
	Tue, 16 Dec 2025 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912178; cv=none; b=ae+JWOs3NjPPGL7Pq0WWKB/SjQFK4wXNLdQ0h8uGwtfCFYe33xSAsUPszfty7qS2H697FkNoDqglCV4WsBmypMOsO+Q5IefV43WwRNKKehUN7qFLLrO5H5HtxKCAFdSlQc3cjiz2DSn3khDTHh6R1JNILBKKNNIjXnjKyOziSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912178; c=relaxed/simple;
	bh=Ei8XrZXg87+kkFxlYIqq9JbQzR/5/I10VR668Vb5wWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8YyBfOVsDSZz1Cb4Zo+IoKMo0kp3d8MHVX8JmpeVAhLEJFApfd3Kppb2W5+kcJm0U48YZJoR4DA7g/UAOcenTyJuzs9Xj4h5/GKPYdhGkFtvcSVNyFXx9zUTZoe/Lk7VdzW2B3IKbNGrclIuKg2pWuKnKMKJm8YBHlgecndUso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E53B16024F; Tue, 16 Dec 2025 20:09:34 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 6/6] selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel
Date: Tue, 16 Dec 2025 20:09:04 +0100
Message-ID: <20251216190904.14507-7-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
References: <20251216190904.14507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

packetdrill --ip_version=ipv4 --mtu=1500 --tolerance_usecs=1000000 --non_fatal packet conntrack_syn_challenge_ack.pkt
conntrack v1.4.8 (conntrack-tools): 1 flow entries have been shown.
conntrack_syn_challenge_ack.pkt:32: error executing `conntrack -f $NFCT_IP_VERSION \
-L -p tcp --dport 8080 | grep UNREPLIED | grep -q SYN_SENT` command: non-zero status 1

Affected kernel had CONFIG_HZ=100; reset packet was still sitting in
backlog.

Reported-by: Yi Chen <yiche@redhat.com>
Fixes: a8a388c2aae4 ("selftests: netfilter: add packetdrill based conntrack tests")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
index 3442cd29bc93..cdb3910af95b 100644
--- a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
@@ -26,7 +26,7 @@
 
 +0.01 > R 643160523:643160523(0) win 0
 
-+0.01 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
++0.1 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
 
 // Must go through.
 +0.01 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
-- 
2.51.2

