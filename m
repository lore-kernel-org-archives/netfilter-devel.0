Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EC53C661C
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619088; cv=none; b=gE9kBI4juo2x2CXf/n28pcz2ootrlSDaztkjVYuTtnxlBdWc9ckedPaMI9ZGzzLAbjfrViXHVLhhZLSJvh3VI46JNMer//wgwSrTEXvqFe9lxZHTMv0Jg1xozHJEWCjMtfQ7Ee/VukUo2tE1QNkubpbHLoXcEzKUQPbSUStdlH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619088; c=relaxed/simple;
	bh=J5gmNSPNQxxcqs8XDR9P+NOgy6ibnVJAuMTAtqZpUZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDY/Zx2y6HuNw4tJuYcBdYhizufS57vocP5xKhaBcoViM6i37SUrVuhCulLmRFayqPfr4jOOIdBEVnFbKD3Qa8HkMyW0sT3A27qz2DQGYkpLWYoZ0g0sXcstjjVMC3910Rx6hd0AVNPzqvlhUfhxxcZFbM83LmkFsXDK2rIGMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKDuELNx; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKDuELNx"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-90d2acb9936so119630685a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 13:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778619082; x=1779223882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpARctubxx8lA4XtZtvDCBF0ktNsLEKbeHjau0kupPc=;
        b=YKDuELNxPRrDXZRddMTCvxBXg7tuOMXxHNohdJP86e9wVCAjhJQf0FWbA8tMPE3TEk
         lRKj2tBaUEN1lrjuK/HrsJpEHPlT1YZqUJWK0puHJjVn+g5/GnI/oa3YI6/Al2df2f1E
         r0bJ17t477l3849Whf3YPA8IrqxYJspTaGMQb7MQdIKZzrpoKOArn25n5m3k8PYXX2cH
         TzKA58WKiCi9QSfjOBAjypwkiKq8tZK/+NXaggA94FUI+2Q1XYAfRksslU0WhItrrQqr
         +hYrX93WSpcUo1MOOaLU1iyk43fL2Nn8GZSBJEyWbFPNoqiveHZJH/KlL6lWwkllAUgq
         rFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619082; x=1779223882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RpARctubxx8lA4XtZtvDCBF0ktNsLEKbeHjau0kupPc=;
        b=Ay9HNBG24Ns+jrmN7eorBdBZesr4/LOqubuXwyI+ipVS+tiwEclCGIS4p0BzXl4piP
         7RUnbz5dpALlYiitgVNEs1a/yGsZLpQiyTdggM8AwnxEPiydNhR0vE3mQqQqU4TQ++Yn
         wug10w4GoPzCDlLnVg8bEmShlwROlexgKb6Z8o3v6rYyjWwTcnZeHUyMHR981yOkqrul
         MMIbN6+a6cMGG83nlF5wN9x6fsNEXcrRnadMx1AUInljatSwuKM/e0Lpya/9+w/BYvFK
         C6SZC8w50205fbvIqDzGJYIFZ3waYEEUO6OHMdpZ293UTzngeZ4pLUYCMx31REdDvPrR
         Mdbw==
X-Forwarded-Encrypted: i=1; AFNElJ+xfKJoNWrtKHXu5Es6PP+QofQaR4T+5h0PTlUpVV6PjeF8G0iXi48/Bk0JFCOrxxIfwFxY+geyRC+LZa+WRfc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYAsfd7/ugEH/H5UudwQUWKZnVBx/CIjkox7dzvHdWdibOyhha
	+R+AakdURbnOX9ZieNZw+B135QDcKMvAyrx3GDgFTOmPa/pmFrcvoCRL
X-Gm-Gg: Acq92OHUdU2T31BpFuu7urlFu7bTipqxFfFWYPMf7VLvGjFLkxKDGgKRFG+OtTVy71f
	vsdSPmA42Slulfe4cphB696/anuCa634+oDbJJTfI9+xgDbe9DssM2mRfkBNnW614qv3tVPyuM+
	zNN7f2x0Y/9hDXGCP4sYWvAdAQHa+7q8f3o73BYi0eTq3CZO+g4Ua0C51XcIomBPdPIzE24tioL
	JmMSRgcgDfDPZs8XFodMIK3CqU6IKxT5DJ0+xyWJaZwPftw6R7D6P8u5x1YYhTuhPapwQC71uIM
	XeiSRXhGoBU95++EQKiZX6Y3nD2FgGCtZ0QLFHtkA1bSREkSWLuKeqgEL8SWJb+FNJsgB8uZwqP
	qlMEBUEpRunlqwanAJQRidz592FcoNRfGz57EfkUxmFFFLesXIuG1pXU8o5oZHmt1khtWBRb9Du
	VF7/UchO52OCQWScwAkvI2M9eltS/3AKra50ymbjfQncU3xCB2pg0pYkETmQbnKoD5JydXpVoFK
	bqGWkC331eve8Tz/RtjyflyQn4NXsenP2w2oLK0qZM=
