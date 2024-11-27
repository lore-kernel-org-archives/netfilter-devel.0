Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1A1B815
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2024 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732730470; cv=none; b=Prrfzh3sWBHyKGHaleG3vaXu6VPtEneFxlyWnr/fcGcGji6bkYRlm7qo8r6164fOUIbo0h5FZ9aTjzvBQo+emmenQkOdNUgMfAnPbQRz9G5HhRd3RgcSrjd106EDkae2JM3/aOVH4H/LP47gkx3ODWbVXDVas+dTajGqOdLphF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732730470; c=relaxed/simple;
	bh=zRR1q2Ipkxr+TcOJUAV2dNWX46xW2DxgXINyMNYbrJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WcL8fWeND99EWU0G3ksEZyZUrKAb9sbx7k5JNsywprJQXbDsHQqxIujjndj086YaAq1mGF8U4nFC9vkviNUFjVtmGx6nMKPD2vCUqiivGPkjb98sFNPJwhkRBrgbu3vahHyqwFfULMYtkbpL54/Skn7Fl3qvH0/EBRF9XZGbG1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OWWIxPVF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OWWIxPVF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tfTz6I9KU5bQKwl7sqAr9zyGEh+sdZOc5iSyxIzWMdo=; b=OWWIxPVF6OgXI5NvG9jBfjG+Pb
	BiX0k7lXKHJHgTXpi6WLVpUM0CX7nGSCWTEr7m5bodrf+zQ0UEbMR6kKqlau0Ray4w3ct6JKR/gMy
	Ikk4nt5PpAE2LQ34u+I7Q1HCaa73nL7nQrhf/D2IPr+nAupWUwvhTk4yiJg+YXYbVnDbPLGZXuH9f
	isvyVLxLgjpInV6Ba7y+iYKG2UzixYXnB9LKrgMW5DmTJ6elLRKtUtlCRwbrGMIllJQC3YTVfgdxh
	C6czDUdFstk9V3/prMyNCfnU/E9biVNtqkghJmHWqj4f34CQryW/UnDi7TjmArk3Ejl3AR3/D+oKF
	GPS/5J6Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tGMLU-000000000Ez-3XnT;
	Wed, 27 Nov 2024 19:01:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/3] set: Fix for array overrun when setting NFTNL_SET_DESC_CONCAT
Date: Wed, 27 Nov 2024 19:01:01 +0100
Message-ID: <20241127180103.15076-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assuming max data_len of 16 * 4B and no zero bytes in 'data':
The while loop will increment field_count, use it as index for the
field_len array and afterwards make sure it hasn't increased to
NFT_REG32_COUNT. Thus a value of NFT_REG32_COUNT - 1 (= 15) will pass
the check, get incremented to 16 and used as index to the 16 fields long
array.
Use a less fancy for-loop to avoid the increment vs. check problem.

Fixes: 407f616ea5318 ("set: buffer overflow in NFTNL_SET_DESC_CONCAT setter")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/set.c b/src/set.c
index f127c19b7b8b8..5746397277c48 100644
--- a/src/set.c
+++ b/src/set.c
@@ -185,8 +185,10 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 			return -1;
 
 		memcpy(&s->desc.field_len, data, data_len);
-		while (s->desc.field_len[++s->desc.field_count]) {
-			if (s->desc.field_count >= NFT_REG32_COUNT)
+		for (s->desc.field_count = 0;
+		     s->desc.field_count < NFT_REG32_COUNT;
+		     s->desc.field_count++) {
+			if (!s->desc.field_len[s->desc.field_count])
 				break;
 		}
 		break;
-- 
2.47.0

