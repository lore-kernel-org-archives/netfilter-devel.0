Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0A13D34B6
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747269; cv=none; b=LYf5/q1zP3xCmULgtcnJlb+Sd/qurQsXMxyZPSTfcqHzzmelHhb7andTbojXYm2kZNoVAVfVW+fpE8wx57SrMEbpyNv/envmsDwPSzyYsEaytKimhcBx6S90x93/o/MqfRN/s2iL4JC5YH1LV8KPvh1/gkZPX4wrIkOjV+tzTc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747269; c=relaxed/simple;
	bh=Tzx1JoLPABShYM1Pm3RTCn9DyXuxVz/UCK8Zh9PzwWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UnYMkFTYd7dBTZh5W5+W4wqZYpI/g7tH+14ii8+sp+gdaHpHA+u1in/aoOO3aSH62wUOyqNpr5jF9aXWjGLBIPgPW2piOTgTmXkTcwJTw7C86nhCaeB6tggj6dSw0S5EqC7m5d4pbSSMswthyGYVkzVImIxsFDnQKBQYBa8DkWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1NYr8nc; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1NYr8nc"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so507571a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2026 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775747267; x=1776352067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PrEq8JFBlKt4BxwmLLBZiPMRBW9tfYXXYLLd/dH/SyE=;
        b=K1NYr8ncZ7rDgEspHQQy3QHmOK2zePYvr1Y/8hWeYphQM8gDSZO73Px+8E7JCfZ+8f
         5pb+QBGtVyQX0HJgArVXV7MhpjCIqfnNYR3s71h5cEfxiOK4FhQXnJV0Qhsn6dJrSzQv
         gYq7DUaLSop3GgBGksn7MEJdEJ0ZPnjJ4DHpSUGRJLyTn4qg1qg6leTAzcSppzGctOJq
         VHVpqtmqyBbPUdToOPr/EcVfgGpFlU4CM10/CctapHwjpbatQ2ScoZ1ka3lOwwPmsg45
         LzP8wLgXIxF+qYEbSEvoNUvEMsR9xFpdwaKFWhflad4bC4ogrQuy+/CHd6mMKrMPD4O8
         RivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775747267; x=1776352067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrEq8JFBlKt4BxwmLLBZiPMRBW9tfYXXYLLd/dH/SyE=;
        b=tH0aRe3XeyJsvm1h8ApJ9WoIxWcCgyi3HJbx/gYlI+3xboJSDQ+kRtqZD484wgCtb9
         brk8dY4BYYh8tH5HIR+0Wr8/HYYN1DPksGR1aOcFtwu8a0vtGiT69olOxo6ETaf74paN
         R8PVi4OsJ6PggyfOtyXH8v1ViYYn+gVtZrDY8Lvgh+eJauCF543Onn5p6sqdk7egfRdG
         BTqTfkkaUd8tPigIvo0AenDNWK80t+Ufoel1doOD6sWhfFjPwEF/7+yp2tUXgM8HBYcM
         6QiaWkMc5twIOObNLMIACCv+dd/LJrOjIB/bCPbJHzrraLOjc8GtvfPLgSoDTg4QwBYE
         4Egg==
X-Forwarded-Encrypted: i=1; AJvYcCX5nYdQXJZzmqom7+jHsE3FQJeUYV87BHn9ffTHQC8KJsNH8U4FVLWcAfq27k0CBZYZALzPEJ2i6WG/6dJtwFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAY9HlPwTYBKaywdo333gYJ3Ug/yQ0gJC1B5YOlL4ysS1JWtQR
	G3DCM+9DgVJN55d8/dFExAuPqFtAilQXQfenpsVhq1SeWy2UilIdYy5A
X-Gm-Gg: AeBDievYJDl59sarnZ2ehdSO91EXcl+WlRREgwrFW8NWwj++xn64XBEYbeim8XYdE55
	9RAxL1Ll2Y3IUb0phuRTC8MUVmejPxaY9HaoM/AZLW5GOkADEEyQYOjGUZUYxtr1BJr7Fz0i502
	c971Z4+ZsVzZvHzpJrLZZgdKIrY5kKYzJ9kJLYfYs2Ad8sF8/Q8/tGy4RwlG+BEJYduOkDA3GUi
	K8xbGJ+o/451PTbhN4gSGb+qB6CnlpMmINheWlS9mQ0brVRjRjbrnazJEtzzoXvRRZDOm2TqkOJ
	8e3bOrff7t9dzL3nTcoRV0QpRPxB4jsNn6kwe/ULzD/m8gWKxKQ2oa43DDTXMl8exfw4BrGxosw
	AwKzmGMOLVR2CTJ3bZsQf3Ma1FBqKruaa+nGAfod7rmarbdpkz6xdSOyre2KhG4d3d2iuzOpncK
	Iv9RfGK7pJBmkfy1lZokbI0iBptQbUfJPsKGmkrWl3iKB16g6a0tK6bRYTb8Gvdf9BL4VW+t71o
	Inlx9mDjOSpf8Z0BuGq1Ss=
X-Received: by 2002:a17:903:22c6:b0:2ae:3b9b:db34 with SMTP id d9443c01a7336-2b28188da6amr269183375ad.42.1775747267056;
        Thu, 09 Apr 2026 08:07:47 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497af47sm312363305ad.42.2026.04.09.08.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 08:07:46 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: nf_conntrack_sip: fix OOB read in epaddr_len and ct_sip_parse_header_uri
Date: Thu,  9 Apr 2026 17:50:57 +0800
Message-ID: <20260409095056.706441-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In epaddr_len() and ct_sip_parse_header_uri(), after sip_parse_addr()
successfully parses an IP address, the code checks whether the next
character is ':' to determine if a port number follows. However,
neither function verifies that the pointer is still within bounds
before dereferencing it.

When a SIP header URI contains an IP address that extends to the last
byte of the packet data, in4_pton() or in6_pton() consumes all
available bytes and returns with the end pointer equal to limit. The
subsequent dereference reads one byte past the valid SIP message data.

ct_sip_parse_request() already handles this correctly:

    if (end < limit && *end == ':') {

Apply the same bounds check to the two functions that are missing it.

Fixes: 9fafcd7b2032 ("[NETFILTER]: nf_conntrack/nf_nat: add SIP helper port")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 939502ff7c87..83741901c6fb 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -194,7 +194,7 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 	}
 
 	/* Port number */
-	if (*dptr == ':') {
+	if (dptr < limit && *dptr == ':') {
 		dptr++;
 		dptr += digits_len(ct, dptr, limit, shift);
 	}
@@ -520,7 +520,7 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 
 	if (!sip_parse_addr(ct, dptr + *matchoff, &c, addr, limit, true))
 		return -1;
-	if (*c == ':') {
+	if (c < limit && *c == ':') {
 		c++;
 		p = simple_strtoul(c, (char **)&c, 10);
 		if (p < 1024 || p > 65535)
-- 
2.43.0

