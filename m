Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795504777;
	b=Q/zB9ge2PI5VMSYHc7/mIP9re9/iFQOyQG86Yd/aK5LtFANV0bMx1U0vhvPRe3JzHGFg
	 nIbYkPcunBtQniB/Gkfb535bTYSF2DJYjyU/hm6nxpHqhCYlIWIi78a/WHnd2XDXwo8Yc
	 rqPIyxdYdjNL2FYYgVtI6H4TEsSg9D8goZU9o94xEH+drmbfRIt8KkiE1BVHVXGapfcq8
	 y5PlLpl9ZrI5Ae2oTXpzXtGpr3ptcqYwDTZ5Gt99yJ5GyjA0W/XYfa2QNKF5psnjwBJV3
	 i2d0BiZiuKv+W5AVutqwtaJE+7Yl8t12qQASWi7nzh1q2V8NL/AJfdQSr94JJi75uhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795504777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=psyQ3R+IPgp+Vrzba+etQGrWT4agfKgZFhLKLz+GJT8=;
	b=GBvcEl1hRJaiYGUP8KbGRxm3gYQSRRSWyMopnWLpJN3QyHjXWJY2IPZJMcvs4bcn9aJi
	 YLpx1LTzcMJ5YmPqmRFQQXtM4ZwJqr9pvy+i9uVRurd3AVP+duZX2r/AZ6x0UPCASWajV
	 WfX1qA9e3AG9dDUN+Zp9xvl9IdjS1HZugOEYnIssQdltCcgoHpRSyBKiDWZNtJnB+geG8
	 tmsBJH/wEe2ggK17Xrry4i2uDN9Or9e8r1FRl0tIdm2/flTyDmg3fNL7QAcrlKfJvHe3i
	 Zf3aOzfkmnhu5qbfpRdUAKTXrehb5XWuKysb3TeyYLigVISrup8eelttf5FmkYg/Ytg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jb33G8mO;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8544606A680
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 07:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8544606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jb33G8mO
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1954979b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 23:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795504776; x=1796109576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=psyQ3R+IPgp+Vrzba+etQGrWT4agfKgZFhLKLz+GJT8=;
        b=jb33G8mOS/Hi1jWlbaudR+Y8v/b7kjNRymBbnp45JRiKAkM+lr1QSILrSFem736iC2
         AfvHjuItnI3tl4xVMogeehGLzwOMrB2+yFoU13bZ3qGKTRZR9JaIU8msDmLWruizzj8j
         OSk6LEihZORe7s9OQMIZGBkXVm+kEF6KUqbfzlc4/pxTv404AitSpyj5YzzJEcHIsezr
         /1DLOdMmJ6e9rD9GDj/ELR4XWfVfJG6AjbqkDpEa26i/A1g0xYDL07lr38ai6F0IKdp5
         KKtU89PJzK9LVmwEICshchHb2kl73xBJ3h7Hg5CleDSX8DZLiDYtmfUHIYsFky5Lfs90
         2YWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795504776; x=1796109576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=psyQ3R+IPgp+Vrzba+etQGrWT4agfKgZFhLKLz+GJT8=;
        b=rQ3Ul2A2ySBItoUsBzayiBMd/zNdXqPxs3CBNLFY1F815Wf3LXvMkua6GAaeazZ0bd
         haFRxs9hQHRWQ9D3Wwrc6jI9JeO2JCcxmI0I6cJ2jpgvAxQSqholVfGpOfflfbuFvQ9q
         3aqWp0mhrIazTdl0SP7LS7JzYAToqEP9bJH7Z4O6LPVkq1BR7l8At5LvCF/fdNSaItQv
         Df2PNz/aYYzrJ98JyXZgTX/mJqrQbIA7WbcrpMuy8R+q0gUgXlMU3VY1x3jyCUnDQuT4
         K6f4Zm6mQdUkGs6mzKoXLqFE9p/IaUMjz3+OtCMfqbkFMqupYt2+pIDu57IN4PNoZgHx
         k8Mw==
