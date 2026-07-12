Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B75D38AC61
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 23:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783899730; cv=none; b=IfmSBv5+XT4ErCBvBTONpnVzi7abzF1Fvymz0cv0bH3OdDrrZQhL2DbJrd5ypqg8wWWcjKtLGlmdLwsXyKTxl56aCgWm3sk74j3Ej7ox+K9zABmDBqCosxihWb3mnWtP5GH6CD2UqYjvf80prXDO8vyKyvFT/z2MBfB/TwX0rSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783899730; c=relaxed/simple;
	bh=dLgwcnW4YtgNTCb07VpBnEanlIde5YMvtskoZ4n/0XU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p+Uvc+wEiETimKmLYXV02VkFYAjAKzdNBmzmBwnNoSTujtBowRWQLEFYPjPS97HvV2HqxSdtjnHBB51fgjgJDnNMAlImPVoBYfhF//HC+4xDkZni1+tNpp5vZinWOZuDx4/d0LsVnel+wI7QAbPw9qzXieSKbSYNM8pkrfFmlIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=KazK+9mv; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="KazK+9mv"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84864086bfeso2498997b3a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 16:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783899728; x=1784504528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LOSvs3VNPQa+toUMC3FY+7NtrOSPXGuDizFuqw88H7U=;
        b=KazK+9mvzIm6kSf3mVKRNikwhV7qsyX9veCDhOWDpUb9sAwhzJc4bHYcID+0WJ3cPH
         etJZ0eBrAl8c2+pg04d6scPGVR0SMBW9ldkxB2KFaeF4Eoq2m2qlEibLZVanv3YmQBfd
         KE4sMxlqXtCKacaJED2LFdJUkQQx3i3O1rnCGiJJzTDOQ618/FVbARBrqF72Z4rqf1vL
         I9WRd/mmkSqTTlA2RDwfR/XxHll5GJVsUe9xONpa6IKl5+FXTYiOGtn3JiUUccxcomrh
         yqyAcRqM+GVUopQiqvvoEtfrXvTsk7mKrrWnvZG4DrCP66JpNEOHSuB6aX6Ysq99lYJ2
         l1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783899728; x=1784504528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOSvs3VNPQa+toUMC3FY+7NtrOSPXGuDizFuqw88H7U=;
        b=tQgvjxCI8vrQ5QohvrbaB4KWcms7dKY/CxVRKR6iiq81qlt9lCglal4pupXtI4YvQb
         fyJDapZSKmXXMbu2TyRiIWzuYK0iaKHxzcpubuHh8NINe2MLP8A+WRPW4W/+mr2UGOgN
         u6IcpM1P+QkWrQMA00uSCpSS1gkb8zpnHbfJziPMol6M3h/F+501B+8k5ez4Qrgv9jO/
         0jtJcYodM5u8NcrkW40QTcXS3G67z5xIhQw3lrD9HZEGPv0Dh/XhYXnuVDIiONBU+xyD
         Gra40s6w6O8FV4tRKlMWmZx0ZtQJSpnvXEvRUK64lGohqoTQnSz6XaL+e1xPES1O0cL6
         o29Q==
X-Gm-Message-State: AOJu0YyUxinizV4oCB6SdaKfHyH2zETRYMEg2mG+esP+WSbA82X6UNTY
	8pbprLkY8Ac8I4UHvd5BvqDLtXxGZ4CpEF4QVYz4GBjFwTIMaXDFRWDBfGum3q1V1Q==
