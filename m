Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792850112;
	b=duF8OKMAhd+DULMUC10THb/6K9tLRLWZ4GWRmbI933fYR/5nQQNUfhaKIl8f+jbfV2BQ
	 cz1LEGWsAuZyBV4OWSr6BZ5LRPG7OoVKCJABTN48JuonOvaF343pPsFVlz0vniC3RRZSZ
	 DXYEmb8TWECFB2NgnxJ3go/6UniSK4Bbd3ORXlaE3EDaY5xtPwGwcpBwDR2bZLhqYUTa1
	 zJuWo8fg+T6DiND61FIprzQj7SBmEoQSp4mhY6/laNrs7uTkt27nG5+l3Zm3kJADREwCa
	 UB1cYPMddxxwXp9ijcOw5uVCiLxCffBBGVmrkPHzlptSbePNkszYLcX9JvTVeJM3DWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792850112;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3WqILMMasLIfOYc4MgkSAAPs0tyX0HLUjF9zVOhuEpo=;
	b=taDWvHOdKiLceEVmiczZ3Ken/wG3HfMKHF5lK2vAMs4N7yc+TPxhol4g84Sa9/sBbZro
	 es9pK1YL+yAuA7Ybi8q6RbB815IMP2qnG5j69CkldfKyI+QNrHWrt4U/YLOthhhT/vuGk
	 6uBhY/U0kDQ0Ps1TxYrkU7EUCCWCzRMM/wG3Y6zDDqwdsStKuAu8gfqnNUS34V8a8vA4Q
	 VR9rIUcz30pN9aTBuTbdj8lvm2ahGknHCXsg4Ym2KtpzV6Y2VYiTkxWsadwRX+JgN0EFu
	 MSEGG7nPIXCRDQ78vt+xmK/fbqUsvVW5drXQnasqVN2QJbIHVTxduyurxSGk+ftP8rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=h2wkUOqN;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A21606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 13:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9A21606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=h2wkUOqN
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so2885767a12.2
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 06:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792850110; x=1793454910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3WqILMMasLIfOYc4MgkSAAPs0tyX0HLUjF9zVOhuEpo=;
        b=h2wkUOqNbgMTOZH5zpcsL/6TfaB/xXJ4YbtX59B6r6pw+ZGEWePsspoxyszmcEbi17
         Tm35E3MY326xa7ggG8DkDZSt9B+X380jLSk96DZ1QP3NTEbIc9kDWSBjyARCT0BnL0Hp
         Iva63qAwAtWryV+YGr42fRqPnSBgnzfpqcfJ/d3BD6W3jrOJ0tXkb4UJtTrYMqEhpIg+
         Sf4NccdPPevOGO4sKOqmH3QF9q4Q1/WDp1E5joP+5mk8IgM1/1u1xtjHBK0NgZhGaDOr
         IU6wsnxcA4ht39pITLOXe14VWJrgWGpVsoq8NEhjbPCCiFwMRG1XAuO7Aaz51HMFnh3I
         QSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792850110; x=1793454910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3WqILMMasLIfOYc4MgkSAAPs0tyX0HLUjF9zVOhuEpo=;
        b=x4TxeYsHqM3QVkf8IkVho0Ggqsvh7PxyLhXrooivF36BJkFIkW0vDQf+Nzjsy2j+1w
         CIaETm02A3HxSZxqK1PfYiT7LX0yiSzys1NdEonzXuXmkXrHe/fQbBE5x8B+fRFxHsQW
         /yP9+6kaUGtmtJxJ9aC1eVd9ni1VrZwdcIGFf1dqm5BGigNfiwJzSYbPmW2SHq7dwaXh
         zW1fh02pDF6XKtljuNSJMW3fea7N9Au9fGRtaJKxLL+QljeEz4cxVnul2TQsamnJ/b/2
         aB8c4OO/B8Nksmra78rTUNrcxdtkGBOAPdtCOv+OcCCjtgFOvJB0UF0fddpFu3RVdkTV
         Adbw==
X-Gm-Message-State: AFq9FYLwM9z8M5pfdHXHmMUL07dnd8kttqnU3sYwnC4a3wmq7nGxv6Gx
	GIXk5e0nqn5TRqBdjDo6KZ+RBxxnEzdvV9v/gMhs2nooZFQQF4yOM+m80b+7g2QJ
