Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240412;
	b=M3CbOdNFoDia7vx9ouCes98LZniryyvwSdXiwc+OnFQ5Qhda/9ZdHC8IjwwNMqkFTeKB
	 TYHtVMzNvoJ/JfGuPorxZWvE5E9ibsO8V8M83efDAC4XCDc3NC9HVkMA7Ndo+nh2JhlmT
	 19Pf+y2QyyZAIXFDbk5MA1rBnOrmArBeR7RVMSTQ5Usv6+9lSBybAhvw1M3Wzi/DJVnyI
	 AXdQrjVFTJ1O5nJWULQieBV14OZoA1aLeL1+LfoOCBSBpKigj14o+xu4T6lAM4s2pJ6mb
	 qfSfPb/prUdin//89VVDkgFUq9AbU4buIqTv/kqGlqriQsFqbG8/CLI9hDW6k7FSlMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240412;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ESv/XtgAd9zTzgAZM6sPk7g+4jPyPje3WJayxGd+hA0=;
	b=xaaMur0kowkQ8pEtW7kgOxDVjG/YSPzVr5eaQCIoKW5ViG/TtrWpspGYqTm1kPD4c6en
	 rAjPyNrlDflF0XAyoAKWzVqwwL8Iz+qi+/qrWGQO84PRBk69k+NOWry7O+kFqKKfu+jcw
	 X0wWcWTikfdVgERYnXhgYQH73FJpiX4Q3CIlfdpGuILvEeovStx+lgLCl4mZ8saVngHEb
	 uOcaeC6c+GRw5eJPA7y1pJU3w8O8hP2xXPPMFLQp4F13Hffz5SMcBrNFaBzoJfuy+xYGS
	 G7PyoLmOoifB/TEAUox/LgrG5BJbP8dgG06vMH1OzGPVsU4cD/MYHbXtZ+geyCTHxrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=s65Yx2y9;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD686606A68B
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 05:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD686606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=s65Yx2y9
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b3b4944a0eso1360840c88.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 21:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1795240411; x=1795845211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ESv/XtgAd9zTzgAZM6sPk7g+4jPyPje3WJayxGd+hA0=;
        b=s65Yx2y99EyVAt5B1FZ0zPvj7kl0LORuWOzURt6UZs0NxtzAlYBg10Mi33WSdWo8de
         i1wuUmuBbQ91ybSH5WxqzGPM6Y4zRR8VvN106KXacxXndJf67JvuP/zMa3z8WPxDTHkO
         Bqx3YHqmZaokjpsEcYV12uv/NaqTCN4ULu7iuW9K2JFoWN6gUe6lNeMQ+PdKolQsiT7H
         QMt6DwD49Q3jZcXapGkchCVnQjDoOc+c2VBpgTYddh9c+25YklrZeN0GVTX00M5ZiJrE
         gCrbdpp1be6CJ4U8v5sEkTdl+ZnQQvXRP8zLqtyID4q3/Pc0jyOQO696MxpcRZi3B5bH
         jb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795240411; x=1795845211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ESv/XtgAd9zTzgAZM6sPk7g+4jPyPje3WJayxGd+hA0=;
        b=y9wSJ7sghMfL2ZTUQq8aXdqLLI7FF1tbriv+D47OtjivMjQ6yesxhFCoYavdjn2lkc
         cv4UN9F+BN3g1uTSZ5nshkueNsgWYDAZvsPce/kV3RulBaZSjk/vos1KWNrzpwXUm+tr
         cF5xhMNWXzFYTtJTwVY7P5nArhc51wJFGdWxPoXAdChl+tng7Vl6Li6Vr9ZMqtr/tXHG
         39wdGQUsoIhJlKU98QHxKuAoeSO3rXyfmctm0y0MtUXh3+F2xWh8QxkhJ7H3QyXXgBep
         l1w+ErasQTU4Gl/GmeeKlg6AoNfKD4YErO/1YBV3xV1wcFNg2qF2bN5QpCDtoh/N1Aym
         fgXA==
