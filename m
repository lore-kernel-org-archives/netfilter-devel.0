Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAB4B1E7C
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 10:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746700536; cv=none; b=jCShB5ou8eyGG2B7UD8KEo6+cazgk7AcpN8oNG32WUgzKlN7T/vxEdJ3N+G7EKkc7yqOpjxT+lMmqlMnpaBXBC7CEgZLWCkoZcVouaMU98Nb8EI8CB0QylRZrGgermG8jEgJoZk5kMboCL7CDtFQgE5EeVQoAVJKkg1TftF8Tz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746700536; c=relaxed/simple;
	bh=lg/qub/VM8HrYhCy9hQrYXNh+SlrBieqmuavJtziJ04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ajPRka6CoeZMwUTDoI7xf8o9ak6MRqFqObWU878ukCyfaRqx+blfpZdN281yR6H9TSncXWoCcQbNdujV5Mcvp+4sCgKDfwAPnZIlcVyKITlJQlWf3CDxxvTEE7AsJ3hfBKWHZ1cG0kaHyR9uUOPwTq8AZM+j049nZVaK3NA/lbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KArTYEB/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KArTYEB/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GVFEwE0DHJIBwjGahdtDllMZwRXOmzCPmKlqc6e+mOs=; b=KArTYEB/yRow9iARo4zCbwgchQ
	YgF/XUbYgA8W86gdD1AYZFzsDAxNzugZWN5nRImCppkkRemFHAeZSs0Vq6l8ijUZyvAywdqkHqKu8
	Gm6NKaFDYRKseCjjIkDfjzZlsGH5n7DPa1rGIbOhAeJUwwebu1h0mAVkr1jtHiubRji8kJVWCEicR
	WNxEJVihJuAaa1FhHaEZ5yYRaOwBJdVv903mCUP07A+m75XnsmhWgJ6xtnt2Ypu1I/zJL/t6Y6Jkh
	mzcTGFFeLMhbmlLnmi0eRPoEjSYc80BrJTuIPhJupxi5exDcIN4RviEbjlYYBA+Ugo2/o115XZUFd
	UPrQBcJg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uCybD-000000003Yw-2Dub;
	Thu, 08 May 2025 12:35:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/shell: Skip netdev_chain_dev_addremove on tainted kernels
Date: Thu,  8 May 2025 12:26:54 +0200
Message-ID: <20250508102654.17077-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test checks taint state to indicate success or failure. Since this
won't work if the kernel is already tainted at start, skip the test
instead of failing it.

Fixes: 02dbf86f39410 ("tests: shell: add a test case for netdev ruleset flush + parallel link down")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../chains/netdev_chain_dev_addremove         | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tests/shell/testcases/chains/netdev_chain_dev_addremove b/tests/shell/testcases/chains/netdev_chain_dev_addremove
index 14260d54b778e..6103e82b10603 100755
--- a/tests/shell/testcases/chains/netdev_chain_dev_addremove
+++ b/tests/shell/testcases/chains/netdev_chain_dev_addremove
@@ -4,6 +4,12 @@
 
 set -e
 
+read taint < /proc/sys/kernel/tainted
+if [ "$taint" -ne 0 ]; then
+	echo "Kernel already tainted up front."
+	exit 77
+fi
+
 iface_cleanup() {
         ip link del d0 &>/dev/null || :
 }
@@ -26,10 +32,6 @@ EOF
 }
 
 for i in $(seq 1 500);do
-	read taint < /proc/sys/kernel/tainted
-	if [ "$taint" -ne 0 ]; then
-		exit 1
-	fi
 	ip link add dummy0 type dummy
 	load_rules
 
@@ -37,12 +39,11 @@ for i in $(seq 1 500);do
 	$NFT flush ruleset &
 	ip link del dummy0 &
 	wait
-done
 
-read taint < /proc/sys/kernel/tainted
-
-if [ "$taint" -ne 0 ]; then
-	exit 1
-fi
+	read taint < /proc/sys/kernel/tainted
+	if [ "$taint" -ne 0 ]; then
+		exit 1
+	fi
+done
 
 exit 0
-- 
2.49.0

