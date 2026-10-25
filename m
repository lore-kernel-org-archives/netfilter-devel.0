Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792912525;
	b=fUV0jcpl6sMik8ZYNtSuoI9iZYTe2oB0n7uSR0VfagW0t6Igw/37nejfToZwZrf9gswg
	 qJKKT5pflbue7F37R+JygCT/piaQUwQ1z24PB+EEyVfBsWn3zef6IBFoW0byRq/OS70mT
	 AKvtlnQ7jbZO4RKbREO4YxpXC4sY91PddUcc0EdW1yG7TCNPnshNOOFaTyM4sl83UIt7N
	 Kj3JnSslr6lhfB7qUYoRrk6l/RykCM/27YbRdW72o5XbU+6Lvmt+6ug4UcO+Vlqf29OCc
	 JfInRvmjbRT1AOYED1jpENp9IjGqufmbdHYebFTGOKaQ9rk/cX/MREJJZ9p4eqlrbBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792912525;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=6pX7Veyv2vDcHysFmyPuQcvhlCA9c/1urkrH8Rw++mE=;
	b=w47vQEmQlFzahcZ49F+qNjeIp9fGQaYs1pFK9os3Ehox0NR0+aCuHzysRDNKdlLI0OPM
	 C6v94j1le7ZDXcZeFijHkJAUABpiZTyErdjWFXQAFlfbFV9/xLlS1NUTp0DbBOfsWc5IE
	 CaNjy1h1dY02sPexi/obpwi/FTUaMieVvEbxNMswE6kNgC+tLbpaQ5A0qgQD+PxrBTIRb
	 2YZ2GUqi6f/4pmQ4ytCUTYQkQ5G4jlSHGVwj37nTOtaN7lqNfDKQPTfl9/E5Sdfbo9j6H
	 6H1pIVb8YIsLP/atU2zqv4TYq/BBhNf9BZ3b5RhWMq9iwQvb5y9j/dFO8fxX/J/qLdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.133
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F9D606A31D;
	Sun, 25 Oct 2026 07:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04F9D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MYvse-1x7jKD1P4S-00IQDN; Sun, 25
 Oct 2026 08:15:13 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.15.y 0/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 08:15:07 +0100
Message-ID: <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2026-10-24-1-daily-reply-0009-nft-set-nelems-5-15-bounce@kernel.org>
References: <2026-10-24-1-daily-reply-0009-nft-set-nelems-5-15-bounce@kernel.org>
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
X-Provags-ID: V03:K1:JyYHC6TdpGzKAKKWifwmDqojkZOpHTmcg7bdwkIpfRKoEQp/5e2
 MbSSKZxkEaE8NQIo2wBRsg+U/imWlIywoaiuF8xVF80bDUyME48F9VX5S5oqXpoWxCTRBsG
 7KtU+nkzR/IW0xmOOvoSwjq5JmAk9O4xkfaKSfMiBVrq8idP21I6PGTq4wgzDkp6Hxn0wIt
 OR5sMYg8xji0/SWfaicwA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SFmD7IjpwLY=;Ks+HngO0N751xDLf88sM0ZA90d7
 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

This is the 5.15.y backport of def602e498a4 ("netfilter: nf_tables:
unconditionally bump set->nelems before insertion"), now with its
prerequisite d4b7f29eb85c ("netfilter: nf_tables: always increment set
element count") as patch 1, as in 6.1.y.

Changes in v2:
- Add d4b7f29eb85c as patch 1/2 (Sasha). Without it, set->nelems is only
  incremented for sets with a size but always decremented, so it can go
  negative, and the new unsigned nelems > max check can then return a
  spurious -ENFILE on dynset-bound sets.
- 2/2: with the counter now always incremented, drop v1's set->size
  guards on the increment and on the error-path atomic_dec(); the
  ceiling is set->size ? set->size + set->ndeact : UINT_MAX, the same
  expression 1/2 inlines (5.15 has no nft_set_maxsize()).
- Rebased onto the current queue-5.15, including the one-line conflict
  with "netfilter: nf_tables: set->ops->insert returns opaque set element
  in case of EEXIST".

Patch 1/2 is a clean cherry-pick. Build-tested (arm64, W=1) and
boot-tested under QEMU with KASAN on top of queue-5.15: the set size
limit is still enforced (-ENFILE), counts stay correct across
delete/re-add and flush, unlimited sets are unaffected, and mixed
dynset (packet path) plus control-plane adds/deletes on sized and
unsized dynamic sets give no spurious -ENFILE. No KASAN reports.

Florian Westphal (1):
  netfilter: nf_tables: always increment set element count

Pablo Neira Ayuso (1):
  netfilter: nf_tables: unconditionally bump set->nelems before
    insertion

 net/netfilter/nf_tables_api.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

-- 
2.39.5

