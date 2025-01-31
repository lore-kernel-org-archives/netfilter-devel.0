Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E8D13A3ED
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738320450; cv=none; b=Hm7jOHgkYNlf/zviPd5cz1DZvt6drXlZi+4H8T0BGCB59UBP/6thl0B95UKPZrAkwqOZ5fh9lu47xJx9nuJi5qfWCV46w+FGvawCBzxe/n6RMznO1FH05kD6jDdscvaMHyJbmCjvr6R3K/6UrWO6hzyKXFEUePVSyOWczifClXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738320450; c=relaxed/simple;
	bh=yv/Ccw2YX+5HWfqI5pUJp2/zFa16qcYmks81nQPPDw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bMt3syD3nDV4uzVkSdUQtG27YqtfL861yg7BuXYbP1wmvOVturJSDsRb36gxss1GNSMRPJoOHMPadpl2E/rmLKkTt+Oaj3dOkuMIqWPXbagcdcEYTPUsAKJvSeSBLuknG9EzX1OJMQJzq8MFNriZ0jTWZZpqWaQCx2+WnZfg/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jq1EBcLx; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TZQjsRiP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jq1EBcLx";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TZQjsRiP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 127A260287; Fri, 31 Jan 2025 11:47:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738320445;
	bh=YHcTeiBB2sTuV+mqupoOxJTSiFT8BjR0jvFS5S3IopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq1EBcLxDDGxLSzy/5trHxBREmYqf0WTPu2VJOlAfftpOrl3j6CTbhtJjuV6HRmk+
	 3a12EKh998Q7iAptz7Oogm1Vg77Cri5oDRGwq5CKbOpmjFS1NBBfDiqRagCQsj7SDG
	 ocGBhRS0sk7o4/PbHlM64eUV+NR+jEGKTxm0E/cMf5a4srIzhh4xlKBNGLidCFU65x
	 fv7cbTBfdWtCjlSA/Xe9hrVAI6fhogySjEk4Y0eAIflKoFpko+ihrGDtWGkZJHmTrG
	 N+1pPqWF+X+AeFdVbvoEFO2oKr6byjDTZGYelpdViEKH7FzGZbK5L89yqk+e/C5h9K
	 ziS+J2m8imW4Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6E63C60289;
	Fri, 31 Jan 2025 11:47:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738320444;
	bh=YHcTeiBB2sTuV+mqupoOxJTSiFT8BjR0jvFS5S3IopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZQjsRiP5+mi53ODRzVfgS0uRmz2sMotnPwNiAffd+IauilriiEmu5nD4Pe0CJjZM
	 x7/dV2VSKfDwLOnxD5/PkNylwBYVUj6PQfcclt5ucWEuwzvqRB6qE5zBJF+Y3kmkwM
	 5IqDkN9Y7Lpf46SVJMiahJopmJvRVOY3sW+/sWWTPJokzdZbsivQVvTsDVzrfkMh/H
	 nkeEPZRurnzl4HuEPBm6wZMVzx8/A/jIeUsixEjW74ytHsHFmeBe6eZrxop1lfq2z/
	 FuJBS8ygKZjNlO2gMBJEYgR2zSQqRc0DzfIZkXcoHiTHQ+88EBILh0F3ZW7viwIb/p
	 2smSoKWXnilXg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: akashavkin@gmail.com
Subject: [PATCH nft 2/2] parser_bison: turn redudant ip option type field match into boolean
Date: Fri, 31 Jan 2025 11:47:16 +0100
Message-Id: <20250131104716.492246-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250131104716.492246-1-pablo@netfilter.org>
References: <20250131104716.492246-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ip option expression allows for non-sense matching like:

	ip option lsrr type 1

because 'lsrr' already provides the type field, this never results in a
matching.

Turn this expression into:

	ip option lsrr exists

And update documentation to hide this redundant type field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/payload-expression.txt | 8 ++++----
 src/parser_bison.y         | 3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 7bc24a8a6502..2a155aa87b6f 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -808,16 +808,16 @@ TCP option matching also supports raw expression syntax to access arbitrary opti
 |Keyword| Description | IP option fields
 |lsrr|
 Loose Source Route |
-type, length, ptr, addr
+length, ptr, addr
 |ra|
 Router Alert |
-type, length, value
+length, value
 |rr|
 Record Route |
-type, length, ptr, addr
+length, ptr, addr
 |ssrr|
 Strict Source Route |
-type, length, ptr, addr
+length, ptr, addr
 |============================
 
 .finding TCP options
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c8714812532d..d15bf212489d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5698,6 +5698,9 @@ ip_hdr_expr		:	IP	ip_hdr_field	close_scope_ip
 					erec_queue(error(&@1, "unknown ip option type/field"), state->msgs);
 					YYERROR;
 				}
+
+				if ($4 == IPOPT_FIELD_TYPE)
+					$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 			}
 			|	IP	OPTION	ip_option_type close_scope_ip
 			{
-- 
2.30.2

