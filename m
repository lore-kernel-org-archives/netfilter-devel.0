Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EEC330B15
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776224644; cv=none; b=Gd/YrxVN/nbHa7nIYWYNUPS/OPz7TvRmszlU30floLWj3ZlJqfhdEmYCddv/PoUPqhEOm5vkK+toSfIEJZnlCM/qMFeuD1Y7x1wXCi2H1cu9rvo/2lLoGCDpztzueQCsERRJ+oRyj3jN9PyB/bJgepXeEQ6jVRk8NSmKq1YwgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776224644; c=relaxed/simple;
	bh=uGI8GPnr9VXAA69kZ/s2eB6gRTG6FQSN6oJeK6M8pWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EsO0+mRODumnIyVJS7nnn34LtnEzLUQsoZwIXaesttIXJDWn911GtN64rvtajpQXHquLIa1A5aGw7YMoXHoreLAJVOXdWlvNbd2FDRtle4zgOus+M+8B/CNQN2HMfk+6P+R0oTZa6OHyW+R+WvEG6wjbRMCY1HE4vlN01fkYdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AC0tC2I3; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AC0tC2I3"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b23fcf90b2so59862295ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776224636; x=1776829436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SNhZ4rollUkSxm2n10gtXaqIbxDOKMY7jgWaxNLfqIc=;
        b=AC0tC2I3MGoA0QxRj+i7bNb0yRLDqJxdePAAo7BiHLPTQBhEMNs9L1riDtVSUa7yLS
         gI78K4ux83nGd4BQuumcDYPaHhrPA21XVOcwfocqJUB2HQa4EhQJPArg2tucCiaNKPSw
         +fdsaSBFWfWpGodfQF7LbiTGmX/A+zVF+i71/wLPWT//Nc50hHr51KgPVMvxwE6mNq5X
         vYmbjR7TBTIDMVbhs9O4wcbLVCpuCMd9Y8laqeBVXmqyFX0TbYvUMKrJq8OR44HzMhNC
         vG1X3v1jRwXL+2kOaNiljmb8sTInUe1lCxVJuIkt4FwyrSrRUzhkazJSiH9PpMSW/kU9
         pguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776224636; x=1776829436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNhZ4rollUkSxm2n10gtXaqIbxDOKMY7jgWaxNLfqIc=;
        b=oYsAmqESSJ5bnNX7DGjoLzDj2ZYAEpiOQYDUJ9z/fhdUNA3/Y5hkH82m82K2DO2qZ3
         ZADJULPLGa7YXDbjNbm0HjOH/V0W3QgpAxqeEZS94xZ0OqmH1bC2wDU6y8yr8bdIH97b
         d3cqBhSgbBo7Tpg0G+7VMMJ+Z89Pe6jQMO6XUf2kLexx+EDIwuKPrNja7/V8n6ODIc7r
         xXYfMek1nIsliCTmDekoUvp33PeQgESAOKU/H9tuSo/EoEzlPwvHcs1D02oc3hmg8VFG
         WznfNJxNg3R7366o/XHeGIZcbrV87g2FNDR4g962le49rtOIoS+NA9TH9EAar1waDFvK
         KTZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8OhMTZiwpG7/7D0UAg4R5CttkThHouijig1xPzihKCjvUXAq4nEFOl7idAj+DbXyoHVdqjZxVVI3RGnmMS0yY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDtKKrRtcxC9rLwSGYqqevPQNu+bTIrKXe0ePoBtupYTyA34F2
	tRlbMMx66tGOXIoWcHhZp4banhB1O94l0x9l37o7B7djxM16WdY/5QEO
