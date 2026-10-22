Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792691353;
	b=p0d8OdDMBYslTZ1hZAFUqoBs6/tlU9sqxtLIuqoeEpZQfY8vS2gOmU/foc52PuWf9Qeh
	 /cUI7LHlTZkQS8bD11ZyrKjR/SR5VotwiasL7Ge21dTIlgaPfu1QnzOCUw2Q3orAl2Be5
	 hgzSmffaY5oJXeFtWesiUnxjDsbq1OiR8+ZPLSXvH/rtBTnwwjqgU7F5FeB96VOm5gya2
	 uz5dQwdpYa5z54kGxTMhHhuZl7X4DxUTcKIUHQgnfrWcfIbj4xdv9hnUCcboTDvZJb0U8
	 WT0wp/VN8x4CYtzoaa/F7r+8ZN4T/oDPffwZA2DDoxCJgs3/jiEveYJSjdebNYFZrgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691353;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=f0ZLBISeyce6U7/hTVm4ywHVaFNN2V0ZlhVxxqx6eaw=;
	b=CvkNwFcVPtHR82f3w86FoqFgyqrljpIEocUdeD8lSLnDQUT2odx1sW4oMWzl5uXBZ/5p
	 tPHHSgI4IqL6coBLwUqHlhlkt0vRMI6El7bAg+NFeHgLgp0DgvIslg9JxSFsyg1n/m5gh
	 geBWqOf2NN13ZuNOS1zMrcuH7mkAScSqL2MtX4HIJJG7sITx1hwwvHE1hTG/SFYvRcl0K
	 7kCG2PRWXG1agJvNm20f2vgomMC+iBbBx2cO6tPnwMWeQ6bC93PPLTgLQERfvA+Zuxdv0
	 9XZmEgSFGIlABUvYg8nof3ahVzfPxM0C+YgvXwAV1NR0uDWvSpuH5bR0Nbv0zgexA4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BzfT9vcQ;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3738E606A319
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3738E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BzfT9vcQ
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so51208a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 10:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792691353; x=1793296153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f0ZLBISeyce6U7/hTVm4ywHVaFNN2V0ZlhVxxqx6eaw=;
        b=BzfT9vcQo0dX9K6hykJfFHWOLKclttgOrxAGaeJvwHPh40AsSaB2+B6F9Pxqkm7hb8
         YF/EKuS3WzwcPYEUI8mQTzKQe57H7DY2pRVx9fKu2nFT96xhQgLhXITu7gs0lhAsElfh
         uATNeLWjFzfIEHZiN6z89LhNyNM39SBZCGe3mpU2mHEuJBeqdt5Q6CWVotqLk2Sdyw29
         o6+Vuz73ku9T1FK0v1w02r2HKp5n2hEk0T404r5gRbt4CykpuinAHNPT1HaWYCjfO8OT
         LTLvQHdDMTG30GSCGhC2peA8PWMd3dWf4DPJopyezHSD4rzWwsCcE4QjbbcwLTWAnQfe
         eHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691353; x=1793296153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0ZLBISeyce6U7/hTVm4ywHVaFNN2V0ZlhVxxqx6eaw=;
        b=wgIMnyr5IZjAfDX9WywhGvwG+oVyVLXkKeB0JO8k2wXsfssHXVJfTedS22/sAFjZ+3
         qpxGX8IOVprVc3PnDkTxYpziJ9wuSJtDlfRXyDsK9Kt1IGPA9W/jE1tf6eRn7XRZiPN/
         cElI5nCxONfNoiuEf9ZT+AUDfeMVpPj5LYB6Xgf4sjq0UWjb3B+3ZHuVhmDmdykl+Iq0
         UgEEyz1m4N1ByOmCNQGN9q0tRtDA3MAUPdsBCTXfPwq9Gad5CRHHB+nZ7rAV7KH5GGpQ
         DO035eZBWH7ijGR0o9NN7TiI+nCmgdPChuYFm8nYyE0lCUHj6NLyW1pa0A95QGx9SlIc
         VVww==
X-Gm-Message-State: AFq9FYIZB/YYf1lSKqubzlxQXL9hkevNp+STvDvUl4hv2T5sup74hSQ7
	MVHaeSw2Nwtop//nrbwzZHVp4Iw59GVmYJuFX3Rj96nz98xO5rhzbu2o
