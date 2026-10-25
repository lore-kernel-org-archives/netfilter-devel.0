Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792912528;
	b=wlgEvEFI+x21K+Mi7JDexC/Sui1lqjWmOc6jHKUyA1h9/ZczMhWTWHVuK68lSnVKGL9g
	 ybBC9bvvUlCtLuvLjRc9Htc/cp3uv7578mAG3J6GgePixioTViL5RbQiObA023G8jrfPZ
	 JuqnOsuEimwHxyQesRg5kKWce044wGSFOvtkIujhERoyLqyyK0exjU2D+pyosO0uu1arZ
	 9IMIRe6gK688Y0tKSIkKki0Bf0Spd9EeWN+D46z4n8dukZXbNYFb7CJni9x+PYdiPOaQS
	 fQdN8oC7edAyNqCbDKvcicEKQwtqq6JliEgg8yRK4Pgd1sr5ecZhAWIJcq/F51v6OGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792912528;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=vjnRf1k68HEK7RIPzwhfCZsl/QKziJcy6FsddkOqJQQ=;
	b=Z3Tk7P44/LV8Tg0Dd32v/QwuU7ajQUlgXP0g2XVNWKf5WZZ5vboz5p6ZvfDqWFvIpc//
	 6blRd2U/EVyVrwqCsRmTXOKlDrWnjIDttuvRQyIq1omy1NzpSMXoUx21mBm5rn8/UxNle
	 yBn3GvhBSnVFsJkPSrUw+kTs71kjTSikW103dx1AvHkGwi7lkTCtywwh6S+GFwZbIF4mv
	 uPRHQV5dCwLhV3oJhHZ+Er9WolwxZ+coveFDzxkpO+LBsQc/ZdSQgElNCDjuNM2gVVE2S
	 HJKkA+22cCCkQYPRFLTLQSPuEuhn5dl1Sl/5ORq7HDvjx7JMGBHdcuMot4bWiV+OPUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.133
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581CD606A31B;
	Sun, 25 Oct 2026 07:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 581CD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MtwIW-1wQhOY2pfY-017uvZ; Sun, 25
 Oct 2026 08:15:14 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.15.y 1/2] netfilter: nf_tables: always increment set element count
Date: Sun, 25 Oct 2026 08:15:08 +0100
Message-ID: <20261025071509.47122-2-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
References: <2026-10-24-1-daily-reply-0009-nft-set-nelems-5-15-bounce@kernel.org>
 <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:Z1DmKDb6aPQ24sS1xM9ngSZnDzDvWlibFEPgT/5CvH3zySB6j5H
 5JNHZqJaq7HZDKJA8QKdKhjMGQfbBdrZK6HAEXjOKKP3WvupDEVAsZrjSFabEkxLzbCD/HH
 fPY9V3jdXDa7SZwhn3QymAy2bQwRR1qMxgu787YMR3WFj+rSpGX1Y+5TaytOwBs16n95n/E
 Wp2Q1EsnThCXDlIWQ2A/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gXBDh16KBVU=;Y86nOyeq2ExFK/oDp5AvWwFJlT/
 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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4b7f29eb85c93893bc27388b37709efbc3c9a0e ]

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4c3615a2bf6..7a6bc137cdda 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6585,10 +6585,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.39.5