X-Forwarded-Encrypted: i=1; AL+hErH/Eyn0f6unTbzSkVRoRN71l7IAnN3K5tfyNoaBdjnqip9dKSFGGtffyAZli9+AKGD+snUtw2eDO8adQfdpO3k=@vger.kernel.org
X-Gm-Message-State: APuU4Z/5K6HCvuzHk8TH3iFXOagrPKT4ghhoWwQ2URGqTovWf0KhHJk7
	VAv3tYLrboBgTPOeX4hNNN/x7zLWvCpdOysYohN1eRgwYX9uQit1u5YP
X-Gm-Gg: AZFdTZc2j9xOWoe1KXPk9EQOfp7nQnc9DJrhRunDPeSVgHOtx3NV25sw4vIKaBJAd/i
	+IEkd5e4yWtNrxh5722k/JkIqcC5i90faiBc4k0joDn0rRNNvtWzOi4vN+C9aHuzspJb6xn8BX0
	bJiVZbpTpkYP0cwtTUHw4imtObMUUaaajMXsZVbjY/A2nv6ehs+1CVOT4EaOuLSjOFP5haJtFwa
	CkSEtZlUHcWZf3+Q5gNoeRFAQZd+hXHayoWhFX5OcXulbPQNDF53Yd+cW5xqBwzY5SYDOmjg49k
	H0OxSobT5uP/grtXmvn9ACxkpZ1vr8JliybZkqNmrdtSbVXuP6MTlKcYP1jC9+GXxBJPMetzfza
	aBR/NidZ1vS0D0HkC+iuuseLTp8+l8V9b/IBHdn6fvrFK4vM3Pl0C/jiE5cAfCRqt6d6NMlHr+X
	g5j0l4IRwKtScS7f83ZN5ayxNpz9uV8EqaEa/7/cg3IFjHCiR+pDDMGKIo+FmH0qWajO9am9Poi
	PQ5RtSXgt9BhtXCUhkPw6frZ2sDRqF5IfExEOvmVI4ovPOB9hHywnLSKhGNutaAyBDdowajf+E5
	Fliy1BrDOOYRoJQhWuyMMiaBt9A0P4MlsrI3tJiNiCmz4aoFR3nPtyu9Q8Hx/TLvxigCMs/i+f1
	CO26QnGez1NDLSXN0z1o=
X-Received: by 2002:a05:6372:a748:b0:3e1:885f:b4ab with SMTP id adf61e73a8af0-4014a27e905mr10620093637.8.1795504776021;
        Mon, 23 Nov 2026 23:19:36 -0800 (PST)
Received: from LDYT9Q2G2M.pvgl.sap.corp ([2a09:bac5:cad3:119::1c:2e7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde7f91c6f5sm4425486a12.27.2026.11.23.23.19.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 23:19:35 -0800 (PST)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiqi Zhang <zhiqizhangg@gmail.com>
Subject: [PATCH] selftests: netfilter: fix missing echo in nft_nat_zones.sh
Date: Tue, 24 Nov 2026 15:19:26 +0800
Message-ID: <20261124071926.8818-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ping failure path tries to execute the failure message as a command
because the echo command is missing. This reports a confusing "command not
found" error and returns 127 from that command instead of printing the
intended diagnostic.

Add the missing echo so the ping failure is reported consistently with the
other failure paths in the script.

I found this bug manually. OpenAI Codex generated the one-line code
change. I wrote the reproducer/test case, reviewed the generated change,
and tested the patch.

Fixes: d6905f088d2b ("selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups")
Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
---
 tools/testing/selftests/net/netfilter/nft_nat_zones.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
index d935c967dd..f15bfd3373 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
@@ -171,7 +171,7 @@ done
 
 wait || ret=1
 
-[ "$ret" -ne 0 ] && "FAIL: Ping failure from $cl" 1>&2
+[ "$ret" -ne 0 ] && echo "FAIL: Ping failure from $cl" 1>&2
 
 for i in $(seq 1 "$maxclients"); do
    if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" | grep -q "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 counter packets 3 bytes 252 }"; then
-- 
2.54.0 (Apple Git-157)

