Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3756530F958
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 12:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765456336; cv=none; b=dpq5B1vP/oU5YkhzhjsH/Uvwo6BFypxcCrkNW3ibpqNEMEqpr+E0TeOBOGpOYXa+h0ZOLLoXl9/JbxW05VU4Z9h9s2kh5lcCdXy2JVkeuxkSjS2ioZmLKQ6P6nQvu7sFnxrjBVwa1Om5fbf91jEkDbUtmlSD9k7JjS9aowzTqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765456336; c=relaxed/simple;
	bh=Ei8XrZXg87+kkFxlYIqq9JbQzR/5/I10VR668Vb5wWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFTNtf3tqEGyeTXkTZ6eCov6tGF/7WdS5s+GHbtT/fIczkdC1GzhxKIi+8/LJlR7ZI+MFQo1zIHZfSQsxKwnbBhLaRDmTehJqrQxTL5mWPLGcBSDQPbyxxn49UQmobRUjwbbZNpKckAq5PY4wjB9/k7xVbQhFPfHE2UMq2SoD28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A38C260332; Thu, 11 Dec 2025 13:32:10 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel
Date: Thu, 11 Dec 2025 13:32:00 +0100
Message-ID: <20251211123205.15818-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
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