X-Forwarded-Encrypted: i=1; AL+hErE/qNvs+Nwcx2X5MGzALhs8svlhf+8P4GX/hFSmsFOJ0bUSHlq+4MgqogRgAm2OVeJelcKIfbalHLd6novc7XQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+x8d7I38pEFFl7V3l/bNFD04WFiGsE8+ahZ8YE07Ym+OqFBANX
	EQJsmtWDNIqeTajKyA71tx6tSZOnNfcFAcqsgTt00ik4LHu22uT5DPVtSrPJwsA5bwNktRKi+jJ
	29EOySEbm
X-Gm-Gg: AZFdTZcXDzzR/MEBnnYH58fDp/r+Einx98lYWEg5qg7UbjmQkaV4MkdiW+0Xru4jr4p
	g5NDr9gvBS/QlzYsebeACsnQVg6WwURgFyrSApaoGKbdFcHmqjkclNMv2RNow35pSr1fFe1tlIM
	lnST04Sic+7WKPVXNFKKkyQ9DiFTXPc3l3rELK27xIvAfAc2jKBKP3vugFq09Agy62Gb3OkNyyW
	JzPHf5EwEMRiP39l4iEXeIE5BoxJWJRgNUx8wJRBeNzIbDWADTMwDAS7N1S6CzZCFa8LhPXFOrQ
	T5OdWWHmAKr0z62pn9tw5XopeNCT5JIUByIaRG9ibkB/JzgxEsZIBaf0Vh5FJnfqLXSgeesR80A
	A7YTJWsEkvDjayk27RmOv77/vhetIGObrHBPlHQJzJOMI9aIf2W5bknQleouwpF0NkmP1mNAVLM
	CgViyYLC46mTegn6F2+43dWu+Y7GvZcmWhTnEab6ORwFJ2rufbR+GExpCkTXa0n5kFYRdL9v2Oj
	ue8w+M7jBSHKHhfja5u4mb0VgG78c9SK1FO6769T45Wzy8gzAUqydkqf3nU5B20O3BEWLw3NyvQ
	KWrgKhP3Yxj0KeRsaxsJcmctON+uewZEQDYeTAV1uisGVsImW18bEXO34GgpVGNrUdW4c45KNKw
	R0kup9gj3oPJNv2MgZKSW4uxqnhjhuZNSSRtt0gddM+dj8nRoM5qQXktioIn60w==
X-Received: by 2002:a05:7301:6405:b0:381:a3bb:f945 with SMTP id 5a478bee46e88-38570254ec3mr6078355eec.22.1795240410940;
        Fri, 20 Nov 2026 21:53:30 -0800 (PST)
Received: from gx81.tail3ecf1.ts.net ([240b:11:99c0:1c00:9e6b:ff:fe84:e26e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38577214c2dsm12829127eec.17.2026.11.20.21.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 21:53:30 -0800 (PST)
From: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf] netfilter: ipv6: stop the conntrack fragment search at AH
Date: Sat, 21 Nov 2026 14:53:11 +0900
Message-ID: <20261121055253.1801692-1-ryosuke@ikotaslabs.com>
X-Mailer: git-send-email 2.56.0
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

find_prev_fhdr() looks beyond an IPv6 Authentication Header (AH) for a
Fragment header. Reassembly there can change data covered by AH before
IPv6 input processes AH.

Stop the search at AH. Conntrack still reassembles fragments when the
Fragment header precedes AH.

Fixes: 6aafeef03b9d ("netfilter: push reasm skb through instead of original frag skbs")
Signed-off-by: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
---
v2: Resend without line wrapping.

 net/ipv6/netfilter/nf_conntrack_reasm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index be72c4346f8b..9d49e3f8236b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -407,9 +407,9 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 		struct ipv6_opt_hdr hdr;
 		int hdrlen;
 
-		if (!ipv6_ext_hdr(nexthdr)) {
+		/* Leave headers beyond AH for the authenticated input path. */
+		if (!ipv6_ext_hdr(nexthdr) || nexthdr == NEXTHDR_AUTH)
 			return -1;
-		}
 		if (nexthdr == NEXTHDR_NONE) {
 			pr_debug("next header is none\n");
 			return -1;
@@ -420,10 +420,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
 			return -1;
-		if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = ipv6_authlen(&hdr);
-		else
-			hdrlen = ipv6_optlen(&hdr);
+		hdrlen = ipv6_optlen(&hdr);
 
 		prevhdr = nexthdr;
 		prev_nhoff = start;
