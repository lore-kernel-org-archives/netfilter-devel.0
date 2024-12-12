Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BCB2135D5
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 12:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734007662; cv=none; b=CrSbnTEoR/TKZTdeHhy5nmCXo9D4n+gAYsnHOIvwEPO36LwA6kUMSzJwa76cyHm4biUWUdZDTVsa0UPH5E5YbXioNn4kHIS9g+w5DrTjYkfRGovyGzhkULfDRsNHU4LBPsljeK+NTdNj2yXi59KRUkwy4o1rzwCylroDnUiTg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734007662; c=relaxed/simple;
	bh=A0mVqtafhyCHRb9/n2ujUjjlm25qwU++WypifyqEvAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2lzyDRTA/V5+vpX/+vYljlQ2mk5yinF+OWlZi5xGNRZGkAzSnviMpsT3tHyBS55VWg2jwxvp9Ea5OjU9hC8IdgCU+MsqvRp2e4oNvGzhS7hypGqQpFEthAQAbLNW/DhSDcDQQSxnAHlM637/3hG3ry2WzA6viDL8FendjCX2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JZhqhtGF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JZhqhtGF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c9/JLQ/rzfZUdNWL3xlwp9KMs++QnnCPvZsmCRh8F4c=; b=JZhqhtGFvsqg9/8D1OIiGF2vFT
	aNaLiy5alwGxGMAAbPjPMqAtk+mpIVQJZw4UJzy65IKlpVUU4qAZgNhUqbwwK0j1RGAARzaPOOyTi
	vkOGLHIhFOmWahlZhzup8PUjEpwoY78DLii7uK4JvASlLlLorgk/z6zfpiiw5a5u/BgAwA+6FlMM4
	ITLGoYyVnXS8+1chyXoq4EElyl/Tftrzri9P0mUHMfbCizBMPYlofN8XiF7CsneX0mRpjluFPAbt1
	5uwBa1SMo7zeKlpanvMa/YHhylvOd5hDlxhvpLQPTEfB17TDrLKb0BONGWZ+HAqB9keG92F6qGFDh
	RZKybomg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tLibN-000000000az-0RMh;
	Thu, 12 Dec 2024 13:47:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 3/3] tests: runtest.sh: Keep running, print summary of failed tests
Date: Thu, 12 Dec 2024 13:47:33 +0100
Message-ID: <20241212124733.14407-4-phil@nwl.cc>
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

Do not exit at each failure.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/runtest.sh | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tests/runtest.sh b/tests/runtest.sh
index 7afa1dd0eb20d..fc4fd3c13dc6b 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -76,6 +76,7 @@ fi
 # Make sure the scripts are executable
 chmod a+x check_* *.sh
 
+failcount=0
 for types in $tests; do
     $ipset -X test >/dev/null 2>&1
     if [ -f $types ]; then
@@ -116,7 +117,8 @@ for types in $tests; do
 		echo "FAILED"
 		echo "Failed test: $cmd"
 		cat .foo.err
-		exit 1
+		let "failcount++"
+		break
 	fi
 	# sleep 1
     done < $filename
@@ -136,5 +138,9 @@ for x in $tests; do
 done
 rmmod ip_set >/dev/null 2>&1
 rm -f .foo*
-echo "All tests are passed"
-
+if [ "$failcount" -eq 0 ]; then
+	echo "All tests are passed"
+else
+	echo "$failcount tests have failed"
+	exit 1
+fi
-- 
2.47.0

