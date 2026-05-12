Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170C93C3449
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619086; cv=none; b=tr/OdQCSx61llho/GwgEBFQyBeXCFQltcTCv0nljLdPHQ2zgZarHC5SGsr3EiCICZ6LRIS5sewPmAiV5O8RLkkj9ay4s4d7B6pEjjf+gTIloUU/6Em6xtsaRkWQFtwzj9WBACqb5FDTNEINYk7sc/Ww/GA7acuwV0eVu29lvszU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619086; c=relaxed/simple;
	bh=SrGWi/6wHIXpn0Jzv1Nk8znKQrM+sdOspj2f3aHSYS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiElAuDJeTZk5txKWMby3dc2yvGMyFW7VvR7JdaN1HKpX5nXvYBPUOVOri/2BY3wE0fu23bx6GStl8nj200lOL29/KjAr8m1od8ax7ftnYxpKRx0Y/CUgxS2YvLDt67zLdG25bq3a1jTWnW/Ly+dDVLaO51VLZ6Co4yqhbiP4Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4WGyJBq; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4WGyJBq"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8f231f3b130so469112285a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 13:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778619081; x=1779223881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gga6YQiahEkWcYcvgOogf9AGzn6VBTkh6VyNbP8w6hs=;
        b=L4WGyJBqW98rGzfUq48UkQf+sLoqqFqTRI8lsOY9ffyHrujzBc46X+w82lmEugol6+
         6CiCMw5AaJAXJs5x7AJiCKQczN/xlvzsFlEZjKHUMQ3smEUIVzrnvgaWzTAdQHA9rv/i
         UkQ/neWqYsrRVUtMWtK4qIsix3oaH4DCdYEMlcD9g8Bqt7i8MN+iK26pwgWncfW0i5Cb
         RWWQQHdyYfU/da8eXynlyL1UFFjUqO5ezHQ83AN3RGnBlKXMC/r0IU9wWzE0fT5KzeN6
         Ny06CFroIcEVNJhWVDcqv+QyQ13sSY1EOAApL4mXVfFcS45wNTi7cYVVrlcaOJyzpPoc
         n3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619081; x=1779223881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gga6YQiahEkWcYcvgOogf9AGzn6VBTkh6VyNbP8w6hs=;
        b=qq9iNob3LMVtndsHTiLB/0CG4seNWrNly+nB13TlLplEOkiJ0qZZJGp2iw8KolvHo7
         zjC3alPeNeN7VXE5nHnwkHyvBsx9suLaKwKcfLgr4BuECctdNJrkyd20FAA98ZxBsnu1
         CSfLyeTIZf2PX6W9jvBbqzUfY5kWQGlrAPs17JYrQUFZqdvavUo70F/EUA6UMKKU+Ez5
         nxgXMc+CZSBEHom79WyNYJg+tqR0Vb3oLXk3SiZU2Eda6wggJHhYhcw2PKUinzYpiJCV
         a+ZQFIgIvWqxuJABrDOIge2dBknXZQLrOz8GrUXKEhv7a9b2fESMd8qJOYpiIbCDhnTu
         dpXA==
X-Forwarded-Encrypted: i=1; AFNElJ+xQbkrn9aHZR1deWsd+/wnAFj3um0aVkWenAVbL4Vy8Lxhn5IovO6sC/k4hKjYlp7jXRzV9LETo++OSMy4yQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe5YqfN2z5xPgA9GRg97qs1Rf0cvOwUhB63JmfMKkt8JuZdbBC
	ge5HldsZENJR2+/SHJKLSsCeazA6tPU2nuFKpbCvIHotC6bbNinOx/ns
