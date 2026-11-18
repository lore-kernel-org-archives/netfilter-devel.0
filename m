Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794976197;
	b=DARv+dsP6Vj/CK6lA3vrqYwBLGUAq4lXy72v2EJbECLPiGM4H2dJ7KHEcE98XW7VzjD7
	 DxvXSm9oqTawrRWX5nsimUV8rAUklSPyCUrXZwMeD7DmvRR/F2QIOR/GM1DH2/HuNXfvX
	 gDz1BjCNbl21b89p++0FdB9suoB1mtTFHJVpT6mbiFMh4jYt0f83Wo5tZoLAA7rlrQj0E
	 SZxjFkPaeL38CcJeHuBUdrSAIYr5RbA55NMRr0QaN+tA4/z2Zn2wvSXf9FF9bBIrsgdv/
	 pVB+N7WJl2kpTRAHxVWWs4EzXHL20g0CmNAsaQ0uwPyf57Fp1zEjQsNyHyLVyUQWtDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LJ9gCj2jGGmLVFKvuakf/3ErIiC4ZxE44mtjMvsbMAw=;
	b=UxfhoOSzXeg2SK3U4EqQ+AZ/rt1GVmcqqY7f7/k2SM0802jPRndByFiBYh8kz1xl1sqM
	 OkolhVqkTK096fpCvo/1nHn2ElEkivZycGHBIrVmq6tfnOcuefMADUpLYFtkwvZ8KwMbr
	 IEenNw0/2X2aNtnJ0DGTgJLvQCvbxa441fUV1peTCTwQ6OjNkyBdqxKNEITV2zqzMbkbe
	 ojvUntAmpjqT3bneYxwKg4os85tpWbbtLzvPUW4IodMwvm3HHPPxRYBhT0MxSWafoMe1Z
	 oFc/sq4L14QGFalj/lOtEUkiVNeHVZYBa5HJa6Bp1Pxko1mAFPzyTKKzgHYeQJ4aRLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KX6CghMX;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D75606A32F
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4D75606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KX6CghMX
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3704d30b84fso872850eec.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794976196; x=1795580996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LJ9gCj2jGGmLVFKvuakf/3ErIiC4ZxE44mtjMvsbMAw=;
        b=KX6CghMXtqwmXH+k2x/YLE7ck2w8PI3LkWfSrobtdaskFNDxfHjRjdQHJwSlA2lp3v
         M2Lma+VM5Mvr2z4dHyaAPidQnBDGfDc0BzaIz57a/eAz57BrEnOY4Cw1kjjsJdJk6cBk
         i4DjvGrvP+HoXxsx9ANrheHnFYwYxTnAWJPoXSRzVQCGBx2OaY/aLQP7+3z8xscMCYa5
         o0E/xqMWa3vPnUq5p8PMF7vAkaa8FVy8z7qKC0Ur5llGkwwywXPNqZuYg1lXYqyEj9mI
         H1rWSWz5uaQoszbm2uVYFp/yzLrfBwZ+bTbROX9Xe07+AGtBOS78t3g/KhHB1OL8AsiO
         xpuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976196; x=1795580996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LJ9gCj2jGGmLVFKvuakf/3ErIiC4ZxE44mtjMvsbMAw=;
        b=NFCUdGAqpso0jzPzi5pt9DDXraUjDC6xubOCaepVqIHxxg7yxi7rz8lUR8edu7DbV3
         nqJG85iql1UjRvDRr9wHxemreJ9++Ikk4q3F4lCYeZEHR3Nn17N2tqMgv+RyF/6uS4wc
         TczsdFsN/vZDMK/6wSUuDaWP6633vfocmlwy8nFbcPjDGiLnBgj8RKqN6xkhKt7LW9H2
         j47UtU+ok0R8hYlkcKZI9oLKWtPoM/lzJMVMZrGNfvDU6usUMIhj0oWia5Xi6xdzNrv8
         d1/rv2f/Dhl3LQQ0+TR2mbTqs/6QrgniV+33dePzruzI6QdO9ftjLgHWZbU7xjuqpU96
         f4OQ==
X-Forwarded-Encrypted: i=1; AL+hErFlgApsdpKHEbNXDNKIHTi1Z4m6YVDWERrEp7sbXy/H0AMEm0wX4HPPlbFhe1T38989YlScEdMg4vaMM5V0e2s=@vger.kernel.org
X-Gm-Message-State: APuU4Z+M0HBtpUC9T9yp5G/k5rGtvy3M1MV7CeWfioGNI92c9Hu5daFF
	fNANofhN+TKu9OBNjhKrhMOVxTzr291QXtz/FR4htzmovc0ninAjRaKO4hAXXqoc
