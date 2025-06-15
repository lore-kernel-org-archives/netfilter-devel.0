Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644CE265296
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981631; cv=none; b=DmGfiBeMb08Oas3BYKLkSzHsKE2wCZTtVR19n/fDQAlA8lMZ8bm4yGQKS4wuSJHNzUBcpWagJvDA2C5cXYbq2xwVhNhYcJkNHBM7hS88SojQwNuvkWNtCTftwHVqQdMVWTGoaLjYzcxs4LdR8eq9xP4Sv/zLqof+l1DvSb8cy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981631; c=relaxed/simple;
	bh=abvecUe4v16637JMVu4nQU8v000BCufoNCPxdEyzu7o=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=olyigsNnapdnC2y5ilyH9ROL2oktwtrsBA1xAk9+t6r/3KGXVzpC8HqjhMuGJ8KRR5C/qecdqfXBNAWJZle8mGGX8aYpbbg0BkG9kNg+6EirwdA/dYh3Ds+4X4UfbE5UEOYttiDfDx6WAyhJziAuEFWlz/4MhAhAFDx36mLnDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jdmywJcS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jdmywJcS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jdmywJcS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jdmywJcS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C96D3602C3; Sun, 15 Jun 2025 12:00:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981626;
	bh=L5JVudrn9CwlzdjWvrXU7QsG3JMBjY6ijPYSw8pxJnY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jdmywJcSRxbE6wtybGaB0wsnIutaCfT4q6DX7qaBzMB2Qq4E4fNctuN/jrO2hSKvZ
	 sACSRHuvCf9Tleo/Ty7OiIsk7qjw1ob7LjlBPyAHjLCdsOGaFXv/OxWPOD190+rU9Q
	 uQYJeGjYfSRJ8G+5YzdB5MqaHQu6V2MdlCmsjCT69jYjlZgS4UD7/F8DXEVSGp2M2d
	 B5EIeJmGdhLvGVz2Ubm2uQSwCgq/6leF9Uk02bs8OqbTcHmRtSw7MNcpjXudl9E8BZ
	 KZGUltU/X7RIkcPCjg7gUspOr914w4z+6QdvNlBp+0dBQPnxGRmt2rbVWtXq7Xi0a+
	 75oAi/cLlsiXg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 63CF4602BC
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981626;
	bh=L5JVudrn9CwlzdjWvrXU7QsG3JMBjY6ijPYSw8pxJnY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jdmywJcSRxbE6wtybGaB0wsnIutaCfT4q6DX7qaBzMB2Qq4E4fNctuN/jrO2hSKvZ
	 sACSRHuvCf9Tleo/Ty7OiIsk7qjw1ob7LjlBPyAHjLCdsOGaFXv/OxWPOD190+rU9Q
	 uQYJeGjYfSRJ8G+5YzdB5MqaHQu6V2MdlCmsjCT69jYjlZgS4UD7/F8DXEVSGp2M2d
	 B5EIeJmGdhLvGVz2Ubm2uQSwCgq/6leF9Uk02bs8OqbTcHmRtSw7MNcpjXudl9E8BZ
	 KZGUltU/X7RIkcPCjg7gUspOr914w4z+6QdvNlBp+0dBQPnxGRmt2rbVWtXq7Xi0a+
	 75oAi/cLlsiXg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/5] parser_bison: allow delete command with map via handle
Date: Sun, 15 Jun 2025 12:00:19 +0200
Message-Id: <20250615100019.2988872-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250615100019.2988872-1-pablo@netfilter.org>
References: <20250615100019.2988872-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For consistency with sets, allow delete via handle for maps too.

This fix requires the handle hashtable lookup infrastructure.

Fixes: f4a34d25f6d5 ("src: list set handle and delete set via set handle")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                                            | 2 +-
 tests/shell/testcases/cache/0008_delete_by_handle_0           | 4 ++++
 tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0 | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 87b34293d22c..9278b67a2931 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1450,7 +1450,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
-			|	MAP		set_spec
+			|	MAP		set_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
diff --git a/tests/shell/testcases/cache/0008_delete_by_handle_0 b/tests/shell/testcases/cache/0008_delete_by_handle_0
index 0db4c693f6d4..9eb75e6ce374 100755
--- a/tests/shell/testcases/cache/0008_delete_by_handle_0
+++ b/tests/shell/testcases/cache/0008_delete_by_handle_0
@@ -16,6 +16,10 @@ $NFT add set t s { type ipv4_addr\; }
 HANDLE=`$NFT -a list ruleset | grep "set.*handle" | cut -d' ' -f6`
 $NFT delete set t handle $HANDLE
 
+$NFT add map t m { type ipv4_addr : ipv4_addr\; }
+HANDLE=`$NFT -a list ruleset | grep "map.*handle" | cut -d' ' -f6`
+$NFT delete map t handle $HANDLE
+
 $NFT add flowtable t f { hook ingress priority 0\; devices = { lo } \; }
 HANDLE=`$NFT -a list ruleset | grep "flowtable.*handle" | cut -d' ' -f6`
 $NFT delete flowtable t handle $HANDLE
diff --git a/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0 b/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0
index f0bb02a636ee..dd390e73c8e8 100755
--- a/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0
+++ b/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0
@@ -3,6 +3,7 @@
 $NFT delete table handle 4000 && exit 1
 $NFT delete chain t handle 4000 && exit 1
 $NFT delete set t handle 4000 && exit 1
+$NFT delete map t handle 4000 && exit 1
 $NFT delete flowtable t handle 4000 && exit 1
 $NFT delete counter t handle 4000 && exit 1
 exit 0
-- 
2.30.2

