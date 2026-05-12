Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188A93C65FA
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 20:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619085; cv=none; b=Gvli+aXwUljBgsyug2SzDO1C2226pNS+RE86bV/mx1/I0ollfIbwg5t2zd2SkYfsxPaiRm2Sjgkq2+y8hdI5npMVOf0fo0XqvHp99KkPqgI3PreOZwxYAE67oAz/9KyVfYoJGAm88gEjYUmA1zCNtlPntCWCVlbOPcnPrU6DHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619085; c=relaxed/simple;
	bh=DaExS6jVhCbFdfpu1jp+ptHK+FugGZYNQVrAif7iSd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vEMLSJBYOGJhanp5yOrN2iPrKyHJ0/3VEKu4nUTMleWxkIk2OGJGZBcdUkgYyr/aSVl2nGq7ubXfpAL3HPWliZC1cXz1vpILAzS20L7JEjoXAUJEEcKjb3EW4i6DVC2rWjKo+D3M5WN2c5FhpVVFDz/RVnsVrzIjjLVFZeyeT+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q67Ia9mM; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q67Ia9mM"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8ee62a19730so677803285a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 13:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778619080; x=1779223880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XUMHU/SEZPYFwgbrY/+Ks3cr/YWBTknXiaWwRLGqhxk=;
        b=q67Ia9mMETYGr8O2ZyTVYha1e1u1W6iKNLtotcCxUeBF3OzAV/HYSRsXg50aw/ydCD
         9RgOzehLJUIZqHDciV+zgf1Z+T9L0rBwVYnpjlwbFSIwUr5yE9pQ0tCipcgGDpUBVeIQ
         g4wAQSoVTSQd+Blz8eM4JDvPUdKVZ44eprrXnI+tzUcWsEn7IHV1niuUUYGU0jMDPVlo
         rN3ClC4UQhBAHDHKLLnGef6DGveSEDCy/lFThOWhZjW8kZk6d/QELHWANuPXX1AVEf+5
         FmNaeMWbwNFp7+TjNLkF4QOuXFcVz8geOBF/WgnnzBIzLsTZNCPUC5T4AFOXPXTqzjQH
         DXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619080; x=1779223880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUMHU/SEZPYFwgbrY/+Ks3cr/YWBTknXiaWwRLGqhxk=;
        b=ZC/8adMbjbzAtNwdZUve4WexFNFq3fPGT5r5YaLRaYEK8IJ+bypgrUDXKuO4DdJrb3
         mwU1imr70NDzDoDxvizSXEpZH0fIlXfU0y+4Us6LG+BmcaoDiXLWh+BWb5aBQuhDEDQ7
         R523GNH0t0NKUq5rRoaxW8n1LdPAidT2ovEZ+0ngsllY8foZ7oD7SUWRV8lxHX3pgZei
         GdjcDfPCX9Xa8aQ5e11BTFlLPiut/cG1yJlFxL3T/PChvM8Kw/4/CPAza5jsrcvxN7E/
         0lpZsL6b3AAkUf/UI0exkKNjRFxc5bPS9fLFo6rMkVIzTgSPHw14OOP1+twnqX4cMvrk
         gbeQ==
X-Forwarded-Encrypted: i=1; AFNElJ9dKutcX96E5Zy6FZOLBq6thaFQv/yPQMHuz0D/taM8TXlm6r7MFkfL256AscIhuicPi3fqJNRUJ6JVdlfxBys=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNxVFFKdzk7sXB36uko+PWM/wJx3t5/OYqqkqJKBbaTUnIpdQP
	U4VTuNzGzSI21+SKa3KtXjRgh8O/9Lu3Oz3D9vb1HaVVcFkU4+r4VjOO
X-Gm-Gg: Acq92OG1ZdDCGamioruz39kgRNwrPdWSj5wNL9wXSiRZXqUJJsRBWsRP2WwggMTmwwp
	yIDNowq/knttdi7jHIwCeIIwRiE7FDswLBwX0Mcpm2IOacv9GHPWw+MeMBAofl0zphDabJ3dY+p
	H16ix+XzRG+5h5M43T+QJph1qJy1Bqmztd78ez5csTq/HbyJSe5zzQkLbqhyAq2Nqic2iYveCIt
	nDQwH1TR3dpHNHz7Mdtabd71Tb21EDjfb0LkGvlGab7FfZcl8Zf3u1wa74SRwZtzpey9KgUnN81
	GYW2IFe8gn9Hmdkhx8gkQhqjbe7VGX4qSvbQpHpZQHdKSSllRwKo/qSligpXRRDcU/UJjaq3ClN
	1hRbU6nk3KEJ9Vc5YnJOm+8sdThFdLrzo2zxAnanIyzvC+xsQPOUEHUM36kPe4wL2jtd4tDJIr3
	bRrKUg8mkrEZ3j691EYxpNPXobwV6cnr41c46dOLbppzilVGubohdLvcj+DLjx0t5wZdrBGNl4T
	HHlQFnvdKPPrt7vAxK924HohcyAr0/Xn+pcetn4sOE=
X-Received: by 2002:a05:620a:7014:b0:8d9:3cb9:9905 with SMTP id af79cd13be357-90fade53b89mr6198085a.54.1778619079364;
        Tue, 12 May 2026 13:51:19 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b8d9eed0sm1490734285a.19.2026.05.12.13.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:51:18 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Maciej Zenczykowski <maze@google.com>,
	Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
