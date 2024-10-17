Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476CE17ADF0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179203; cv=none; b=IFn0jUw0n3J3iTDlW24udSxM2VSeMu71vAKoA25CiUYWg0VkM2zlEe2QEDkmePQfI5H6OlE2QZFBQ7yi4MAbHHJ5J3iX2t8E0MgMGQqfHHAEwshv1PseiDphHI1qCMKLZqhWKj5o5Moh//25kYN0kn5foC0QJzMQ1IU4xJwlFkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179203; c=relaxed/simple;
	bh=ihALP5fS8rOcedEfeoUpEe2dNe+MI4roBAOtZlPemgo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To; b=GSVO1wE2hz8qHjmUSTU9DgDgex1ihXLp3n+uGUGIY7Jzip5sLCbLHuOOL6nFn2OCheq5otb3tULb/40GBzYLo0doU7fgyGjGhyZSfARVPv+S2qKrQZLrF9rzfmH6hjl0IRe9F0xq7LIooGHS1XEjGZHTLzkj4E7IzDiyqy5ZjHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzbIbovz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzbIbovz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC171C4CEC7
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729179202;
	bh=ihALP5fS8rOcedEfeoUpEe2dNe+MI4roBAOtZlPemgo=;
	h=From:Date:Subject:To:Reply-To:From;
	b=bzbIbovzm9AspkiQ0dpu7dqqgXeB9touwOfkAKuSVJJXyvXTRF8ZvtHrzq6LBlCqz
	 B1SlTaOepLup8o9upZURrBNERTKkiaZf6w1YJ0HkpErwBY/QDNiYoxYl/LNgpe/rXs
	 kwYM5WlLtrQyxCJafqPAmCpfnjg8ZhyphKaDR44uTd1EC2VKsewOYyPPkFNAPu3fl4
	 lB4Magp5sxTX4EmjIN/nqB3luBKfyLDjLqbOw4OPvAObhUmwiriTkHSk0kAe49fdT9
	 SEjkpwGzaWZL4TtAe7iUHUirTaFOW6NqB+TWhe2/uRM/zHwhNFRaFq0nKqaZMdU03m
	 Nuftyv0i6hkRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CE8D37499
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 15:33:22 +0000 (UTC)
From: Eric Long via B4 Relay <devnull+i.hack3r.moe@kernel.org>
Date: Thu, 17 Oct 2024 23:33:17 +0800
Subject: [PATCH nftables] libnftables-json: fix raw payload expression
 documentation
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241017-libnftables-json-doc-fix-v1-1-c0d2efca1ab2@hack3r.moe>
X-B4-Tracking: v=1; b=H4sIADwuEWcC/zWMQQqEMAwAvyI5G7ChIvgV8VDbqBFppRFZEP++R
 fA4AzM3KGdhhb66IfMlKikWMHUFfnVxYZRQGKghaxrT4S5TnE837ay4aYoYksdZfshEtnVkPQc
 PJT8yF/2uB/gSGJ/nD0+tDXN0AAAA
X-Change-ID: 20241017-libnftables-json-doc-fix-e2245a24cedc
To: netfilter-devel@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=978; i=i@hack3r.moe;
 h=from:subject:message-id;
 bh=8G2jiRNCYmstnPIa64oo9+zrrbBcL2qkry/1/TIQ7H8=;
 b=owGbwMvMwCUWYb/agfVY0D7G02pJDOmCeo5b1JvS4kKdZ1qmvJVLu34pLOW1cMj64ObI1OT8L
 Tmzl4t3lLIwiHExyIopsmw5/EctQb970xLuOeUwc1iZQIYwcHEKwERqXzIyLPtkfNjtx+LMuWW5
 CcdnP7i644zW9Ovu5aK6aSsvq5cYvWJkOLY359v6Uq3aj9N3KmyaZpDsduRqzKQHah55ZzRuNvF
 sZAEA
X-Developer-Key: i=i@hack3r.moe; a=openpgp;
 fpr=3A7A1F5A7257780C45A9A147E1487564916D3DF5
X-Endpoint-Received: by B4 Relay for i@hack3r.moe/default with auth_id=225
X-Original-From: Eric Long <i@hack3r.moe>
Reply-To: i@hack3r.moe

From: Eric Long <i@hack3r.moe>

Raw payload expression accesses payload data in bits, not bytes.

---
 doc/libnftables-json.adoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index a8a6165fde59d419f1ec7a1fa904e1491fe15284..2f29ac0436280719e50016ee92a6b78605894831 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1182,7 +1182,7 @@ ____
 
 Construct a payload expression, i.e. a reference to a certain part of packet
 data. The first form creates a raw payload expression to point at a random
-number (*len*) of bytes at a certain offset (*offset*) from a given reference
+number (*len*) of bits at a certain offset (*offset*) from a given reference
 point (*base*). The following *base* values are accepted:
 
 *"ll"*::

---
base-commit: ff0846371c0c1cca41fd61ef2c481248684b8aa9
change-id: 20241017-libnftables-json-doc-fix-e2245a24cedc

Best regards,
-- 
Eric Long <i@hack3r.moe>


