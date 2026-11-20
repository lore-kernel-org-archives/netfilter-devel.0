Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795194817;
	b=4eKyrdU0S5HFIiWZFCttrHfaTjafTRFD6PR7BKf8zhBwewOd7Y6u2h89om5xyOyP9mrA
	 PFzARvxwgyXcsZrqynUr2Rn2fKh/ndocAWDKUpAja4FXSUHEpbUbiFbTCJIF5xGJKFFZC
	 2+gI5WS89uFjV13pjFYu69xQANGyle9wQWBwI8b34TyoQTCeFHR04gasT3OSSlKRfaVwr
	 FS3SSBIVLwtPATpiKgiRYo7k7JFs6z6wAPgQ+Y5euobfk6blAmjE+l4bImhWhS8Yq+yp1
	 iSjqCkdp738r5D+w16UtKaxS+zgMciwEEM5/h7mI79Tf+iQCSNbqqXt4kP/+L+okqGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795194817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KjPgCbUzN1D+YOhV31hO/zmYZL7tdGugpdJIEZntHNc=;
	b=w05yZo98jaLoM4liYt9lYHiJicPZZ5JWYWw8TcCHAC8GOc9AMgVjggJ/L3a+KInQKQOS
	 WjxWyIYBNeEf476/V5bQtH36dXjJZJgdkIWDACwwdHI9qsIpQYngfoVOQP6UCSIABcKIr
	 hg7I1YanDmOrtxAKupzRGIak/kKfSvBbu8aXKf7AE6ERMwt6TDK9aDqp8ujv1FCMzKGV6
	 NwwIxnMPAbY2HK4Hs2DlqBJAHA69ifkEhcWb9mxx3HK68Za57a/Eyrilb5r+9yY4aPFlh
	 g5HqByN/e+Co0M0fLOWS2o9a4TNukwcRF7CE+E7lVVFvBzp/Tu+NjVKjcNdX6FGF1Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloudlinux.com;
	spf=pass smtp.mailfrom=cloudlinux.com;
	dkim=pass header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=RBhUHbpI;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A54960A2601
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 17:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A54960A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=RBhUHbpI
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so8820445e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 09:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1795194814; x=1795799614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KjPgCbUzN1D+YOhV31hO/zmYZL7tdGugpdJIEZntHNc=;
        b=RBhUHbpIqrkv08WHuQRt875FWMxuS4lb10/Ee+ETSWUDT8SJGfL3H/etrmMfVeswE1
         FwoIhvtz+Fp28P9yh3xPcZ20+EOuUKgysr+4qSPXn+v+oM/7wZAWv1+8jtOxn1CIpAkh
         IdFLwNMbF/LKJap1nxIdt1RWzGKnf0WW7nLdHUPYE9Ks7tavLbaBJgSW3HsG5mWvNUEg
         ajfhZcPEcMFuexa9P9/SH4YK78fnIMo/Fj6XU7UUPqCt+wEPyn9/UTAJ5TQKvzBf+eeH
         K4FuKZXDjdCa20fe8YGRGaF9qdBZs+TRQwo2077PA041jVXY6VtKc/igElCYiEPOCV9R
         A21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795194814; x=1795799614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KjPgCbUzN1D+YOhV31hO/zmYZL7tdGugpdJIEZntHNc=;
        b=D7QVqz6HzY5xdjo+xbwpL4+MMYQYxXJ35SoZkHuZuuxvi/J3AWQ0916/h8ZiZb1eUk
         0SgiCJbg0X/qpIiE8EANg0jHDiStVrhtNq85nySL+iopguT2Y85+vgK2WAlf0B6zOJsW
         kivGaxfVDB4XJPy73lOOCfFNJz+x3y3NtJcT7c3KRfMeSxtmzdFFCL4Crlp1jM2z7Azn
         jtZ6otfuWi7PZtfIN6UuAIkzlELnnYSD6G3tym50wL/1VWHCsYNYQPO68uKKaUj0aaCI
         R7SnygDgDxGzQhUWalLRtbs6giJdNVYMHGJSGbZ4izH/Let7TOp1NJA2bWpT5+2VE8w9
         TDWg==
X-Forwarded-Encrypted: i=1; AL+hErGtbKtu7sGFlQCaRPQhvLijI5pdlXRrwtH2RJR843A2UQ+KbnAr+SWNwi1jbwgYsk4cOzzcSaQtm8JixCQdPnU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+JPtMI9ejRdFTM0FrcS1cor3fsTjdVTl6fQ8ZHtv5z8SRPm9Vu
	9jUi0QfRA+PS8Y79hjriJmTSwxW6TZC9T4fSClOjJucuJ6KBWcp2vB1r0+hk+foNnaJRrAICiXg
	ZQ5SkhhKwZA==
