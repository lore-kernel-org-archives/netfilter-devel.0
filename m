Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686064;
	b=R/6s156NtWRSLQiU0f3DD3/aq8o9F7uM3a2adx0lSt1x2mSVfdzWIEdoub6bF6+mSamE
	 i3DncLWQWjK9IE1Yfjt2r7K2wDlSgVhgfERqbEcFpIZlbXSAqnUz01Jcs8q1U/q8/FHvO
	 Flr6hIcIGk2Q/Wqk5wx+9GkcqLERnUXdS6GuJYP88Nsce8T1DlphR1okts/P8nXqKiOpj
	 p/QflNpfB1lqoKjsk9tVB2uHoqyxji3TlMg3zXf4ip/E1f3+lu5n4MqYfDldcnCT/SHgS
	 SYX2IIcTS0o+jOn8GL29l57xzg0KM0ySKYm8Q3NykY+qnUByXkth+rKNBbkyMDS/VEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3qJyGE4a5UB8YhjOY/fzHOLCz805/i0NwCGq/ktQh8s=;
	b=GaxzTlweMWGfhQaAgCUr85ov9c3NFYS9sux7O80zfg33ZQ5u8SZnReXSyAypukeIv0Ck
	 2mOE/qDWO+JE+gWD0MJi0v06WIkpbTgKcrz4+XcRJsAPwm4aHoHTXd6oDIjwymbOlEQA9
	 hyLYyrypRzQX56fKziQPZ6Xl7Qo+iC/iAb4FmOw3cDGRCILHIo7XsuZNWfPYeBcxp8Mvg
	 XHDiMiOF7z6PtXuudjkQBnbJ/wSaTznxjrFJFIrMyrknc+pdouqKsy09ElRnevhw+teFe
	 p1Lnlx7feNJy8+tNN/E7xyF+L0LzU0hl4X7C6vGuG8OqbobWd3jYfy51gTNAmTTYR/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wIUueDOB;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41709606A32E
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 19:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41709606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wIUueDOB
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-37628596783so3712185eec.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 11:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794686063; x=1795290863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3qJyGE4a5UB8YhjOY/fzHOLCz805/i0NwCGq/ktQh8s=;
        b=wIUueDOBpnVCEvuV8Dp2/5jiAS+lYJl4cP2IVvXaTwL/NtbOF8E8OqpR1ki0rwgV4d
         Qec5TkPv0LlEh2Y8V/u9Q43jXt1yQmzhpMWLB2CUDZgGmaA3QxIAqDH0yKtxJgtwhT2O
         5bgWymkei0ImgUBzoSsanK+1ZWFBMKcSp9Xnmjz+usNmf59VffX6IvJ+uAMZ6x4MIva6
         Y56K6nOVKvFIOxhdmCokMLbIt0LEN0RrmXyhCSk9sOIgG4HLbEWsInMOfIhU95K1ikJ5
         o6jpnA3CHQTHjXPVjkosZKfqXN/2gs6gqXC1Ymz5ux3Fy07zhmVMY2BhXS4dnBIGDWLi
         xL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686063; x=1795290863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3qJyGE4a5UB8YhjOY/fzHOLCz805/i0NwCGq/ktQh8s=;
        b=sLb6BHhM9XHhyEdrNhNQyXlyX84p/p4110weHbtwj9rtKhV0iX7qJ/QDhtBjY2nR1n
         1gt3OAgGmwyBjJmZ+7TBJGWY42gbiwSsBGnAu5K9oQqrRT7IZELEi6nCWVLI7ODeAE3j
         X3ekJRV2yK4m5On/7rpdGK9vC6E91cLzOOwaqXyV7xYPgTnb+hJXCWsEZI7mpe6rXDzP
         OOeJ5UbU1BpEXLVq2JZTPu2TA7vfG+8/4NSD3CaED6xcCOTz3Y3/BH43ZRHKIRG6GQBd
         qw0ojtm4/9cE63FEr5vc2sXNsnLXt2t43sFtqlU5fptY1PGMpEM4cV6c78zjQpoXH7JD
         neEg==
