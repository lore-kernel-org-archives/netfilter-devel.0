Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922860;
	b=xQkuhOwm0BhazFtbFDdYMulRk+39n+zmc72lFbGlHwi9PI8pAL6avU7NoUA/Zsx3WM2i
	 NrzzqBgY5IqmyzcJ0QHrUfQFz+taHRSaR7oMV0DezupIULBzczlcKTkGWFcHeLn1EdGIP
	 Ol5I2JuxRv2fGhyOgAG9E6Zzsi/uD+qiN6bcZ0DcZqDCnrY42vKE40vSW8yf8no/H5UiH
	 onRXZ4LFtYHA9EpdFjopZ6FpRdiFb6qcM4QoQrVHhKRZOaLj5w+GTHcUAu0vVIBgt4UnV
	 3OaDfPblfs9Ta0pgJXDUnc6nGy8rKKBpy6ovMSwY85jsysqP7b+ciUKEurympd96xsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TwB4RSE1ahOv1eWO7HrIP9Xo526ulRCGPxUhrPC4tB0=;
	b=UmyURCrjKV6K41wYvpXi2ixjLV9LrH1WupRel0+r7aYm/xLVha/KSP4epzQFDrQC2ETZ
	 EnTd7m7Y1X35xd2ThteiuumlwMwVT6Td/z9N9S76ZnF9RzG9eWw4eDN5DSWe1r2qs5Ixp
	 dVKJySj66+gGAVTfWp0v0IznJ+XyiEDDo0jXRA645iWgqzjkpafemVb4k4sAHi8BdIgL+
	 68if/HkxWwfEkweIjxhesxYQeNfzP1lteju+ik2d7WUO16kRkSOqdp0LeJE3SeIFED9vn
	 Dh1zYzcpcA40CocyMkq1jo/5wu4PrxSmmYoIh/5AaseAWJhpVsMSMVof40RmuTFk3Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=mbrGrYZU;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E29606A32C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E29606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=mbrGrYZU
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91f0274f88cso74467766d6.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 05:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1794922858; x=1795527658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TwB4RSE1ahOv1eWO7HrIP9Xo526ulRCGPxUhrPC4tB0=;
        b=mbrGrYZU/2TOeFzN23IFhtlXtGQ53gHxnOmST27w/O81rXdXcuR1XDou6E1j48MhA6
         wwq4r2OalvYh9HWBrwgCxsJq6diJWHagel8aNFSlqQNTCIJbHhie31WwSYbXJgaS49Fh
         FCqoYH74WEGJ3ZcXJ1zVY7dOj6La1jKN4T+Go=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922858; x=1795527658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TwB4RSE1ahOv1eWO7HrIP9Xo526ulRCGPxUhrPC4tB0=;
        b=iViptiMykjnTuIdI/70Bsw0CqVuCslR19yJKz9YJw4j5wGnY+LSo0zAnTOw3bUlg2Y
         hHAR02QTqRE3wV3ddHIdEUn5d/uXyoiLrvrWrSwTeM5BXsxwPxkbPCk50KqUPNgOblQa
         0g7Mme4SE3H1mZaMr73x1duNUIUG80svSWyF+5bUwPinKnDbneLbAgHmwBtkbfTnJ45n
         +TV0ECKlH3ErFPDqqNf7XLewwc8U5a/mx3ff+1KWEaeY7CIDd6NhmMImDCbikDiWxSLq
         ZVrHI64tSN1DEIgj1l8gVoFEAIFxxkYWYdyNxH4it2j1M4b9pKIchNwTBUKyd+QnMgyC
         cLJw==
X-Forwarded-Encrypted: i=1; AL+hErHickeBM7uilBO4NZR8dGsKQIP6ZT8Es7Y5acuzLCB4fIVmHhD/I42Dw3oeu8VXGiYMIEsYGkcTWyjATZCAS78=@vger.kernel.org
X-Gm-Message-State: APuU4Z8JUqVoa3fxJDxJr6HM8zKEs4sP+8IcvVV/7QLCT+UUDAgUkAvC
	aDl7RWnBsMpO7CGu79t8VKvmW/SDrwCd9eUk4RTCu1s2+1hneRECa2BCyIJ7VJq0L4I=
