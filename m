Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F218FDAF
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743170971; cv=none; b=fknHrenKsxw9mPofAhOk0bUvWrVyOACXjvZtbNdpPyBMKg/2WrVmotw/EL8WfHMNj+9aSMyInsa+Ugsvo5nHwCgCuBXnZBj2VWiiJ0gJRF/ddkIOYX2W5wGCHrjm3G/bPruqLY8EnmnNijeUUNDBO9CXX7xWsqP0rzwZm4V9kx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743170971; c=relaxed/simple;
	bh=QmFbpPZALdPlf7tMwkQ1gqhi08h8/VXATosCGXCBkuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kMbeBDo8oAZkaopHNTYeqa1o3daU3DY1gqfj9Vgbx90qxpVCf6oBdlwp7lal9UBHltJWDGsnRl/K9xgSJk5en2x8XICKMQHqdb/tj+UinCr++MntG9XLwPA/JwTC/THQYI3qq5rXjudbQcN5cZxm/Vj2nFG87lioNMFhCoHviR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CxGki/h3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CxGki/h3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1qycJPMoyIY+VR4uWexOvFHe1Nq+DPQGCOZMAbv8euw=; b=CxGki/h363kVtVNPruyQmp2tUC
	5smJcRUG3vrF4LeFnMoEvfTpPWWxMwWJrjwJpnKhbY1aSC5D/5mmA1kh4UwJFQybnmL2nwmQx1xaD
	oFlUPfyFIy62iqgndQCEjF3UzEcuJJcJIzVsQPSBcYXlmY2m+uFXhEuU/9zry2puDgQE9o7UYrL3p
	PwGpkcF2+7ZtpDdbvmlQXEJ+nqcQ/ry96sGJx05P+orrMdAzsEUe1oIajmL0TJP5CjVMEA31P/IN/
	RqronnlgqGhTpZ6561W5N1qUTu/lHq1abeXDt6kcb2HsUtK/B/iVuBmIU3F1qniZjho1AGBJlUfSt
	iMvpLaFw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tyAOk-000000007qI-1s9i;
	Fri, 28 Mar 2025 15:09:26 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix owner/0002-persist on aarch64
Date: Fri, 28 Mar 2025 15:09:21 +0100
Message-ID: <20250328140921.15462-1-phil@nwl.cc>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not sure if arch-specific, but for some reason src/nft wrapper script
would call src/.libs/lt-nft and thus the owner appeared as 'lt-nft'
instead of the expected 'nft'. Cover for that by extracting the expected
program name from /proc.

Fixes: b5205165bd708 ("tests: shell: Extend table persist flag test a bit")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/owner/0002-persist | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/owner/0002-persist b/tests/shell/testcases/owner/0002-persist
index 98a8eb1368bc1..700f00ec5e5f1 100755
--- a/tests/shell/testcases/owner/0002-persist
+++ b/tests/shell/testcases/owner/0002-persist
@@ -47,7 +47,8 @@ cat >&"${COPROC[1]}" <<EOF
 add table ip t { flags owner, persist; }
 EOF
 
-EXPECT="table ip t { # progname nft
+COMM=$(</proc/${COPROC_PID}/comm)
+EXPECT="table ip t { # progname $COMM
 	flags owner,persist
 }"
 diff -u <(echo "$EXPECT") <($NFT list ruleset) || {
-- 
2.48.1

