Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C63101DC
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Oct 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759353319; cv=none; b=AA6q3I6Jtk874lB+ceq9c+ppXCVg5fhAKiVmt8h4Ept4TWTcpgV1vQrubVob1HLqmulUNOb+VzBKSNuOuzjl2OE5rp9VjTf83CktED8xZ6fnlUYJsIDVKlAYU7H+8IA1bL4X/eJwdgw0DUduDJ427ccWDmQ+sH0wlvFJYDOM5KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759353319; c=relaxed/simple;
	bh=hFcwwbJigjKlFl+IaX8fUeRnDh9cIt6svgdXFmkye+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C5NYcomBc3PU8ww7ambbKVws2INOcaoIodkFcF74xaQ1oF9aQslhu8qHkXzoyobA88HK3e2rZMj4H7uMyuZg1ycSyiPXVZkxrViGNiBNvF++h19eJaG58a7udibMxTaYQZ9YKLZytnOwCCQMsxpMmvRNNK/JAiDzBm1whIULv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBP7mE4S; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBP7mE4S"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-36bf096b092so3951981fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Oct 2025 14:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759353315; x=1759958115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bZJ9z+Wa6zujes7Avhj3X3F/seOErPXy8Ws1U3jiSoM=;
        b=OBP7mE4SQbkjsBFQrOCJZA+fio3cS3SLrNgZXUHEXAo8kETi/HlVKUpA2gen1qLkYY
         8y8EpE0TcfB5ITIF3X4hYn3ybnxra18Fl1FPgEKJzcoQ7nrWo2qcqgxf+IdN1+zBU1J8
         h78/W2Q6acDvcgeLDzinGCptTDVakTV+Lk+xfvuNzkE4flIZ0Nz4DyjaP6RR6VetYCvs
         NdQxfBtbEiN0d7T+ZW9pb0kqBbMI8Du2rLGcRwLu3rlWjZjCbSdm9iZWNTa2tUl7q0UL
         MGdL9aKfYvhvkmm26lcywc3dMT47SjG8NDUkRfLJ9bNCz6NBnVX08wXpMadMWLb/cXre
         W5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759353315; x=1759958115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZJ9z+Wa6zujes7Avhj3X3F/seOErPXy8Ws1U3jiSoM=;
        b=kH3Y3evoZVTchFDR05dlPTu2ln46ykFuVzFH3vnyJ2xDLH0a1AM8V5VyvKJ7eu/wTo
         cUXj4AxdVSa9tT62XAIEBiRDuRxSrwFju77e70Ou+nbceG/fKcPdvX9I9TyFacWMt//m
         JSt1Pm09XrhT4Lv20Rec9cldHm58lfOe6olIMTs3JisPRyMGGAOdOh9qE+M/rhOTMzLL
         xtdktxBp6psfDNau9kS/CWchUOOl13LDzEnVbthC4QSDad1xRotRPCF+34MoiEJPaMw8
         5BieesWsjPNN4Y3/j/0Yi2+MKZbNeBuEuLMfBK1Ip40M+noQrDcvcPX4PjM3LFtSiTTv
         xc+Q==
X-Gm-Message-State: AOJu0YxSuWgF/5DpJdRZA2TX450HvtgdOYrorKCajgAnAMvzUmpbYhz+
	IfBIRq9cDxaqizpG0f75+RaPmJu4MqR2sTBDIfQMQGuHfV+odfMdinN4Rt+FbOzxMvY=
X-Gm-Gg: ASbGnctfDVyQ2LqKQQ5M5n2X+i+uq86m/4rhjIN/uReL+BVo9pTrxV5EYfagXYjhxIN
	Lz/4z4v83+bB2uh+zOBLAi7BKPzSPUtCXghF60u4HHFphNVrmPy0eD5fqK0Zs9Uz5Sikd3HNPQh
	rJvKFqAetvK+JDYkMLTR106WIJYJfNSiK4lwdjPxMjQcArJ2gjKipy0PORUBnF5fDN01UR7Lab4
	z3qGA9OPMLwwODxHMgpcSMXU1tDU1DmsjnZLHNEQ1EDHwdSG5Lhd5+p7QOdxZZ+oFW2XgWuylcL
	ROBKDLS73U3s00R+lXMmD47L3mNUBdDfqiNJ0ab8c56rRkT4zlZ6r/dm3+5/GpiwZAtHK6aDKtW
	fEZCcbbmfxDBkMwAMRJ3dtuWZHQjW7vzycbkyR43gmcGmBQ4bfOctCcQJOlw=
X-Google-Smtp-Source: AGHT+IGTbjVMR499YH+MRQ15TS+Lgo8hbj3/VQ6wQaZB9YDhHM/2RdN6L2XisnOzcjgtSM9otfjxUg==
X-Received: by 2002:a05:651c:35c5:b0:368:2cf8:5121 with SMTP id 38308e7fff4ca-373a73d7209mr13564581fa.27.1759353314962;
        Wed, 01 Oct 2025 14:15:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:464e:6820:0:b853:e491:c1d3:767e])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-373ba4cdf62sm1439101fa.51.2025.10.01.14.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 14:15:14 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Date: Wed,  1 Oct 2025 23:15:03 +0200
Message-Id: <20251001211503.2120993-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before ACKs were introduced for batch begin and batch end messages,
userspace expected to receive the same number of ACKs as it sent,
unless a fatal error occurred.

To preserve this deterministic behavior, send an ACK for batch end
messages even when an error happens in the middle of the batch,
similar to how ACKs are handled for command messages.

Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
Hi,

I recently came across the issue introduced by bf2ac490d28c and
while trying to find a way to handle it by adding an ACK on batch
begin, end messages, I spotted what looks like an inconsistency?

I have tested this change with my userspace application and it
seems to resolve the "problem". However, I am not sure if there
is a suitable place to add a regression test, since AFAIK nft
userspace does not currently use this feature. I would be happy
to contribute a test if you could point me to the right place.

I may be missing some context, so feedback on whether this is the
right approach would be very welcome.

 net/netfilter/nfnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 811d02b4c4f7..0342087ead06 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -600,6 +600,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= NFNL_BATCH_FAILURE;
 			goto replay_abort;
 		}
+
+		if (nlh->nlmsg_flags & NLM_F_ACK) {
+			memset(&extack, 0, sizeof(extack));
+			nfnl_err_add(&err_list, nlh, 0, &extack);
+		}
 	}
 
 	nfnl_err_deliver(&err_list, oskb);
-- 
2.34.1

