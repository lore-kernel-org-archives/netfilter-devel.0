Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C0539AD5
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707206442; cv=none; b=o9uUez3fdPfSTpHhQ9PvkTpLe/dFMNVg39GChFJ8s7MNid2PJDQM1oqae3YS3tO4lv/vGRSWCeP/IUdz5+Lp7cKzJ5eLuK1fNKKOrNtKZv1eX3mCwWO6s3Tr1gJugbYtV9bnKduWAK67bfThLEIWJUdBtJC1ohm2SeIdCjcqqOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707206442; c=relaxed/simple;
	bh=RMbQI4+hPIuYrwIdYeib6e0lZG5DvtVtP0wag5Fz6NM=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=LIAeXfZ45SpqYFPeAKOFX28T4rLKOPPBhM4rPDmFtkQmY+pgcG/ppgIrP/VTz/sdmwFZGWmF05Qedf7TxAwvS7/5KAgCFP47exYhcWNHKmejx8zdDkrsKjwMAqlyuoHE1ALjbjEyAFPuuwoGD2LMVL6NOUwHfF3WsMYpfqzHITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=QQGlaBWT; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="QQGlaBWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1707206428; bh=qlIBbiH/8kqeiOBSHS7mTLIsx53GukbXv36RMKntQYg=;
	h=From:To:Cc:Subject:Date;
	b=QQGlaBWTMS1kzsu5s1MmQEdqRo/hszurjR3UCLVb4ZBD0Gey2JbFgN/BHpigkDIO9
	 bUAAMmFMGZl12q4bzdXWqGxzYfRfhbekJia9lEvlyehQNGdFTQC5EbLqSV9ZsC5gVz
	 MPAcZHyGtzikOuc+nvVNH3pKe8ytRKdCam2tR2w0=
Received: from mail.red54.com ([2a09:bac5:80ce:18be::277:44])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id 15114E6; Tue, 06 Feb 2024 16:00:21 +0800
X-QQ-mid: xmsmtpt1707206421tujcs40bp
Message-ID: <tencent_EF81CEB49C3DFFD67C7F9FCFEDED323F1008@qq.com>
X-QQ-XMAILINFO: M7uElAZZZMmFgjhZ8GTJzWw/qRiWQ8+JO+yJ4//zy1LKVzxf1YZzPK6+pf+cCv
	 wtHQ8PAyDsEpZoyyk66l/utSzL6ggUmqpe7g5ztYaYbUxFCR6hHTC+r/iH2ewsHH+n5VDfYtrq+f
	 fS141xxlQES7kPOBpEovWj7YtL57r31KFwSqtI2V5nqTcg38k2G81EOGRSh3ptps0btSfAzhCfvB
	 H5P4ZRtXT7eb5JYa8sj6KxcY/vqLmF7wY41zjbL6r10OZHzhbmqbtmZ/uXRvDooPTLVyDrAi+y2/
	 PNmgYD+tvRXv1LXrZWLAeEeQ3eDBNvA8bAnflO9ZyjIt0DHoR0GHgw6RRwfJdP/9GzukSzMoOISu
	 lcnEE2Q9E0HI+BJHNlPprqQHUSEZkJ+3uOKlesFmn+Kf/Jm7y22+gS3jo79C8h/jmH6w7xc6Cfx2
	 w2mHkouTXOlHzMZ7jFOqcJ20kD98TUrhv9hf1V/ZafsgVqPfMgBnGMnzcWE9H5J+epNrLUviyAaK
	 6OFcNI1Tweh8Pzhfm43tqry11Crj6pJJ5gR4D27KF+FPDOdtcM5oeX7lpU8qglV2gz2ww+M4s0Sm
	 f6fF8C+4yjACXBAiQXi79zFxFRIibH2iV2sy7ZDPVRmXtdcwx7sFn1pIjVA8rtxrZCRP8gNNexSf
	 Hlwcg3eK/IdmGXSDLmIkgZHNjqa8Ghk8WdE32Rw9hUKcUmeiaQSo4UQ7ffZN+zmc47nc1QUqIp4i
	 igev4DgpJGNh14VjhdGLGcqAGs2uLeElOtRfJLbNmDRz7b2ID79F3mcOZyJfIQl1YlM22BH1zlnG
	 FVAOv2m8MBG7pRwj4BbyQWlieS/iMsPBDA7FoTsOcYMV/ogpvo+7NzZ/OV2/BefK8Onz2NqWLAL3
	 FVETTHhY4Mb8qt4UnQqLjpAUzfWCcQ0u3wuxkOyRF2U45a070DGzaFc6eGf5zxc72wZdtpDTnVyL
	 o7edTrboj97z7PomGVUhA6lSWsoX8cwhW3/kSFf0U/gjD2o4HGHWd5e7TFhFfiMwlSK2G3LObI59
	 C76HT3uX5ZDb0NqPqvqdCLUql3pChByRPat5YAODkeWDUmpkYK1qpN8Heno7bg99/x1LtB0Q==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [PATCH] evaluate: fix check for unknown in cmd_op_to_name
Date: Tue,  6 Feb 2024 08:00:14 +0000
X-OQ-MSGID: <20240206080014.58080-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
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
+	if (op > CMD_DESTROY)
 		return "unknown";
 
 	return cmd_op_name[op];
-- 
2.43.0

