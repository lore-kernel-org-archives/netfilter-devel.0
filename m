Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112DF333729
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772908004; cv=none; b=JoDJX1NQ0R/4VUEeWzzOYdNvrVBeSEbGsZy3XFYO3i6yDWTTdO7ufEleg4k1O2NyckbG9fV9hJeyRY4oqk73Q8XsUaPH9ok+MDu14EeqVh3oEvaEsVrpW8mMMfaFUnNdtMvF5QXLH6JJuLqHoC65J0e4rRcu5jx+jUDX9c+3yjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772908004; c=relaxed/simple;
	bh=LDcPWx1f95bPyKfDPJh89acMaUAKyvRzcSBXPZSHYI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uHk6LQoPsWwxyl+lsCueAh3UmnRSuUPZSPb3xWPIbKnpdbsxpJAbHVufkXiXv5U2fGqO7cimHglOFhz3EEKBM6grgogGKyYbOd8E6I2jbbTj7dfdxVdKhA5sPhEW2ZkbPQBcx1aSjdG17CQjkW8vzLUMwPGgxzK/B/zFdXfI+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4ALIzQm; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4ALIzQm"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439d8df7620so1228521f8f.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 10:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772908001; x=1773512801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hhBEUEJUl/80XVEA4g7ryfearpKKWUJXRw7MRUNtDtE=;
        b=H4ALIzQmMG7ZTrfW+liAut9LChdN92vRIs+jJWB5TL01YYW6/tbJzN2Yv8D7utgFCb
         NO1LAJqJcCt7+7rbxKWRCrIuodQgjK78fdani+Jb01ptXaYB3HEH1SPuETlscFTpa/es
         SCHRlkmOppLDASGKEO+2Z02wYzewZZcP2JXnkCEzgFnz+YLQ+GeNsEma0ePeWUO2fbke
         ViANzIRdheUBqU7CvOq8mCZBccLSInbHPC/GyM7EIrpbIrcm+T7U09BLIeaSBxy1r6mK
         Ld25ErWECFt6D6MBoceX8AP/YkeQUCHSjX5PbCww+tJzXekcFR18bpIojPyR7ykQdcrK
         7hXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772908001; x=1773512801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhBEUEJUl/80XVEA4g7ryfearpKKWUJXRw7MRUNtDtE=;
        b=QYMVF+eJFAyOt0rmhx9KbGXPOn6pZQwHr5TVXo6mRifZo9Pjx+VgWZENp/yw5oR6zK
         X0IL40LbhLYKRIwV8tmQW2xzQFgOGmi3+Bqz9WpSkPj8rAtU5CLn+zTSN0dx6U5d/jSL
         kfRT8eTgERpB7uQxS5AZlyzY9jNO0iaLKo6Y2k5AG8xnFwzWeB6IMQs5DCrZ6ReNe6G3
         RdigSbj0wGuOMeDdP2589Nu4B2/26wxKygvIwaIMwCly42or+KNLuQq97TI+rJxX5yEn
         3A9vQ6dWV2WsRi5fEKND1ItcacUh9uPBZW7y1X9PzE/QB4/baeqCx10f9+U3Z9jWhKlR
         PqdA==
X-Gm-Message-State: AOJu0YxQsFjs0fDwNyqGKt08yxEqXwDZCtwuyulZTDybvECH3kydsCym
	GkmxVZuFip+6HqdN6n7HIaGpVz+C8FnFbOeLtcgRFbJIehiISdqG+i0HnVgXcA==
X-Gm-Gg: ATEYQzyyQ0zQhKX/DYRA6P5/+G87h3/CvuNRCqZfa0zpSCpO4cjMWiCFX6BBtlNgEdl
	1idcNSP07n4LyzAWkWnzhs1bLBYaWqqb146l1s2eiS8CqCwDy6SKJF5VtWSdQl/hyYuakZeD80K
	m1VZaM2ab2Hscinw5FzUGOizYi6TJaVWS939i4W4Za1Q3HyFAit8tPmMMD+7ulC1srmbbvg6ZsW
	NOrqkTx0E3Lh8/uxZNvN5h6n9HWPZCJAu0GtgNxIHSPp8pkw/feglyEijcIfs7nsNOhx+RIhaoX
	YNXrvW5kdygKgEDOnana4V/RX79ZoZDwHLZL6IIBUNsunykLk+XayOp9859jr1jm3r1IrvIaXTV
	aPQ6h0jc+3jynT6XFMKkohrt3yE40hr5yBOUohZXbjtaipTT1YcJlWQZvDoxy+H9sf+iGFwFdNX
	4/FV2DCMYXjecWH2Q8ad/sXJQSySnKDcS8hobXiaaR
X-Received: by 2002:a05:6000:2207:b0:439:cce7:d04d with SMTP id ffacd0b85a97d-439da8a303fmr11114222f8f.58.1772908000874;
        Sat, 07 Mar 2026 10:26:40 -0800 (PST)
Received: from localhost.localdomain ([102.164.100.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae3a20fsm13610466f8f.28.2026.03.07.10.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 10:26:40 -0800 (PST)
From: David Dull <monderasdor@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	David Dull <monderasdor@gmail.com>
Subject: [PATCH] netfilter: guard option walkers against 1-byte tail reads
Date: Sat,  7 Mar 2026 20:26:21 +0200
Message-ID: <20260307182621.1315-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When the last byte of options is a non-single-byte option kind, walkers=0D
that advance with i +=3D op[i + 1] ? : 1 can read op[i + 1] past the end=0D
of the option area.=0D
=0D
Add an explicit i =3D=3D optlen - 1 check before dereferencing op[i + 1]=0D
in xt_tcpudp and xt_dccp option walkers.=0D
=0D
Cc: fw@strlen.de
Cc: stable@vger.kernel.org
Signed-off-by: David Dull <monderasdor@gmail.com>
---
 net/netfilter/xt_dccp.c   | 4 ++--
 net/netfilter/xt_tcpudp.c | 6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)
=0D
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c=0D
index e5a13ecbe6..037ab93e25 100644=0D
--- a/net/netfilter/xt_dccp.c=0D
+++ b/net/netfilter/xt_dccp.c=0D
@@ -62,10 +62,10 @@ dccp_find_option(u_int8_t option,=0D
 			return true;=0D
 		}=0D
 =0D
-		if (op[i] < 2)=0D
+		if (op[i] < 2 || i =3D=3D optlen - 1)=0D
 			i++;=0D
 		else=0D
-			i +=3D op[i+1]?:1;=0D
+			i +=3D op[i + 1] ? : 1;=0D
 	}=0D
 =0D
 	spin_unlock_bh(&dccp_buflock);=0D
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index e8991130a3..f76cf18f1a 100644=0D
--- a/net/netfilter/xt_tcpudp.c=0D
+++ b/net/netfilter/xt_tcpudp.c=0D
@@ -59,8 +59,10 @@ tcp_find_option(u_int8_t option,=0D
 =0D
 	for (i =3D 0; i < optlen; ) {=0D
 		if (op[i] =3D=3D option) return !invert;=0D
-		if (op[i] < 2) i++;=0D
-		else i +=3D op[i+1]?:1;=0D
+		if (op[i] < 2 || i =3D=3D optlen - 1)=0D
+			i++;=0D
+		else=0D
+			i +=3D op[i + 1] ? : 1;=0D
 	}=0D
 =0D
 	return invert;=0D
-- =0D
2.43.0
