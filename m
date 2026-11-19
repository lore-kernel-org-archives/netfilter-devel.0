Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795106016;
	b=bvFN2xZqFfi8qFRqtCsSyJMW3v0ouEaZso4EvUge7EKy5R7W8SqMKaPuMOjfFs796FGg
	 uThzq9EPWNU5R1I4gUfN3dvedFx5BeB9cwjA3tN1LBbDf67xbgDjuUwDSqQwkb+SFF4ec
	 zMMiHjgSe6XczhzqUsFmHFQfrtNIJ9dKw19+d1lC9+wlMQf6EQEJbxXDJeRG49SAOu/vL
	 7kbyvUJF39MAw1OCnhvOnTPdoa73AkT57+YE/woeHbz5DaJj+iz3U5pW2Tfnn/yOuzhKg
	 Zsi6Xy0PXIqg63Q5xlM0oCOBE1KoIQ5yShKq01QjpayGwzqsvxkW8mm/MXueWrpssaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795106016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+ZvuHn6ya9YnbK+HCx0pAQs3i70n5ubo26Lf+Gm3Zv4=;
	b=L40MEehIdc0ekp8hIvAQdR7njfQuqLdTnWDV3GP4Rri/GcUUBMsxy1zYk8kS2FmctPjE
	 ziPn4RrdpgG4h85C0Y1wpY9f/IB0XySG1dQ3bQdzFkw4fQfwZyb5rzCDpVGWbhVkOrVbs
	 5TYciRRq5LC1L1BPPryaxKKVkCZBpjw/+5gOCLVl0Vw2r02QT8iNJMeng7LscgAbvKprT
	 kEVhBa2QPzLX9XsqozJJDg7Mk3AQiu3D2HZ1xVeCze2ONYq2wCxa+/kc868DlTqnwiidH
	 m8UA58zL4dK8foJ7xoOlLjMQHT5qSVUYZ6HKTFoDIzHiUWNE2eBl3tbVQJbcvfzZZQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloudlinux.com;
	spf=pass smtp.mailfrom=cloudlinux.com;
	dkim=pass header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=EqHZzZvu;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F1606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 16:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 814F1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=EqHZzZvu
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so1482096f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 08:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1795106014; x=1795710814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ZvuHn6ya9YnbK+HCx0pAQs3i70n5ubo26Lf+Gm3Zv4=;
        b=EqHZzZvu2/bjApZCJGNtoNeE+d2Sj9sd2BeFEQ/7rMnkTvXVeNITJ/kTOn7qEILyHq
         j83Mx+THFnHsWacoKfmp+0A2cqutgx7SPbsdpVqmPC1F1hMa6bM0//R8QKzpSQXxUqOQ
         FAitpOz3o2yLmhMINzuOH8xX9cSlpi49fhoszpA381qK7PPKukmetyS8VjUvRt+O7qCc
         CR308bb3SIr2ZXIjhkIj65evqGW9sRQ/iv5AyEypMcoBf5jCH/zOFK2mt/y/hP7KTw6h
         vlCO5bxWS7mpZ5wPAuh0ublk4pA7tqsP0WJOyvRribkMKRiXU1be7VFukC3dNoDsi7X2
         LXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795106014; x=1795710814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZvuHn6ya9YnbK+HCx0pAQs3i70n5ubo26Lf+Gm3Zv4=;
        b=qQs6FwbfDcJjv7ydotzhfQNaw3DZ8C2w5e/Lux1xYGElcwksdtb7RcUL5g0YdXG7HT
         Sd9V8/ZR8CXe78tzYZlpVx0m/0aDGQ7DFix1wtLQ7FvwwUD3JY+Ppp2I30WGW5lXbF6q
         9pHH/9Eqv7qfh99mF7GNWzz3L2v5M9EJHvXdvBI9wIV0JW63M+o7ynuEE2L7iZvE4IZP
         wFtgLPY1V12jnqAOdmFX3Ll4ErUVyYX+TJHC3Fu6xF+CvjQyir7i5Wx0EBrtrVGIRrr5
         9ZY1pxklBHueK0ey33ODtYonojVuvfyhNg5KzvgqkjxH/f/qriOEFzdZUOtXYuOEK2l/
         jLQQ==
