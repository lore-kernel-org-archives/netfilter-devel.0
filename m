Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795004944;
	b=jAfm2FBdoJGrKEFPw5wWfc2ejCoZK64fwiYmIc06Ekf/TXzxvZfvnXI8K6/XRczeyf4p
	 gwxrrkd7ogOVbgdX5yxscP4BMRxwMTNcTFkHRP8499cPdlQmgGirVvVUehTgzcyZ+hytf
	 l61K0fYUE+xuFRLkNowqx2chkX9gXPwLgxhwOd9+6Ta1B6UJTdYDbDUpLnZVM9U2K73eZ
	 r207Qe3QqiYJEEq+csoadWFm2M5aE5xXEbvSlTqLjt0f1npph1Xx8RNjy1UDxLJ9EeC1Z
	 UlGLEVrI/wG7iLgCu+YwA5W/3BBgMUaY4TPV17bZ2vGJEQ8S0D43y2fZgUwFzRaM/pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795004944;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rBHUNIeg71PAnIVFvGQABUjBmJpAmg4Ag12k4fFD3zs=;
	b=2azF1MAq3rEuSfxi/raKHu11D+EBGmT/my+D0q4wwZmOrWwa0HkryPtDcKVwYvCgwF9L
	 llHQPJwmctBklVJvGLIMm8jb1SIUZMwqXlvtWH7afzSXwk//5YdIocRNmxwKl6PBOXRie
	 z5VzaILKWgVvZFnSBhgLVOIFLxvPzF/lZacK7Tcs9I3NhVQewA1f4EDpawUJ61vOanv6g
	 Q1KhSrUyQ6bgjM0tzPcCcMH2RSSZLIy9kpfSZ0OdAQZ2LE5+8YfdyzYjFk70lSua58jUA
	 g24I0He+a33WmVkiIFPNdkBfOqpDkdBpBL4O1yM2MfP1ZO72iPFwoXPNo5SjT5ZRdAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uOFCtPLR;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85DB606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E85DB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uOFCtPLR
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3282db206d3so2513695eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795004943; x=1795609743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rBHUNIeg71PAnIVFvGQABUjBmJpAmg4Ag12k4fFD3zs=;
        b=uOFCtPLRh6NiXcbVdbUMDTaueXMu9tBgVehZNx1X/7saTLLqJJH0TeWDC6935IlAE5
         CKVOJbMQOHsmEBnuN0YSguK8etPgLd2L5/l4Dn3wlr44jq9cPLX+aHG/bENtqnp6A7cS
         seSwO/na0zf0KB5ckjcceImRMOjtCKDOAohMAn5/CWRaVYXxP87oj4YC/Cx6tbgucJwV
         lZRGYwEgxMG3FfHrvqjnLetz8+2k/7v8ZTFI3Xs6qRNJeWgj+wRmGJLQYaWJwAlKVj0L
         ZBSHkPGS/f1laGbMvuO4fFcv9wrYvRvtbvcBIX2Qqqvm+o41Tr4rB5kjU8YS7PzbE4E9
         na0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795004943; x=1795609743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rBHUNIeg71PAnIVFvGQABUjBmJpAmg4Ag12k4fFD3zs=;
        b=oWIDbLFZ882T3x+VExaL/ov4IphdCybKJYr6BIxfQgEhLYgdoSRVPa8BC6OoomBTpL
         budQ4EQvwnVJbt7jOKew4LASMk+R4FXJ2HBjJeCv/PK32Y608ZGYEORUrSlcdZPyWxrB
         WIJkaS3fTLPKvcfps30McFK8T1BqqE5ULVq15N5qcCeYj8b3XL5IOTZ9zsGNWb/4GD2D
         QvK55dV+Z82+lzSmQAZL/YNeZRL32j+8f2FM48ZIoTlfMq9eRIgwIMBbgVkwY3p4Onr2
         xsNJWtw6K8lAccqJAKtiFnPJkQ0ASpQUL0aAmaa5Mw+lSSeRt0ugy6jbC7yLlL3bSxuR
         Fhjg==
X-Forwarded-Encrypted: i=1; AL+hErF+4dfmQKOAyuOeqspVFBv6k0rnfEgeXqekuwTm/2MBWzWdlRwBPWFxaz1zkdOf1wuZKdydY5N7R7ju5fqTn88=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Y8w15JItsfpiPpxA6BPuEeWuaPu3khSY4cnkm7VJNYjRTWaW1
	6LpwmS9q8Rhr1/xrI7maqHPA4xErbJUV0Dia8KRcPx3c+cobkFGTba1B
