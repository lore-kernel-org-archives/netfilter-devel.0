Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9E723098E;
	Tue, 12 Nov 2024 11:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731411292; cv=none; b=c0bivMnj3l0xLjVQBFf5tpm0L4pLjKkhNugq15i1BAa5bLfe3kFTv5LL5nmTzQBe9UpZ3sUo/OjPGcVOWKBLKsSVTBmCnk1CR2mvcUUc2nE2fhVTvFrJAd2t5BPKkCnAb5XoP9yx3D7slNaHrruBuxTTtPYg2KlvPOSz6p052SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731411292; c=relaxed/simple;
	bh=tGWkef8oRPVbKIm8lxPB39He4I6ZPEkKKg+zvLwwrKg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VMHakSFlRlT6DiLViIO7/UQZjQHFXh0QpcdiCGPLZfK9K7lxliQAYv2pjDzPH+xmzHo//vyiQH+lCFMoR8bsfm6Ksj70UDb8hPM66E8k5oevl2XSeaLvCAVVyYAvYxw0/XBF3q+fWfxwE9/ZHQShpSvEFRe9c4QDNNtXS/Ljrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMf4fMJI; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMf4fMJI"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20caea61132so47585675ad.2;
        Tue, 12 Nov 2024 03:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731411290; x=1732016090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BBciCWF098p8Q9R480GusPAiYwzzotgDMxNExmqOzhg=;
        b=gMf4fMJIhckfnIQszAjyfl6/JQWB9qr/t6yaPbqDzn6IhZqNHVDfrPevUYFQmsNcmV
         VGO1Z7GuJwgxTwmQhVziI15DAKby1/fcWvQULeKwxuvJIuO2kI4gSmje5VPPZyNDXINb
         Kf7rvtowq7vh4aSr0Rxs+hHd3NosoWUfQPMo4jEUlkgLGuqGwcmG47DYvXCkhCLBNaF3
         1ihHRKlLqayXJFGQiLXviYIUpTWGMGITXlV3/CGmUUxAUiJQzho/UPfkxKl5zuRNq81L
         CQkyquuVPBDP/nOmZSRZ7KNIIeq3waDRfhBTqACB+3cF+Yg3cxrQOR3xMnYUOIylXCkZ
         dKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731411290; x=1732016090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBciCWF098p8Q9R480GusPAiYwzzotgDMxNExmqOzhg=;
        b=rGq2RfA1/UYsy6C8N1wTpHCE5R7ROqf7UfUu8tGCKVMMsqsYwNhdZ7yjP9trY9e+w8
         vkicgJv/YXye2RSVMWloMcvn0yxLyDaIhUODy2Bypu4qPBYuTuO9x8e+tRMH13SBzZjr
         yzjaFs3ae+UwvsXkd6eZHTLMCDJ5jixKvmj/0SgLyuN/IsoVTMj2CSoHK8qUoAA/OtHK
         v4hqyjHu9aScU3089MCZTv88J+3M0Ef7GLJrl2f9iSWX7xMPTOy6V6H+i84eCgY80LVe
         ieGCgXvHQqdBn6mMFhMCjF5djmgh7FXoBFWd8BLquJxcV1V6PRTxgjZL6LgxLPot+xIw
         X42A==
X-Forwarded-Encrypted: i=1; AJvYcCUrW8nYPiLMxDEg6g/76B+aOtsXIR3rRFjzW6a4KvkvSzwA+bcBOtjaioTe1RJKr4J6uuAE2HWBBIH7oVSK0I9F@vger.kernel.org, AJvYcCW6GCYygZS/j/gIUFp2vnWYF7h5ICjKB7AitQB3lGGyVwQq7Qh95EGwH4iHpmw5yiE0fVmHdZYVSkz+pKs=@vger.kernel.org, AJvYcCWbZMjvjlPk3h5h+JIa1yYAmInohA4blntKCzduQnjHDBVZR9MbVU0ntvi9hYnINd/0+eksZM+X@vger.kernel.org, AJvYcCXhxIxwkSBCZ1E+ungnTphAqtC1SZs2Yg2CDCnzRHtMEoMU2mFsCMXDxf0FU1cWDxcnJ45T33+a@vger.kernel.org
X-Gm-Message-State: AOJu0YyntLHwJEZjhcMj0yxBYbtFIg7G3U5jb9V7f4uzsi6vc4bilG2x
	gwRiruY77hADs+g6Ab68RN5IBFW/+1Lkj0SjaFRM8Ll/pO4EE/dUQyjZxJceAzY=
X-Google-Smtp-Source: AGHT+IE3TJwzhFldsUlkBu1cbuT+lJaCxhF62RVb0VmyLIfgheqvWGnc4SfZmeez3miWxOIdNgnJOw==
X-Received: by 2002:a17:90b:3911:b0:2e2:f04d:9f0d with SMTP id 98e67ed59e1d1-2e9b170c3camr21923226a91.16.1731411290233;
        Tue, 12 Nov 2024 03:34:50 -0800 (PST)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e99a348dd6sm12466928a91.0.2024.11.12.03.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 03:34:49 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH net] netfilter: ipset: add missing range check in bitmap_ip_uadt
Date: Tue, 12 Nov 2024 20:34:34 +0900
Message-Id: <20241112113434.58975-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the bitmap_ip_uadt function, if ip is greater than ip_to, they are swapped.
However, there is no check to see if ip is smaller than map->first, which
causes an out-of-bounds vulnerability. Therefore, you need to add a missing
bounds check to prevent out-of-bounds.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index e4fa00abde6a..705c316b001a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -178,7 +178,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_to = ip;
 	}
 
-	if (ip_to > map->last_ip)
+	if (ip < map->first_ip || ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
 
 	for (; !before(ip_to, ip); ip += map->hosts) {
--
