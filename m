Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DEB41D10D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386539; cv=none; b=fdSYKaD/m7RHNlI4Gkq72pZMMcHVhuk3jRVWLpKg+x/si0hTqzr3h18Rf6LXka/835+KWvkvg0J+fkXw7sFBEJctnyBfnSWdRiITa0vsPeJpZQYPKzGPyqYPf/ov0bi16Hg4CWTusYCagzqMOFwMLVoZYZmg/+WrO4nMPm4ZOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386539; c=relaxed/simple;
	bh=Qz4ik2no93VbWjCQq3F4T5koe0iFjic9d0TMZix2Tqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=WzLVdvkrZ3lBwRZkNFmQbP1HpDxg3m5pyNXy89vLl/WTowmeH4KWySXq5Z1FuezPTGfpAypFXq/OOF6nffiO8T7zVC6Or0JNPKtijUCJ2CtzLAvA8SgDnGrhSfS657zbVORGOfZ9HXQhEilQPNVqHfFvnPQQ9u7uTP2r+/FlTro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=otE53AqF; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="otE53AqF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386528; bh=HVjDPcS8F4vJ2yyYf6flb2gi0sNZoj/gO+xbkY40c5U=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=otE53AqFVTwVWsyKcl6hNZz5ObPIWT9FQuXPtgxCNfPF5ZJ1WhCEM73nJdMNGZAK0MseQDRGRbo5RarJPKdDLYDswu6oOkmFo7FfKNSbSSmWY9fGJ2vk4Kk7D+jBjbHMimPsHAmlJDqGZdf3NaiRu2YyAuMytMNza61mtCACji+nuMkwY++SpAUgGy81NBvYqZUjuY41J1k2wECfKSyRaqz7uaSWEIefDLkaraLJuE7jieNnQ5sOccg//FOH9kAFLYjGESV3GFoWpS47EFVUXFGuHVInapXOwpAIb02QtnrXnM2myY61ng0jXI+W/glqkAH0YStOPPmW//dpISKPXQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386528; bh=5jeq2fBsfxWJbRgElJVgYDLvJk4l0GWcSd8laTgx33M=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=PnYSB802VbbGtCZq0STdY3FifHy671NcBpKZbIFyb1rOThtR1h67LVh0FLSKxe+ByXBOp9RUUOyLvmjCWuU4HlmVRO8dRzrH/LFSRVpEG7RlPtlwHIQTMdTIS4DaAGbGahGQu8OqrHI1B3IbAiHy9CpOB7lhJhpVmer72RRmIgjn3VlE0akZXL6P3C1G5BTB6j2S0K7Z6rpzeQlpct+oVe/sA3oh7TF+FLJE+x6VAjysCvDD5FQA6tp/LoSY/78uY2NhfxxMEqDshqHOZ6XXu5mS0leXWmhEjanqvzuUd5SelNVrG0vumBGW2+xr3TjC8Rq7yoLr6pVMX+tVfAlE8A==