X-Gm-Gg: AfdE7ckOokiawgRs/2yTWL6OTpNtVUZ11Sdul2o3ucrsely698E/YgnJeoDsGUEDWUV
	GLAiXMfbx3es8UbmHvEbRra3NFwij8NKW4iWvwb5tETOGtLHoyWsezN/HGWf8I89j1e18FNC8dI
	ior41AP4DwqbXkiH8SAoLVPCUhYMLE8VmLoBVv34pEUOPmd0Qju7uzTPbDETj5iK5XuzFUHpOhO
	dPnVaWwjxCYGbbmKhYJa2voXMdCVlcjI9pwa4IEiWrfF4crW1PNWpdl9TL0wI1E3/2RUuS3zS1H
	YMAC9/jut3pkL7V/Z6phIjxKsb2bUsYcM6Z/o5F9EB4WF0NytS/lpSzHvQ91ZhDAfr7gPjvZeAC
	1vWgpOdQhjDSmjTSCsRfQxnn6ulHw8ktdHYd2hA8OzFa5Z/UzEWyE4P5UaLSfj6ZT1i5WjSY5ZQ
	==
X-Received: by 2002:a05:6a00:4484:b0:848:3f07:c5a2 with SMTP id d2e1a72fcca58-8488974f8cdmr6076086b3a.4.1783899727744;
        Sun, 12 Jul 2026 16:42:07 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec82:d7be:f961:4fa0:51a9:cde5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca79ac0e269sm5756646a12.3.2026.07.12.16.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 16:42:07 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH nf] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
Date: Sun, 12 Jul 2026 16:42:01 -0700
Message-ID: <20260712234201.3213635-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sip_help_tcp() stores the size change of each NAT-rewritten SIP message
in s16 diff and accumulates it in s16 tdiff, but a single message can
grow by more than S16_MAX while the packet stays under the 65535
enlarge_skb() limit: nf_nat_sip() rewrites every matching URI, and a long
Contact list expands the message by tens of kilobytes. diff then wraps,
and "datalen = datalen + diff - msglen" yields a huge unsigned datalen,
so the next iteration's ct_sip_get_header() reads past the linearized skb
tail.

Widen diff, tdiff and the seq_adjust hook to s32. Both are bounded by the
65535 byte packet limit, and the seqadj core is already s32
(nf_ct_seqadj_set() takes s32), so no previously accepted input is
rejected.

  BUG: KASAN: use-after-free in ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
  Read of size 1 at addr ffff888010800000 by task ksoftirqd/1/25
   ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
   sip_help_tcp (net/netfilter/nf_conntrack_sip.c:1694)
   nf_confirm (net/netfilter/nf_conntrack_proto.c:183)
   nf_hook_slow (net/netfilter/core.c:619)
   ip6_output (net/ipv6/ip6_output.c:246)
   ip6_forward (net/ipv6/ip6_output.c:690)
   ipv6_rcv (net/ipv6/ip6_input.c:351)
   __netif_receive_skb_one_core (net/core/dev.c:6212)
   process_backlog (net/core/dev.c:6676)
   __napi_poll (net/core/dev.c:7735)
   net_rx_action (net/core/dev.c:7955)
   handle_softirqs (kernel/softirq.c:622)
   run_ksoftirqd (kernel/softirq.c:1076)
   ...

Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 include/linux/netfilter/nf_conntrack_sip.h | 2 +-
 net/netfilter/nf_conntrack_sip.c           | 2 +-
 net/netfilter/nf_nat_sip.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index dbc614dfe0d5..aafa0c04f917 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -115,7 +115,7 @@ struct nf_nat_sip_hooks {
 			    unsigned int *datalen);
 
 	void (*seq_adjust)(struct sk_buff *skb,
-			   unsigned int protoff, s16 off);
+			   unsigned int protoff, s32 off);
 
 	unsigned int (*expect)(struct sk_buff *skb,
 			       unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f3f90a866338..e4a70d1d77b0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1663,7 +1663,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int matchoff, matchlen;
 	unsigned int msglen, origlen;
 	const char *dptr, *end;
-	s16 diff, tdiff = 0;
+	s32 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
 	unsigned long clen;
 	bool term;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff09..a93eaf0f7d30 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -321,7 +321,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 }
 
 static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
-				  s16 off)
+				  s32 off)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-- 
2.43.0

