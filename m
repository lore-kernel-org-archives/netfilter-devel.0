Received: from mail-24430.protonmail.ch (mail-24430.protonmail.ch [109.224.244.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22CB27E056
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776454907; cv=none; b=MfK/3OD0r3YGkvLQbQxsijTGWxMu3tqnf6KCaoOl5xuVmD4SupnX4BkUVPl/vXKJaTLhkdCid+Wh49xR2OeKxaQNx1XTamZlApL0/ls37poWk7eQFHibf+dNl2SyfWA1/d0/a6XDq/xC3cffY/b6XRFg3D7X2O4pyY7X7700svY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776454907; c=relaxed/simple;
	bh=qCPCvrhkOsGPGd3amlDjI5jADwpOQxEPgs5CVKAAYR8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Gd9nfuA0AFqh86WJSwxTdZz97wuN9J3//4AiR4/0zPTkVP6VrxAQvtZ/WMDkODSqIC30UMUEuliNCZwNM/pAkFAN86wPORRqoNl6HfwIZ5bSUGiu/BhvySwHYhHlE/CHnggjaOl0KR4rb+f9CYrJfPuBNRP1lkjU328OICjRUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=RyRKmu/F; arc=none smtp.client-ip=109.224.244.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="RyRKmu/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1776454896; x=1776714096;
	bh=qCPCvrhkOsGPGd3amlDjI5jADwpOQxEPgs5CVKAAYR8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=RyRKmu/FHHNf3GEVB2TKbX8Gns+/hXpYAeAH30UxAHVvnC5+gf7J9DrbF37MAEDFO
	 WKYgf7YN06vA0Dow78z2fk4D+OXohuAR9pDJZyVo4vpBVQ4DxTUWEhiIDJYGJdeX6S
	 MNN+fsI2D1jSD3iKRp7KD15T42jFWoTX7+nZu4iNv9LSC/R8YXst6k4rwhNUZh7S1f
	 0DJSyKlI62jYKmjDm5xKIlH1JKd8GfkANbHHjCOJdRFIJKUPaWx7pPhl7nwSIDrSxm
	 v06brqe5bj/zSuK2sZmISop/brrtPpclUF/8zctZJrn+LyYMJ9Iz5Pj7pcDHTdvWPF
	 j+vl4i2HSmvGw==
Date: Fri, 17 Apr 2026 19:41:32 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: "Avinash H. Duduskar" <avinashhd@protonmail.com>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>, "mkoutny@suse.com" <mkoutny@suse.com>
Subject: [PATCH] doc: note meta cgroup returns zero on cgroupv2-only hosts
Message-ID: <ao4yv2o0cv8dPaKxuSYQGhLvUbSEyoqb0s32In5v6LNK1DLu9OWdQFFMZ_tuc1i-CcOLr1MXZYgpOBZcGQTBuI1swdQGygi24_RtIZ9sHbo=@protonmail.com>
Feedback-ID: 10914616:user:proton
X-Pm-Message-ID: 5d500efda6956afbf749d93dff5fe27c4fe85851
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Commit 2ff29969 ("doc: Clarify cgroup meta variable") corrected the
terminology and pointed readers to socket cgroupv2. The man page still
gives no indication that meta cgroup silently returns zero on
cgroupv2-only hosts with CONFIG_CGROUP_NET_CLASSID=3Dy (the distribution
default) and no active net_cls hierarchy, the common configuration
on modern systems. Rules load without error and match nothing.

Make the behaviour explicit in the meta expression types table.

Script to reproduce the issue: https://gist.github.com/Strykar/512e08f9fc2e=
7ccdcac971fd1719489a

Signed-off-by: Avinash H. Duduskar <avinashhd@protonmail.com>
---
 doc/primary-expression.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index bd80cd7f..f09817fe 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -117,7 +117,8 @@ devgroup
 outgoing device group|
 devgroup
 |cgroup|
-control group net_cls.classid (for matching on cgroupv2, see *socket cgrou=
pv2*)|
+control group net_cls.classid; reads zero on cgroupv2-only hosts without a=
n
+active net_cls hierarchy (for matching on cgroupv2, see *socket cgroupv2*)=
|
 integer (32 bit)
 |random|
 pseudo-random number|
--=20
2.53.0

