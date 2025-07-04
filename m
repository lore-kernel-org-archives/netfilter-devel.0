Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E361F4CBE
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 03:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751598752; cv=none; b=UQaX0i7WEcQxqWqAwYFDREH0C6u6r5//wPyaVYq0/J3obneBf+M9UBSuQ8OewWmf2FiBycisUMb8X+igKhG/MdG6nP/IXZD6vUhoT4Euy1sWSR8171MjkVJs9p8NNow0UZvn0zhpWmvVkdVHHyWg24MlOCZtyoePH8s9yo8YLes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751598752; c=relaxed/simple;
	bh=lS3UGdA19pAzpqa9FVhuRuWlrCthqrF658J2hDX7FNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ik/j5RuXia9Yp12BsulX5HDYEQAw7GJW6xM0cWoavJs6gdyfOciussMD2VCLB91+Ixevvx6YUVgMNIFMNL6OihozE6PSmka4r1nrFP0XJTTbPtc5sNEAtme81HhOo68eXRb0aswsyCaCre9BoKJsLMOp6HYv6Ff2wtDUDvZRRYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f18DVlzw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f18DVlzw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234d366e5f2so8493805ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Jul 2025 20:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751598750; x=1752203550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pTi9sqxBCZ34F5xYIO1KycGTOmj+4j52CE6rySmUfKM=;
        b=f18DVlzwvylhx/7511N0ViUBW4KqDmSMaCeG2nHRp3A0NN8fVlWLw88gocxtGzbH6Q
         uwpfhSMPSR7RVMDScBRc83gIDmuIslsuuPvI8UMGXZSOx4yAVGm/0liYxV4Use8WnY8z
         8Y3Gd0erlM4BHcsDjNdIuDZfjGFWgadPXGqFZt8p+XnwEQa4J13bEhFoYhdNjNLT3k6+
         MMFjWlwsNza9DlUlFOCA5fViJfEa5nm25nwLIH3NeCLdbHkRO3UkOaQZ5M+tOo4MXnZP
         n46w4vfdT3fwDnYiTP6hMWFE2bGAjGMZXyjaIHGI53lPFPGs8msfRW8EKOINCXe6OYhA
         vEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751598750; x=1752203550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTi9sqxBCZ34F5xYIO1KycGTOmj+4j52CE6rySmUfKM=;
        b=HjP9MZnKL4ZpsiGmMa5qaNJgQHMaAupbW+ai+LuqWerjnB3RUyZ4JwQlCmYVhZHTCW
         mBU5kPlG2F9/q9e3zS8ShsSOUz2CWQys2RxdFt2yoW2riSM5HXWXcsfGHm2x6rx/On3I
         F5sVDphRxEawRxOum5ZuhZ4C2uxUItRSJqeTsgcoRD1NokxLGkWAqfwomkAAnt8AYySS
         cwP6NZHJMOPOs4XvPkUNGBjrmnlDajp63ZBk3b5LL7ZbnwlYcyHm34pVT0xV59epC3yv
         KsI8Mntf1n30Lbj3GLF+DFZCr2aAOFMXEgdMm/b+zC04WcFfAYWs0w0R11c91Jz6N9Pp
         xo9w==
X-Forwarded-Encrypted: i=1; AJvYcCXxl6Stv8kzTTmELtpK9nCR3zDJUqyQJI7K33ktqNkiqAiOQ2X3oExrgSGax504UoxT8R+A89CzFz6Ol8zghNs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmi7jQRfm35PFKqmKu7R5qJNVay78b1L+djwCI07gLNG+wCJcw
	mXGOoL9Tq1wukQ1vyRcx7+f0ixmKWkjy37QUMtUbjm0zcTiJCW5kTLin
X-Gm-Gg: ASbGncun7g5ysc3u0uNzNY7yeaoPqukBeoOe0kZL0LaPyNkMiJ/qp8pSU5gqEjQVDZ4
	TcpgqDPxHa5BgaSlwwDr5zhj2leOSTEuizCoWTdc7T4yQy163YwpprOfNl5gR2qOXjbrxH6hMB4
	MmnGUIsC2tGDdGOPh5EFwJL78FRKlXFKKfzGKGKg1QmlTIIAXbclSCnzTRIa8bHPSAMdwG7MhU5
	u2veiC6hGVvvCdaWW0qOIcQJ2Udcc4q7fXHDN3FU+MzvCyYcT8DiL5czTXzoG1ynKkXBBixgY4F
	ID2NifRi1Qkm3GsbyWrJxNmhvB50pckk8ezPI3rYdIkPxEl456v4D4qqzAKc6m2xkA==
X-Google-Smtp-Source: AGHT+IFkB0A+6tGtfjtzA6JdivuO2cgznoaQIAsuyBB5DeQOxOBW76LJTA3IjPvCCco4EnTeJO2O7A==
X-Received: by 2002:a17:902:e885:b0:235:1966:93a9 with SMTP id d9443c01a7336-23c8746d7c5mr10337315ad.3.1751598750402;
        Thu, 03 Jul 2025 20:12:30 -0700 (PDT)
Received: from localhost.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8457e9e1sm8726665ad.175.2025.07.03.20.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 20:12:30 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2] tests: py: re-enables nft-test.py to load the local nftables.py
Date: Fri,  4 Jul 2025 03:12:16 +0000
Message-ID: <20250704031216.15279-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a needed follow-up of commit ce443afc21455 ("py: move
package source into src directory") from 2023. Since that change,
nft-test.py started using the host's nftables.py instead of the local
one. But since nft-test.py passes the local src/.libs/libnftables.so.1
as parameter when instantiating the Nftables class, we did nevertheless
use the local libnftables.

Fixes: ce443afc21455 ("py: move package source into src directory")
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
v2:
- Taken detailed commit description from Phil.
v1: https://lore.kernel.org/netfilter-devel/20250703135836.13803-1-dzq.aishenghu0@gmail.com/

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