X-Forwarded-Encrypted: i=1; AL+hErHCzTB7HlaF1B1bkPg0TzW7KojB9fQ4Gw7n7fBQ9oGbR7oqUiu1sLcRcxaOb+h9TL8KQbETc4zp0La9HIV+jFY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8lm/kDzb+aSAoMIcnrOHh7jlCY9l0OemrQUsahUgpYrP5iBBqi
	oolKjGUUW2qqm+SGLcKVHg5VNXOzyPn89QeZyj3E760/tZMfGgAIWlr6+IW/R0PX
X-Gm-Gg: AYBFou2x5xCFZeb4/xyzgu5gdFNf9Y42BjpqzsqLR71JivVUZt9QuRTyyDzDPRrT71C
	doPB20DkgW60+ugNlOV411mV0sfpqgY+zlyrM44KFgrWLYQkQkZUcc5dN4iwyhbYAgt5LI2WBUB
	s8f8x5baFjPg4OuGFfjsbidJIjLGdw368S4o5VW/ktj/j+jkZgpzZN0uKsWNLLMEWNs7tc1sYa8
	VgNtaZRbzewhib6i3VsBdhIKbqcHWPuKsPDsIg/JDG4BzI3IpL1qdYW2P+gDFSvccoTM4VFEinv
	oUnYTrG2z/XBB2bpsh+Q2MhpCIQP99Qehh9TbQcjQH5N8ZIHicQY9VR4f8P1kKMdVjBTRbiAIX9
	CNUUedw7Fr0gmYyYwtb4de4mYqsNmoQMItkjrjP9gRPNf8GxGo/ByY3KKzeQZom7R7na4k2Cu37
	ZjYw8t2CPth0dZFNLYxlUG4Gso+Xk9gAvlEAxiUoWiuF2W/2lBo/Egn9b+fTsYXeyf8Wj1i1I+c
	+viH2YLpW1JVqjav9Wqu+CRZCgCYXDDWjPykhomEQzEg30vpbFM+aLwX6aEuPIWQEmaaBXW11gT
	UQzHk5yqVeOOoa2+X/ioSJlfPyCN1XuZCV86
X-Received: by 2002:a05:7301:fc09:b0:36e:b3e6:ebe7 with SMTP id 5a478bee46e88-37966a58499mr5631650eec.26.1794686063266;
        Sat, 14 Nov 2026 11:54:23 -0800 (PST)
Received: from user.. ([2405:201:c052:b00b:f7bc:3425:951e:ab09])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad134sm23226931eec.27.2026.11.14.11.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:54:22 -0800 (PST)
From: pavankumaryalagada@gmail.com
To: horms@verge.net.au,
	ja@ssi.bg
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
	syzbot+84e27adb95fd2a1fe9bb@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH net] ipvs: wait for RCU callbacks before dst_ops teardown
Date: Sun, 15 Nov 2026 01:24:09 +0530
Message-ID: <20261114195410.96503-1-pavankumaryalagada@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>

During network namespace cleanup, IPVS releases cached destinations
using RCU callbacks. However, ip6_route_net_exit() destroys the
per-CPU destination counters before these callbacks complete.
The RCU callbacks call dst_release(), which updates the destroyed
counters and causes a NULL pointer dereference in
percpu_counter_add_batch().

Call rcu_barrier() at the end of __ip_vs_cleanup_batch() to make
sure all pending IPVS RCU callbacks finish before the destination
counters are destroyed.

Reported-by: syzbot+84e27adb95fd2a1fe9bb@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6af795e2.98e60839.1e023a.00d4.GAE@google.com/T/
Closes: https://syzkaller.appspot.com/bug?extid=84e27adb95fd2a1fe9bb
Fixes: 026ace060dfe ("ipvs: optimize dst usage for real server")
Cc: stable@vger.kernel.org
Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 8a3c880fdb26..9c456efe13c7 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2553,6 +2553,11 @@ static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
 		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
 		net->ipvs = NULL;
 	}
+
+	/*
+	 * Wait for ip_vs_dest_dst_rcu_free() callbacks before dst_ops teardown
+	 */
+	rcu_barrier();
 }
 
 static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
-- 
2.43.0

