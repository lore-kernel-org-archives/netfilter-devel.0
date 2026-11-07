Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069254;
	b=JQau3hXuTyzfVD4j9zYvuUToJef8DvBefYj3Ushv4fFgDNQQ7j9jF//rgwJeiO+VJXed
	 UNW3ZHRRj04fvgiaKkVbxgjE5LlfhIFYvl2jhP7be4yuUJdDfb+QywuMstJo53LRkVI8x
	 Xw2hZjDUSkxUtGIN2Xt03X1LokGCWhK6cAMQs6XUiej+m/F5piKtSmKrxE3Gw3eTDV4jC
	 47Fm6wB/LYrg5NbsIiUPQf9iWjMBp1MtaP2gRrB1CRKF9N4YBHNSScRx1M+mGUN5aa3Mg
	 2iIjordtvG/QmkxXfKrw6t1lIABStZ6oAsAkkOClzuZAYM+6toJ9YgKguL3nBu4UCyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069254;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mcGUxoLI+ikhf+8cHnw1noGtyfu3ho7IeBqehooAtOc=;
	b=iClCtHtpp9PcOeQMauq0eBrgzsVW89TXzl2HxWE1+quuoHKpZZBKbloiXC/VqIeitxuX
	 sXa62yGwjXjOK1KNoKFSnlw+QPF41osNecp/I5Zllb7szOIL3dCezcowzmbZG5AUGdS3W
	 Qv+U5r8TJ25q+Uia3cpc5TupiUgqH4jA8sYYk9l1anNAEXOQhG0XEMr9BE0g49H+aHSCi
	 pgnAM5/CswoSeIiZ8T98gL+C4vW6bV3FSdAa8TUUK8sMw1g3DZ7lRAOJMZ1kP4TZjUwGD
	 ixIk0rdLtAr1ceYBsfzL3/Euziy5BaQCEkurIJRf6DKf0VF0AR2dD/Ibdu84YvNBYEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=000ty.net;
	spf=pass smtp.mailfrom=000ty.net;
	dkim=pass header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=l5pgC2Hm;
	arc=none smtp.remote-ip=109.224.244.21
Received: from mail-24421.protonmail.ch (mail-24421.protonmail.ch [109.224.244.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19982606A32D;
	Sat,  7 Nov 2026 16:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19982606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=l5pgC2Hm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1794069252; x=1794328452;
	bh=mcGUxoLI+ikhf+8cHnw1noGtyfu3ho7IeBqehooAtOc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=l5pgC2HmKH0t2HzWZNxMe4Vqz7CgHOLwiimjoOb+MRxuqiVoykc6WeDgY9SIOk8I1
	 G4GJep++SPESb4SqXObRKY3c9T53mhYqI9YuQ1AN2qBYXYJrNrAdHZxckin+9YfrY9
	 hFVqsL8jmzvdevtHvEJSqNNYX57H3Gu9rMBYWCnO5fejkJFl4YYZJb5JbtY8/eX2/8
	 NSdAb/00a6if5kJa3YGsll0tlD89RqmKZmbhZhPusVAVz/CBV8et/d9LzFGoHGgxLb
	 MP6DF/iUVX4Mw9VTFJTNTAjKHEVsxnAWW8YjBXzfxuOsRRC/IJSSoffH7q1J4Zx9PJ
	 16pbfbtCoP2rg==
Date: Sat, 07 Nov 2026 16:34:08 +0000
To: netfilter-devel@vger.kernel.org
From: Tamaki Yanagawa <ty@000ty.net>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: [PATCH nf v2] netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR
Message-ID: <20261107163402.1458-1-ty@000ty.net>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 3fb11530f64dcb731da31945594b885781d1cc3c
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
is changed while those may already be in transmission. Call
skb_ensure_writable() before the copy. At the bridge hooks skb->data
points to the network header, so the mac header sits in the headroom,
which skb_clone_writable() already takes into account: a write length
of zero is enough, and a clone that owns its header area (nohdr) is
left alone instead of being copied.

Fixes: 8d45ff22f1b4 ("netfilter: bridge: nf queue verdict to use NFQA_VLAN =
and NFQA_L2HDR")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
---

Notes:
    v2: use skb_ensure_writable() instead of skb_unclone(), as suggested by=
 Florian Westphal
   =20
    v1: https://lore.kernel.org/netfilter-devel/20261107160517.726-1-ty@000=
ty.net/

 net/netfilter/nfnetlink_queue.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
index 90d887546f..7d0980286f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1819,10 +1819,18 @@ static int nfqa_parse_bridge(struct nf_queue_entry =
*entry,
=20
 =09=09if (mac_header_len !=3D nla_len(nfqa[NFQA_L2HDR]))
 =09=09=09return -EINVAL;
-=09=09else if (mac_header_len > 0)
+
+=09=09if (mac_header_len > 0) {
+=09=09=09/* the mac header is in the headroom, which
+=09=09=09 * skb_clone_writable() accounts for
+=09=09=09 */
+=09=09=09if (skb_ensure_writable(entry->skb, 0))
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


