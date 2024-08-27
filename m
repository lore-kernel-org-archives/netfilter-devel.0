Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE7817BD6;
	Tue, 27 Aug 2024 09:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724749387; cv=none; b=q/UIFjw0WCrQJ11/lU0HAdeirC2o1aXBz8SdgeDQToDyWT2o/64cnpw+puuUs4XWt96wyWDIqjPSHWVMWsRHGKmyzfCmFvLB39cejdRE9IY7tNBUyqBdH9SSBQfxwHGdPqss2e+K6fYenFTgeuWEko5tOOdecwMWT/CACJaIblY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724749387; c=relaxed/simple;
	bh=JUC6DOMN8YBQgcrZvkS/X1aqMcAhv/zV7V/5rUDHepk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNqjsssSHrkLZo3nvcDxWchdKsaXUFz9FSDg5CCFFZsIjggs+F7GVuTBGRTpHrwgM+ayiWQwL/Q4brq4gAdtm2scnLKS+lgS6erP2omK87VueEinpdhmB9lv/fvtsYAeMu6q+/HjevfiHtUvr3dDrgxTrtZgqWXYoa10ZhwoolA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sis6K-0008VV-H8; Tue, 27 Aug 2024 11:02:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce test file size for debug build
Date: Tue, 27 Aug 2024 11:00:12 +0200
Message-ID: <20240827090023.8917-1-fw@strlen.de>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240826192500.32efa22c@kernel.org>
References: <20240826192500.32efa22c@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sctp selftest is very slow on debug kernels.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240826192500.32efa22c@kernel.org/
Fixes: 4e97d521c2be ("selftests: netfilter: nft_queue.sh: sctp coverage")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Lets see if CI is happy after this tweak.

 tools/testing/selftests/net/netfilter/nft_queue.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index f3bdeb1271eb..9e5f423bff09 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -39,7 +39,9 @@ TMPFILE2=$(mktemp)
 TMPFILE3=$(mktemp)
 
 TMPINPUT=$(mktemp)
-dd conv=sparse status=none if=/dev/zero bs=1M count=200 of="$TMPINPUT"
+COUNT=200
+[ "$KSFT_MACHINE_SLOW" = "yes" ] && COUNT=25
+dd conv=sparse status=none if=/dev/zero bs=1M count=$COUNT of="$TMPINPUT"
 
 if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
     echo "SKIP: No virtual ethernet pair device support in kernel"
-- 
2.46.0

