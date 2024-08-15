Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25011AC451;
	Thu, 15 Aug 2024 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723710536; cv=none; b=K832ibX6m41wU6FkgKlWdN+1MVeOjqoqerm+pK92JwVcI+SVhzNUMqVBrbW1YffKRrWIuqNx1+bo3LPAfsMx8xHKD7HyE8pu4MfWB7cW05W6twGX+iJQ/VAReB9cnA/GKeYnWCT2o9MRApxyoP66F6D14yzCXNuTmNbXtdxAHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723710536; c=relaxed/simple;
	bh=pYiibuPCOQ+DnlvpyzyPHr7ObAv45Sa/IJPwOtF5a28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gN8QP3jz5Z7koSvTI56kks7QmNoG/aJh6sDkgh9b3cBqclfCO/2dwCD80VpNUaO7EcwOAA4g8xVNufstD/ffGttS1rltwXODgqmm1Aou0F2Pne8qJFpBNIwxpoaBM5SL1cJ5Vk1Z9AJ5sIa0aQhN8/DMeDb+PJhEIYB8Gg8lJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THyOwnBN; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THyOwnBN"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fc611a0f8cso5943915ad.2;
        Thu, 15 Aug 2024 01:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723710534; x=1724315334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Po+qMQMbpzYP4uJIJ/eolh7Aqpx5R5OsB3tn5+DTss=;
        b=THyOwnBNVZwbhh4uL6afjY7pzPuTcDFHCgz5u3rBnCC6V6/twyf9Atn0Sf0b/QuyTK
         DfqlhOHQ9Z0W6ae5YSU4LwIb4VJbCS+SaHV68TmlOwGQWwcutyjtUZIguqclUyIuMLA1
         yxGUr+8sJ+syj+qKH7u4/5o/GPZ1cqqbHmHoXWXwZdqsawrkz3cRfOjBeNk2bj3Q1kH3
         kSGhN0BCkfo6xz4RTvf9AYNac3PHfyWoO6PObgxQ6okosH6d470jBSCg0KrZUg/Yr76p
         HuktaGlO88YOTK2k5ZpLUi8xSXLQ0KLAdeSer2/7pdCQpJNqFSsM4pAaa+AhMT5Z+ESe
         jMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723710534; x=1724315334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Po+qMQMbpzYP4uJIJ/eolh7Aqpx5R5OsB3tn5+DTss=;
        b=DAuYU5T/Q1IoUdhJvJf/GAsLbIv7ia0o2Z5Oudeb479szbn5H9rKIj4E62Xz41GOZe
         JFytoUyjXreOjnUUzyPDNDXSaW+nCSuT7TkfU6yz+fN5UrMqi8+xQWtLYSaooTxIeBj8
         S3dOOszCDQejLVzcYAiyuVmm6xZpld/SHsOAIPC8tZLDTMCTD2O+gLI4awlltf2TZLAe
         CaQcowXcRV1Q5ZCC23NRG3YKqdgYZDyYfE/hGEudLKKGx/+mwuP5SICE5l6RMiAvURID
         7ZoTl/b5OmmsrpLpVoXZL0cRUH9ScziZujh0iPRQkoOt8X1LHlhjt6MNrywQf/j5DFW5
         d07w==
X-Forwarded-Encrypted: i=1; AJvYcCV5Ll0INFdNSwbrP7r4naVIkhT8k3CVx73RZmaPTonVHTNpp4gfdUqBRR/3LqnoC4USYHdg52NY2R9KCLGJ27tZMHMH/i3mCHs0Y4/EjsSWvJStpRmB6gVPEdO5f+fnzRidVVNa
X-Gm-Message-State: AOJu0YxwpLglHCAPWFDs+1e9VxH4JqWDv7bsrge9/TU2zHlDFrniPgSj
	FcxTwuksNYZY8sZlJZjIWiw36cqzh9eKfr2WNHyk7MTtmpZjkDBk
X-Google-Smtp-Source: AGHT+IHRwFFkBt4msVtwJ6Wb4AlGastbzIbW6wEHvNQuV7vRPGZDuqYXnRG7QAKqUyzRRhD1J1dU1A==
X-Received: by 2002:a17:902:c943:b0:1fc:4763:445c with SMTP id d9443c01a7336-201d644d894mr60980815ad.32.1723710529240;
        Thu, 15 Aug 2024 01:28:49 -0700 (PDT)
Received: from localhost.localdomain ([139.159.170.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f031bc36sm6613965ad.100.2024.08.15.01.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 01:28:48 -0700 (PDT)
From: icejl <icejl0001@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	icejl <icejl0001@gmail.com>
Subject: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Date: Thu, 15 Aug 2024 16:27:33 +0800
Message-Id: <20240815082733.272087-1-icejl0001@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the nfnetlink_rcv_batch function, an uninitialized local variable
extack is used, which results in using random stack data as a pointer.
This pointer is then used to access the data it points to and return
it as the request status, leading to an information leak. If the stack
data happens to be an invalid pointer, it can cause a pointer access
exception, triggering a kernel crash.

Signed-off-by: icejl <icejl0001@gmail.com>
---
 net/netfilter/nfnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abf660c7baf..b29b281f4b2c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
+	memset(&extack, 0, sizeof(extack));
 	if (nlh->nlmsg_flags & NLM_F_ACK)
 		nfnl_err_add(&err_list, nlh, 0, &extack);
 
-- 
2.34.1

