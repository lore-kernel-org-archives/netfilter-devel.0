Received: from mail-106117.protonmail.ch (mail-106117.protonmail.ch [79.135.106.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B763F3DB632
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 03:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792295544; cv=none; b=gVVR5eZN2DpglAh1VCWODq/OzNywDWuHwwf/lMmzLHFxwG4extCxc0wmGHIvBGaxsqnvQyAYTAYWIiPWU3+d3Hy8ZueN2BqzytIpb/POjPY/ByIgL+TH15WP2zzEI2tRunKK80yAs3vIkomDdih8Wjb4s0JZmL+eBhbN/2w/QRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792295544; c=relaxed/simple;
	bh=kxiGhsKngx2sQnqmBKL/gQuzauoQiMHMU5+CnwL9vtE=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZMLaGAyqD/QYZgR1hpmWDmNVcpfOf4n3EXnyPnU/KhSFLZuT03IPw5CpKGSeygo5hJR5snoZsiLxNWSlphARbL/BIT5MZxMPQneSfFiIPGKAvrSdGhn20jiUU/AG4YStwimSx7a+Zo/Uu0d4tjKgWd5fp2fbunfFCSEX8JOkfcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net; spf=pass smtp.mailfrom=000ty.net; dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b=rGFObv5/; arc=none smtp.client-ip=79.135.106.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b="rGFObv5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1792295538; x=1792554738;
	bh=kxiGhsKngx2sQnqmBKL/gQuzauoQiMHMU5+CnwL9vtE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=rGFObv5/Yg9v+nnd0HI8WREPwZmOhPn6imvKJbwQvavnX1np3h4ZOU39h9TpBM0v4
	 Pqf7Xfa2PwfB7dGqkYKmctqAUv9zJekHP0mwo3D3Oz6YS38KOl4YymlqNezTM+s1JL
	 7sgbbawFQzfIbftv0iUb0aIRkjMTBxBJzZ/WOLPEBoWrHuv0F9lAnLQ4blZWNwOi24
	 WxuwS9AD4HY0w8/U/wRy0H6rL8Kk1Z/zDGw0wchUqfZBllK9WFkCxXKBKEufE+TTqy
	 3v0o5icjjDLUy9F8o/l1h5UqRXIyNU5pp9k8CUJPNru30Ug7BtMbsaFbxcnFrBFhUR
	 dtCI7PS6NO06g==
Date: Sun, 18 Oct 2026 03:52:13 +0000
To: netfilter-devel@vger.kernel.org
From: Tamaki Yanagawa <ty@000ty.net>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: [PATCH nf] netfilter: ipset: restore element before rescanning cidrs on seqcount retry
Message-ID: <20261018035205.1008-1-ty@000ty.net>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 76ed2bc77d9ab97b0e86590a52f8fe4ee7d751c2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mtype_test_cidrs() masks the element under test in place with
mtype_data_netmask() while walking the cidr array from the most to the
least specific prefix. Since the walk is restarted on concurrent cidr
array updates, the IPSET_NET_COUNT =3D=3D 1 types (hash:net, hash:net,port,
hash:ip,port,net, hash:net,iface) rescan with an element already masked
to the widest prefix tried, so a lookup can wrongly match a more specific
entry at the network base address (e.g. 10.200.3.4 matching 10.0.0.0/29).
Restore the element before rescanning.

Fixes: e80456d79ec8 ("netfilter: ipset: remove need to allocate memory on d=
elete operations")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip=
_set_hash_gen.h
index 80ca523f30..4f94443dcd 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1307,9 +1307,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_ele=
m *d,
 =09struct net_prefixes *nets0;
 =09struct hbucket *n;
 =09struct mtype_elem *data;
+=09struct mtype_elem orig =3D *d;
 #if IPSET_NET_COUNT =3D=3D 2
 =09struct net_prefixes *nets1;
-=09struct mtype_elem orig =3D *d;
 =09unsigned int seq1;
 =09int ret, i, j, k;
 #else
@@ -1372,13 +1372,17 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 =09ret =3D 0;
 unlock:
 =09if (read_seqcount_retry(&nets0->seq, seq0))
-=09=09goto retry;
+=09=09goto restore;
 #if IPSET_NET_COUNT =3D=3D 2
 =09if (read_seqcount_retry(&nets1->seq, seq1))
-=09=09goto retry;
+=09=09goto restore;
 #endif
 =09rcu_read_unlock_bh();
 =09return ret;
+restore:
+=09/* mtype_data_netmask() masks @d in place, undo it before rescanning */
+=09*d =3D orig;
+=09goto retry;
 }
 #endif
=20

base-commit: ab699d296e066eb64f51d2a8a1d42237a3b186c8
--=20
2.52.0.windows.1


