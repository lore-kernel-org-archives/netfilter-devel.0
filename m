Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27EC2E06E4
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2026 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786800689; cv=none; b=Oa+obqnTCyqW91hboE6/ZbnpsRINe1DYqlGcKip1FsW+ktMQ/2ifmxt3GlbYwe/Iwz8NCZHZ8Rys+PqNsx04UcKqNNI+KbhIqWRizxkl9cjs1mTDU8Og2KUHGXRUSW8RqnT3NaL5GjMt5+IXilLchfbwclJmgdlwTGqivgHNDxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786800689; c=relaxed/simple;
	bh=ffXPqKdSIu9gxybAgPMX1CVXHu2WOyg410kZcmMe408=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rrfI98wBWtU8gye6Wfymhk+YI0VkM8sZE69G7c1M5S1AeW7SwWhcz3LYmCK36JDfxRrJdy8nP2nHEbDJvqDaXL+K/Ko6psb3hjBeWda/UKLkdNF1hyBk8Lf3KHQRzc0jVxiy6qiWbXz030OfxnLdi7hwVCPEMwIPRofHSrcEJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+yzGkoi; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+yzGkoi"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-ca80d708489so1039164a12.1
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2026 06:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786800686; x=1787405486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xxe+qK628pSv5aRz3Z60BtjyzpuZLQOeH8bhyQjGgxI=;
        b=M+yzGkoibBNBFeNxtACKk5HkYdv00BtxVpwW2G6GoyzGvqHPTphQHkUm/s83wpRt5q
         f/PbSQeBd6uyobkuvcIBWbhba4q7PXwOlei60LSIKZHHSZ3lG8dHulgNYX6EnmZj5CjW
         DoB43A8WJO5UU1PXZm1cJu6V0KWzEnXX7sEbDwDSGN0OsEvNiUBGiK5lrvhLczUYDHyX
         mojF6FSnCY5Aar0BK0/oCLHh0YlQPpH4W8CHTBnb8gG8J4Qc0isQiv34X1KkC5ZzBc+P
         CZngQAS0rV5IAbxRzLeHqTVopyZje/SjZflBYGQGERbgI6ij6rIwi2wpBKJ/WGJviNwD
         +rzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786800686; x=1787405486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xxe+qK628pSv5aRz3Z60BtjyzpuZLQOeH8bhyQjGgxI=;
        b=jLPk3Ihe8WkfNrUByzrNyPcQKq+lcHDxEiHLjlloHDXfqw8BsmdgoTYaqcxfF0iGu3
         jUgZCr86uGqJ0JgBXaF0pnWJMgujseggf7GQzizZG1O8ltznRbFktsKF3QZj3sHXa0GX
         6jQAskglNo6gRfmDUWEC0FGcBHa+USc4142U/ndpiL3OGRPH1fESMkOS+LhjSWcN5bMl
         ceLIYtXtKu6CpuSrF7Fv7pm3oEwEVO4Add4o0k3vnqtII16K2R9zjeqf/pFaiG+t4Mx4
         WRKIy7IpUEEfL8kRRXI3KofzAINwb+h6Ux5er0LzPJ9rdpMHE/S80RJtxsBTisoLct2n
         TDrQ==
X-Forwarded-Encrypted: i=1; AHgh+RqxUtZ3ISgSZiSOOOzfhy3NIT6Nsr72oLfVKEzGWIMmm1UzK0kxntIGsAq0zhPtX0qDe5KZoSkiGNVn2EsTIlY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/vBXW/fjnInYbkUw5ZZtJEm3RhC+hcQtDDej1pA6iHdglZEvE
	Z2b9q8AZZhGpzQWBjpAChIwHF99unE8pC2ac9854VaOGAObMIcYMw0Mq
X-Gm-Gg: AR+sD11B3HOpyzyYAcBYxOheYvnX3u9iKeFOa+xRhQZmRb7lES6IA8NWmmPvLuvoq1i
	RO4+gVEWNIGuFz+kIkIMm9nBwm3oCoVnEt9DPxia7sxa4Xr9bnmOw+ytGDYhYrLgk5f5HZfZ4Ft
	okpz79jZ504TipSqWmRBA7MeetxbFHq4ZNbN354r5+aY7MQCkYxGwjQA03quKgenZU1HjuZmCwn
	2uP86Xl6K9pNudYHozmk/GKx0avZ1HifPaYeeY7LGfxm21dvhHiZC0i8BWbX8hCA/hyak9zxO9I
	bswo11ByBwubkTMb1giA/UxALLbyQLb6vohj0iE7Nytm0pddvhz+Yp5s/5uYM1etJE3KlrTZyQS
	OxmELqlZM6vU1sfL7eaYBWg8u9UE5kyfGX+vs3MnwpxySAunk+6T9X1q+B4/Z9QQ0/hCM1X3eZG
	Nfo/qXWr8InQx67o9tROXveL+LZFs0EN3YpQ/7G74mNa7rZKm+3iudAQhGvFARGWmJ0AzDot3ax
	RDMRsE9cGsbfXESDlmX2dm3gHkStEmm0E3/hka8I3NIDe+4
X-Received: by 2002:a17:90b:5445:b0:380:8bb9:aba9 with SMTP id 98e67ed59e1d1-3931f450eb6mr16557155a91.3.1786800686259;
        Sat, 15 Aug 2026 06:31:26 -0700 (PDT)
Received: from localhost.localdomain ([103.75.11.105])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d5ff42b7sm17854020eec.7.2026.08.15.06.31.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 15 Aug 2026 06:31:25 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joas Antonio dos Santos <joasantonio108@gmail.com>
Subject: [PATCH net] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Sat, 15 Aug 2026 10:31:04 -0300
Message-Id: <20260815133104.50369-1-joasantonio108@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

Fixes: ea45f12a2766 ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e4a70d1d7..f3b1d6356 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -707,9 +707,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.39.5 (Apple Git-154)

