Received: from sonic307-16.consmr.mail.ne1.yahoo.com (sonic307-16.consmr.mail.ne1.yahoo.com [66.163.190.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE539768D
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788217126; cv=none; b=RrQ2VGp2UntIEtQIGWad0+hZlTP7laixuGP2+gV1kFSyr3Fs/kLa3lb7GLMVgVbUyAnQOu2/hDXi5QumX0+Dqy3kkpJgUJ4BLyCnl6WJAbMUJltasvkggctOZKm5JHua1UiO7msgOdrZCl9mLHUyCVSxwBjh1M7PT40746jnjuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788217126; c=relaxed/simple;
	bh=bbNYb3yqFL/S3c/QVE3uKjr1JVkhomg4oJLNAcltsRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=ky2aQFugv0kVEpNga9PfTcqJ/quL5VkeTmvArmMfLx8NUBkvZhfxM2/H48qwgfUxnJVzZpjREpNyR0OrwIoR0Gq8JBK4fuKBGRamm0h6z7TP48pLwRoVTCx6YmmqAe0+k0CPQBL98Bq0K29E2/owzFO2ncYkJoIwVPqh6hGDoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=NztPMeP4; arc=none smtp.client-ip=66.163.190.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="NztPMeP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788217122; bh=l0sO2SYfGRYvlcNWVz8ZWrNgwyr/k0iy0Kc/Ebdd3OM=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=NztPMeP4KC0AIYJf5L22s0M0yTq1deRLcZMM07206Q6Qcaoirx4+gj0FIPiHPDgXNQgwHsnZtG2VQdWlzTDo5rYcmh6DJFYyw1sLvAN8kESUiFi3f5XvMW2UVC9uDWzab6Yc1DjdgCBxWiXxzzvTmdjke5Rc2OeeJsFfZ1ldb+5iUHIuL/r+xmZwmobn8l2qf6xT5r7Wg72vEAhFElS3U0zD7FM/8vmYlLvwb68T9e+6iPMgpZAVbzVtjZp3HfZR7rWCVuUmoNyi+GG3xBNmypKpQgI58gqhm2al9O0cwClZhBL9AE5FqYEu0vSPQCpEUp0LFWduUDUMz5hhyDN5sQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788217122; bh=Vv9ZQkhieguNoEioiL3jlkYC/7g6etIO7nGl9sYOy05=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ahNjedXXmzUEiEFjvCL+YIFzQvpZFWZ64JI7xuLj4MPXRqpQ9OGYh7FVGDB2kvZZD6nuXKm20uY/Abd1gzCp5A4EUG+owmIPdBKjRLsismFtieIEjstEIeGiVshTZPTqoVpx+DYmEugDywaVgA1OufBqWbaD92LG8wdqaN5mfqC5Yuhg7hR9ESk0z93imBHDk7M58oEc/SdqqpYwDxHecqWP3BloaCnoyj8oSPQhKAk4VTWwn53vagSxOqRpIMeaGcNoU3sPpdBv6+Eke4bqSj6RHoDP7gaJjyfqw9472DzLw0vzTmcG+2w74bVgCskw3vc/eSqOXtjcShzaNlrlGQ==
X-YMail-OSG: a5IPlA8VM1lyzxhQzoPzriq1enrhpIVww0i6L2OIScgva3sLUdEReMG6j5T8SoT
 K2p9i0LTJTxyt76C4kFjqXmQPOCjY07CE7cc77arRGuDzg8stSvpdt3fEWiciFRFWhefPeO0YqBt
 WiGx93FDK8pPpLDEL3CRaMlJvcQBTB8Yt0iHFwRabomXRSXBmY202jvZV2UZYpRlq5Lgxc3VcmNy
 ZKmBI4h00UdgJ4lCEl9Uz6OezYTxDbXtBbEBD_uyDnTDxvbpYVHRcflNSjQSJZ2kS1Wi3Z5lhQaM
 6Q.bfW.FLAxQoCzdlIw4mzC4PkzpfHGHqbdzEV.GNAla4hkKrAoHuY8g6U5lqzfUQ3znnJWkQl1m
 3U_Vtz8.Oo5igSUd8LNYQhIDE4UHTFq50pLQUgByzl7lOjTypp2AJXY5dK0p.m8dDIPqSm1Q4LZB
 cEQ4UphtKv.uKpPjSbvlEkiRPyqr_X6Ch0f2I5bC1GPAopK1NKJOCz2VpSb7J_7Yv2Xh6SCZdu0h
 bz_RG5dNita6H4h6kbHyFcU4VVLxpZ.JjIJqUnOlzsieqG8F4iQ01EgWyEhNDQAIEyQ06rs7eD4f
 ovBDfpsKV0CVBt7fT8u3cCYEn_sPDLunOBzA_RDNfLT7Ks7kEZJRoSTcXqOwwSvQZqPxdZ6P.H4T
 .1ppCBBp5pisteOHUEEOomLp2bpuFRJNBniHNlNjbnZYvorD1cfDplX1JrrR4HSqBs6KWmYMLJZX
 sNtmC27yfl4T.5AS7N_slk7RWHu7O7DD1iAvO9xWfE6S1.3p6VDHRLjnwcgI4PGLoRhquVjNIHLZ
 7B9euTCldBnxKj3SwEt_pGo_DvoKEyxkDVhsIcvkwC5EXa8IEIwU1grb1FmLAsdS2YyvWgBiwQuV
 l6XWtmclVXAr6ytNsXRJFmYlxJNKSX9mDiRzR3zg0zNdkwJM6MDgH5P4nkNjZKtseR7QGnCfr.RQ
 p0xhgfjGEkNxUpVeR3zA_sz.xYZEMBmYbmuZlLMZKIs4FT.0aPo_4tNq9suTcdq1DrCktbMbPGw0
 IWzurW22nFV5xPodT9RSjcHiBaaIF9q.2_UEn5CpKhUtLqxWxxHMRSSHJkUi2wfo.BUZMxKhkrlX
 hhyvljWXBdR0RN.4aK3BD5nXTThDOELByuSMjs1hoRgRMpG_QLwOVZGKp7n91SECRySgHfQfOYhr
 zs2G8osj7M82JjDZOdrAxsjGeCrhNUYh9Opt8wHDnGSPvDA7LNnITJ.LwpsqmzRSgRfC01d3UCuw
 REBDJRvJq4wTC_0RDVezzhhsaCagxG6Zcy8ID36Co0vndksTAZC8nUdeSLqN7CZQUwo8d9d.0oX4
 nqxrz6wSmf4bLvrT.Ge6eVsno9UsNUll9CvbLEog5BZlfLE_Asuh3kCnN7Sid2akvpQXiIqXeEoU
 QGdnmIsKSTSiz_FIMZn1y6bD9Skv4Db5LSV_fZz0MXiJPxcOlfe9S3n_hRmiPgrJDeSGm19TTdKw
 L4zHZ.qiuQTcxsGlOG8lq6K93DvN.PitCJEryYPB2gvlQFAYaa3JBc_coaYv.44iX_6VuJ_MTB_H
 CfQFWa_hrny.pDSNH8_QTtshMV_aIBGRKZ7OUQnqPV3CI6i9fghixkNKDtWKRVmYD1Ca4IegI7_K
 TwW8ZyQKvms60WBVk6iBJYKMlQnmw61LjmZzvUbRbfDL.L2MuxNdeYEY7KRK8XHLNySS59ZGRPeh
 YJwk3KMULavzq5m9l83s_Y8C3KrSx_.vl_KbGO.jTtwyICItdHryGCsi5q_MaKxn_H3dSBSCO_R0
 _zIkLq_fU4qpvvVrhlx_Wd1fcIqCqgRxDql4684VNltUi9YJNuoiX99KQdYLTgsOc2eZUt4CfgcD
 szxrUW9.3f5m7qQo0jWW9HGPMQxppyWrhOeWEM8U52R4L.oDW6yj5zuFB7IhUu7smnfVPd35ROrV
 YFouu2KSbuvjnO6LrAsb41Fi0v34PPYva5wUplgjw8UID5sya8W7o7F0d0PZwjd42hVeB2Kl7J_i
 p3hYOMUr09C7QtJ_Q544G8Y2ENfXuThZTtzAnpIgtvjcDO.ktRf_fZzwsn.ttQbRxubnTRcui2vZ
 ZL4ZGKz._yXznCHFMm4CE2KV58jPT5o4hm4GHtm6IkmjVDWLgvsFPZWViy2zWtxfR_XtbdocZ9gx
 j0uLpB0aX3yqfa..m3jYhC_.L10tqURORGQD9PUQ1AyWVWpluNOivHVIQdZo7yztQtRNaSyk5is8
 ZA9aQIM5YRqwlvYIApAqcoFegrJ8KmD2W83BRXe0IHIOoEJFLlcyDsZYz95MKWDJmGxuzVgNRMDY
 GnxRE5Raq9RJeJ.19iTec38xp
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 4c0cc34b-6058-407b-a70d-0b45d43857a9
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:58:42 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:00 +0000 (UTC)
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
Date: Mon, 31 Aug 2026 15:37:41 -0700
Message-ID: <20260831223748.4304-1-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260831223748.4304-1-casey.ref@schaufler-ca.com>

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
 security/lsm_secxa.c              | 128 ++++++++++++++++++++++++++++++
 security/security.c               |  38 ++++++++-
 security/selinux/hooks.c          |  87 +++++++++++++++++---
 security/smack/smack_lsm.c        |  43 +++++++++-
 security/smack/smack_netfilter.c  |  11 ++-
 17 files changed, 418 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/lsm_secxa.h
 create mode 100644 security/lsm_secxa.c

-- 
2.54.0

