Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A7B19413B
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728638717; cv=none; b=HUXMYKlJMQYwUEypY1s0VFm0Ym2gSQThRTEJtdtLkv+PAKhD/CPEleCUd8Y6sgflb7Dc6/MWLTTyiG+rLOd8AoPkC5QTc855s15AX7ivawHkOIvSLf7gW2ynwtH+4JS0CGNW8SLiPzhEFSJ94RCv5TddIr0ezGocZtIJfOD5m2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728638717; c=relaxed/simple;
	bh=68PLdg+1vaZ2AQgMnVAOlBaw/ZqAqF7Cho9tUW9LWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Brt2pHYrKPXLeDg4RLC4h3z1GYTebkwyAsonWSwo4fuul9B0Xki8OOXiPJPPLxaMEeOfrd/t3x5aDdYanodbeVz4DI6zX3TLJZAZYE8S1Skud1eFrlxFRyiNHb6aq2adz3V6UBJk7aEV8ILkG0new6vMYWwLWxb70p7SdB41sBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NxQya7iO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NxQya7iO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xoXvS+7VjAfrQCTKlry1BDLvsBXqZdPZRYcm6GN1zfY=; b=NxQya7iOf0N86eaNCZRjDYDt1H
	E5oK/qkvUYfbB24wd8p9QhiLPafcLoN3SwK34vSa1Nem7ibhDiFGOOeVNE5o8gxQ+6GeFQGbgANyC
	Ue7uaOYyGmDauTdzP9/Hx46j4LZkRWbHF7miNlSLmRLiLd7ASQjomK7ctzK0iC5f7bjHP4cS3kq5J
	kz6c7BSpUgQ578rJEKVcYXOqKCUJavDYZOJ10uMDTLteTMk4HW0Ram5Id8GF4D22/fJ16ZDtr0Et3
	ARfRoxKfFtMvYjfxwAv1Mr+NX9mHxL56xo5ft9C2JDwr8DPAoYF2MPMJr5Fw34LP1MG9hBT7oQQsI
	oDaGwJww==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szBtX-000000001XN-3Crk;
	Fri, 11 Oct 2024 11:25:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Join arithmetic statements in maps/vmap_timeout
Date: Fri, 11 Oct 2024 11:25:08 +0200
Message-ID: <20241011092508.1488-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In light of the recent typo fix, go an extra step and merge the modulo
and offset adjustment in a single term.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/maps/vmap_timeout | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index 6d73f3cc9ae24..8ac7e8e7684ab 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -9,8 +9,7 @@ $NFT -f $dumpfile
 
 port=23
 for i in $(seq 1 100) ; do
-	timeout=$((RANDOM%5))
-	timeout=$((timeout+1))
+	timeout=$((RANDOM % 5 + 1))
 	expire=$((RANDOM%timeout))
 	j=1
 
@@ -28,11 +27,9 @@ for i in $(seq 1 100) ; do
 
 	port=$((port + 1))
 	for j in $(seq 2 400); do
-		timeout=$((RANDOM%5))
-		timeout=$((timeout+1))
+		timeout=$((RANDOM % 5 + 1))
 		expire=$((RANDOM%timeout))
-		utimeout=$((RANDOM%5))
-		utimeout=$((utimeout+1))
+		utimeout=$((RANDOM % 5 + 1))
 
 		timeout_str="timeout ${timeout}s"
 		expire_str=""
-- 
2.43.0

