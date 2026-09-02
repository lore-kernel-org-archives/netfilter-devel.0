Received: from sonic307-15.consmr.mail.ne1.yahoo.com (sonic307-15.consmr.mail.ne1.yahoo.com [66.163.190.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454294AA037
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377903; cv=none; b=bF40EHUv/i9olxuGBeFPSaTlZsYCa6l2ENkbSkd3+/+CEwj4RC0p/CrxyoBg0wkwd1EKcmlcyTXvXnCjrJksYQ3GfGD6nNV/KjkGk4sviA6040eiNLaJIkag16rhqFqLhBQzkCgHJdI6GAn9h2A54iJGvFYeh/xs8kGxqQ5k22I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377903; c=relaxed/simple;
	bh=FfVP7ZHwMUX4clPHqj3GfGEBM8rkDzr7WOneMyDb+LU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJEe/3U28LNIdqJeYzzqXBsVEKI0MeE1pLvcQsINiK+Jo3DM+sbMXjzfIIJxDtfXW1PrWV/CQpwYTyZk4GfUxt7NsssvL1WTvw017XfWUi9rXL+f+H9xNKhQDcJSD39c20ZNMzPXGCekcFz+1Op9wjGUaHtPFGDm6PuMqKZLrUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=X8SVJI4g; arc=none smtp.client-ip=66.163.190.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="X8SVJI4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788377880; bh=sDQ7o2SAAN5I3uv6IUKkmoXo37jnBtTL6EKFl3E8YMY=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=X8SVJI4gHO/jtd3biSMjkWAKGK2iDU2Kuicd+mUFs0uxXHGsz6CtmCwjb5heP3Lsh5jHSIRbRRCosrF2MDPbhh22Bah8huVuRtvWE8CalMg8Sg/xAi3en7n1PVm0VYGgVdnCucjygP4RvMpi7f9VbxXj20uAZnssJS9mDJpWOtbJB75niE/aNqCR/oAVlP7uZ6JwhjpC7odPwRYq5ucX9K1PYAonbKukaV8u++FJf8L10pOrZJq18Qz2qQITIl0wdZKmOVDnrHckLvESSCwQzxtV/72WcFpaChFZre45CITtu/QMzUh6nfUXREuHhlZHdIcxCWQsIcfMF1BGdZRHbQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788377880; bh=Ghc8rbnAPdvUKco1Djk8Z/7/0itW+F8udaNnF0n4fBh=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=SFanMeCzZyuXXdFubVxFJgvmMWy7j2NWPNPZn3yac7lrigx1xFVoTILInvaTMNWaS4TX/QbkAPQHZHKrxJUWMuAC8skVumhLXDlu95Yxiu8gqasXY41Fh2EVUPjn1u42qXfU7AtEBme7hib2yEPbmkMmQaRGVE5omnUMHuorAqeb0lBnZ/ewubFQO8K0FjGpDTNiFzRxfNbTTfzABfd4BFcPwm3xwPZqzdPVh85Qda9kNf8Xiaz5YoTHhmb6hvX9G6Ov/Q2MsuxM32bFrlFhdUsEpJRNc09Nax0uYw0Y3qKhmhJLtclhRz72qsy8jr/D2YPx3ti5y+WWpOhRHmfunQ==
X-YMail-OSG: fLZQ2OwVM1kV9VOfjqpHYlrxfGHKK7bj0TFwnsmPHRKj5gCI847u.yAj4JF5J.q
 D6unKkX5tMCAuviOeg3ju2Ho.kdBrqGGs0vk_jQODM0fa1HWJDPQtKE41kOF6tdfO.3JEnCCq9DQ
 1MoS83VV3ir.Ze0vWUu9hL5LCkIzthGw2ebpbCBfUS0xEz9aK5lj0._0k.kkUu6THE3h2Jo68r18
 vaSwKAO0tsTxcOKx6Em1FQ7K5WyTWYWSFHE5SFEXo2bK462klkdiAMUfwrzB7nuFNOI3B96iqhMD
 4q3XLsX72M8lCyqec88aIoQrklPyni1T707gl_JlNjIkz1glvkvGDsyJyEyDbOlRwIt_QhrYIt8g
 W7nGHXFMaDD0sRs1M9hkKHDIwpdemBjX0GLdYcAtmNkoVQrdeDblbijabbdEX5YmlSKrtb3vJt8X
 FF10DBVQcpvb8eV2It0ErWZQx8xFIr.6Qa4ANVszZWIAm8gjFgwG7bZKJ3TSud3oIe7V2zb_FLqx
 fEGznQcm7HxrCkSKA8NK8ssMBfNHOWnz9BqqwrO_QFqeyxubU_4hpJlwUy9JvhdJNP4PBiD.Li7I
 sZgNQoD5Gv5cc4.Qt2ZkZBPYpqLX4qi9Sdn_MPrc4XAsKrcGl83x37eppuzldxeQ.BFx_NPlH8OL
 Jku37O9Jrpc.UvGYaqwydi5BaiVXoiQPrsqNIrVu7u.gfEDiUMgnEL26VLWBiKVL6RBw51H.Z1ye
 d5DFcOsV1t8Ih7PiExkyRtEsZGU_32YWfA8445D9j1Y7IkiOot1scCEL1ElIKEpg1VD_qnmOskY0
 S45ofWKoKts3nuz8l3BGyBAPwlKbwwlwCedpn7a7zJLDuKaG2DD28XxLsEJWIlVO3r.jqgMcWAeh
 xxndwMQfSu7hjd6aodSh_t7mKdP9e5xaR5gg5z1mbhqDhn0Jr2ERXm8qqVRMFTaSW.WCEaNOyI0_
 c8kPusksGcYXtrZdyJiOX.18VAUwcxK9L4XV.L5roZWLAqpuR8jB48zff5Ms1SC7RIg.dZOhsK4P
 mq8Xk6yQHv8csNS10vVE.dRDwy4AQ_fofNDS5oYgJW6eARNZkoL6hZhVm63IRTLHcsB06HyLSHVj
 _VucAC8tSc5YlX2DnA4P5Ra071Zr1ocRwOLmctT50oSVQTJlpn_3Ph.EdTkF0ciLzv3MJGd_gmiV
 GpqiDwJCsMFdcRbdpcyG1OP89Kb2Lnh2RH27oX0IjByfUZmfpx0qZDwSD0jKRuv8w7_akD9aAaPE
 8hS33sMXXpI4shIZqbwdrbd0e.P4YgwNezxLO.r5XyWaf22AkNNRv0N95pXMxd1fAXN1rnJZPk6J
 MTKn9f5x_Sk5EnyxD_SwSz6jLOEDrMjE3lu.YbekM8nXP9AJbxeFa_jfNsNwQdXpr487qYbdKHI0
 RyLP8yxezlzgdDFVYTPsMArpynHAAQJsCEhJFL91Rhh2POJIArroM1J.4WZNOsNLG6GlQnwI4wf_
 JAWpVMFwJAmitrRQepkQKM9QUfDyNINE8O33v1lmzyPPCtyIeGMghH.OvmYwViZA3Xetvc8ct.At
 FPnyjc_AKMeB.te3mx1x0couFhoYckCBWaLcJ1LqG5bRseYN7EzICaypz3.y77iDsfX1mK5NtVGu
 3WhUolHDVL4JV5de2KRxH_9eGmJM8TLnR.GQp6AsIxK_t0tb_MqAq7QC_pxTNGAOlcR8eZl7XKK9
 ANKWXk3TOurXaZlgIFt64U3Sy.ZgQomHZB0a4T8DcW3quZG96yQ7XDK5iNphUrXhMqh.V_W7Y8ZL
 Xqqld6X12BWmQQdONqYLgWvAtqPuOydmPV_NPFDy380QAZkiiGOV826WJLzbQe_qyr6NIE5tVb3Z
 inm5CJLAqV6ZJJpRX.eaxV9G7OeSPQviffi0mo7i4PJ79TV4K7lAq1lL4sGseXYGgXrO6FLZulVk
 zx9dOfQ1ymwPbnoss6ojYwhPTKChpUsdDdgnmHo9ZHMsfxAxQmB.DOawhd5Z0EuSqUCVxtyqnG9O
 rZnHoN.ey4slAomk5_vC5sB76awRRq.U85EgrtUY49kcXcN168W7ceg37cNQC20BxZpSL71BK3IE
 C1cHFKzMS.DPGgblESftyBZblGn86ytEH9GUd0jNA0xUFV6EKRxp.Lul4lpcsqmfiPsk6Mx52a.A
 Rya6cCpR4nLwDb0dcxL4fsUptK4ijB8my4BXhlKE2sH9qdNYo8gAwcYyFDvCxtjIOvllSHVLFX8d
 Z9YIBwYwuD7yTxlx0jJLDVzxkTn8EsV1cGUDVG3HH8ehUwlXPv_uQcMLfKrhyn6Muc6Y3.7TEXXz
 ._P9mRrDIlV2G8Qn3XxjIKc6VVuI-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 12003354-9909-46bf-b900-8bf8e4ec3d2f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 19:38:00 +0000
Received: by hermes--production-gq1-678d9dd684-nh227 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 11e2868e9ee745b04b92bd2578e2b009;
          Wed, 02 Sep 2026 19:37:57 +0000 (UTC)
Message-ID: <8c4e0734-0775-4680-aa69-f6f35345c02d@schaufler-ca.com>
Date: Wed, 2 Sep 2026 12:37:55 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Change skb secmarks to x-array indexes
To: paul@paul-moore.com, linux-security-module@vger.kernel.org,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, john.johansen@canonical.com,
 penguin-kernel@i-love.sakura.ne.jp, stephen.smalley.work@gmail.com,
 selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20260831223748.4304-1-casey.ref@schaufler-ca.com>
 <20260831223748.4304-1-casey@schaufler-ca.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20260831223748.4304-1-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.26460 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 8/31/2026 3:37 PM, Casey Schaufler wrote:

This patch set was incorrectly sourced, and contains errors.
Please ignore and accept my apologies for the noise.

> When security secmarks were added to the Linux network stack there was
> only one Linux Security Module (LSM), SELinux.  SELinux already used the
> concept of a security ID (secid) as the representation of the security
> information about a system subject (active entity) or object (passive
> entity). Adding a container for a secid, the secmark, to the sk_buff
> structure allowed for efficient transmission of the SELinux secid for
> socket based access controls.
>
> Subsequent LSMs have chosen to represent security information more
> directly. Smack and AppArmor use pointers to structures containing
> relevant information. Alas, these pointers do not fit in the u32 secmark
> on most modern architectures. These LSMs are required to provide a secid
> mapping to use secmarks.
>
> Even with all LSMs that use secmarks having a secid to reference the
> security information the mechanism is imperfect. A system that wants
> to use multiple LSMs that use secmarks is constrained by the size
> of the secmark. There is no rational way to fit multiple secids in a
> secmark. While it would be possible to allow one LSM to use the secmark
> and any others to be told it is unavailable, this has been deemed an
> unacceptable limitation.
>
> There is a lsm_prop structure available that contains security information
> for any LSM that maintains it. The secmark cannot, unfortunately,
> contain one. Instead, an x-array of lsm_prop structures is maintained,
> and the index (secxa) is used in the secmark instead of the single LSM
> restricted secid.
>
> Uses of security_secctx_to_secid() have been changed to
> security_secctx_to_lsmprop() in the netfilter and iptables code.
> The security_secmark_relabel_packet() function has been updated to accept
> an lsm_prop pointer rather than a secid.
> To support multiple LSMs using a secmark it is necessary to re-evaluate
> which lsm_prop structure represents the current security information
> at each step where the secmark can be set. Smack sets the secmark for
> every packet.  Netfilter, used by SELinux, Smack and AppArmor, will set
> the secmark on selected packets at a later time. If Smack and AppArmor
> are active on a system Smack will set the secmark initially, and AppArmor
> may reset it by netfilter rule.
>
> v2: Address issues raised by Sashiko
>  - Configuration option insufficiencies
>  - Locking issues
>
> https://github.com/cschaufler/lsm-stacking#secmark-xa-7.2-rc7-v2
>
> Casey Schaufler (7):
>   net, smack: Create a function to set secmarks
>   LSM: Implement x array functions for secmarks
>   LSM: Two hooks for manipulating struct lsm_prop
>   SELinux: hooks for secctx_to_lsmprop and update_lsmprop
>   Smack: hooks for secctx_to_lsmprop and update_lsmprop
>   Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
>   net, lsm: Change skb secmarks to x-array indexes
>
>  include/linux/lsm_hook_defs.h     |   6 +-
>  include/linux/lsm_secxa.h         |  33 ++++++++
>  include/linux/security.h          |  20 ++++-
>  net/netfilter/nfnetlink_queue.c   |  12 ++-
>  net/netfilter/nft_meta.c          |  20 +++--
>  net/netfilter/xt_CONNSECMARK.c    |   3 +-
>  net/netfilter/xt_SECMARK.c        |  19 +++--
>  security/Makefile                 |   1 +
>  security/apparmor/include/secid.h |   4 +
>  security/apparmor/lsm.c           |   2 +
>  security/apparmor/net.c           |   8 +-
>  security/apparmor/secid.c         |  21 +++++
>  security/lsm_secxa.c              | 128 ++++++++++++++++++++++++++++++
>  security/security.c               |  38 ++++++++-
>  security/selinux/hooks.c          |  87 +++++++++++++++++---
>  security/smack/smack_lsm.c        |  43 +++++++++-
>  security/smack/smack_netfilter.c  |  11 ++-
>  17 files changed, 418 insertions(+), 38 deletions(-)
>  create mode 100644 include/linux/lsm_secxa.h
>  create mode 100644 security/lsm_secxa.c
>
