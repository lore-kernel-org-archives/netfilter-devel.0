Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38D14EF13A
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563201; cv=none; b=joZ7tnP1i5jKJtZRooM6tyodX5DETrRZSjCdANHdlmjOSksljKdh0sba0e27pdilW6+e3N2OQ9SMrPzqxjz2QR9Vu81mupam17+h1SSfQRfzxTbJJ6t1w4g4oN2udLEAKmMVM1eKpoNUiw9Oh7JAryFUdUrAU5vFIfNEuqCNPq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563201; c=relaxed/simple;
	bh=z8LVxDwXNisEDg9XRjD9l5cNR4q4YDySjviXXc/lnQE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PAdiRxCUyvafLzeqhPssDqMpVYvoPucisLvnRXqBHtGfJg78R9jmncQ8x5ZKjgSJt8XmJBEBTgLSCbrZ1MBFpg+3UQhFoIGQr2iPRuzSGXxKLs+JdA3s0DUgAjrHdc2OU1M7Axpb5nlUdBQ5lid2TIFRzfK2yn+PIocjJ7tjA3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxiKyY09; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxiKyY09"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4be28b82so3918830f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2026 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791563189; x=1792167989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ckizy139Yx68MapGfbyuMco76+jqL/TiZ1vLBTM9150=;
        b=bxiKyY09W2A5BA9exft9roeyERw+dW5dIIhz81IwB+W3asI0+rhE80y37a4gw3SpcQ
         ENdSmJ4aM6PA9AwXtxvBE+FoBn+vayBhGDg1J8XKNMt7meK3sogD3RbQf2pVPH3bkHcq
         qoVl3vzsoYgwXRnBgC1sB3eiyqfwd6qlWo6g5WdwnniZt+jW6qGqj66zJS1OA7pi8Ove
         nE5HR/eqwh7U+6lkHjWddTvWDumdoOOsRlH7Ozmch87f+T2/tBAzRRm0jB54zRm02jwE
         j5c1Tnt04BHiDOdQJRSrjXL84+Mtu+/4/fmh2jZdU26Gbnc3DCA3VDp2J/WOj9FrLxNT
         /tPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791563189; x=1792167989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ckizy139Yx68MapGfbyuMco76+jqL/TiZ1vLBTM9150=;
        b=tyzveQy7LcaXR5pjWBFVe4g3w0+wICCR6FsWtgvEH12Gvvtm++V32cdUc5GoKnLNFc
         BkbFDYHNW/Z8t2xTG2gRCZ0FD6CWyMfXGGn9vfaIouFodoHLRY/rhgSNOjWdZX+YDskh
         f5D6FNBqofkdeouovszSgz3m3T47nDRH1YrDIJ03nsHWJjFHMy4MEXTgs0kfq68ws2Vu
         4fd0VVkrih0OK8vvC7B7DM/IXQ1uZpn8ehyA6isZlxn5oR0GOlZZ8ktc64E6NSA6GhCz
         JLki+xi6Q6QDnxs/qmKoyp9g9xQlNo5aCS+N24Fwp/SPmTUNxh/s2OCPHxdzNXWKk4yC
         ZENQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlHXwtTChMvwbz6oBy893ZuYgw7DZK9y2n3X6P390mbN2wYJeI3dD+XfN2d50W7VyYHxc4zTrwtFI2GNsAtDg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJuqhWTmtELipr8dWeDXr6Gu5KuGpyGwrghc2ZEwY2Uja7nwikZ
	R3og9vSX2JQRGO93KbLo/pUV8ZgXYIbTmhmLkdZ7DbvwupNNl+KZTMAQ
X-Gm-Gg: AYBFou0E9Od6h6hOOXMmAW9egisEMIayrIutypiCqKxsvSDl8foiGhzrLY7pWE8rz5f
	nI6r83RJT8E0xjBa9UUOcjEa40WGGyCNLVHJG8ZJp4w18a9dE2wLiUwBtkTLAqnGr0H51KdkK62
	BsrcjbxKWfENpiFvWk90kMtPZe5DND+bxGjvxvSLeECnm3b73sNWRFEbDmOzUp2vQ6N09/+FrZb
	emvslXj60nA1u5RXeRXs03H7TQ7Nn3JyzGhrb7SHSR/9jhfi0jgdN0Lue32SK6QKGGU/ZLeL293
	Sqz4wSrqPqyxTrz65ULwOLVrr9Z9Q3w8p1VCdqIY7AxpYep7B1xIe8ZFj+zXYC/UepLJ8bem3cU
	rqwMcpu2bgiXT+JiIXPSw4t6HQBkvY/Xps2NvxxzSOF8yQhtPKUz+Ldsn6RkxizfKujreiWTNsK
	u9SyGZOGlXFyMxeoXV1ldP2twAakriryWiphTKNFxRU+RZ0ABqY1KwxjLr916+gU1W55iwvxhLU
	rIg3CokSjYQYZYU2mnRUYtPeH2Iswa5amn/ngelrSl+ySK3wM1g4UIyS8N2+tQW8UU=
