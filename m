Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D4623AE62
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761500829; cv=none; b=kkYOaIZR1WWqi8NC0n92cusCgzvtDjpLihjs5gpzdUQgLvb5S3fhvR4OQbILjw6uSsM3MAhLexM4Begvj4F0Cl54TMa4lWm6SD8/IOePz0qJZgYrGN1z4kD1eb+F1tcFmRJ97YO4KgPY2Q7rQOgSvDbji93wUfFWsUXNLe/m9Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761500829; c=relaxed/simple;
	bh=a+5TfOJqZaa7uINUuLkBAnYsuEfoCPkWzUliS6FwM7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PYx/ZGTkGHfzMqKQYGchtyPZbJAEmXWf27cjNl4sYOB116o54HAlr2QcF6EEB6XkodThf+fyfStIB74NE3uilG7y4tdRP+oqRE5bAn9eM6nTtsTdHPldUXbbiHMjm2CbO3bqt4PUw6fbHnCQav/NSom4pCUS7a8a8sl4NB5fcV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KV0C/Lji; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KV0C/Lji"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-339c9bf3492so4571552a91.2
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 10:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761500827; x=1762105627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cTlRnqQ5NYA26/eQEooThXZv5VwSOGxJEUEP1dj3fhY=;
        b=KV0C/LjiZP6gTyvZ+exzxXK9vCzPEreIHAyBr+17kfxupcEcFvP7xRof15hazqiaLU
         ZtIAGM0Op+fO24lNEMrNfbx/yo3MOqRhVbOqsB84YVZJeS4i7VcLlvrCF7qepThcxLhC
         jKBIMbsogONHJaY9qveUTIPplz1NTdOeXAXeSwziely8wVaN2rQCwZ5PRTRPIErEUaXf
         NmJ89+Aw7sOfhIGTQp11Cb+EOfcUOlCB9CthIAvs1jLR7k0LZHlrAM/O8WPZ9FZUIHjw
         L2MEV8sBkzeoEfPnvUwfjjB7ZVc7dj5Oe6LFkbdz6ZrfZZjgjkKGqZNSuHsXlUn7Foh3
         JHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761500827; x=1762105627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cTlRnqQ5NYA26/eQEooThXZv5VwSOGxJEUEP1dj3fhY=;
        b=OkMPrWpo8VWWCjKIfe7IiCOpXU3R37jGx0/O1MG2yvN2SjdiELnkddFSb7JyuWuuSY
         s613KW02N7DtO5LkA1DgSuQ6HSxkNCNgRXlJ/DkbZoPaaFmmFxmsUKeb0T+Q+8ibI/4C
         x/ZZtRwrAbuPq5IXOQv+nHWxD7pVLJqzWU9D0H2oqJBRQVId3qfmtaZL/mL/Kyi4S33x
         NJdIiSqwT6ewm1bqQ3uaUM+mQkX1pAd8R88yqU0wBHaS9CtMkh/l0A82Pk6Hj2s9L3Zv
         F+pZbGOJIlglj/dSwzgU0MEGiLwz9cSEbi8QlxNehMKeNz70PVQrviDzT4tgdfFI8Wcr
         COiw==
X-Gm-Message-State: AOJu0YyA6Rf8DAteLu1UqhP1WyWhxVAmS76BL9wEt4Q1RsHP7Ks4dYPE
	knTLx2uyUt1bG/2JfayL4BK18AGtxD2XweBEMbr649Ix2vzQ0jgGeYS9
X-Gm-Gg: ASbGnctxU8a616sRSOdm/IwmDcP4rraHxHVDEfmGb1Sc/zeAZfVPilVjT3NxZceRHCg
	3WByTntyVYWUs41J8m4JQjq/zD/zcjEN2/jiWjU7L+Qrjj4CMfN79omfojr9Wqq5WqP0S/Zfo5S
	ZE0Ve1IIM0VX6z1A/kF+PAbOFi1rHksJASEDAmcykA6aFmdTpjbFFvGke26oKZ3cpcH1z6EIoFx
	PF/YZFRA4Frh8OKfbVaDVYG/DrVmisoGms06sQVIF6AVyqJW7WbF2nhVI4MxwZvnAfSB1fra33+
	tRwFARE50vIaV/DlqsPyBu+j+EzGuQxEus9/HtWWmbxDqHKZOIpj4OTuHnlLPxj3zg3vGB5SUqN
	baJzXySj89um935n0iyOMZaTqeoHAHOojebhpvT/haeGjT28Op7GI9wdY03ogaWP+JZSOpKyIrR
	HVQQHVQrp4lRmLVfbfpW/SB6ML/nAurQ==
X-Google-Smtp-Source: AGHT+IGwYCSe19Ty4P2Kg68LQK9vteTSxPeeGBo2iswWXXEumD1EpQASl9RMMGaFry0bwrT+Y8+yLw==
X-Received: by 2002:a17:903:41c6:b0:25d:37fc:32df with SMTP id d9443c01a7336-290cb65c914mr503829555ad.47.1761500827212;
        Sun, 26 Oct 2025 10:47:07 -0700 (PDT)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d09855sm55131445ad.30.2025.10.26.10.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 10:47:06 -0700 (PDT)
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: [PATCH] selftest: net: fix socklen_t type mismatch in sctp_collision test
Date: Sun, 26 Oct 2025 23:16:49 +0530
Message-ID: <20251026174649.276515-1-ankitkhushwaha.linux@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Socket APIs like recvfrom(), accept(), and getsockname() expect socklen_t*
arg, but tests were using int variables. This causes -Wpointer-sign 
warnings on platforms where socklen_t is unsigned.

Change the variable type from int to socklen_t to resolve the warning and
ensure type safety across platforms.

warning fixed:

sctp_collision.c:62:70: warning: passing 'int *' to parameter of 
type 'socklen_t *' (aka 'unsigned int *') converts between pointers to 
integer types with different sign [-Wpointer-sign]
   62 |                 ret = recvfrom(sd, buf, sizeof(buf), 
									0, (struct sockaddr *)&daddr, &len);
      |                                                           ^~~~
/usr/include/sys/socket.h:165:27: note: passing argument to 
parameter '__addr_len' here
  165 |                          socklen_t *__restrict __addr_len);
      |                                                ^

Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
---
 tools/testing/selftests/net/netfilter/sctp_collision.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/sctp_collision.c b/tools/testing/selftests/net/netfilter/sctp_collision.c
index 21bb1cfd8a85..91df996367e9 100644
--- a/tools/testing/selftests/net/netfilter/sctp_collision.c
+++ b/tools/testing/selftests/net/netfilter/sctp_collision.c
@@ -9,7 +9,8 @@
 int main(int argc, char *argv[])
 {
 	struct sockaddr_in saddr = {}, daddr = {};
-	int sd, ret, len = sizeof(daddr);
+	int sd, ret;
+	socklen_t len = sizeof(daddr);
 	struct timeval tv = {25, 0};
 	char buf[] = "hello";
 
-- 
2.51.0