X-Gm-Gg: AYBFou3yR38/mumQ6iPc99OTxsWFeOQwkaQ9KGoYhBfbvP9uCFBaCtV6Gjcr6yxnQ9a
	S6Qn+mTlgVmjViiz3cIsIcCiYFfXmwNwJ+dXRCKEXRDy41XYa/dA/zxKbk81IZpuxlaBBvNDZSd
	za0Ihej/tzrT+Z16x+C4d16f1pIdwr71og36TtItITXsuyxu41EjpXQdjhvOE+KlG/uLrybpL3I
	uNY5csE6uNKiJ9WLD/JToGYiSdIcXJRI5HdAADPbFB9E0tXMRhcFBqC3lEAxgX6+D/v/YKAiwP+
	58/b42OeAMzeFu8sp4IXpiRZLtv0obq9hsM+d3KKh85GvUBRJmmxa+66olZYMDGi8GUpIRlIZVn
	DLdjIvoKvqWb9sqPc7R3xo6kSzRKImZY2eHea9p4/nK1u8Jq45FAqVDSfKLR7pWfuYz+RP2G89U
	K51nIJY66+T4FXKvt9PmHQPGxAW6WWb2Olsu02HjW6/2BlMrzqCzEof+W5IrWKsqo2zIhIBVow0
	55yE69b2QdLwJTbux7P92/zCmIdupQIN/1FOgblk65Oc79djArAOTPdRGhuZbm6ST66IBdfgINZ
	TqHmR9OOixiG95ykmohx8lAQhhOxIKY6IQE=
X-Received: by 2002:a05:6402:51cc:b0:6ac:73f8:2e5e with SMTP id 4fb4d7f45d1cf-6b44325de6cmr2843796a12.39.1792850110241;
        Sat, 24 Oct 2026 06:55:10 -0700 (PDT)
Received: from development2.visionsystems.local (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4459711d2sm994628a12.17.2026.10.24.06.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 06:55:09 -0700 (PDT)
From: Yegor Yefremov <yegorslists@googlemail.com>
To: netfilter-devel@vger.kernel.org
Cc: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yegor Yefremov <yegorslists@googlemail.com>
Subject: [iptables PATCH] include: linux: drop bundled copy of types.h
Date: Sat, 24 Oct 2026 15:55:09 +0200
Message-Id: <20261024135509.4097035-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.34.1
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

The bundled include/linux/types.h is a copy of the kernel UAPI header
from v3.1-rc3. Since the build uses -I../include, it shadows the system
<linux/types.h>.

Kernel UAPI headers v7.3 changed arm64's asm/sigcontext.h, included via
<signal.h>, to use the __u128 type from linux/types.h:

  - __uint128_t vregs[32];
  + __u128 vregs[32];

The stale copy lacks __u128, so the build fails on arm64:

  asm/sigcontext.h:81:9: error: unknown type name '__u128'; did you mean '__u32'?

The system header provides everything the bundled copy did (the
__aligned_u64 and __sum16 types used by iptables have been available
since well before v3.10), so drop it, as was done for ebtables.

Link: https://lore.kernel.org/netfilter-devel/CAD04=wrZafKknWixGGRZWtYD_ydfdL4Uk39s_RkwZ6WUEVATKg@mail.gmail.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 include/linux/types.h | 51 -------------------------------------------
 1 file changed, 51 deletions(-)
 delete mode 100644 include/linux/types.h

diff --git a/include/linux/types.h b/include/linux/types.h
deleted file mode 100644
index 630cd3bb..00000000
--- a/include/linux/types.h
+++ /dev/null
@@ -1,51 +0,0 @@
-#ifndef _LINUX_TYPES_H
-#define _LINUX_TYPES_H
-
-#include <asm/types.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/posix_types.h>
-
-
-/*
- * Below are truly Linux-specific types that should never collide with
- * any application/library that wants linux/types.h.
- */
-
-#ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
-#else
-#define __bitwise__
-#endif
-#ifdef __CHECK_ENDIAN__
-#define __bitwise __bitwise__
-#else
-#define __bitwise
-#endif
-
-typedef __u16 __bitwise __le16;
-typedef __u16 __bitwise __be16;
-typedef __u32 __bitwise __le32;
-typedef __u32 __bitwise __be32;
-typedef __u64 __bitwise __le64;
-typedef __u64 __bitwise __be64;
-
-typedef __u16 __bitwise __sum16;
-typedef __u32 __bitwise __wsum;
-
-/*
- * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
- * common 32/64-bit compat problems.
- * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
- * architectures) and to 8-byte boundaries on 64-bit architetures.  The new
- * aligned_64 type enforces 8-byte alignment so that structs containing
- * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
- * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
- */
-#define __aligned_u64 __u64 __attribute__((aligned(8)))
-#define __aligned_be64 __be64 __attribute__((aligned(8)))
-#define __aligned_le64 __le64 __attribute__((aligned(8)))
-
-#endif /*  __ASSEMBLY__ */
-#endif /* _LINUX_TYPES_H */
-- 
2.34.1