X-Gm-Gg: AZFdTZddHAfBzhsj2CIM/GKMEwCmqOqb0zvjbNPyM5/Yy3rdpRCp4+iyURKfLoZW53v
	spKnquLXenHRTwAjU8s9xj6NaK2GIemB7iSQTfaNVmGO3AkCjltboVefEWMUy3yZKu+X8jaJaTv
	6qoek/wcWg21az4QXtfdpbkaNHvwaWZM3nSTw04MVhObQ1/Ob2bSA8XTWddivJL03CLdFFWs6TA
	lybQoesFrpAt2zPsuR+wmgnl5AHyJJz4hK3xsTlukxRgdHgAIoYOiMHcVJSt1MQXAV/OQJXmom/
	ZjUH7YrtVQRJvF1OUG2+y2VbNCJOnsnaD4QtGZ8O5UtOql37nvc/2GoYi8isnoqMOQ4HsXKejxd
	gdG6Q+eWmF29Suix7m3W1lVK8woiS562CvBz8X7iaId22oT2a+ps7D6Yy6EmqJOzSzHZXHPgRab
	faT57gdisVn9hWNbjO0T1uPvUEDF84ouHWNDRwclZu8lGrXYTgaFfCldAagLK1CTYCYYTe1VLKf
	m7/asQFGvqefPDBn+fW+oMvxNSf/k5geRMOFvmqud3y3Ivb5FCMYf8ETMCr6uW7uNvnUoMEo4Yi
	yxx3i9w8s9GGo3LnpPbrp9aAvjFEAKD2knMfxBO3BA54QQlHMY6+KFxWvYsB81D8NgL83GawdK/
	Rdjsr2YLIYhLBja/O6pRmvFbf19V6v4uHb0l29KAGmPn4Nm/aW0KWfp18OhKocC+dLB9CkLHYCO
	O9Cn28ztOe/8MtI7acZ65AasCpu5HDcJXQaPhzcBPr18rYlhs1RJ15Lukcca9gpu0w6mqE2jO/I
	rfEzZeBLfC4q6pDP1JgWv0G81Vw
X-Received: by 2002:a05:7301:1823:b0:379:3c04:2cdd with SMTP id 5a478bee46e88-3828181119cmr1441606eec.31.1794976195799;
        Tue, 17 Nov 2026 20:29:55 -0800 (PST)
Received: from FT6N242TWK ([223.181.117.48])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a6304efbsm5273447eec.7.2026.11.17.20.29.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 20:29:55 -0800 (PST)
From: Shashank Mohan Jain <jain.sm@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf] netfilter: ctnetlink: apply port filters to SCTP and GRE entries
Date: Wed, 18 Nov 2026 09:59:50 +0530
Message-ID: <20261118042950.83129-1-jain.sm@gmail.com>
X-Mailer: git-send-email 2.54.0
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

ctnetlink_filter_match_tuple() only compares CTA_PROTO_SRC_PORT and
CTA_PROTO_DST_PORT for TCP and UDP. SCTP and GRE also parse these
attributes into the filter tuple (both use nf_ct_port_nlattr_to_tuple()),
so a filter such as "protonum SCTP, src port X" is accepted, but the
port part is then ignored and every SCTP entry matches.

CTA_FILTER is also honoured by IPCTNL_MSG_CT_DELETE
(ctnetlink_flush_conntrack()), so a filtered flush that asks for one
SCTP port deletes all SCTP conntrack entries in the netns, and a
filtered dump returns all of them. The same applies to GRE keys.

The port and the GRE key share the same offset in
nf_conntrack_man_proto and in the dst union, so the existing
comparison works for both.

Found by reading the code with LLM assistance. Tested on x86_64 under
QEMU: with three SCTP and three GRE entries, a delete filtered on one
source port (or GRE key) removed all three entries of that protocol
before this change and only the matching one with it. Filtered dumps
show the same difference.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
---
Prepared with Claude Code (Anthropic), model Claude Opus 5.5
(claude-opus-5-5).

Based on nf.git main 734bef548a96. Tested with a small raw ctnetlink
program in a busybox initramfs under QEMU (x86_64, TCG). It adds three
SCTP, three GRE and three TCP entries, then sends dumps and
IPCTNL_MSG_CT_DELETE requests with CTA_FILTER set to protonum plus
source port. TCP behaves the same before and after. Also built for
i386; W=1 shows no warnings for nf_conntrack_netlink.c before or after.

 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1f8d94a05..5e8e0b93b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1127,6 +1127,8 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 	switch (ct_tuple->dst.protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+	case IPPROTO_GRE:
 		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) &&
 		    filter_tuple->src.u.tcp.port != ct_tuple->src.u.tcp.port)
 			return 0;
-- 
2.43.0