Date: Tue, 12 May 2026 16:51:13 -0400
Message-ID: <cover.1778614451.git.michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a size_t underflow in net/ipv4/ah4.c:ah_output()
reachable when a raw IP_HDRINCL socket sends a packet with ihl < 5
through an xfrm AH policy.  Originally triaged on security@kernel.org;
moving to netdev at Herbert's suggestion so nftables / netfilter
maintainers can weigh in on a related question (see "Open question"
below).  Herbert also asked for the malformed packet to be rejected
upstream of AH rather than guarded at the AH consumer; that is
patch 1/2.  v1's AH-side guard is kept here as 2/2 defense-in-depth.

Bug
---

In net/ipv4/ah4.c, ah_output_done() and ah_output() copy the IPv4
options area with

    if (top_iph->ihl != 5) {
        memcpy(dst, src, top_iph->ihl * 4 - sizeof(struct iphdr));
    }

The "!= 5" guard correctly excludes the no-options case but does
NOT exclude ihl < 5.  For ihl in [0, 4], top_iph->ihl * 4 is less
than sizeof(struct iphdr) (20); the subtraction is computed as int
and becomes negative, then is implicitly converted to size_t at the
memcpy() call.  The resulting length is close to SIZE_MAX and
memcpy walks off the slab allocation backing the skb's network
header.

The malformed packet arrives via raw_send_hdrinc() in net/ipv4/raw.c.
raw_send_hdrinc() validates "iphlen > length" but does not reject
"iphlen < sizeof(struct iphdr)".  An IP_HDRINCL caller with
CAP_NET_RAW (acquirable in an unprivileged user+net namespace on a
distro kernel with CONFIG_USER_NS=y) can therefore craft an ihl < 5
packet; if a matching xfrm AH policy is installed on the outgoing
route, ah_output() runs on the crafted packet and panics the host
kernel.

The guard has been in place since 1da177e4c3f4 ("Linux-2.6.12-rc2",
2005).  No prior fix on lore (3-year window) and no CVE on the file.

Reproduction
------------

x86 + KASAN (QEMU KVM, net-next 7.1.0-rc2):

  BUG: KASAN: out-of-bounds in ah_output+0x696/0x19e0
  Read of size 18446744073709551596 at addr ffff88800bae9824 \
      by task trigger_ah4_ihl/97
  Call Trace:
   __asan_memcpy+0x23/0x60
   ah_output+0x696/0x19e0
   xfrm_output_resume+0xdc8/0x6280
   xfrm4_output+0xfe/0x4c0
   raw_sendmsg+0x2531/0x26f0
   __sys_sendto+0x32b/0x390
   __x64_sys_sendto+0xdf/0x1f0
   do_syscall_64+0xf3/0x6a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  The buggy address belongs to the object at ffff88800bae9800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 36 bytes inside of
   1024-byte region [ffff88800bae9800, ffff88800bae9c00)

The read size 0xFFFFFFFFFFFFFFEC (SIZE_MAX - 19) is the
underflowed result of (top_iph->ihl * 4 - sizeof(struct iphdr))
for ihl = 0.  Trigger: veth pair (loopback bypasses
xfrm_output), xfrm AH transport-mode policy, IP_HDRINCL
sendto() of a 128-byte packet with iph->ihl in [0, 4].

A container-only variant (CAP_NET_ADMIN container, no
--privileged, no host networking) panics the host kernel on a
stock distro kernel with CONFIG_INET_AH=m + module autoload.
Repro harness + container Dockerfile + console logs available
privately on request; not attached to this public posting.

Patches
-------

1/2 ipv4: raw: reject IP_HDRINCL packets with ihl < 5

    Upstream-of-AH fix.  An IPv4 header with ihl < 5 is malformed
    by definition (RFC 791) and must not be allowed to continue
    along the in-stack output path.  This is the primary fix.

2/2 ipv4: ah: harden ah_output options-copy guard against ihl < 5

    Defense-in-depth at the three memcpy sites in ah_output() and
    ah_output_done().  Changes "if (top_iph->ihl != 5)" to
    "if (top_iph->ihl > 5)" so a future path delivering an ihl < 5
    packet cannot re-introduce the OOB access.  With patch 1/2 in
    place an IP_HDRINCL-crafted ihl < 5 packet should no longer
    reach ah_output; this patch closes the OOB primitive
    specifically at the AH consumer.

Open question for netfilter / netdev
------------------------------------

After patch 1/2 lands, a caller with CAP_NET_ADMIN can still
deliver an ihl < 5 packet into the post-LOCAL_OUT in-stack path by
attaching an nftables payload-set rule on NF_INET_LOCAL_OUT (or an
NFQUEUE reinject on the same hook) that rewrites byte 0 of the
IPv4 header after the raw_send_hdrinc / __ip_local_out validation
has run.  Construction:

    nft add table ip mangle
    nft add chain ip mangle output { type filter hook output \
                                     priority -150 \; }
    nft add rule ip mangle output ip daddr <victim> \
                                  @nh,0,8 set 0x40

I reproduced this separately with nftables payload-set delivering an
ihl = 0 packet to xfrm4_output() and onward.  Patch 2/2 covers the
AH consumer; other consumers that read iph->ihl after the LOCAL_OUT
hook may be similarly exposed and I have not enumerated them.

Direction question rather than a fix proposal: does basic iphdr
re-sanitization after a header-mangling hook belong in the netfilter
machinery, in each in-stack consumer, or both?

Michael Bommarito (2):
  ipv4: raw: reject IP_HDRINCL packets with ihl < 5
  ipv4: ah: harden ah_output options-copy guard against ihl < 5

 net/ipv4/ah4.c | 6 +++---
 net/ipv4/raw.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)


base-commit: 73d587ae684d176fac9db94173f77d78a794ea4f
--
2.53.0