X-Gm-Gg: AYBFou2zvb/YHF66k/O5nG1YksOTHNV8lM3YqEaZgzkUXSTSAqQE3Eq1oc+snqEJOQW
	4HNsJFBzCPqBXVCplVMFPXCaPvWKAUooaQIZgyeMJWRXwNIm0XttluC7c/Ll0DpPpkykTBF9Qps
	/Z+y1M4EZBp6bx73pqlvuPDe6BZbOTAf89bvghVBywzfHIag6AGk+Uy3ZKgE+p0N5+l1TSNlLNm
	QHt688YUFt6VD6Jri9pNPDREZJQ8deOkZq0Os6fOJpJBb15xNhkOlOUsGxLRQdphTHX0fVk9XgL
	+SC9S9lesZJSDDZr/J8HjF+MgPJZ1x+u3hQqjkx8/DAZkazVUKvApptbcQ64go6MvOH2y800pcS
	f06EP903b9dcVSk1RQ2TR8vxHKOMle/lV9KBxx1aYT6yv87FODQJsj1TMkpCVztliBwJPoDjOyp
	p4X6IcHErMM+QouL5TrsP//jzGPyHs/UeY1f9laO2VF7C8V7Tv4PVOCw3U3IyKZwk1TzIATgG9F
	tG+cHxTm8kkxhAJVm6PhhmitQMU+WZkFqsvjRjufrevi9HCSvBSP1RBoMfF4+x6uPmdj3mpiQa7
	rwgyptQs54AaesRO0m8tMVgYIBpKS7F5nbseU8pyVxlfvXX1JgKWtksLZacR
X-Received: by 2002:a05:6214:62d4:10b0:91e:850b:770b with SMTP id 6a1803df08f44-91f24151026mr170565066d6.17.1794922858319;
        Tue, 17 Nov 2026 05:40:58 -0800 (PST)
Received: from localhost ([2600:4041:59c3:300:b8f8:e592:18c8:ba23])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a81sm110979646d6.42.2026.11.17.05.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:40:57 -0800 (PST)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: ja@ssi.bg,
	horms@verge.net.au,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	dsahern@kernel.org,
	kuba@kernel.org,
	edumazet@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	w@1wt.eu,
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH nf v2 0/2] ipvs: fix OOB write when NATing ICMPv6 errors quoting non-first fragments
Date: Tue, 17 Nov 2026 08:40:47 -0500
Message-ID: <20261117134049.52386-1-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
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

This series fixes a 16-byte OOB write past the verified skb area,
reachable through ICMPv6 errors that quote non-first fragments.
Following Julian's suggestion, it preserves ESP ICMPv6 handling.

Patch 1 includes the embedded IP header in ciph.len at both ICMPv6
call sites when parsing stops at a non-first fragment. It stands on
its own for stable.

Patch 2 makes ipv6_find_hdr() set *offset to the fragment payload
for non-first fragments when target < 0, rejecting a truncated
Fragment header, so every successful return updates *offset. It
drops the workaround from patch 1, which becomes dead code.

Changes since v1:
- Patch 1: rewrote the comment and commit message. Nothing blocks an
  embedded ESP fragment on ciph.len; it continues because of
  pp->dont_defrag and its lookup reads only the addresses. Name the
  skb_ensure_writable() callers, handle_response_icmp() and
  ip_vs_icmp_xmit_v6(), that size the writable area from ciph.len.
  Code unchanged.
- Patch 2: return -EBADMSG when the Fragment header is truncated, so
  *offset never exceeds skb->len (Sashiko, Julian). Add Fixes tag
  (Julian). Drop the ciph.len workaround from patch 1 now that every
  successful return writes *offset (Sashiko). Describe the
  handle_response() effect, the nf_tables trace output change and the
  SYNPROXY callers in the commit message.

v1: https://lore.kernel.org/netfilter-devel/20260925141155.17603-1-axel.mierczuk@1password.com/

Axel Mierczuk (2):
  ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
  ipv6: update *offset for non-first fragments in ipv6_find_hdr()

 net/ipv6/exthdrs_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.50.1 (Apple Git-155)

