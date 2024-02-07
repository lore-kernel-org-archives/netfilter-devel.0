Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7D7F7D4
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707318680; cv=none; b=iuD/omROlNrFeTCa0nDQjklrJcSgcgDtZLJN7/mSP6d8+uK4cMdlxiU5qGpzMFOPmzuHcAS1nc49gCaW8IZns4iIerU/pKClty+jccah7sCARbAM2BTEttAX48DGeUI3q1PHkk7/aLGdsUxcvlJzLWS3F8XV+wA/HzD3/PtRmtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707318680; c=relaxed/simple;
	bh=d+Wl13n505wLNh/+NaqjzHf7XZ4MTU9lK4v2CU54lQA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=H/Bkij3Dz44xhfzmw5lCdPDh+gJ5KSha/jfKKT4w3t24+QWgI1lICUn/Pd4fmiez2qFafo99lg++Jyfow2Q6ltqysWfwbL0kDSnUu6EQhSibBMBr7eb58QjnA+iV6+5KSQz6km6S7pXGKUpiFx03GYqMe5MQlGRYMn21ETVbyDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=aTfCo+aq; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="aTfCo+aq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1707318675; bh=YLe8v0Wc8OdU1JU7khGCXTr1AeNz2Lb+MgwS/o9/kDM=;
	h=From:To:Cc:Subject:Date;
	b=aTfCo+aqXZRrjYY/593m3JpV/DQ8Jr8aX1QpKgcFXTVEmMv4rTL2lRMe+aBVEFa7a
	 0OENICGNb47uB3MYFEVZR0VHFUirGWk7di7wlbJCadK5TBgFANgNR78R5m7yFR4b1k
	 oYGIF38fCVibATb5AtP8+2SHTmY5wrQfU0T5PLFg=
Received: from mail.red54.com ([2a09:bac5:a6c1:15f::23:3eb])
	by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
	id 2BB358AF; Wed, 07 Feb 2024 23:10:59 +0800
X-QQ-mid: xmsmtpt1707318659tsscrvhea
Message-ID: <tencent_FC8F6CE01EED438FA435FB1FD8337B3BCD06@qq.com>
X-QQ-XMAILINFO: OZZSS56D9fAjhxYV/uk0Bx25lg3x2k2lwTSOOJZ+0d5o+cllqu3BlfeZeRABsg
	 lgQiOwiyePjL07Da/C8WiT+k5Mgtv+y9NNQoS7tWI1nWxiZiVAhSaVdCAvR6bqg5a3Q++8faYTsc
	 tLjF022I5Cv2rpXyz/1YrlR76UDvNw8PtguagHW5yUmB1ezHnfqMBj7j1kkGeWCr/KVdr++EnK+R
	 wTTErMBzG865X0vBIR7X9BQ6Xkvb/ltvY2GVBa3FLmflxaIkbsii6BkO2wizik90oD5VOpAc1lWX
	 icOM6hTm9vToAJX/uwM1f9Won9lbVNkeGkN/1M8Wyxswu1ju/3JARyYyjJzZnhEINE93MrwUBRcJ
	 LpkX4Q3HhNV18bMD+MfUSoUu/szUIn/bdscixy3BRUg3GYiDj7FQH34cIHNjcouNQeVKMqDq1I73
	 +1AFLBziuxOI7cGch1PkZxwznHtGZ2iL8yFD3p4uLf+7cwaQuPEmi1SDc2vQyg6GoCRxQrzvsG2A
	 xbsY9gWqtI8+OaGgtE6p36z/ehk2dwq/6nPCExSPG4nMNbirKSA7Y9t3BDyQGTILvC+bHHoKRWg9
	 cMmZa8cz9RylkKgHyZZk/AoHzoVHhUmNItRz6bFCNdWYKyceCjYcERpF+duUyd++8TcUv14OaL/w
	 06vRQb+CM6fMV41gKp+Owyw3+P5lmzivNsr98og1WeYXAlmUMb5dn2ufqwci5UPn0TCPKO7Yj0YO
	 2UazLkMj/JU2WlKcKRqPD66p5N6pk25bIjf1US9Ohj0dkZguVTAzy6trZQb4xTfoQCyWSofkzz86
	 4LTSWbLLVhh/zJxJFmIqYDeJm264p1RPFuq9QjfOdW5QI145wH3YCCQ5EsEk1tK47ANJ/vI3ero8
	 yLcNJ++ywI7tNZqmE9td41zsgrT1NwdBwX3GIVKRxdvjLJWny5rRJNIQyIU+wA3wOKH7neL6lmhr
	 kj0Z0BoX9iczMwDZojsMs9HpzzdN2Z59opUV8jLbukrlPfOKU/DHZdSyRk3btAXjSrjpsaDL6kEf
	 MIcLGtoMZyn4TLYV5OAoomzlZXRf6SRPw5Q1Z6k8/BUMrn5V+M6mmDAF5NvDsB+7qQb7V7UQ==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [nft PATCH v3] evaluate: fix check for unknown in cmd_op_to_name
Date: Wed,  7 Feb 2024 15:10:20 +0000
X-OQ-MSGID: <20240207151020.6173-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Example:
nft --debug=all destroy table ip missingtable

Before:
Evaluate unknown

After:
Evaluate destroy

Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
V2 -> V3: Use array_size as suggested by Phil Sutter
V1 -> V2: Update subject and message

 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 68cfd7765381..57da4044e8c0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6048,7 +6048,7 @@ static const char * const cmd_op_name[] = {
 
 static const char *cmd_op_to_name(enum cmd_ops op)
 {
-	if (op > CMD_DESCRIBE)
+	if (op >= array_size(cmd_op_name))
 		return "unknown";
 
 	return cmd_op_name[op];
-- 
2.43.0

