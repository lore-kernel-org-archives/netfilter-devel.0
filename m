Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3D21A76B6
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723633655; cv=none; b=V80Gg075H08jwYi0g49Yo/t6nIyP2efXQ7KEvb+d1Yr4n8CPlOhfdYFTeM5z1K7cnYjwta7k8PPKXoqRQgmT5e8UjDNTPx/RU18qlhnDc9Vq29jLGoPuYZhrRaDfsm6OAMUmVCZGMAQnE2kSb931uHQ/Pu0OMKkNQSl8eRhAV5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723633655; c=relaxed/simple;
	bh=96JH0GKWLIhkF2WBCrHurppIYq6KKDfTqHdZC/PNuAM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ciDRME+vKJwq3Wk/HDED7g35GY4EfuV3Crbjx9XdrroHxSgHlzxdIECLBmDp49iTDb0nZVOYaLWfCwZXVPJveV21HOjO9ZjhhhzKpuA4RuxwloPCdnPf0Ozq2YBunoidPSbRYU7TMehABfEUpSLmxSfBRAyIKFLskBd+Xz820VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] datatype: replace strncmp() by strcmp() in unit parser
Date: Wed, 14 Aug 2024 13:07:21 +0200
Message-Id: <20240814110722.274358-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bail out if unit cannot be parsed:

 ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
 add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
                                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

improve error reporting while at this.

Fixes: 6615676d825e ("src: add per-bytes limit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index d398a9c8c618..8879ff0523e8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1485,14 +1485,14 @@ static struct error_record *time_unit_parse(const struct location *loc,
 struct error_record *data_unit_parse(const struct location *loc,
 				     const char *str, uint64_t *rate)
 {
-	if (strncmp(str, "bytes", strlen("bytes")) == 0)
+	if (strcmp(str, "bytes") == 0)
 		*rate = 1ULL;
-	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
+	else if (strcmp(str, "kbytes") == 0)
 		*rate = 1024;
-	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
+	else if (strcmp(str, "mbytes") == 0)
 		*rate = 1024 * 1024;
 	else
-		return error(loc, "Wrong rate format");
+		return error(loc, "Wrong unit format, expecting bytes or kbytes or mbytes");
 
 	return NULL;
 }
-- 
2.30.2

