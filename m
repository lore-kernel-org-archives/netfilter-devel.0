Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E3198851
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749753585; cv=none; b=BXlziRT1jIWKNastG0mK0GZaewNVV1H+iUsiigbKUQFXVNH7lneH6xigQ/OYWgIY5Nl/JjAb07HLYPjsdM36+thSpI8KUq+PuvPwX0TOXQHjsmyXrx/JnYOdz44tjmJq1TYviC69g2p16tE+m2EbP5QBQ9pf+iKLzzghiqe6uI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749753585; c=relaxed/simple;
	bh=VhPR52H6NKjcoqBofP/uQMulxY22xqa9lqJW0ZZuP3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qo7V5tcZeip8LRG1YhtNMtYpnFhCCl+TyK7ek9jwqjSicsbFpNJhq7yqwhnJKsEL2qc2seCli6pKJLDamN6zBHkiMeUllkpjdniQE5izEpSdVOvQ41OWHTshxNvaqZR8tfV5G4SwdqMlFdwQZ8XNBjUWRYtavY0S4glIkyunXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gtGo/fAt; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gtGo/fAt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+YfR84mK/GkGmdjAjprWWHG3eiRPdZwTjLerUhuHJ30=; b=gtGo/fAtFWT6acwvCOFZBbB3AF
	aQ8UXSfPXPnq9RLJQw5USC3A3cL+7+ILeV7+yzxHDA4AfUTL6hpgWkfRacq+t9ioFvuuWvNozEmHM
	JnUO4fJqkUGzQB6VixRhwPKU4ns6ypQzHwlZ0e2JA4GtyUjDXylsW/BWJbZgvzTgfPKnfh3ah8J7N
	2pDKFkRla5mqD8QaxBiWGq9s30cdsjNJmMxFUJMszLoEXXRgzD+LJyyVM0vRcrr+sA0Gjs9MU60dP
	Ul9rHI5YEDDkE/QSwlQV3nOs4ipHbHmi8dJpaMCIm/1tSekPqg+UPD469+gDbuHrnCvrqfpm+aefd
	X5cnQDig==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPmpy-000000006ja-1HBj;
	Thu, 12 Jun 2025 20:39:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] netlink: Avoid crash upon missing NFTNL_OBJ_CT_TIMEOUT_ARRAY attribute
Date: Thu, 12 Jun 2025 20:36:35 +0200
Message-ID: <20250612183937.3623-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If missing, the memcpy call ends up reading from address zero.

Fixes: c7c94802679cd ("src: add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This is a second bug in netlink delinearization exposed by the "Fix for
extra data in delete notifications" kernel patch.
---
 src/netlink.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index be1fefc068bfd..73fe579a477cf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1769,9 +1769,10 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		init_list_head(&obj->ct_timeout.timeout_list);
 		obj->ct_timeout.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_TIMEOUT_L3PROTO);
 		obj->ct_timeout.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_TIMEOUT_L4PROTO);
-		memcpy(obj->ct_timeout.timeout,
-		       nftnl_obj_get(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY),
-		       NFTNL_CTTIMEOUT_ARRAY_MAX * sizeof(uint32_t));
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY))
+			memcpy(obj->ct_timeout.timeout,
+			       nftnl_obj_get(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY),
+			       NFTNL_CTTIMEOUT_ARRAY_MAX * sizeof(uint32_t));
 		break;
 	case NFT_OBJECT_LIMIT:
 		obj->limit.rate =
-- 
2.49.0

