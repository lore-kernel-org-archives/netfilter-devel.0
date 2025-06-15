Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE4263F36
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981629; cv=none; b=HNZWLUG0YGr08khrbjsIzFWihuZsLeQcSyd9meDEiwDYamzDEdaN9wSGMqXDkDhmxT16s4xfckD+QiFxCFXF96YRWTg6RT2NVE7X3kj0sCYIbuGZUXHk02wJA08fShQjiVDVfut1KEYPpUhDDdsT4CPozROv+PK9z8zkoYhpH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981629; c=relaxed/simple;
	bh=OjeIv9IzR1aF5sSM+dI45pdexUD67HBq98prlMZiFoM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CK2+gDlwXPOpbmxYFV7jiSDgJmEYrBl27xNPzT9jnIKU0T1W1HoryrNvhO3RJDpYazvCA+MK/ENExyv4KxmbBujqYUGyfLNpUSFxT8ABGjossyZWcnWz2uyBdGqa5og+aWV8Cat5Cxu9+X15EmBZbf49OCI0xu+S+W1jRSEFfHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aWMBKEHO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aWMBKEHO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aWMBKEHO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aWMBKEHO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C1C25602C0; Sun, 15 Jun 2025 12:00:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981625;
	bh=iKupuRvdyEni6mylGAC9I2Hzk98i1z17/shiwGSYTEg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aWMBKEHOb7E2SsW2NXwL/ssog7XvWMC2C6Qy/Z/mQgTUhBZqxtmQhxmcYj5Zw4o7s
	 LyXk0eNayHnzoCPEB82WX1tRjIRWKPGRf2S5K0q5zXsC6kizzEK2uM/P13fWmeuoYf
	 fhqicUGls0ojyXgjkQLSZpAfRxpuMPW3Sc+cHtgdy8H7sYtZaivbrV8wiBR0t4BfTj
	 TSW4ClmzDNwU3QbG+KlgqIeH6JQBnUtWT97WM6JAx2xcEv158vv+nBqQryoHSfLw2D
	 hmSLX3Tv0B+g34RzH9DPeBjG9C0I84u3T0cDE4q6JcKmqWygzPv/cjJgPO7Tfi+pUt
	 Rk04BHTNZucZA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 33C70602BC
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981625;
	bh=iKupuRvdyEni6mylGAC9I2Hzk98i1z17/shiwGSYTEg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aWMBKEHOb7E2SsW2NXwL/ssog7XvWMC2C6Qy/Z/mQgTUhBZqxtmQhxmcYj5Zw4o7s
	 LyXk0eNayHnzoCPEB82WX1tRjIRWKPGRf2S5K0q5zXsC6kizzEK2uM/P13fWmeuoYf
	 fhqicUGls0ojyXgjkQLSZpAfRxpuMPW3Sc+cHtgdy8H7sYtZaivbrV8wiBR0t4BfTj
	 TSW4ClmzDNwU3QbG+KlgqIeH6JQBnUtWT97WM6JAx2xcEv158vv+nBqQryoHSfLw2D
	 hmSLX3Tv0B+g34RzH9DPeBjG9C0I84u3T0cDE4q6JcKmqWygzPv/cjJgPO7Tfi+pUt
	 Rk04BHTNZucZA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/5] parser_bison: only reset by name is supported by now
Date: Sun, 15 Jun 2025 12:00:18 +0200
Message-Id: <20250615100019.2988872-5-pablo@netfilter.org>
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

NFT_MSG_GETSET does not support for handle lookup yet, restrict this to
reset by name by now.

Add a bogon test reported by Florian Westphal.

Fixes: 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                                     | 4 ++--
 tests/shell/testcases/bogons/nft-f/null_set_name_crash | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_set_name_crash

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ed6a24a15377..87b34293d22c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1757,11 +1757,11 @@ reset_cmd		:	COUNTERS	list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
-			|	SET		set_or_id_spec
+			|	SET		set_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
-			|	MAP		set_or_id_spec
+			|	MAP		set_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
diff --git a/tests/shell/testcases/bogons/nft-f/null_set_name_crash b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
new file mode 100644
index 000000000000..e5d85b228a84
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
@@ -0,0 +1,2 @@
+table y { }
+reset set y handle 6
-- 
2.30.2

