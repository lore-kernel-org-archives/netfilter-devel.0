Received: from sonic312-30.consmr.mail.ne1.yahoo.com (sonic312-30.consmr.mail.ne1.yahoo.com [66.163.191.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6696C3ED3CA
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.191.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654155; cv=none; b=JhUkpEVAdnukIsCFHNUi6hJs4zxliYE4gBTj0tH4KnSDBVZLUGC8WxDq5xMHJ5uzrnOdDif1jBgq/aKxUsK7CsEAprHRW1+UDewH8uqbHgcZAdAjjfJlsBEPLtoqfQuRvhMBW2QIV9JyJDXkp1P/PM5coG+Axr05iASHcZ/w6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654155; c=relaxed/simple;
	bh=DIQU+6auSh2IH5hwCPHBRsjGy2ENr2rewD3KTBPZauA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=L06Nm2CTH9IOmuvN+DscDliiixOHKzgu7gnlupMqRsHYoP5Qd7P15zygD2eH0+aWBOYJUhHRKOY1mozZ/AOlKfQ7AOPgtTBCaTZeO8OOfHrb8iDDKSL/dX1jPqT5FMuzU6Fb8NYFYGnzLrDKGNkRhaSAnmVKPb3FpUORoJX/JIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=TjFFaPvg; arc=none smtp.client-ip=66.163.191.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="TjFFaPvg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654152; bh=/RMT55IF9krlnK8CsE8LRu5kxWE2zTAjTr2x93QxEpA=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=TjFFaPvgJ9b72N+qaZQJLU8PHcZsC5eerargR66R8A31h/HmClVKWBX+qS6hfJ0Z/znGoo+5l+FDseudjp/AtcKpK4xy9tT39emtqhRcPqdPW9udZ5bDMR/bnB2p5KS1+hT1tKdmNG6shXVJZQI0S25TLUPtM23c76NRDojJv0OMfC1u5p1SInrZgvgKMCzk738UHw04qET3CVqLzriheYFT7itcm0m43pU9j+HQPTHa8BMy5s405WIid8EEiims4H2FdA8AmpZrrhw5bCUk1Pj6H4kbkDpUJXWlYTyFLnSdwiiSdr115jvfZcfPj5qkfJ/vUEWqE0xvLjaGlVXGWQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654152; bh=am7R0gBvRkkJHhwcTc4xrmJJfxWFF35LHGRnGI6OiFu=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=LS8AiTg87omGqd4GWiCTb06ae5MPqNs1kjBHFIHN/Q2lcAA1yioB0zXwKRklGQCvtyYqG8H/zlo+U522FL+rJcIDQ+BFQwoUl+0m8QzTtdK0uZs7O6KvaFEfwZaVbrsDPZjY+2/kI6ClrZ4FPQK7SjZspA7JKdg0it5Z/K6ZFiX3hApP7gWsO6wBiOU0zrf8DngbJT1RmGuKI5/4OoFVciidLrV4nR9vmdesFyyy1w/U8cHI7ihxOioSA3MstADWhCADK1TxIo03uijcCyb9BDOQSp1Abl03cfDvGJSoEfstJevgV4FEFu7d/52cHRaZLwl/PrcWiGX3/e7zklzgIw==
X-YMail-OSG: PXqJN5AVM1nMUZk1ij9VznziUc6mIyncqkuVhWhrrq7hJhll9fkUcjj3837BdkG
 3Ll3Qp_7vgSS_AENnvYbgN0JUDq9OpQm3MWrK2AjlObej7Soo5YLgKYEnjlaZmLxNW.zdpeEeOHq
 UbOfT7aPir3po_qDnfrcHpC4ZSybFoSVKXQR_YtDUmRcYQ7Hq_O9GlQFsAhgigYonyw3XwryBSst
 4p99x7ErMtD2yhSR9q2z.GAoeQDNTMBS1dThQl8UufSpm6T1UOsulmF5gwpue.xH_i8z9rcCv7J9
 zJmuEk7iwLjrniIlSnCIQuV308marDT8JupagaqGp.3Xgx0m2TiRNZKkWL4aDIleqB03j8qWTfe9
 SXtFmJI_smfr7P1ESA79604X5Q.7VRQyD2h6h6IOOcU4oVMsZRi16Ur_vW0bA6eSdacenKU1V4jH
 4mcTjF.htq9PX37q2SvvqoJTIMw6hB9jhm_9DN652jRUnq6ns6PkatsobXadRrBTDIfRY5a5Keri
 xpKxFsKvTC.YJ1nOF.klySBD_rt5YsWpBF8yyP287M79hUj5Cm.6Q70Jo.fcFFOF1rJW7xhf.ZsC
 YlP1pnj9LIAjK_5aAQlnmqZX.Diq.nfeBCoRbMO90.LBZ1NRVAhX00Z6OkS1UWWI1osEO6bFZCTx
 GcNQ9s.FQEzRvjXqAlRhQusPhS7kD1cwApk61.iRGC5Fu5gpfXH9vcQQAJHmJ0cnjJcMfIWTKRrT
 FWKkjzfa7PLhryQ1TQefOJEUM5x_AsgNB1lxelLOzhtodBZLFwWu37LfH6N_o8efaadnBPUp3kE7
 ILuhq5XBkfAgxYxlZRr15gSUQ0qIoNHBoAp5WAJVAVO703CGgpS3.gtX1mtuO9o6QF52EnVbOffX
 qDN2LUWXRTdmPvt7kGjAU9PsMG1dQkH79wkFVqcOg2H1e697j.E4zvgWy_8HZRWRgYFqLsxpCqcI
 fwPGiaZwLDu5kKczUekWWZtZumtgOUqQ6_DYPWOL0dQ.XI6wn8tmLeVcKPaGW1PmGlkvPrrSUFgh
 mLhntiOVrPCY_Yec4CjYLTRQyNDBzaoxgeVv3FdbL1Ep_zxbfM0qoGhm9Q9dxtGF5veoUJk6RB2G
 PBtqcQYtcNrg9WVIxeF9O2xz8.h9mZA2TtSXJ5.Yd1i.XcCqBMZOk7nrEAD.qj6NoxKLbdlU8Apq
 PyJci_vdGMOlNYL8PRjHdYiO4fsGL38XFCIyjCMqNrWEaia.kNUKkGQ0lkrJPxG3AXnEFXI7jAyY
 SsQpYJeDD.k_NApG5B1coMK4urIb.tZ0cRiRoutW291A_PNV5OapCoqmjNejAhVE55jfFBd3F1UZ
 Gwv491.jEJe9dFLnACBPZJtUmBWJkjQMUbU0uhCZSKLxEm6i_VLBG6aWAOKDFLgX3EKE3pZUiXsf
 8UZ.swip1CqDUU3ihlY8WnEIJBR4AVx0Tg46UMsNKnhga.Na532XGgTTqBbYQWtB39.hNDZF8IFz
 FpzoKe2J6KZUf0bSZPh9YvqoYCmey8zcYNqX4Y5tosny8I_hWRCxHnqr2zGPFqzfq.cGtNMkE4j0
 t3hbm61J2Vx0sPQbK96PbvNLB32nCU_dJFzNfpiptAf6SBJMnPt96XOrfMq86LbccNvZxnqv6hmD
 gbM5OPeGxSkA2FuAZw1brUlOaHTs.2lHaABPr7DYaeC.La9ej9.cUFia_4YPC2iLJ9aNTSq9XGjE
 IuwxHQMxHQKp6rp7e2Ueu99_8eqp8ucRW5bAZ8HL794OaONg6s66oNcIGFEr.b8xV5bkRljZDW8C
 78KO67f9eGVl87WTiBPtR8cXpzIzB8wplB9.YykBM978NHF.1WZ8wOh0zcBkjvDYvXy3X4cyeHQp
 y2gi2iILlY_Cp_kMeL9SlUmOITKmTfzGfxyOTUDogeo9078HLhQ6WkDfXbqZq0ISXUo9u4VT2lup
 VNH3mnSMhoMzFZVXGGcWeQxik0ggsRAGKsdn_7wOXOSTvw6JaaOSm7q1tE145X.kOl7siuM.kbka
 Y5MkjUzUPgekhwHmyKohVIAaKGAibpxw1ODdIyM6hrwrbceId_bpcgA.skiaYwjAfyHdv13EbKCd
 5K5F900lFxYvXEratjwPc0RJcw78fc19Eg7sXI5hqHsrz5bZ8ZCru5ycXAfqXYqEk6HFU5bFINnD
 1LCLQv0zISwA4knjG0HlWAWNpWwA9dhmRMNSMb.r15YmZQ8s0J1ZMopz_ZbOMWSfvQJ76E8CowWJ
 3invtJzd7MI_XY5TH.XAJQ1xWeLYhy7514cJRxueTaAkTZuTKqN1SiGoZX2QqAVUFhv_eEYFVQ3I
 9yAbUITU45moWF5UXEX0S2g--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: e5e0a941-d512-4301-bce2-2ac91937ec17
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:12 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:07 +0000 (UTC)
From: Casey Schaufler <casey@schaufler-ca.com>
To: casey@schaufler-ca.com,
	paul@paul-moore.com,
	linux-security-module@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	jmorris@namei.org,
	serge@hallyn.com,
	keescook@chromium.org,
	john.johansen@canonical.com,
	penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com,
	selinux@vger.kernel.org
Subject: [PATCH 0/7] Change skb secmarks to x-array indexes
Date: Thu, 13 Aug 2026 13:48:47 -0700
Message-ID: <20260813204854.19211-1-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260813204854.19211-1-casey.ref@schaufler-ca.com>

When security secmarks were added to the Linux network stack there was
only one Linux Security Module (LSM), SELinux.  SELinux already used the
concept of a security ID (secid) as the representation of the security
information about a system subject (active entity) or object (passive
entity). Adding a container for a secid, the secmark, to the sk_buff
structure allowed for efficient transmission of the SELinux secid for
socket based access controls.

Subsequent LSMs have chosen to represent security information more
directly. Smack and AppArmor use pointers to structures containing
relevant information. Alas, these pointers do not fit in the u32 secmark
on most modern architectures. These LSMs are required to provide a secid
mapping to use secmarks.

Even with all LSMs that use secmarks having a secid to reference the
security information the mechanism is imperfect. A system that wants
to use multiple LSMs that use secmarks is constrained by the size
of the secmark. There is no rational way to fit multiple secids in a
secmark. While it would be possible to allow one LSM to use the secmark
and any others to be told it is unavailable, this has been deemed an
unacceptable limitation.

There is a lsm_prop structure available that contains security information
for any LSM that maintains it. The secmark cannot, unfortunately,
contain one. Instead, an x-array of lsm_prop structures is maintained,
and the index (secxa) is used in the secmark instead of the single LSM
restricted secid.

Uses of security_secctx_to_secid() have been changed to
security_secctx_to_lsmprop() in the netfilter and iptables code.
The security_secmark_relabel_packet() function has been updated to accept
an lsm_prop pointer rather than a secid.

To support multiple LSMs using a secmark it is necessary to re-evaluate
which lsm_prop structure represents the current security information
at each step where the secmark can be set. Smack sets the secmark for
every packet.  Netfilter, used by SELinux, Smack and AppArmor, will set
the secmark on selected packets at a later time. If Smack and AppArmor
are active on a system Smack will set the secmark initially, and AppArmor
may reset it by netfilter rule.

https://github.com/cschaufler/lsm-stacking#secmark-xa-7.2-rc5-v1

Casey Schaufler (7):
  net, smack: Create a function to set secmarks
  LSM: Implement x array functions for secmarks
  LSM: Two hooks for manipulating struct lsm_prop
  SELinux: hooks for secctx_to_lsmprop and update_lsmprop
  Smack: hooks for secctx_to_lsmprop and update_lsmprop
  Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
  net, lsm: Change skb secmarks to x-array indexes

 include/linux/lsm_hook_defs.h     |   6 +-
 include/linux/lsm_secxa.h         |  22 ++++++
 include/linux/security.h          |  21 +++++-
 net/netfilter/nfnetlink_queue.c   |  12 ++-
 net/netfilter/nft_meta.c          |  16 ++--
 net/netfilter/xt_CONNSECMARK.c    |   3 +-
 net/netfilter/xt_SECMARK.c        |  15 ++--
 security/Makefile                 |   1 +
 security/apparmor/include/secid.h |   4 +
 security/apparmor/lsm.c           |   2 +
 security/apparmor/net.c           |   8 +-
 security/apparmor/secid.c         |  23 ++++++
 security/lsm_secxa.c              | 119 ++++++++++++++++++++++++++++++
 security/security.c               |  38 +++++++++-
 security/selinux/hooks.c          |  89 +++++++++++++++++++---
 security/smack/smack_lsm.c        |  46 +++++++++++-
 security/smack/smack_netfilter.c  |   9 ++-
 17 files changed, 398 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/lsm_secxa.h
 create mode 100644 security/lsm_secxa.c

-- 
2.54.0

