Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556D168BD
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 10:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726742650; cv=none; b=YoXK5DbukTOjX0gpCjAr43UjgYH8U8DWaQoYviCcRZhdQdatI0S0uiSb3N59soCrzktfGKcYiHNSBH9j78x39ZO90tnd/Tqt99wJrWAUucFPirCfMbGLut8zht/MuhJvW0i9VXEFNjk6nBERSrfg8zJ1Z1KpjrhRNd+VF8046Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726742650; c=relaxed/simple;
	bh=vB06LzafELi1DtD+VjDu6fLDt/zuNI2pJ+xIKiCId7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pazejAW6VYatk1umdIIT3FQ6pgnGnxvHpr85amEIctzpncL/kl0+dh9zUcWfhMtHeEypseC80w8GBXMFMj6qoQY/tbetYr+JpacMLGlo5eWTUszvLiCrdjz3mqTWrB5uTASd3+hcz6JVhQyeweP1FdHvnSlia32E38sbY1/eRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RzluevfL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RzluevfL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tFuiyzpSN6voI2M/A/4zlfNW5jiOfb5RlOaqM1kvvWg=; b=RzluevfLzw/q3hnk/1fcK9vkMT
	dwDpayaQrm5PpCJ8EYqhxF5k9YFprJynddElhera4mHqqUV3EfzwIW6CU0WJkAvyHmX+sDPTjR/y9
	8mAMPD2HmgpOQAaouc+QnGz1tBLG7zlmlQTwGT1tTUm2AUwfO59JQYFdcfGkwwoAxyEZ5ePRJx4uq
	qPpxNtXUhkO8JAd7JRMPoV7SiC1AyYrKtDIi1C7nnivUM1lYrqy7CR/5NBsTUz8YBM9xUuycTFurw
	N7akrfRgUusEpU8chDn6PYmjJBThkUlyY344DkMAL6LKf5Ud1jM2DSA1rBBSbAi978uuLAHkYmPpt
	idyILWtA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srEdk-0000000023q-1mKx;
	Thu, 19 Sep 2024 12:44:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH] selftests: netfilter: Avoid hanging ipvs.sh
Date: Thu, 19 Sep 2024 12:43:56 +0200
Message-ID: <20240919104356.20298-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the client can't reach the server, the latter remains listening
forever. Kill it after 3s of waiting.

Fixes: 867d2190799ab ("selftests: netfilter: add ipvs test script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 4ceee9fb3949..59d7aecbd887 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -107,6 +107,10 @@ client_connect() {
 }
 
 verify_data() {
+	waitpid -t 3 "${server_pid}"
+	if [ $? -eq 3 ]; then
+		kill "${server_pid}"
+	fi
 	wait "${server_pid}"
 	cmp "$infile" "$outfile" 2>/dev/null
 }
-- 
2.43.0