X-Gm-Gg: AYBFou2bCTPyvXNIXQTntdKanszqw0uCa+BXsWAP3zjNGkwMO9eIhqp6h0dBWfJl7b9
	UvQ6XEGwRLnxa03AR3ZUIO+yDykidCDhOM557qm49kLBOeK8ELM2C8m0Uy1hYJIUYkVTdlJtjSN
	wpq1mwk6ZfKwNf6fWqllRi5yEX/DqOG4onTYBzQvxxmR1oBdRiXSWS9rmAExl2Gh0hKazKyMTHl
	obESBIBOUFERB5MFhXYcdeq21dTT7IH3JyB3wZ1MkYPtct7O1lkKL37UIrcxsTRrQLNG60Bq9Gb
	btLQ4EA2U9WPpx+URlSJQxjpMjv2EyoJB8GjcoBTx8RzJ/Vtqf3W6FwdMfibRjwjkCCs3DHCRzQ
	a5yLWySWhXBoeHYMS1qhswQvM9CKFAa3zpycuiwmn4Varn0dRw80NUddhwmHnj+YuOVcLoHuR4y
	idf8cp1D2KjKC2NWNsz0jCI0vV+5ocb7s0z2FiXRs3QwfCE1CapCroostkE92gTTqtHqmoPse1N
	dBtJq4RUsDeo0eVV45RxhqNuU86JGFIO6jCgQVwsLNCTU29T68cj+ad2DiKZFEJeW6yh8lt3nBJ
	PJd8vTQFIjgKsEQIhdtEoGV4Y/JQEsBWeFe86OPWr/LZe3g9EqeICffqDb8ylWCIRe5RyHDNZ4L
	yiZkEHeIYZvM=
X-Received: by 2002:a17:903:2f8f:b0:2db:733c:fd1f with SMTP id d9443c01a7336-2ea7c169201mr1589395ad.8.1792691352522;
        Thu, 22 Oct 2026 10:49:12 -0700 (PDT)
Received: from test.. ([118.68.116.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7af67e12sm1722565ad.10.2026.10.22.10.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:49:12 -0700 (PDT)
From: Duc Anh Luu <luuducanh05051995@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	phil@nwl.cc,
	coreteam@netfilter.org,
	eric.sesterhenn@x41-dsec.de,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Duc Anh Luu <luuducanh05051995@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_h323: fix out-of-bounds read in get_bitmap()
Date: Fri, 23 Oct 2026 00:48:55 +0700
Message-ID: <20261022174855.615855-1-luuducanh05051995@gmail.com>
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

When get_bitmap() decodes a bitmap whose end falls on a byte boundary,
it reads one byte past the position that the caller's
nf_h323_error_boundary() check validated.

For a bitmap of b bits starting at bit offset bs->bit, let
l = bs->bit + b.  The caller guards the call with
nf_h323_error_boundary(bs, 0, b), which reserves ceil(l / 8) bytes.
In the (l < 32) path get_bitmap() first consumes l >> 3 whole bytes in
the loop and then unconditionally reads one more byte:

	if (l < 32) {
		v |= (unsigned int)(*bs->cur) << shift;
		...

When l is a multiple of 8 (l == 16 or l == 24), l >> 3 already equals
ceil(l / 8), so the loop has consumed every byte the boundary check
reserved and the extra read touches *bs->end -- one byte out of bounds.
The value read is shifted below the final mask (0xffffffff << (32 - b))
and discarded, so this is a pure over-read, but it still crosses the
boundary nf_h323_error_boundary() is meant to enforce.

The extra byte is only needed when the bitmap spills partial bits into
a further byte, i.e. when (l & 7) is non-zero; for a byte-aligned end
the loop has already read everything.  Guard the read accordingly.

Both get_bitmap() call sites in decode_seq() (the field bitmap and the
extension bitmap) are affected, and the decoder runs on
attacker-supplied H.323/H.245/RAS payloads when the nf_conntrack_h323
helper is active.

Reachability and behavioural equivalence were verified with a userspace
libFuzzer/ASan harness driving the unmodified decoder against
exactly-sized buffers; the fix removes the over-read while producing
byte-identical decode output across the whole corpus.

This was found by incomplete-fix analysis -- reviewing the recent
out-of-bounds read fixes in this decoder (decode_choice(), decode_int(),
DecodeQ931()) for sibling sites of the same class. The code review and
harness work were LLM-assisted.

Fixes: ec8a8f3c31dd ("netfilter: nf_ct_h323: Extend nf_h323_error_boundary to work on bits as well")
Signed-off-by: Duc Anh Luu <luuducanh05051995@gmail.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6830c9da3507..8c04925b7007 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -229,7 +229,8 @@ static unsigned int get_bitmap(struct bitstr *bs, unsigned int b)
 			v |= (unsigned int)(*bs->cur++) << shift;
 
 		if (l < 32) {
-			v |= (unsigned int)(*bs->cur) << shift;
+			if (l & 7)
+				v |= (unsigned int)(*bs->cur) << shift;
 			v <<= bs->bit;
 		} else if (l > 32) {
 			v <<= bs->bit;
-- 
2.43.0

