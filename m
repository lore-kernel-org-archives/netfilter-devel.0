Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794067531;
	b=q8IAnSKMeyY4iuYplfX1VRz2koVp1BLKz8kID5DE34FXXJWwQ7Ic20eHHBMfH67CAF0R
	 mdNlwlxRo3MQakgWRXCapTIbBS7FxQAnBkgUJNrHKYZ+YKNvmFb1mDn6+nNE4lJawlXTE
	 zasBDT6Mz40FBNmfwGR5vgWR5aUeNI3uPkLIEcBSgGEsvb/s362gUfVpndnNdmKPk6q/t
	 U8o0LGJpllBNU+Crsd7jLU4xCpT2ay2ZWbLkWISgWKMsPCjUmFHqjF8YBawHnDu8ZLmsl
	 3K0AXG4wBYuF2PWepgsZO6U9oTniH9dGNnd7r4K2kwuOQkFcvec3eESpe9N1RxlXHag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067531;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UIBeA9+89SLk9E6HL07jeiFdHykYYpcD39rqXpl+ZY8=;
	b=AqxX41vl5/3YRuu7dg3ekKB/tC6tSiJ62ywgmCLJ/CYY2l5AobAVTEyYrtxgs185F2Ht
	 2V4guA7YmGF7SAEpUpmCfYoJbcY4tBQgqhFVo1JQWunrCfZmYMRUivQ3c9rFWlHTyS9GR
	 XH5yD8IzNuU8bnO+pHTT4IeLoeo/nxUewUbrhP/USukVEskS6pnyqqMSLYreebLn12TKo
	 mqAOPc9sVBGjYnBrKPKzaLdOPqlaSPQA75strHnt7e/iSKJJ347dOVL9HK/+rfZ5f84M0
	 ws0l+qQSHehB9HmT3Zqb+LsD1MUA+dzg3H0BCbwSaXFdIg1OWbfZY0srfiGsvn7sACQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=000ty.net;
	spf=pass smtp.mailfrom=000ty.net;
	dkim=pass header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=Ois+nNzn;
	arc=none smtp.remote-ip=109.224.244.119
Received: from mail-244119.protonmail.ch (mail-244119.protonmail.ch [109.224.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1F606A32D
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2026 16:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FC1F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=Ois+nNzn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1794067528; x=1794326728;
	bh=UIBeA9+89SLk9E6HL07jeiFdHykYYpcD39rqXpl+ZY8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Ois+nNznv1jX8pRApCQNkYEoQtNdcBHZyW5dYXFfI/VdBQeDYiWcnTqVf3edjOQ4M
	 QGMK8FQVkPvFFtLiQeNTu0nI+USB3y/XBAk6ua4kaS4S/ucDbu+VJ0Bqel+ibBA+6S
	 wVxzwDJxI77k79wX0DPO5BRCnC4YBugoeUDLDlsXHLFamf/Qhv603GxWT3mFArhyDK
	 6ruWjXqKofmbkcnz5eoqa7H6fjIv9NDdkYzf6QGCPh6ZslZYfqIuMS23tAFx2VgUQ7
	 TK8MiVpjcWl6pHLBY9pB6EPBABpePFycOrqIoywONKQUWwXEM+ldP0n5bGNbNwkqmP
	 YdiWV2UT0zeQA==
Date: Sat, 07 Nov 2026 16:05:23 +0000
To: netfilter-devel@vger.kernel.org
From: Tamaki Yanagawa <ty@000ty.net>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: [PATCH nf] netfilter: nfnetlink_queue: unclone skb before writing NFQA_L2HDR
Message-ID: <20261107160517.726-1-ty@000ty.net>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 854d1b169310b54152d09383e0e9522acb59b98b
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

nfqa_parse_bridge() copies the NFQA_L2HDR attribute over the mac header
of the queued skb in place. Bridge flooding queues clones that share
their data with the copies sent to the other ports, so the rewritten
header also shows up on frames that never went through the queue, and
is changed while those may already be in transmission. Unclone the skb
before the copy, as nfqnl_mangle() does for NFQA_PAYLOAD via
skb_ensure_writable().

Fixes: 8d45ff22f1b4 ("netfilter: bridge: nf queue verdict to use NFQA_VLAN =
and NFQA_L2HDR")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
---
 net/netfilter/nfnetlink_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
index 90d887546f..146211fd03 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1819,10 +1819,15 @@ static int nfqa_parse_bridge(struct nf_queue_entry =
*entry,
=20
 =09=09if (mac_header_len !=3D nla_len(nfqa[NFQA_L2HDR]))
 =09=09=09return -EINVAL;
-=09=09else if (mac_header_len > 0)
+
+=09=09if (mac_header_len > 0) {
+=09=09=09if (skb_unclone(entry->skb, GFP_ATOMIC))
+=09=09=09=09return -ENOMEM;
+
 =09=09=09memcpy(skb_mac_header(entry->skb),
 =09=09=09       nla_data(nfqa[NFQA_L2HDR]),
 =09=09=09       mac_header_len);
+=09=09}
 =09}
=20
 =09return 0;

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
--=20
2.52.0