X-Received: by 2002:a05:620a:7003:b0:8eb:10d4:a46c with SMTP id af79cd13be357-90facf9e383mr9443985a.35.1778619082195;
        Tue, 12 May 2026 13:51:22 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b8d9eed0sm1490734285a.19.2026.05.12.13.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:51:21 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Maciej Zenczykowski <maze@google.com>,
	Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net 2/2] ipv4: ah: harden ah_output options-copy guard against ihl < 5
Date: Tue, 12 May 2026 16:51:15 -0400
Message-ID: <423b9ce3b45782c09a2fd9c65ad6674a9abb7c72.1778614451.git.michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778614451.git.michael.bommarito@gmail.com>
References: <cover.1778614451.git.michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ah_output() and ah_output_done() copy the IPv4 options area with

    if (top_iph->ihl != 5) {
        memcpy(dst, src, top_iph->ihl * 4 - sizeof(struct iphdr));
    }

The "!= 5" guard correctly excludes the no-options case (ihl == 5)
and allows ihl > 5 where options are present.  It does NOT exclude
ihl < 5.  For ihl in [0, 4], top_iph->ihl * 4 is less than
sizeof(struct iphdr) (20); the subtraction is computed as int,
becomes negative, and is then implicitly converted to size_t at
the memcpy() call.  The resulting length is close to SIZE_MAX and
memcpy walks off the slab allocation backing the skb's network
header.

With the preceding patch ("ipv4: raw: reject IP_HDRINCL packets
with ihl < 5") in place, an ihl < 5 packet from a raw IP_HDRINCL
socket is rejected before it reaches the local-output path.
However, post-LOCAL_OUT hook mangling (nftables payload-set,
NFQUEUE reinject) can still rewrite the IPv4 header after the
raw_send_hdrinc validation has run and deliver an ihl < 5 packet
to ah_output().  Reachability of this path requires CAP_NET_ADMIN
in the relevant netns; it is a smaller class than the original
CAP_NET_RAW path but it is not zero.

Independently of the post-LOCAL_OUT mangling question, the AH
consumer should not contain a memcpy whose size is derived from
an attacker-influenced field without a floor.  Change the guard
to "top_iph->ihl > 5" at all three sites:

  - ah_output_done() (the .complete callback path)
  - ah_output()      (the synchronous options-copy site)
  - ah_output()      (the post-hash restore site)

Behavior for valid packets (ihl in {5, 6, ..., 15}) is unchanged.
For malformed packets with ihl < 5, the options copy is cleanly
skipped; the malformed field no longer becomes a huge memcpy
length.  This is the defense-in-depth half of the series; the
upstream sanity check in the preceding patch is the primary fix.

A mirror-pattern audit found no analogous bug in ah_input(),
ip_clear_mutable_options(), or net/ipv6/ah6.c (IPv6 has a
fixed-length header and no IP_HDRINCL equivalent for crafting an
ihl < 5 ipv6hdr).

Reproduced on UML + KASAN: kernel-mode fault at addr 0x0 with
memcpy_orig at the crash site on a pre-fix kernel.  The AH guard
was verified by forcing the same packets through xfrm: the xfrm
state counter incremented and no KASAN splat or panic occurred.
With the preceding patch in this series, the original raw
IP_HDRINCL path is rejected before AH.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 net/ipv4/ah4.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 4366cbac3f06..8fa31bdf9792 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -137,7 +137,7 @@ static void ah_output_done(void *data, int err)
 	top_iph->tos = iph->tos;
 	top_iph->ttl = iph->ttl;
 	top_iph->frag_off = iph->frag_off;
-	if (top_iph->ihl != 5) {
+	if (top_iph->ihl > 5) {
 		top_iph->daddr = iph->daddr;
 		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 	}
@@ -197,7 +197,7 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	iph->ttl = top_iph->ttl;
 	iph->frag_off = top_iph->frag_off;
 
-	if (top_iph->ihl != 5) {
+	if (top_iph->ihl > 5) {
 		iph->daddr = top_iph->daddr;
 		memcpy(iph+1, top_iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 		err = ip_clear_mutable_options(top_iph, &top_iph->daddr);
@@ -253,7 +253,7 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	top_iph->tos = iph->tos;
 	top_iph->ttl = iph->ttl;
 	top_iph->frag_off = iph->frag_off;
-	if (top_iph->ihl != 5) {
+	if (top_iph->ihl > 5) {
 		top_iph->daddr = iph->daddr;
 		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 	}
-- 
2.53.0