X-Gm-Gg: Acq92OE/xk6e9bYdn+Mi54R3d/oj0S/a9nNhlbbum7SgrLg4gIi5mkdCeItSwc3WN6z
	B6hPzJrYWdgqWXE0i6TITuPRl+5leuGEjzTSP9k2lB2tVi/28S4aIoSPyrkhk2BYh5F/6MVTQ5a
	+EWikDdKzhyGihkVv4fcfxuBcRoMYDkjQrtp7XjyF/7i5FzjDBfNpFg95jpN9G4OkSuZkpFrxhp
	EpkgS4FPy2tVWlr3rCUJm49z3CuEYNSBphT7PR8RRm6BhTntUPm4HskOkOokPlGqHJ8P2bl0SKq
	Ln9VnDFufb15Utf63TXFPINqCFUwN804rjA9pON2pcWoELHsULz3WTJJMutNCq9tANUjhGsL8y3
	HgpZdeXBVwT/ObClz6Th6czaz4H0fUdpq3pCbrEXE8T0zl0pCNgiGxoa0mhsHFqxdHQ4cMkryL6
	WLdcewRg6FFsKvTrmPFA/8MKHgvNhBqpOF6Y+fcyoCZit70NQLDslvohlCpbm0HMg8UB1bajofF
	pqNP3kZdscEgTf+IqBiEU7TFasCeUKCfkfWeI2iZeuHOBWSHqXE3g==
X-Received: by 2002:a05:620a:d8e:b0:90b:263:f6b with SMTP id af79cd13be357-90fabcf968amr11126885a.21.1778619080781;
        Tue, 12 May 2026 13:51:20 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b8d9eed0sm1490734285a.19.2026.05.12.13.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:51:20 -0700 (PDT)
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
Subject: [PATCH net 1/2] ipv4: raw: reject IP_HDRINCL packets with ihl < 5
Date: Tue, 12 May 2026 16:51:14 -0400
Message-ID: <77ec2b5e8111961c2c39883c92e8aa2709039c17.1778614451.git.michael.bommarito@gmail.com>
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

raw_send_hdrinc() validates that the caller-supplied IPv4 header
fits within the message length:

    iphlen = iph->ihl * 4;
    err = -EINVAL;
    if (iphlen > length)
        goto error_free;

    if (iphlen >= sizeof(*iph)) {
        /* fix up saddr, tot_len, id, csum, transport_header */
    }

It does not, however, reject ihl < 5.  For such a packet the
"if (iphlen >= sizeof(*iph))" branch is skipped, leaving the
crafted iphdr untouched, but the packet is still handed to
__ip_local_out() and onward.  Downstream consumers that read
iph->ihl assume a sane value: net/ipv4/ah4.c:ah_output() in
particular subtracts sizeof(struct iphdr) from top_iph->ihl * 4
and passes the (signed-int-negative, then cast to size_t)
result to memcpy(), producing an OOB access of length close to
SIZE_MAX and a host kernel panic.

An IPv4 header with ihl < 5 is malformed by definition (RFC 791:
"Internet Header Length is the length of the internet header in
32 bit words ... Note that the minimum value for a correct header
is 5.").  The kernel should not be willing to inject such a
packet into its own output path.

Reject "iphlen < sizeof(*iph)" alongside the existing
"iphlen > length" check.  This matches the principle that locally
constructed packets that re-enter the IP stack must pass the same
basic sanity tests that a foreign packet would be subjected to.

Once this lands, the "if (iphlen >= sizeof(*iph))" wrapper around
the fixup branch becomes redundant; left in place to keep the
patch minimal and backport-friendly.  A follow-up can unwrap it.

Note that commit 86f4c90a1c5c ("ipv4, ipv6: ensure raw socket
message is big enough to hold an IP header") ensures the message
buffer is large enough to hold an iphdr, but does not constrain
the self-reported iph->ihl.

Reachability: the malformed packet source is any caller with
CAP_NET_RAW, including an unprivileged process in a user+net
namespace on a kernel with CONFIG_USER_NS=y.  The reproduced AH
crash also requires a matching xfrm AH policy on the outgoing
route; a container granted CAP_NET_ADMIN can install that state
and policy in its netns.  Loopback bypasses xfrm_output, so the
trigger uses a real netdev.

Reproduced on UML + KASAN: kernel-mode fault at addr 0x0 with
memcpy_orig at the crash site.  Same shape reproduces inside a
rootless Docker container with --cap-add NET_ADMIN on a stock
distro kernel.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 5aaf9c62c8e1..68e88cb3e55c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -391,7 +391,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 	 * in, reject the frame as invalid
 	 */
 	err = -EINVAL;
-	if (iphlen > length)
+	if (iphlen > length || iphlen < sizeof(*iph))
 		goto error_free;
 
 	if (iphlen >= sizeof(*iph)) {
-- 
2.53.0

