Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AB34D93C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672605; cv=none; b=Olxq+63FHjdyGAxU/XCf0p3CGYoz5By6EkPK0kDdiHiCHbr+hE537AWcn3dzSICe9HZxLhc/lvgvONlC5NLT3IWAkCNB7F4We39Nh4JXBYJZ1z1QmKOrrP/ZooJglj3YhP5BfUY1dII0DXc+xPntNjw6eZX2loVRtLrba4tyJtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672605; c=relaxed/simple;
	bh=SuJH3HWPiM306OrhrNAnCKKfLjQue1QzIizP6/wUym4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tTF7wiSUoqnt5Gj9TzWpsFIXYaUgTVrn4U28C/RR7tRI0N8Xruxh2HOUG6GoHpjEx1rotedpjJMEwozorw88MHN1JOxTgUhX2jCDgnH0oKPkYix6dPKTSNVAkw/HYGiRQ7NPL2XBUy8u1y1T7V2chy0L/b1BhRYiMxkHjHrI5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTTSJAPJ; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTTSJAPJ"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-273a0aeed57so1322015ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 10:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761672604; x=1762277404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eLUXKj3JdQcNGrW23cOuQo3J+oSHDUHH9EfbwIbJJXk=;
        b=aTTSJAPJynIoQg0lb3IO/0eK8p4kLxzuQSHUauj5fzlwjsenWnT4fOcGy79r33bDgp
         pDRw9SEg36LGsa3gTvPBlJvB6vf6TZO5UCOL6nZ3qx7S6JGLCJ5GBydj8mPsmu7ahb9m
         QZPBcFeNEz36G8ZMohy7YJXKqbj5X6zdyveGzB2RgqHjUoLbohV/aSuV/LLsEpWBBEMv
         d3N8Kf463x1V9hOikdJN/ZFac8CWeWQ7xc5K/8SQHVLhy+XN9/c+cHw7gDMDiE/x8Ppi
         8StagREI89fnRQklOKRCc2a2FYU+Jm0vxFAXAtIsXbwsDex5Bx1zNCCuRqqb/0awlqrl
         eKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761672604; x=1762277404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLUXKj3JdQcNGrW23cOuQo3J+oSHDUHH9EfbwIbJJXk=;
        b=SRxcE7x58dDN0IQcEb8ucVbXkenL5Rv48+Au47wL0T8BhbX6GMw+1KDLyO54UtZuIw
         XLsKkje9sMzNZwzVHZV/lXPeMu1GZ6o7a7J1RVHsFHiH/glyY2JcZF9kEn1qhdCiVKcW
         WvqQdyA/YyiPslG9OaTUjrnJNrUtaWsiSUGDiklAnj9vYTtCNml11gybDrxn9F3ZArB6
         0sEX5pML2eYoce+uRn5ToQlwORUQbGmce/I7XDDbbvYSCnoCA/HAOB6o18F6opQOj4g/
         VQZBaPjSaD8Hdhl3pzg/HKvb+kpLWYjzAgcYxkkbjcVt0oEFUl2HsHemMxC3N9CkdrsG
         xzIw==
X-Gm-Message-State: AOJu0Yx+3m3XveWAXCVCkYoCAmEO3gywJ4hV7t8ScMvZLfVNVTdiTS/d
	gfui68qUHoGcJR7Fboc+ZFrxGlZlxFISyH7G//LtzkbyqMnW/lpXPC09
X-Gm-Gg: ASbGncuyCuMtzwDuzvI+fEGPaeEOMAbhZgDTEn3Wkyodnj9m/8sijuxqzY8QtSFSltK
	BLu4hkN8EWNr+BELvQVRWZf/KcfEMLZ+siLcT9NC7IeyGQ+qYXtSjjHVRTamhaC8jmhNJdTcXTJ
	RpLHWTOFLNJUb4hyncVSlswXJbRHYgU1XOztEHhiwTqZmPNJy0+duDOM7ioJi+1Mvl835Nte8Mf
	EZOrq7TuBRrtxu89BVlH2DVfWFP4u1Cziux0B1f1EDknXmZwarbVUz6xicuyVU3lJbsRNG58y28
	lQP1Z2T2QW4CoWlXSwXMICO63jqctto0BrddKUOerLmKzHuyG6tpGB2pLoQ8BKyX6S8vOg9dZB0
	bz5ML/Yp72YL5A6StN/+q3dlo/wgAft2Z95Ajcy9fKLuD/ObXX9Si1o5lusUoACxF9mM54ngqoW
	IasUVqfIq3L4uXUc9JkVLoEGippfI+1g==
X-Google-Smtp-Source: AGHT+IFtX2DEf86QAUTfh07/RypVq+7k1EhRmR6o/ag686o7shl3n/6W/Quvmd/xiNh5jfkuDo/tDA==
X-Received: by 2002:a17:903:2f83:b0:294:8c99:f318 with SMTP id d9443c01a7336-294de7f3f19mr861325ad.3.1761672603628;
        Tue, 28 Oct 2025 10:30:03 -0700 (PDT)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d41c4esm124942545ad.81.2025.10.28.10.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:30:03 -0700 (PDT)
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
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: [PATCH v2] selftest: net: fix socklen_t type mismatch in sctp_collision test
Date: Tue, 28 Oct 2025 22:59:47 +0530
Message-ID: <20251028172947.53153-1-ankitkhushwaha.linux@gmail.com>
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

Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
+	socklen_t len = sizeof(daddr);
 	struct timeval tv = {25, 0};
 	char buf[] = "hello";
+	int sd, ret;
 
-- 
2.51.0