X-Gm-Gg: AeBDieuGJsr6d0lU3tmS/PUwlVAB6r2EaayqKDyF78iIw3+ah9s5ZgckKiHNAi+0pok
	ZSgnauZ3mB6775cDS4Ki3aG74IUOdNzcz7kVlHMWrqpkMQqw6eSTD8/EGzO1W/AtTSmYJkvNPbT
	iBPRtmEXSVF0wAat7jOiMX5I9RTIVKXa5kk0ozedLv82qJ/hb5TpBqhQsSf1xqPuYG+HTdvKu9s
	KZ18OsrloKOnccXnE3cfwxZ5iLQikGpWAG4C1zkTwNvGM4DXC7bDxZ48mCogthc8ejrfhT79fo1
	fBt0DbpArNnwwalAychX9a9ijdoQLFWFT5uZKdeH/dPMo0yHZE9C0MxiLvHJ8ix+03S0lZPuXur
	0Yi5/e9qJ+A3p4XIVxcTET8JeYsEsmDX8eXtNK51aSuzdzqCm2qoFwZez4HFkobQ6Hbkr8edT7/
	iG+iGKWoTXHFT5Q4168j7dsKsQ5RBifscGP2E1yiMo9r1xd+c=
X-Received: by 2002:a17:903:3c30:b0:2b4:5f69:715d with SMTP id d9443c01a7336-2b45f697b4bmr107939525ad.25.1776224636000;
        Tue, 14 Apr 2026 20:43:56 -0700 (PDT)
Received: from home-hyperv.mshome.net ([103.136.124.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4782cb32csm4742175ad.79.2026.04.14.20.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 20:43:55 -0700 (PDT)
From: "Kito Xu (veritas501)" <hxzene@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	jengelh@medozas.de,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kito Xu (veritas501)" <hxzene@gmail.com>
Subject: [PATCH] netfilter: xt_realm: fix null-ptr-deref in realm_mt()
Date: Wed, 15 Apr 2026 11:43:43 +0800
Message-Id: <20260415034343.107920-1-hxzene@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

realm_mt() unconditionally dereferences skb_dst(skb) without a NULL
check. The xt_realm match registers with .family = NFPROTO_UNSPEC,
making it available to all netfilter protocol families. Through the
nftables compat layer (nft_compat), an unprivileged user inside a
user/net namespace can load this match into a bridge-family chain.

nft_match_validate() explicitly permits NFPROTO_BRIDGE, and the hook
bitmask check cannot distinguish bridge hooks from inet hooks because
NF_BR_FORWARD and NF_INET_FORWARD share the same numeric value (2).
The match also has no .checkentry callback to reject non-IP families.

When a pure L2 bridged packet traverses the chain, it has never gone
through IP routing, so skb_dst() returns NULL. realm_mt() then
dereferences this NULL pointer at dst->tclassid, causing a kernel oops.

Add a NULL check for the dst_entry pointer. When dst is NULL, return
false (no match), which is the correct semantic since a packet without
a routing realm cannot match any realm-based rule.

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 1 UID: 0 PID: 169 Comm: poc Not tainted 7.0.0-rc7-next-20260410+ #15 PREEMPTLAZY
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:realm_mt+0xa0/0x180
Call Trace:
 <IRQ>
 nft_match_eval+0x1b7/0x310
 nft_do_chain+0x261/0x1740
 nft_do_chain_bridge+0x20c/0xe10
 nf_hook_slow+0xac/0x1e0
 __br_forward+0x33a/0x480
 br_handle_frame_finish+0xab8/0x1d10
 br_handle_frame+0x80f/0x12c0
 __netif_receive_skb_core.constprop.0+0xbd4/0x2c10
 __netif_receive_skb_one_core+0xae/0x1b0
 process_backlog+0x197/0x590
 __napi_poll+0xa1/0x540
 net_rx_action+0x401/0xd80
 handle_softirqs+0x19f/0x610
 do_softirq.part.0+0x3b/0x60
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x64/0x70
 __dev_queue_xmit+0x9f3/0x30e0
 packet_sendmsg+0x2126/0x5470
 __sys_sendto+0x34e/0x3a0
 __x64_sys_sendto+0xe0/0x1c0
 do_syscall_64+0x64/0x680
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
Kernel panic - not syncing: Fatal exception in interrupt

Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")
Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>
---
 net/netfilter/xt_realm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 6df485f4403d..6d3a86647cae 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -24,6 +24,9 @@ realm_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_realm_info *info = par->matchinfo;
 	const struct dst_entry *dst = skb_dst(skb);
 
+	if (!dst)
+		return false;
+
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-- 
2.43.0

