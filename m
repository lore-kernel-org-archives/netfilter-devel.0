Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F5394493
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778622911; cv=none; b=etPH0UKb2V0Y30hd9+DyEexFYPqexGS4KlULgZuM2G6+9CAzfN/tH80m6pK7IDx1OcIMCpqUq0f19jkm8GnCieAPrj5LNGEb41kK79lLQ1oXm00eaTFCFGP6x4Vi9tvjqxIbOYxeUTkqVHKC23nmqC6oG/idsKcMtjPGfNXckIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778622911; c=relaxed/simple;
	bh=reuPeR5st+dNjQ+dUnUpP6RytIN2DJ+Tp7VAQwercNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dP+4rt4nddNrkPbcM+BiyZ9cErZYkV7L18/amvJPnetBjl8bPhm/0zeWNr7xnsieiKiKRpDQ5nv2l+7+2yrWR3lEaUY2EcoVLg5u7OIQ2jKuYKamdlmt2kVwqs9nQfygyxIh9InQ4uIWgs4ZmJRCnYuIvKasVjiNgEM7m3PNpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1ww8I9i; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1ww8I9i"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-366375c43c2so3554351a91.2
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 14:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778622908; x=1779227708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9nTYItNBEtJamr9+Qzv1BppMHRb0qZCJCrUuytaYaF0=;
        b=N1ww8I9ilxYYwzVoA1zQfsqh9AE/Fnfno45zOPpuBlhwAsZjVLY04NHry8axtMI2NA
         z+EQCom2rmmbaX9ZcgJ5HEQK4CL9iPVOmurfhrMb/DtFgYpu0Q+r5PUxjpq1ZSrUTTFq
         8CPAYmh7i0uGAbkIvpAtV2q57EHwABKz2wgXx3jx0BCam6FvH1+YS2mJf9LadON4MOSg
         Y1nD0HNdHJpnCyD+VWVjW4AfbtvYEQFUfOi15MXq0x1OfHQtwJzjT98Mi5qljsWkNX8a
         3CyHmvFtg/fAX1O/TlxVPYGzjyPD+UvTV4ZDfPaB0JbZEFtJzZ3NWZk263pkbuhYMXHH
         mFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778622908; x=1779227708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nTYItNBEtJamr9+Qzv1BppMHRb0qZCJCrUuytaYaF0=;
        b=lN9/CLPNIfZVcHHmNC/MRWIFwqu3DrjgEu+WcHrG3mzhK58mRTMIx2SkwfgQ+jrwfg
         CTmbrPOPwMoFFa5nRUbUEpElKx1HVgnkZRfQAuDAuFhsEnJrEfCBb7f4yu6Pu1+JLFMl
         KWCP3aRdthpYiz/EVS8XhJofgT23kqOS4f6g2rUK0dcqDSa+NLBPMKfAZIIJKRRIhHM/
         vM3pcxhzJnAkJ1U3P1LH6P2bC0sj36Uz7lvNG5X5Q+y7oIX2CxTn539lT0HAMzdX43w1
         QspBD+FgNaSf+Mz74+DNsiv69waesp8ceV3CVAXCrvCj2EES8ikXguQ4CSshBsSo7ZrD
         JZAA==
X-Gm-Message-State: AOJu0Yy812BAWk6h43zweD81lRiufT8Zi8lXlgLhuEtdYSkyZ28fObdJ
	S+pJzJ5bPf109K26GC02n+xC/NWPdFldT0DX1mBc5FKWuokKJasfOGPIcsAYP93y
X-Gm-Gg: Acq92OGDCrJUQKEgWjAU/NtrIs+/17635u/Km3UR/jA4aiV/PK7MIzSFjsDi8GC2wPT
	YcNShlh0Fw6VkKaHfUR9MbuX0iMeFJCeoC2MIDymhB5H+NODvslMp9T35Ek5AEb27vwaPsAoZWc
	79bL1B+aTFM/Bh6mz/rsEqaA/asNdp7fcVGyF98hWI6MwAZOmkk6x8ZJBM+z2SAUOFGJQvMGyTZ
	+rfpSi86Wwf7wBFmhaXvXlsjXFT1CZ2K2SjkLI/tSs9aMjfKkxMmohTAcBCQDbFk7kQejBIspwc
	ZL7pxL4huzgt5U9pV4a5zwk15tyXvUjQ9GvRR2R96Qbjtoy80g8TpKKg0KSHPJf5mh5pd1JsbW5
	baRzD3rx2tF1Oflhi3pnioPNVZRftMtooxABCil201Xcv2QQsZ8pvpnCcaJrlK+z1xIrxb7r9Ak
	ohnCph83dg0jDADUJQJkkr05JTuFuekeu+7aG8yVJutPTg+bmKjGVYtEKSfv9QizetsfujWSvG
X-Received: by 2002:a17:90b:37c3:b0:368:3d3e:efa6 with SMTP id 98e67ed59e1d1-368f3f87c51mr696927a91.20.1778622908222;
        Tue, 12 May 2026 14:55:08 -0700 (PDT)
Received: from r912.lan.4v1.in ([182.70.116.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d52f27sm180335295ad.36.2026.05.12.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:55:07 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] netfilter: nf_conntrack_proto_tcp: fix typos in comments
Date: Wed, 13 May 2026 03:25:01 +0530
Message-ID: <20260512215501.1988242-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix three typos in comments:

- "migth"/"Migth" -> "might" (two adjacent occurrences in the
  tcp_conntracks[] state-transition table comment block).
- "agaist" -> "against" (tcp_error() header comment).
- "intrepretated" -> "interpreted" (RFC 5961 challenge-ACK
  marker comment in nf_conntrack_tcp_packet()).

Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b67426c2189b..47dc6edb4431 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -169,14 +169,14 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 /*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
 /*
  *	sNO -> sIV	Too late and no reason to do anything...
- *	sSS -> sIV	Client migth not send FIN in this state:
+ *	sSS -> sIV	Client might not send FIN in this state:
  *			we enforce waiting for a SYN/ACK reply first.
  *	sS2 -> sIV
  *	sSR -> sFW	Close started.
  *	sES -> sFW
  *	sFW -> sLA	FIN seen in both directions, waiting for
  *			the last ACK.
- *			Migth be a retransmitted FIN as well...
+ *			Might be a retransmitted FIN as well...
  *	sCW -> sLA
  *	sLA -> sLA	Retransmitted FIN. Remain in the same state.
  *	sTW -> sTW
@@ -798,7 +798,7 @@ static void tcp_error_log(const struct sk_buff *skb,
 	nf_l4proto_log_invalid(skb, state, IPPROTO_TCP, "%s", msg);
 }
 
-/* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
+/* Protect conntrack against broken packets. Code taken from ipt_unclean.c.  */
 static bool tcp_error(const struct tcphdr *th,
 		      struct sk_buff *skb,
 		      unsigned int dataoff,
@@ -1098,7 +1098,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			}
 			/* Mark the potential for RFC5961 challenge ACK,
 			 * this pose a special problem for LAST_ACK state
-			 * as ACK is intrepretated as ACKing last FIN.
+			 * as ACK is interpreted as ACKing last FIN.
 			 */
 			if (old_state == TCP_CONNTRACK_LAST_ACK)
 				ct->proto.tcp.last_flags |=

base-commit: 73d587ae684d176fac9db94173f77d78a794ea4f
-- 
2.54.0

