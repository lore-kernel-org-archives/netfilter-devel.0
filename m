Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB58F178CC8
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734007662; cv=none; b=CsUx3CXPZd/TFF2cZSZk4H3aKd36opouROxv3SrPZDESvGvpRLbBUXq0MU9Jt2MmHazkTIYAgVhTE8XhAKanD9Sz4kNL0WIJhLUZSEudUdCUv4SnYtV/Ry/v/fMX0pGa42YC1m7ve6J+Fm0oOe1cjtb6eE0dZDYA1OG0CLftoEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734007662; c=relaxed/simple;
	bh=4pQFFfEJyox85f2J8dFF4hal5WFitREZhm53zJRY7m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHsT2/OpxOdyCjTc1jhiUC/wLUc/ETyWUj/2mHIh6XQMWlGbOZREOKh5Oj6ZEWmLdr1YiVYFgXqHBTsttVSY3S6fBLlDynClAuJAgLc9M7r5jQDCyIb4LE0Fn4/8ZgpiXOX3l2JWsdfxkDC929HIcLnVhjWT2voWJ0I32qlBVcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KiRj95rp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KiRj95rp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TptV6C/Vt+5qdrtmzWM7GxLnaWbZiWugD0wAaY1Ocvs=; b=KiRj95rpG6jYqfFZjF5vO5mVZN
	NFgZcQh1OpUS+GQh5BDOG99rbZfs8GNxpzwTii82JK0o8Z3wX9K2Pn9haO6w62DJDDbquEvu4scid
	QYSFLIE0iHu3A5cl7wfAMrv5U3O6r3ANeut7r0jwFgFQb7wLdGRTubCO5Bdtr06Xsluho8ARtVEBw
	2dD8KCW0VU7An3vgLj9vVKXVpNkOb8Ytxr9pyVE0u/ZKQMokMqdwhkr1HPmz2GDwlEMjznLp2pzzk
	8CtIOW9a3l+DU4TKFWkv//rlzbtLQMlCZ0tI7xgaQPFhhA5LjNBlHqBS/fQI/fVvLB6w2S77cWRvO
	DYJT0Oxg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tLibL-000000000ap-42DR;
	Thu, 12 Dec 2024 13:47:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 2/3] tests: cidr.sh: Fix for quirks in RHEL's ipcalc
Date: Thu, 12 Dec 2024 13:47:32 +0100
Message-ID: <20241212124733.14407-3-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212124733.14407-1-phil@nwl.cc>
References: <20241212124733.14407-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RHEL ships a special ipset[1] tool with different output in corner-cases
than the common one[2]:

* Reduced output with /32 netmasks:

| # ipcalc 255.255.255.254/32
| Address:	255.255.255.254
| Address space:	Reserved

To cover for this, make net_last_addr() fall back to the 'Address:'
line. Simply adding this keyword is fine as in normal output it appears
first and thus the other recognized keywords' values take precedence.

* No "Address:" line with all-zero addresses:

| # ipcalc 0.0.0.0/1
| Network:	0.0.0.0/1
| Netmask:	128.0.0.0 = 1
| Broadcast:	127.255.255.255
|
| Address space:	This host on this network
| HostMin:	0.0.0.1
| HostMax:	127.255.255.254
| Hosts/Net:	2147483646

Have net_first_addr() fall back to the 'HostMin:' line in this case.

[1] https://gitlab.com/ipcalc/ipcalc
[2] http://jodies.de/ipcalc

Fixes: e24e7656b3dd9 ("tests: cidr.sh: Add ipcalc fallback")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/cidr.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/cidr.sh b/tests/cidr.sh
index ca01f063dee34..abb69b835ffd8 100755
--- a/tests/cidr.sh
+++ b/tests/cidr.sh
@@ -46,7 +46,7 @@ if which netmask >/dev/null 2>&1; then
 	}
 elif which ipcalc >/dev/null 2>&1; then
 	net_first_addr() {
-		ipcalc $1 | awk '/^Address:/{print $2}'
+		ipcalc $1 | awk '/^(Address|HostMin):/{print $2; exit}'
 	}
 	net_last_addr() {
 		# Netmask tool prints broadcast address as last one, so
@@ -54,6 +54,7 @@ elif which ipcalc >/dev/null 2>&1; then
 		# being recognized as special by ipcalc.
 		ipcalc $1 | awk '/^(Hostroute|HostMax):/{out=$2}
 				 /^Broadcast:/{out=$2}
+				 /^Address:/{out=$2}
 				 END{print out}'
 	}
 else
-- 
2.47.0