X-YMail-OSG: _HBP7y4VM1nCOHOOAMgeFhMnPwVYJ.Qm0LIIEM.m4U_ROg9iuMMt6ZjP3WsRlNo
 u2f1r6Mv1jzwUJOPh215oNI80Yx_WcLD131zc8muV68W7gcEENdA8nQ0m6ZQmsXBqbRjSHGy0l8B
 9.AWgz7dBJzwyrBgLvO7MduZj2AfrYjr6rL2TnIrWu_CrorXj1SeWVLMWk4FEvrDj98Gu_PGflla
 5twtMG41QBnIQ5FuzzPdgjoJonWSeef9xszZ6FKNC4NGFad.cu7xjrFRCwmtbjGusBhFJGaruJkx
 c1_TmTmXTmzJ6tjCuoTfwNPQe7yjWnZgnJ8B_.7zs8m0Cy5Mxz0jHeBuB.gpnfgohX.vqIKi0cWX
 oK1x1gtj30K764RAJbo5bD7HCJcoDN.bNcMn4urJzryQB_JkBXY1_KRi7miK9azc_kkvAVvIV0nc
 OXtQpTcQ0d51lf8Mhf1nlkI2c0frcW4QZaDsKXgxaaAccAOOTr_Y.lxBHuBG8A2sLN8x0GMNgkEC
 nq1hea8QeUHYnjl1BwABB6556zfPy3_SXyRZs2fMzf_25z45kaKIWFyWkqjjAMkb2gnir8VVN8P_
 JpbKTmfoouQngHfNH7g3RGBQE9I3t6e2C3ctwhKezC5VxVXsF4hQA6yCR2kGYbNJASKLQzqlv5xo
 vllNdEkoioN4UQoGH4h0UMsOlTI9MPjmbYtDgIleI29KZMTekM3c.f17qOQatMg71k25WOTTSZFH
 4pMi912RUsywDFMMGRaOTtzm3A37zS6hN4X2PwV0xy.IL4yqg18cOoT5JA.DCwv4V_6eNk.mp2QR
 jx.td2HRvbehY1Ygk16uWiaPqX3Jo12Ef1a1UHLvFckxyzKtsH7Py95j1P1WH_mEHfAXQ2at7IYz
 c1r9a1S3.o1V3PKz.G.Yj4uj7LVpB2DdeZ0.TGK83MgcVuZWswLk9JBncXC5gvnfadl.KEMpBEem
 Nex9sCmChBP8RVR4nJhZVrLSNobHaGmK2I4wfAYbDkyA.BpF3TFidnJz8aE7cZ4efxmYIMOe1lQA
 T7Y.0Q5137TpWkWKAWeEsQwc89VCaXFMQt6GUJoNC.NVz_vlp982M96gL87ANv83QGM_JP2j4_.n
 dL5M0ypvhSRHKQWtPe9WSJQQA7drMgPSaxnhtgjYi5mfn1isG3kdaP9K8UA44TNrEgqY2IYDbJhg
 l90ynEKWvT3ZVsy8d6AY6jmICrPcpPMig9amMoXBXLl.8HUrU_KmFQmSS1Y9DJopoXyyw7QP84bm
 jB4SAqRFE3miiGvOgaRCSj3EETDBhoYZrAir2h7ZBC2tuegb4BybX9nXSCDv3HxzHxNBeB_EJtaB
 dUoeBlmRXrr4QfEP9DoajQooR.HplWaHqkQ00xGaR9T0Rlmg3gCfClklFcnOPfChvOpfm3y6uxcH
 EARgCm_ShxVtt3GRR.beQs1YcX_iNSiu83dWuVhgn7C6Vyqv8MBS.utYecAL3SzjRUFMzkiK264m
 JcAxMhCgkDEaa.wGedxX7Ocm.4ZGO9w2KRjB_DOXRUkE469VOhayTkLUpE3Vw2Kt0Aqpp4U1beai
 TG8AkKIO0THbb5XcZwFf8WQJDI2djif0QyF0XIx0RXgAKcAKqRUmqZdbUYshkRGW9bkeFMhpvtO.
 BDVD8yARIErwcJN3rKdIKTk4hVf1Kl8dsWcVtMnB8BeUzz_aZuq8RffQRx4Ar6bWrneygj4iiMAW
 auZLyDfTye6fX65jvLoCzwGeUKryQWcifwNtQUrf7vaPriWK9aEkBDUbF8d8TiJYL7kxqzFWuGq_
 jAMT4XopTJZF6nVhl.rFHDihldQBYD0mRycuURMS97ULpqIJeHkuu5ONa6r2xsjaMZKMyFkwDgS9
 F0hRJuHsUGVXEv5F.nuWhTbRubEo9QjfeRH2BzG0p9HlRNcouUxhz8hviy2NPHPwY6mIBcrzcGip
 xoCdUUy5pHyeMsy00gMK_ecMeir5_IhkkRt8Wm48L1vxlRh5XAQg6en4u2kwiixOoJDUZGddQtVF
 PoLVZndn35urFBaw0HtorPLpo8LbhdYMPcBU86OAbdgwLUebhUzfXsKmu8tVcuAeLOZi.4m04HbV
 77LAkMXnVM7rTJWmVoBDnp1d_qzx89_lvMSz7rOdDqJL0FOnHCxhX93GBvr0Mg94eISpJzPv.QGZ
 4p3o1ulaeBWgjmUkWbdRudjvKwpvASEXUWjGukhkx9lngZ2Q.kMur9XQImwY3mKkODaxiWvQW810
 6d0nq_QfPFQ9DQl_ijtfVu6M7M02kkrawQf1A3fhvEmp6uAYttEOnDl2ef5nx6mO.ZmYK1f8GoTZ
 eLidiVM8vagx5GWRds2vv
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 11d8b984-c4cb-47dd-b9ea-426920e65f8f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:08 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:03 +0000 (UTC)
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
Subject: [PATCH v2 0/7] Change skb secmarks to x-array indexes
Date: Wed,  2 Sep 2026 15:01:43 -0700
Message-ID: <20260902220150.18586-1-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260902220150.18586-1-casey.ref@schaufler-ca.com>

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

v2: Address issues raised by Sashiko
 - Configuration option insufficiencies
 - Locking issues

https://github.com/cschaufler/lsm-stacking#secmark-xa-7.2-rc7-v2

Casey Schaufler (7):
  net, smack: Create a function to set secmarks
  LSM: Implement x array functions for secmarks
  LSM: Two hooks for manipulating struct lsm_prop
  SELinux: hooks for secctx_to_lsmprop and update_lsmprop
  Smack: hooks for secctx_to_lsmprop and update_lsmprop
  Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
  net, lsm: Change skb secmarks to x-array indexes

 include/linux/lsm_hook_defs.h     |   6 +-
 include/linux/lsm_secxa.h         |  33 ++++++++
 include/linux/security.h          |  20 ++++-
 net/netfilter/nfnetlink_queue.c   |  12 ++-
 net/netfilter/nft_meta.c          |  20 +++--
 net/netfilter/xt_CONNSECMARK.c    |   3 +-
 net/netfilter/xt_SECMARK.c        |  19 +++--
 security/Makefile                 |   1 +
 security/apparmor/include/secid.h |   4 +
 security/apparmor/lsm.c           |   2 +
 security/apparmor/net.c           |   8 +-
 security/apparmor/secid.c         |  21 +++++
 security/lsm_secxa.c              | 127 ++++++++++++++++++++++++++++++
 security/security.c               |  38 ++++++++-
 security/selinux/hooks.c          |  87 +++++++++++++++++---
 security/smack/smack_lsm.c        |  43 +++++++++-
 security/smack/smack_netfilter.c  |  11 ++-
 17 files changed, 417 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/lsm_secxa.h
 create mode 100644 security/lsm_secxa.c

-- 
2.54.0