X-Received: by 2002:a05:6000:46db:b0:48b:e50:7152 with SMTP id ffacd0b85a97d-48dbaae21dcmr3251605f8f.28.1791563188334;
        Fri, 09 Oct 2026 09:26:28 -0700 (PDT)
Received: from Raghu007.. (sgyl-44-b2-v4wan-174108-cust110.vm6.cable.virginm.net. [80.1.81.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9abdaa5sm4745750f8f.35.2026.10.09.09.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:26:27 -0700 (PDT)
From: Palla Raghunath <raghunathpalla.0209@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	raghunathpalla.0209@gmail.com,
	syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com
Subject: [PATCH nf v2] netfilter: synproxy: check TCP header before verifying checksum
Date: Fri,  9 Oct 2026 17:26:24 +0100
Message-Id: <20261009162624.16294-1-raghunathpalla.0209@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

synproxy_tg6() calls nf_ip6_checksum() with par->thoff before it checks
that there is actually a TCP header at that offset.

par->thoff comes from ipv6_find_hdr(), which ip6_packet_match() calls
with target -1. ipv6_find_hdr() only makes sure the first two bytes of
each extension header are in the skb. It then adds the header's declared
length to the offset and stops at the first non-extension header, so the
offset it returns can be past the end of the packet. For a CHECKSUM_NONE
skb, nf_ip6_checksum() then calls skb_checksum(skb, 0, thoff, 0), and if
thoff is bigger than skb->len we hit the BUG_ON(len) in skb_checksum():

  kernel BUG at net/core/skbuff.c:3606!
  RIP: 0010:skb_checksum+0x8b2/0x8c0
  Call Trace:
   nf_ip6_checksum+0x1bd/0x320 net/netfilter/utils.c:89
   synproxy_tg6+0x1a4/0x6e0 net/ipv6/netfilter/ip6t_SYNPROXY.c:21
   ip6t_do_table+0xd37/0x15b0 net/ipv6/netfilter/ip6_tables.c:366
   ...

syzbot's reproducer sends a 60-byte packet with an AH header followed by
two hop-by-hop headers. The second hop-by-hop header says the next header
is TCP and has hdrlen 167, which gives a thoff of 1400.

nft_synproxy_do_eval() has the same ordering: it calls nf_checksum()
before it fetches the TCP header.

In both places, get the TCP header with skb_header_pointer() first and
only then verify the checksum, the same way nf_reject_ip6_tcphdr_get()
does it. Packets that don't have a full TCP header at thoff are now
dropped before we try to checksum them.

Fixes: 4ad362282cb4 ("netfilter: add IPv6 SYNPROXY target")
Fixes: a311a8981727 ("netfilter: nft_synproxy: use the family-aware checksum helper")
Reported-by: syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5a8667f002726fc59f88
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
---
Thanks Fernando for the review, and for spotting the nft_synproxy case
and giving me the chance to fix it in this patch as well.

v2:
- Also fix nft_synproxy_do_eval() and add its Fixes: tag, as Fernando
  suggested
- Drop the comment in synproxy_tg6()
- Add Fernando's Reviewed-by
- Rebase on v7.3-rc7

Testing: I ran syzbot's reproducer on v7.3-rc7 with this patch applied
and ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset
past the packet end") reverted, since that commit already stops the bad
offset from reaching the target on current trees. The BUG doesn't fire
any more. The nft_synproxy change is only build-tested so far; I haven't
managed to get a packet through an nft synproxy rule with the bad offset
yet.

v1: https://lore.kernel.org/all/20260926204519.43402-1-raghunathpalla.0209@gmail.com/

 net/ipv6/netfilter/ip6t_SYNPROXY.c |  6 +++---
 net/netfilter/nft_synproxy.c       | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index d51d0c3e5fe9..b3aa4fe67589 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -18,13 +18,13 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	struct synproxy_options opts = {};
 	struct tcphdr *th, _th;
 
-	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
-		return NF_DROP;
-
 	th = skb_header_pointer(skb, par->thoff, sizeof(_th), &_th);
 	if (th == NULL)
 		return NF_DROP;
 
+	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
+		return NF_DROP;
+
 	if (!synproxy_parse_options(skb, par->thoff, th, &opts))
 		return NF_DROP;
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a000f4..6b290a89886d 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -118,12 +118,6 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
-	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
-			nft_pf(pkt))) {
-		regs->verdict.code = NF_DROP;
-		return;
-	}
-
 	tcp = skb_header_pointer(skb, thoff,
 				 sizeof(struct tcphdr),
 				 &_tcph);
@@ -132,6 +126,12 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
+	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
+			nft_pf(pkt))) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
 	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
 		regs->verdict.code = NF_DROP;
 		return;
-- 
2.34.1

