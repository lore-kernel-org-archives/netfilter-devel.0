Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E74D2E765E
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551129; cv=none; b=EJsHVrsip5eExOtqVTB7BcH4oPGNZ0OfMcFz/YXtxH3kpd1IxcfPodnghbIlad85ggxtOuXi6fkdYAgbrMgVF6QITYTLyzOoDnaN6u2PmqkacwD/lkOd+/L5HMYlWd2NsBOsUEhjKv2iPJgW6IS40F7rCl+KCV0iRPdDV5DSZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551129; c=relaxed/simple;
	bh=EsibOu3zI5RFOuWYts/fvm6q1zbjMoN223sn1CLF4hw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n3A7lsLgktMA5tT8fcJAxiHxJV39PfirnDzicwvwZRBmVyPLcEZiTyFlmpwftpZCJ4zbf5JT1XpaZUibXBKK3rzS+db17nbMV+D28nOZWsGf9pqedQwd8nVlIWuVUnNwpqd9QAPgLEG0Zl3+cs0ZOEFlkNVZSzzjHoAsCx+a91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ef4X3/0p; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ef4X3/0p"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso5117392a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Jul 2025 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751551128; x=1752155928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o/V9oxa1K4n/o02VYJXAgpiVkFweh8gqP2zZ10kCK3Y=;
        b=ef4X3/0pD8xiAh7j8QDkrSov9L4ZuCCYuJ628EEwjx5HAGrxJD4FnQWBEtypAKZj9y
         HKEytC3fn313u4/2O623SmUga4iGTL9wGMpGh7iCsDI0eeLCSyrYYfY69Fn9y7kKqvyq
         dkm0U+yF/pb/6IrL16D7wLCU7olRt7Y5rNOjMMFMpHRHRDU0j3pGazQtpIFk4E5clDT/
         63VtAoo8jBUHlRRQX++HgrpMNPYb3/I7Ux2GjmVPeFx0khj9pAaxyxyvKsEVOzdjUDH9
         B2WWyUKPJFEpMymDctieFcjilva9B4y89Z1Axn5jlb0KV0UzZAFT5iXwALjv43btMSVm
         Gk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751551128; x=1752155928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o/V9oxa1K4n/o02VYJXAgpiVkFweh8gqP2zZ10kCK3Y=;
        b=WNN8rokmPakkrSDFScHBz+JdIIGPLxLTL0JW2LD9XVmF5cddvdcgrGeqfwau4G6Zyr
         XgRwNTHsOD1qZM1znT2n0dSyK7YwnwoDHm4Rtk3PFSElkl8iRGb8wlErebF/GCQJvehT
         KBcl8Pf7ixfOlSMsIh0hJus7JLvew59IBcg+VotetAoJFzulPaK97yTUN+FX1KwUOXm1
         uu3uZkJ9BuZvz5ZwEAt1xRuEumHd2ehQOm3CEQoTpktBJq0bw0jnml/EL0kxkeSpZ01e
         0fzU5E8iEFZNZEjtrvAE6iMO8RA6RbInJ2Q2W6mUn/n/AEgUSrQK8QeVVXhQAhildR+B
         EkJg==
X-Forwarded-Encrypted: i=1; AJvYcCXDC/v7w3aTF9gom7zc9TAfRn2Xi02LXKoEEzt687oS1wpAPaZ6DyL/wxcvMaCE0eY1H5a0h3KfVoVqLf4QWtw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEL22NDPnFnTl6WGbs3lOAtcOaFPESfrmAUo7KAUhZfQYsez3W
	5HW10Yx3y5guN5MEALwuDdZ5+2LyG8WBYDBE5TUHzqzLTfJCcnZ1VyR8
X-Gm-Gg: ASbGncstOimri2u5kNN26SaWOa/bMUwNDvbymUyWcrhkVrf7LHBPDJxAmeqNkQz+82g
	mENS+pKsvVLRKCWWXj4k2okFPITAFuI4Wei+PIgXGO5V7FRAm8Bvia8vD/ByGezBdzKxeYSskly
	/jU8x5aG6gMozDFgXQD5Tmi8PZaB4ccY5NWlCG5p4SC42WpyBU1SGeffDcfm3r+ioRQGcMLRJAU
	0Ikua/5yWSrAaWIO/vs/DHiHGh3npqpnJStPt1zAx2Y0M5RRQ+5VDVZPYaeHqEeBDI2Ah5bJpwD
	E1LZW+Qb7uIBJ7YJrbU6EXLNJrf1TXqQ/H1LqPhqIe5dyxeQNShO1iwiN6mAOoZRBy1QqFc=
X-Google-Smtp-Source: AGHT+IGYhzStnueFkBebvpQ/Hxy2HiWEMvQcpdX8KW/yXEsqZuDVJWyFnY0toNwTDpM9w/kSmT5Hvw==
X-Received: by 2002:a05:6a21:9989:b0:215:ee6e:ee3b with SMTP id adf61e73a8af0-222d7de1d08mr11458479637.15.1751551127844;
        Thu, 03 Jul 2025 06:58:47 -0700 (PDT)
Received: from A014158-NC01.ESG.360ES.CN ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31d8580sm15009260a12.52.2025.07.03.06.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 06:58:47 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft] tests: py: correct the py utils path in the source tree
Date: Thu,  3 Jul 2025 13:58:36 +0000
Message-ID: <20250703135836.13803-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: ce443afc2145 ("py: move package source into src directory")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 tests/py/nft-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index c7e55b0c3241..984f2b937a07 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -23,7 +23,7 @@ import traceback
 import tempfile
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
-sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
+sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/src'))
 os.environ['TZ'] = 'UTC-2'
 
 from nftables import Nftables
-- 
2.43.0