X-Gm-Gg: AYBFou37T60OHrDTt2lza73baHqxd1xsBqSA+8gYjexpKRnfg3/P5kkNAC3Us3Pa9vu
	+2NNMy2WIDzn75yq9KMIXkIgECDu4jYkiUjSlX7rmrJvz4jGJoSA0aIsHXam/wTUjO/Ldyefszr
	PQEQ7+h/7G/3gazWVLXEbZ2X8yFL6Zr71QbqKx4Cf4G0vPrkZ6aOaUmT2FoXzgBHXiC3RB/hClk
	7ZWoZn0KOfSJuOkxHukr7XxTgKqMaxTE+7os71RCMZbhSUqkeOgGylJlNtbv8jmXd0MXGoze+PQ
	G/O3JB0qYlhCek/6vj395gAmi4HhGCqtGQdin2A+3idDv9p3CRF8CD1uwzQ1PKnZhsPjAh7VDRF
	CvkHaTjRMyG4qxNbwDCM+HOffULX2p6JSjhbvTTBrex2Nr9wMqiG5ARj+Q2l8H3UszTeYh4HvgS
	9smryhtPn5NsvpjOmedFqTbmdFLhr3R5fy1xEtuSX3dOOSzShgVM/xCG6aM0PET55B3q+3Z88E5
	4bjWWmOUrvmOWr3oonDkUMVRr2H1miwBaYDMcs3MTnVAfUhC9sXlsotoBXXZnldkcmJxeMOMysh
	e1BBy5y8uACvnKTRD74XyrBwSyuL3pbuQRbfnMvdTmw/mw==
X-Received: by 2002:a05:600d:82e4:b0:4bb:6847:7927 with SMTP id 5b1f17b1804b1-4bb8882677cmr87433725e9.7.1795194813839;
        Fri, 20 Nov 2026 09:13:33 -0800 (PST)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b2437sm190918955e9.13.2026.11.20.09.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:13:33 -0800 (PST)
From: Andrey Misiurov <amisiurov@cloudlinux.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	amisiurov@cloudlinux.com
Subject: [PATCH nf] netfilter: bpf: reject a repeated bpf_ct_set_nat_info()
Date: Fri, 20 Nov 2026 18:13:25 +0100
Message-ID: <20261120171325.2721546-1-amisiurov@cloudlinux.com>
X-Mailer: git-send-email 2.43.7
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

bpf_ct_set_nat_info() checks the l3 protocol and the manip type and then
calls nf_nat_setup_info(). It does not check whether NAT for that manip was
already set up.

A BPF program holding an unconfirmed nf_conn___init can call it twice with
the same manip. The first call sets IPS_SRC_NAT_DONE (or IPS_DST_NAT_DONE).
On the second call nf_nat_setup_info() hits WARN_ON(nf_nat_initialized()):

  WARNING: CPU: 1 PID: 21673 at net/netfilter/nf_nat_core.c:674 nf_nat_setup_info+0x251/0x2b0 [nf_nat]
  CPU: 1 PID: 21673 Comm: loader
  RIP: 0010:nf_nat_setup_info+0x251/0x2b0 [nf_nat]
  Call Trace:
   bpf_ct_set_nat_info+0x81/0xb0 [nf_nat]
   bpf_prog_e4b00ba35d2f7a6b_nf_skb_ct_nat_twice+0x110/0x13f
   bpf_test_run+0x172/0x2e0
   bpf_prog_test_run_skb+0x2e5/0x4f0
   __sys_bpf+0x7f8/0xe90
   __x64_sys_bpf+0x1a/0x30
   do_syscall_64+0x5f/0xe0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

With panic_on_warn this is a DoS.

Reject the call with -EEXIST when NAT for that manip is already initialised,
before nf_nat_setup_info() is reached.

Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
---
v2:
- Correct the Fixes tag to 0fabd2aa199f (the helper that added the kfunc),
  not the later manip-type check (Fernando Fernandez Mancera).
- Drop the inline comment; the check is self-documenting (Fernando).
- Reword the commit message (no "confirmed check" in this path).

Found during a backport review.

Reproduced on almalinux9 5.14.0-687.61.1 with a BPF_PROG_TEST_RUN SCHED_CLS
prog that calls bpf_ct_set_nat_info() with NF_NAT_MANIP_SRC twice: without
the fix the second call returns -ENOMEM and WARNs as above; with the fix it
returns -EEXIST and there is no WARN.

 net/netfilter/nf_nat_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -42,6 +42,9 @@
 	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
 		return -EINVAL;

+	if (nf_nat_initialized(ct, manip))
+		return -EEXIST;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
