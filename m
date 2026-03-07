Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EEF13959D
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909176; cv=none; b=OUXL8MsfWaovpW/Kti4q4InTnpcX94CNQMTgMVi7aLvDi+ZJ/NWEd/4tNdRWeCXJzpJlYAShBlR3y83fr9uMSkteeVJFgkdREK5vb8bUiXSQnLntcfuny5CoOn6Jdr773aJPY5PuyEuOw1FW0rShM2nUFXm5hNAfFqSRWVxFaAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909176; c=relaxed/simple;
	bh=/CYdVKq2l5MzKXzbnzRHBtoUaMnVXnwtdkGZqN1ZVmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPMGRxfyJYyxnNmXeX//4kF7kFLhd3QC6ceVHQDKOwGD7HNdx1jskFbuAsNkk31oFDjGxt6jBOMVJorPjxltCaTnL7E1KBDUPp9mMxfaOmgVXIt1UbFiywkO8+qpMVbsMJFAMWAzh2PkJb9fTNcrPJBL6Jh2PDXScPfnshCVQfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgxQ75Rd; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgxQ75Rd"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4327790c4e9so7924497f8f.2
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 10:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772909173; x=1773513973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLhowYs/RuAbMNrDZmXsktoh6KkWBTGnUSpYNQYGOrw=;
        b=SgxQ75RdpEx+g5kDY2uKxTknRhQf6rpYEll+8jXetn6nzGTVNI9WRy0FtibW8lhAhN
         Ag9BR05ygSxgttOsj6maQScdOhCd7lwfcTMT6jRXeSFEgX/niv9dRcGmxshUV5YwZ9S3
         q5qL1Hq7kcQWnZicmRsjYQnUj20NO9/8Cdeq3Yl/wBAXvOhXUWOpd0FVAHRsY+Ydh9ic
         EoTpRXEIJkJmT4POWYzWQPUzesb9mBvvpIeIlvelQPYSYs0WYzUFD3Mw04plVEGyaUjP
         8UIHwJ6cldb2XKESfh3cgjZBAiMJVtZKYLlg+gm6zv1IsIUf0f7gAsPr2/hNctqeVeyg
         gVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909173; x=1773513973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vLhowYs/RuAbMNrDZmXsktoh6KkWBTGnUSpYNQYGOrw=;
        b=URtGOEy6iXWhMXFkeU+wXjbpQee6PA+i7xnoi2CZ4mtEIdjHK+kHM/pV3L827j+YB9
         emf07JbUc87nGvItHokF04Cae2Ii3+nVZbPTwH+Q3NC8UkV+f+V35ee7lp+dbAFVD7hz
         tf3InG9IrcL4zj7ga5ntFlZO1YRVrMWuurzILwyH3+jWzU00r0iAyrWOE2K7VeFHK0Cf
         Q5aL52iLiB2p2H7n3z4uYuNPy/6IEne1hgCjlQnlZ/kM8gNebueHzTk7H7kyQkk/woQh
         UiywIVNGdhSey88x09prWez4PCOS/jXz4CD0e71uKN/KLDD4zTvRdHecS+rpjbOHOKdT
         wIlA==
X-Gm-Message-State: AOJu0YxD5bPnRRGIa7ungWExkc6mIRz0kVNuOdI3eUdaiEICEM0oDrM1
	Bz9lwwcBfEbpEwd8jZ5++EL87AHF9LmqgGi2+GhaCPt11sQ+7hl9Mwq1Tt7bWQ==
X-Gm-Gg: ATEYQzyovI+faWPMXDnSek0tIpvsHJBYtPGCGTezrk9D0x6laZEpN28tvCVPMfuFXBn
	aBlv4hQBgxjNMV3Jnf3iDfIIlNsecPlP4eXo70+48+NxA7KSBgpkrDmtZt1j3MvJFyS0zVSTgfG
	TwOuzmAeqslUUrFNQtt1z5EoYHDIEB1ve1BxgoeENZTmtdf8AoifA2TliFIhz1dPn1Zm7tvUN3p
	wZh/0xPtYrOyIDYV0HvG9hrB+BUdcQ6f16esyOWbKGwTszMw+vZEA90y38tFFoCD5/lBLGM28Ow
	e7ZhTQWazKyamVsaykjkygLIGB64wg7TinRhAuSjI7dxJV7tRR1vXcpO8BgGSqSkAtjfI6urJgG
	SeVPxY0+vsZJgc3UPoOG/bRV2Aj7vjfQIHIUOn5I63tGfAWLHizbVLLftpadtxoBub8bUOXXcBV
	u4hCdVKKJdr11Edch51jO+WTYFkxRIkFd6TW/CoMNB
X-Received: by 2002:a5d:588e:0:b0:439:ccd7:cde1 with SMTP id ffacd0b85a97d-439da65c413mr10376467f8f.14.1772909172793;
        Sat, 07 Mar 2026 10:46:12 -0800 (PST)
Received: from localhost.localdomain ([102.164.100.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8da01sm13394197f8f.1.2026.03.07.10.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 10:46:12 -0800 (PST)
From: David Dull <monderasdor@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	David Dull <monderasdor@gmail.com>
Subject: [PATCH v2] netfilter: guard option walkers against 1-byte tail reads
Date: Sat,  7 Mar 2026 20:45:52 +0200
Message-ID: <20260307184553.1779-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260307182621.1315-1-monderasdor@gmail.com>
References: <20260307182621.1315-1-monderasdor@gmail.com>
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
Add an explicit i =3D=3D optlen - 1 check before dereferencing op[i + 1]
in xt_tcpudp and xt_dccp option walkers.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,a=
rp}_tables")
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
