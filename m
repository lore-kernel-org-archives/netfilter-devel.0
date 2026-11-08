Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177218;
	b=2tCRCFvTZjScjmQVgGkZsMOtEZ+1S5vI6BgGnm7kxJDCdh2gAZLK9YezyGcAERnZZzGl
	 fqdfLuFzUBuaPhyM6emwAFfjXsRv5WGSRSovIaDqpl0UbNAOrNRroeH59HhTqD6sLplXG
	 54IjvmL3OZkpCShEn98TjrZ4i4vgTdSZWG4UttjIjS1WOjsXRxILgVbT9lZDQ4XT4B53Q
	 e4Ileev33YD+MJtlxG61M89CLXUqJ7aPRZtohPveM4+MnzweL/oPyc+j+5uwjfJ7jR707
	 osulojGdVr35X4c+Rfi7stZwu8PxZ4W7jZCG4gYrnmAo1pnYVfliWkdrZ/d7+5wcTOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177218;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gvbSaS7GyP0cnYD5s+wxI51RSPVN+a6vxoEzW8zoP3A=;
	b=O4VK95Ar/3jc2hPXyrpRKR48Uk+UC5GXkiLsVpHRHr0Dt6ifk0aZEd6d8XFDt+m33zwW
	 JpS1lThq8CMdqo77ZYRCw6M4L7LQ6b0eV4DiSmVgGFDHJdE6YgvvzVvZ4KihhHf3Xq5w2
	 9VrhZU5BJKRAePDzm2iYe+bmFG7uTgCGkVrwWIgGxsdBHimgYiS/oPw7R7f+NQnG0pXWz
	 N1RZZcfH9HJXtsUw/604hSWuimw0040oc/FMoR0HAeTUOJ4r6c+RprwS3sYCyxmTP1PTt
	 5nU3eACNwgF9TcGoHLT4qSrpdrq4O6lwnZ+GquN7u0zV/qWrx3CVIf6LjY3ylMmftOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=4vvxxerpwbagjmsxqnscve37cq.protonmail2 header.b=BWz0BAFE;
	arc=none smtp.remote-ip=185.70.43.22
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C2606A325;
	Sun,  8 Nov 2026 22:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 815C2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=4vvxxerpwbagjmsxqnscve37cq.protonmail2 header.b=BWz0BAFE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=4vvxxerpwbagjmsxqnscve37cq.protonmail2; t=1794177214;
	x=1794436414; bh=gvbSaS7GyP0cnYD5s+wxI51RSPVN+a6vxoEzW8zoP3A=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BWz0BAFEu2MuRTV+Vzqi32XqValaWjwnY/XLc+TJBrozYmhwz2J/LSk0Y8s8MiZ6v
	 xSeixP3zJ+6guxb7NCy0pcSWNjfxDEtUFxQEV/JJkukqKmzUZPK75Uyc1Qq5e8E6iy
	 H4YWS0KxZaShQ5V2XjfFgf3ThUhXOoKgt6IzVYchsiN5XcLAPG9rbLt8u9K6oqHQ74
	 inUMN2MgIXijXqjGH5H982jRHVlleNOrMLgjZkiNcpjUOoCgvHYDX3mKzP7I+q8lx9
	 /TChEJluhB34Eo3pFmb5pnzHvif+Ehn/95pGG48ZEgBxGFS7SauHRHB6dJqQvI802M
	 J1WeWdh1ZhdkA==
Date: Sun, 08 Nov 2026 22:33:29 +0000
To: "pablo@netfilter.org" <pablo@netfilter.org>, "fw@strlen.de" <fw@strlen.de>, "kadlec@netfilter.org" <kadlec@netfilter.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] netfilter: ip_tables: propagate compat_table_info() error
Message-ID: <YEo_4lnonRc0-_Jotuzk7hOaWl3QockF3xDwJ4cE5v8uBvy1KW27Eku0fWDJycuoZ9AgGFxsxgtSWI6SE2kNJ38eVnLx-HtApOhBw0wxXGg=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: cad6e748cbba3426e6e2549fa89e6176241586dd
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

Hello,

In the IPT_SO_GET_INFO compat path, the return value of
compat_table_info() is ignored: on failure (vmalloc ENOMEM in
xt_compat_init_offsets()), private =3D &tmp is used anyway, and ret is
overwritten with 0 after a successful copy_to_user - so a 32-bit caller
gets stale or partially adjusted 64-bit-layout size/hook_entry/underflow
values instead of an error. The follow-up GET_ENTRIES then fails with
-EAGAIN. tmp is fully initialized, so there is no disclosure; this is a
robustness fix. The same pattern exists in ip6_tables.c; both are
patched.

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), net/ipv4/netfilter/ip_tables.c:968-987, net/ipv6/ne=
tfilter/ip6_tables.c:989-1008.
Longstanding code.

This was found during an assisted (AI-supported) static source review of
mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); e=
very code path cited below was re-verified by the
reporter against that tree. The patch below has NOT been compiled and has
NOT been runtime tested, and no reproducer was produced - the triggering
conditions are described above instead. Please treat this as a report for
verification rather than a battle-tested fix.

Reported-by: Noah Weinberger <noahweinberger2003@proton.me>
---
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.=
c
index 809441c..e11a5af 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -968,6 +968,8 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 =09=09if (in_compat_syscall()) {
 =09=09=09ret =3D compat_table_info(private, &tmp);
 =09=09=09xt_compat_flush_offsets(AF_INET);
+=09=09=09if (ret)
+=09=09=09=09goto unlock;
 =09=09=09private =3D &tmp;
 =09=09}
 #endif
@@ -986,6 +988,7 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 =09=09else
 =09=09=09ret =3D 0;
=20
+unlock:
 =09=09xt_table_unlock(t);
 =09=09module_put(t->me);
 =09} else

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index 313c4aa..1d5749e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -989,6 +989,8 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 =09=09if (in_compat_syscall()) {
 =09=09=09ret =3D compat_table_info(private, &tmp);
 =09=09=09xt_compat_flush_offsets(AF_INET6);
+=09=09=09if (ret)
+=09=09=09=09goto unlock;
 =09=09=09private =3D &tmp;
 =09=09}
 #endif
@@ -1007,6 +1009,7 @@ static int get_info(struct net *net, void __user *use=
r, const int *len)
 =09=09else
 =09=09=09ret =3D 0;
=20
+unlock:
 =09=09xt_table_unlock(t);
 =09=09module_put(t->me);
 =09} else

