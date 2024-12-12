Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5EA2135CB
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734007663; cv=none; b=kw0PMIFvZ/PbUxvkY2unL2taQSFlRmzC1wr/2qgoDqrgP4o3ZbYs/WNk4G9RfWE9xmHH26jQIvtK/2O4Memhoy935kShx9K8xl9hLrmY0qkOGI0Yc6v3z2r4666UdgifcCtEV21hx8thE29Dh4riHBFZ+S6DvRVDXD/ynvEDIqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734007663; c=relaxed/simple;
	bh=Z6aHot+7DVSARi6h1mdbOetavt/XVMvuZOGeaRyY+xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzZxUvTK6ULWT3GWrTrL8lQS4FcAw4dynOlcisMkwGmvBapSO7/GycOOWBPn2IK7thGiC0FkJflp3d2qMd23EBur0b8Qpi8onVB+u/P/HV4iJktZeGtirA4NJt8YkgNAXQPxvjNM+Ssbilu44Wqq0Zhh/pqs4zTTJBRZpz5SR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XGqf9dcs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XGqf9dcs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XGw2KrxEecHGpfO2085h7UbdT/9FJgxXqgUezHUtKX8=; b=XGqf9dcs9cFL0e3GJyFJRQ9hm6
	BvDxPm0Dspmiyd27kCzxpDu7tP9bXBp2Z6YYnjwNIleXsXjaBw3WMBCcew9BF5eCC0EescSk43ySC
	VD1LFppJ3pGSaw1wen3k9PJg8xs4VFMnDQfOr+ySRdFp4jRJFCnYlNRE5irnXiIP4d9n5NEBiECbY
	vDSxikGj2XWQwTPI1YSUh/x8vhuT6U5rlUeRq23WaQ8uObyLIKW+O9qaxl1gTd/vEAdnmkSJKl8cA
	iFq6XrPfItXI/MqxSvvCVEae1+Jo6mSCUT9z1yKLRy+gGi537JMl7SfHnT1g+2lB4Vcs+MEoTpv/z
	cpHiohNw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tLibL-000000000ai-1oNF;
	Thu, 12 Dec 2024 13:47:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 1/3] tests: cidr.sh: Respect IPSET_BIN env var
Date: Thu, 12 Dec 2024 13:47:31 +0100
Message-ID: <20241212124733.14407-2-phil@nwl.cc>
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

Allow callers to specify the ipset binary to test (with), just like
runtest.sh itself does, too.

Fixes: d05e7e9349bd1 ("Out of bound access in hash:net* types fixed")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/cidr.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/cidr.sh b/tests/cidr.sh
index 2c4d9399f02dc..ca01f063dee34 100755
--- a/tests/cidr.sh
+++ b/tests/cidr.sh
@@ -35,7 +35,7 @@ NETS="0.0.0.0/1
 255.255.255.252/31
 255.255.255.254/32"
 
-ipset="../src/ipset"
+ipset="${IPSET_BIN:-../src/ipset}"
 
 if which netmask >/dev/null 2>&1; then
 	net_first_addr() {
-- 
2.47.0

