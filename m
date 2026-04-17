Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A3351C14
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776442916; cv=none; b=D2DOQX+CB6RzPqE7lPByF8ROEpulSzm3WRJMbtwgtsW0iVqWyXljZ0KKV3052c3oQRWWVYu5fJtenm7q2PPlfGeP5InfsVmc0gwUnN3tGkmDiYUkkFgK6GIEq2LJR2HjlsJr5qAp6C3GmKhGNI5/ifvSLJnt8l19aO4X0QNPqmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776442916; c=relaxed/simple;
	bh=hS+9/c0wkyuDAsKloIIceu/S6QTx+mwr25Zziy7MZOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWyiqwfWwus4gbbTD/Pn9R8wBGr4/GIq+tgRUrzq2drD7Dk2D86BlBnw4nXR7MNTkVOM8v046+qF0cvgu1Sy257f/gmMNm26BwjrumzVmwpv+mVuebgVkZNgrIfo99BvciyuWvEyiar6D7gvacKj8yv16zOsU/of0ilVq13xOiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TDUO9Koh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LZeRX3OI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZN23vV+i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aZb2fu9A; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TDUO9Koh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LZeRX3OI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZN23vV+i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aZb2fu9A"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D3B85BD6A;
	Fri, 17 Apr 2026 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776442909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRgpWyM7ORPv84VXfXpsGgufMh6mX8Pkm5cLRpDYg5A=;
	b=TDUO9KohXAuFprlLyGR518y4nVbUcscrr4HMCcMzDauSYYEcyy69yHxkj3cnSJikgjVDz6
	Xh7PhfPbGfDPIz4F297cbv19HZZasyyyXZ4+Bl1aneF5oEdUAAGoMHoga5HSoj0ovOXzwN
	TTUFOCNuoc9VhuP69bealO/hGsBLxfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776442909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRgpWyM7ORPv84VXfXpsGgufMh6mX8Pkm5cLRpDYg5A=;
	b=LZeRX3OIlAWHCWy61BrWt3otkh/R3y9tUH7zmtMc3LwfIxRPJWmYZKN4iW4txRjRqs2nCY
	d+l9wJ2zU6cO7lBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776442905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRgpWyM7ORPv84VXfXpsGgufMh6mX8Pkm5cLRpDYg5A=;
	b=ZN23vV+iwzefUsQNBhtwWyRBEr94g6muDEdOofwYqUZaXJAHo+3XwCfUo23l2AcgPBb0cH
	U1g827cPCUQJWunjfwaYVX80eL9U7Z8h17wU0rYR/q8Ilx0y8fVeOCrRnKOHTqsgWCIl4u
	ow0dix8uzVoxnIFoi2wAxZcR5YiGC/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776442905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRgpWyM7ORPv84VXfXpsGgufMh6mX8Pkm5cLRpDYg5A=;
	b=aZb2fu9A2MaDqWMhx4AhcQK9Eu/nZp7eUKODHI0kqC+cJEAeg4vZav2ZG5dGGZLQiBoPIv
	OR0iVfWI1+s2LZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA224593AE;
	Fri, 17 Apr 2026 16:21:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cGLFJhhe4mlAFQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 17 Apr 2026 16:21:44 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	"Kito Xu (veritas501)" <hxzene@gmail.com>
Subject: [PATCH 2/2 nf] netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check
Date: Fri, 17 Apr 2026 18:20:57 +0200
Message-ID: <20260417162057.3732-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260417162057.3732-1-fmancera@suse.de>
References: <20260417162057.3732-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,nwl.cc,suse.de,gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

The nf_osf_ttl() function accessed skb->dev to perform a local interface
address lookup without verifying that the device pointer was valid.

Additionally, the implementation utilized an in_dev_for_each_ifa_rcu
loop to match the packet source address against local interface
addresses. It assumed that packets from the same subnet should not see a
decrement on the initial TTL. A packet might appear it is from the same
subnet but it actually isn't especially in modern environments with
containers and virtual switching.

Remove the device dereference and interface loop. Replace the logic with
a switch statement that evaluates the TTL according to the ttl_check.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Kito Xu (veritas501) <hxzene@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260414074556.2512750-1-hxzene@gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: if some help is needed during the backport I can assist.
---
 net/netfilter/nfnetlink_osf.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index f58267986453..f0d1e596e146 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -31,26 +31,18 @@ EXPORT_SYMBOL_GPL(nf_osf_fingers);
 static inline int nf_osf_ttl(const struct sk_buff *skb,
 			     int ttl_check, unsigned char f_ttl)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
 	const struct iphdr *ip = ip_hdr(skb);
-	const struct in_ifaddr *ifa;
-	int ret = 0;
 
-	if (ttl_check == NF_OSF_TTL_TRUE)
+	switch (ttl_check) {
+	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-	if (ttl_check == NF_OSF_TTL_NOCHECK)
-		return 1;
-	else if (ip->ttl <= f_ttl)
+		break;
+	case NF_OSF_TTL_NOCHECK:
 		return 1;
-
-	in_dev_for_each_ifa_rcu(ifa, in_dev) {
-		if (inet_ifa_match(ip->saddr, ifa)) {
-			ret = (ip->ttl == f_ttl);
-			break;
-		}
+	case NF_OSF_TTL_LESS:
+	default:
+		return ip->ttl <= f_ttl;
 	}
-
-	return ret;
 }
 
 struct nf_osf_hdr_ctx {
-- 
2.53.0