X-Gm-Gg: AZFdTZd7TfXv/ZUauOFkXvmfEO71GqwkP8Ec85D95w2qzXwkxegDj0QlTJZSNbSaIPM
	AuZAacw5g2yDSa5jUp2fzw+5xOZvOSGX63j0X7Du0H6/gvN5PdbD/qG6eTABX41EJIwg0Tir+tY
	MIlyRaWrnOU6u5m6RIFpCnjieNZaJuUuMqGN/cbnl6EDiaEoDfZB9kSJazKS49uEXPdsKpwGYdv
	KZT7z8TO/ae32eNvcskITo6coOxlHY3FaEYf1u+5AsZlIdyTV05g9lQPf/zB9MQmgNLHZpskcf6
	hhcV3rwVtHVFQdY+j+x67+6oj8uHKO9PpdZjxODlJqGzhfdQqi7/JnsKDDHCJhBQRmh+dsyXFTz
	y4aNhFap6a3cVIIaQgyF2Qwh0Ld70538ASDqdWcpm2rwMhAi9tiJL10Xm1u36tioTX8SoDQbAbO
	7czquXZ9QP3xetfTXHB/ayGlsodMeNm0AGbPdLMZLqBkYdXCRVdKbkN2T1bdUlSG6jz5FX7mN/1
	bJAt1QpxCOujmkNElO+Jxxkkvu4wUu60PTWAa5U+hvilTiaI2cERYFtAh46HYYBTpmPoLNkKLZc
	I/4AXZ4RvcbWxZwkfWyeHko7xqtDDK6XZnyNSarzZZvy1FbsuhuhXCrKvC2A+L6GujrUKpBMLw/
	CqzyDpJG5U3QDGp0n/pchVXKBe0S7vHW6kMm8H7VS4G74EiUeG1fxULwqEGG7iGk27B+C57iG9A
	07PbyKrP5NoRSI7NOgLSzDuLMNIu00R1l+cB0qSJBF74XsVB9CQCMrJp4sKUuxyN0MtsLiLc2ja
	L1OBu0te2AH
X-Received: by 2002:a05:7300:2150:b0:383:bc0:77ea with SMTP id 5a478bee46e88-3830bc0895fmr1468156eec.30.1795004942743;
        Wed, 18 Nov 2026 04:29:02 -0800 (PST)
Received: from FT6N242TWK ([223.181.117.48])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a7eaf3b3sm8948312eec.27.2026.11.18.04.28.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 04:29:02 -0800 (PST)
From: Shashank Mohan Jain <jain.sm@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: ctnetlink: support port filters for SCTP
Date: Wed, 18 Nov 2026 17:58:56 +0530
Message-ID: <20261118122857.86193-1-jain.sm@gmail.com>
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

The kernel side filtering of ctnetlink compares CTA_PROTO_SRC_PORT and
CTA_PROTO_DST_PORT only for TCP and UDP entries. The SCTP l4proto
parses these attributes into the filter tuple
(nf_ct_port_nlattr_to_tuple()), so a filter such as "protonum SCTP,
src port X" is accepted, but the port is not compared and every SCTP
entry matches. A filtered dump then lists all SCTP entries, and a
filtered IPCTNL_MSG_CT_DELETE removes all of them.

Compare the ports for SCTP entries as well. The SCTP port has the same
offset as the TCP port in nf_conntrack_man_proto and in the dst union,
so the existing comparison works unchanged.

Found by reading the code with LLM assistance. Tested on x86_64 under
QEMU: with three SCTP entries, a delete filtered on one source port
removed all three before this change and only the matching one with
it. Filtered dumps show the same difference.

Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
---
Changes in v2:
- Target nf-next as a feature, not a fix (Pablo). Drop the Fixes tag
  and Cc: stable.
- Drop GRE, which has no ports (Pablo).

v1: https://lore.kernel.org/all/20261118042950.83129-1-jain.sm@gmail.com/

Prepared with Claude Code (Anthropic), model Claude Opus 5.5
(claude-opus-5-5).

The QEMU test above was run on v1, whose SCTP part is this change (a
small raw ctnetlink program in a busybox initramfs, x86_64, TCG; TCP
entries behave the same before and after).

 net/netfilter/nf_conntrack_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4b6abe3..798c11d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1127,6 +1127,7 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 	switch (ct_tuple->dst.protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
 		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) &&
 		    filter_tuple->src.u.tcp.port != ct_tuple->src.u.tcp.port)
 			return 0;
-- 
2.54.0 (Apple Git-157)

base-commit: d0107f38162279d9cb0e012210731176265f835d
