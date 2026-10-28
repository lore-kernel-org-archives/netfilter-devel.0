Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199429;
	b=qc2FNs2Y1NCtftRl+c9iJCoV+2DjzFU/imqQK6jLHdVEmUMR7oNB2pZYbxAF5XD94ypB
	 btSowEIrbO6qDbrTkeeDn58/PZQL1sOgZTy1+ZIWasHSX/iq4N1At+xEy7ZiPzEooejh4
	 OCXQ1PSLC6Xh+DOR6mD/ZYfFlH2uSYEKgXDsaAnUZA+U3ZSvRaBbvTFDg5mcWm761MYGi
	 TuGSMviESo+8VMJ6pLJ/V/FJ+Ic9VHzkXOsNtbu44ycvCJwuWLhfyw4c2zIZ0QODvQ0RN
	 qg8OBI9JLx0p1udr0GjJG/wBS35RTkxUyQcyNu4cDcLZuL+f8TkwrJ66MFJ49WZumpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199429;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GgNp5RZB1jKVmmUkOsVaEQU/xke84SJHRJjNnDa6TNk=;
	b=L6lL/GdVDBy+ecsR5apFL2pMoDOrCcMYsDed9+cpSfU1DTwF1ryJ1dGwnCWLlz1sbTpB
	 NHpOj1C6OkDSRmbJC7gAAhGVNQK1Eoa52rzChatMJbm7tMCjKieRO3qcSD2djVgTVqk5N
	 tUbs6dzmbS1AX31tbyCykgcdna/aL8R3TRPg+2EfPghsClfFMdrsdGTx33cTHVrwW4Rfe
	 VZNZ4GfHAp6fphOXtoy0z2azBXmpnpnLSvXOF11gcyC7nQra1gMwCVhGM7O8VYrPUZgvf
	 VjZTWe2M9P9JFsFIrG9vKp/vC+Vb43iEmFkmEeC9PtrMJHVblk5cV5VjxFcZu2oHZZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F5D606A31D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2F5D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 06FBD609D0; Wed, 28 Oct 2026 15:57:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 05/12] src: object: don't permit to re-set or clear object type field
Date: Wed, 28 Oct 2026 15:56:25 +0100
Message-ID: <20261028145632.7089-6-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
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

LLM finding:
If obj->ops was previously valid (object already typed) and the caller passes
an invalid type, obj->ops is nulled. The object is left in an inconsistent state.
flags still has the NFTNL_OBJ_TYPE bit set.

Subsequent default-path sets will fail.
get/build/output calls that dereference obj->ops will segfault.

Don't permit identity change.

The object type uses a set of common flags plus a set of type
specific flags.  The latter overlaps.

Permitting identity switch is just asking for trouble.
Moreover, there is a latent crash bug:

If a future type introduces a flag overlapping with
NFTNL_OBJ_TUNNEL_OPTS, we free a pointer inside union.

Check we have the correct subtype before freeing.
This is NOT a bug at this time, nftables neither switches
ops nor does it call nftnl_obj_unset().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/object.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/object.c b/src/object.c
index 1198be6965d9..d35e050b9d83 100644
--- a/src/object.c
+++ b/src/object.c
@@ -56,7 +56,8 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 		xfree(obj->name);
 	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
 		nftnl_mem_blob_free(&obj->user_data);
-	if (obj->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS)) {
+	if (obj->ops && obj->ops->type == NFT_OBJECT_TUNNEL &&
+	    obj->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS)) {
 		nftnl_tunnel_opts_free(obj->data.tunnel.tun_opts);
 		xfree(obj->data.tunnel.tun_opts);
 	}
@@ -86,13 +87,21 @@ void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 	case NFTNL_OBJ_USERDATA:
 		nftnl_mem_blob_free(&obj->user_data);
 		break;
-	case NFTNL_OBJ_TYPE:
 	case NFTNL_OBJ_FAMILY:
 	case NFTNL_OBJ_USE:
 	case NFTNL_OBJ_HANDLE:
 		break;
+	case NFTNL_OBJ_TYPE:
+		/* don't allow to morph one object type
+		 * to another.
+		 */
+		return;
 	default:
-		break;
+		/* object type specific. Clearing e.g.
+		 * NFTNL_OBJ_TUNNEL_OPTS results
+		 * in memory leak.
+		 */
+		return;
 	}
 
 	obj->flags &= ~(1 << attr);
@@ -121,6 +130,8 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		return nftnl_set_str_attr(&obj->name, &obj->flags,
 					  attr, data, data_len);
 	case NFTNL_OBJ_TYPE:
+		if (obj->ops)	/* don't permit object type change */
+			return -1;
 		obj->ops = nftnl_obj_ops_lookup(*((uint32_t *)data));
 		if (!obj->ops)
 			return -1;
-- 
2.55.0