X-Forwarded-Encrypted: i=1; AL+hErFDpa8mr7qZonyk/X6V0GzhCTF6OnweLRLvkn15KxYrBkdf4/MMjX3nft2Q1DYDVlkoJCH4rII1AWHr8Fj0urI=@vger.kernel.org
X-Gm-Message-State: APuU4Z80WDqeREDc29QZ0bqprSN3Y/zbHz4+D+bMB2jNSKmT1uE4Ivtj
	/BqhirB5RQondwxxvmlQI2IoTO4Smw3rhgCtDmeLanVg00kQSV3OXtvS9azh3Ji4hJ7mAdiY7fA
	iI3hxE0mHNg==
X-Gm-Gg: AZFdTZcZSUpYAXGBxxZL0J+eePs8RXjQAjC16HVzbpBV6ujbcJs7c//XlG84hR2v1Q4
	ymk/poAjGOZElA55Xqx+ZwHeH6ML8V7ogZvHjEKJSdz+H4b+N7mL4YD5W2J7zRi87KeiloCiDbE
	zsEnzR0lclhNe4JCnteDdSynB0NrqkLsYgssLlGjPK4T6lD3BMWZetQObFmzYD3uxHCSITqy2tu
	r1egPygJde66L/MRDI/5YDbSw2kBzBhJaGAja4H9NyH2rF5k4YSkHcQ2MyruPufwIerKkuGRXr0
	ti52XeGSxmyRrQ1PKwJKih8gzLL/YMN2YNN9+r+dd91KCxmVjpnfyjzI4qT/WDg6RfYo7XCyQcb
	1pzeHvW7vzj/ima9kFmU7NBw2qE/YAPiqSEUh2XFjRc2nU6TPiVAeKKorTWm6fOq330nOwZU5bJ
	RrUbVoMCXArjbokgILcRIJfiRy3mcuhlTQLkqz5/FaN5U81cbT7vYyPmnQht+nOzDhuPxpF8Fla
	il/KGLomoTjDd1tV2liCY4BUM42/LjjKpR8MMHc7RWetc171VY+aF+fIU3d0o0G5P8FTI3vsrXZ
	qTCiOZkFtZGhgQn18c15UT0M
X-Received: by 2002:a05:6000:2f81:b0:4a8:5a5b:3b7d with SMTP id ffacd0b85a97d-4a85a5b3cf1mr10186684f8f.56.1795106013927;
        Thu, 19 Nov 2026 08:33:33 -0800 (PST)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c248b75sm522855f8f.54.2026.11.19.08.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:33:33 -0800 (PST)
From: Andrey Misiurov <amisiurov@cloudlinux.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Andrey Misiurov <amisiurov@cloudlinux.com>
Subject: [PATCH] netfilter: bpf: reject a repeated bpf_ct_set_nat_info()
Date: Thu, 19 Nov 2026 17:33:28 +0100
Message-ID: <20261119163328.878804-1-amisiurov@cloudlinux.com>
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

bpf_ct_set_nat_info() checks the l3 protocol and the manip type but not
whether NAT for that manip was already set up. A BPF program holding an
unconfirmed nf_conn___init can call it twice with the same manip. The first
call sets IPS_SRC_NAT_DONE (or IPS_DST_NAT_DONE); the ct is still
unconfirmed, so the second call passes the confirmed check and reaches
WARN_ON(nf_nat_initialized()) in nf_nat_setup_info():

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

With panic_on_warn this is a DoS. It is the same BPF-reachable WARN class
that 16d464013ec2 closed for an invalid manip value; the repeated-setup
case was left open.

Reject the call with -EEXIST when NAT for that manip is already initialised,
before nf_nat_setup_info() is reached.

Fixes: 16d464013ec2 ("netfilter: bpf: reject invalid NAT manipulation types")
Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
---
Found during a backport review.

Reproduced on almalinux9 5.14.0-687.61.1 with a BPF_PROG_TEST_RUN SCHED_CLS
prog that calls bpf_ct_set_nat_info() with NF_NAT_MANIP_SRC twice: without
the fix the second call returns -ENOMEM and WARNs as above; with the fix it
returns -EEXIST and there is no WARN.

 net/netfilter/nf_nat_bpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -42,6 +42,10 @@
 	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
 		return -EINVAL;
 
+	/* a repeated manip on an unconfirmed ct would WARN */
+	if (nf_nat_initialized(ct, manip))
+		return -EEXIST;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
