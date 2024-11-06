Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342420408D
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911368; cv=none; b=YM6FJ7c1q1elNrEzu4ZwzhFIDKpkwG7nN0azz5cNfgzuyIYoSc84YTHohIJMpp5o9qRWF8ki9NAL6rh8pY5bvBiuqyNJcvczBDSClRHXCYgVEkp5F2kYsZgBBwZ1izFQaOvTdiWyFe/0bzpKKX25yGdzsjru6CVd6KNJWIwcCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911368; c=relaxed/simple;
	bh=cDqrYMgQCReT2+/nC2aCv4YEpEVFUwGWbcHXs9xDagg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0Q+++UzSZtY0hJuFc/4D0xI6Ybto4Py1FL0p2Aibg0kXDlpQzrT3TO1CtkAAumB6kHDiyiBNeooRAM57Wu2lcxtnsEYjKZzhG8rm40nK8TmXGrsnZp2vCa8iiU4H/zK7jvURID6JxX6cCcvIrA62vhCgfED2C0TOdlpot9EI7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oTc+t/f6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oTc+t/f6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NXUWLLwQ7GRlMj82sr4gVTLukl1vokPSqU634JQ1cO0=; b=oTc+t/f61kCsQk+Xui1RswX+4r
	+T4SwdZHt4AWiadWtYT0MkUOviu8G7YNbvqTicQlfd5A2Jt8d7YC+exooxXOjTCpfPtn5eeLHSkCg
	AGSTiW+y38oYrqdF2tUb+OKtxxKX6IpsK2RJADQrpE2s/4I2gZOQFMipohMPZmYQbEJLVl7yiCZwy
	2yilW3P+mq6eOxEBt71jo4dAc+ta5YTCt4Xi8Slnw54TeuKoRMgFuq77Tzha+2IPZbr2mc2S4Kkeq
	WpPny5AOKEZpORNpWPj8sQhlmWtddfJzh+It95pJjfP9FsH+PF+ktlEIcPNSF8GUy9krM6lKgD08Y
	rV50YyKQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8j78-000000005P9-1EZO
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 17:42:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/5] tests: shell: Print escape sequences with terminals only
Date: Wed,  6 Nov 2024 17:42:29 +0100
Message-ID: <20241106164232.3384-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106164232.3384-1-phil@nwl.cc>
References: <20241106164232.3384-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If stdout is not a terminal, don't print the '[EXECUTING]' status line
which has to be cleared again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/run-tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/tests/shell/run-tests.sh b/iptables/tests/shell/run-tests.sh
index 2ad259c21644c..565b654e9f134 100755
--- a/iptables/tests/shell/run-tests.sh
+++ b/iptables/tests/shell/run-tests.sh
@@ -165,7 +165,7 @@ do_test() {
 
 	rc_spec=`echo $(basename ${testfile}) | cut -d _ -f2-`
 
-	msg_info "[EXECUTING]   $testfile"
+	[ -t 1 ] && msg_info "[EXECUTING]   $testfile"
 
 	if [ "$VERBOSE" = "y" ]; then
 		XT_MULTI=$xtables_multi unshare -n ${testfile}
@@ -173,7 +173,7 @@ do_test() {
 	else
 		XT_MULTI=$xtables_multi unshare -n ${testfile} > /dev/null 2>&1
 		rc_got=$?
-		echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
+		[ -t 1 ] && echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 	fi
 
 	if [ "$rc_got" == "$rc_spec" ] ; then
-- 
2.47.0

