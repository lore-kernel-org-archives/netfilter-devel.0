Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0699317166
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 13:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782394305; cv=none; b=VDqQC4FW+G4dCzAx7TKzGswSD61wyoPDLVEv2QXeAnlqxdK6ohvf59WvHrtl002jlsFsBCaDdqG8XSXO82mbpQrNG5vruRNY038Szi2Q9MpHrQNMopJWLDMlNiEE1nQqTX6SwCQGTsUYqbP6ioosmfdT2uOB9qbLBx82ag4yTPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782394305; c=relaxed/simple;
	bh=GkObJTGOwvo/yZsse89jgOyAK3tQLcC4VOm5XflDZOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=chrCA6yL8hcXREQR49KRcJtaP2WvLVq3MJm7bvr+lRNpbpT3IYSv7meUMrXST4FkCD8gJOCmeknCRkudOuUfWlP558EmJBhhHTlAMf8Z0KkcoznFH5fZdUDsQkQZBFGpn0GRkan+tsgOsq0+k2uTBqmlkZwrw/OsEuIz009uQxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eS3r46eC; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eS3r46eC"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-139b5e604b9so2607590c88.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782394304; x=1782999104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NK6SpJYh+oLbM19wL4RZRwc0NJUjhwQHIffBTILtoP8=;
        b=eS3r46eC4opLOzjO0f2kQBTShxHcOHDa3ckBl3twkGEkKAtbVuHFvB6AJ6aTMweHG0
         LC/JXTA5kiU00rW3GXXNIRjcTlQWoV7oVtkFiQ/UvsSDtR3ZrAfUROeirefsM/X/qXxW
         Wx8IYJHsZv3q5/utYbvHnBkaUjb6zb7G6/aAjf1+TKNpbswG0jhxqYhnK9XmP8+2z1HX
         uwWbp8mJkEkZQlFWZa0zaEQ3wXWeE0Ud3867ViRubxCgee0kljfwEJ45L6UGN3pkJcSo
         ObOOavSn3bPSKCzVmdo+Aq+SVblcj7nNZHxF17GESq7DrFdnUYYBRLVkAdzxt11IL3AU
         RrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394304; x=1782999104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NK6SpJYh+oLbM19wL4RZRwc0NJUjhwQHIffBTILtoP8=;
        b=Vfwhm5eIAc9SVZ00XdWKij9adFshHIrtlDl3IAW2cJH/XozOQFirnxhRTA1rXspM3B
         0IZ3HwidoO5nbxSBj9AqF48TVyiqtE8TFBNatiZP95Js6PIPovbrs0MfibcVhO4osoOc
         mOJ5PowiN/M4670tOETENK/+vNXFKBQhXi6s2htkpHWSUzpbL4AaaTf22otL+0Ccn6v2
         E4mrxZVatilBKXIWDb1NYca/A1OHtBfX0OtJZ+Aom8skOj/jzUA92VTowP5RGCEcEMe2
         N+6pCCMYktCKMBUxBBiPdi3i/XDPOK2nSpP4G16Q7TSCAH49fl2WGgB30EcEm3yxUCsk
         wUbg==
X-Gm-Message-State: AOJu0Yy6CR/LeDln+t52gKI7GnJgb704cz02GHxmVUfodPo9pDLGf/PL
	n14dnygsUwu1XACKy1mUDhkGavajmEd9gk1DUgDzyAIAwfc8HNqDWYBH
X-Gm-Gg: AfdE7cn8ZxhtB64K+Y/QL5lEuR2zax7LPI+uWoc9BFy7oBowU1Zs25hlBZKRlGTg5oG
	Ug2J0EX4mcKvhvQz7dtCO/UCmDer4l08fMbhDCkVJkgPRAmv5X2e8B0LPD59o1hM9uHbY0auDpp
	hVqnGFeWmksRUBYze6PAPROu4RJX66aX/Et3hxue5anAphw2yik51zjU2UQTNhijFknOzoTJeTy
	M8Jqb3izY8JF9RLN7tKEDR6ajmOUBDLJRhJnRdcfiPSvM//eY5Uqbi5PhNJw4eHyVEKZ/Wkb3y6
	2FUGJTAcTJORMhfW7CprJmQeO+Zhoo4G53CK1cdsDupgR5lt9GoH6ldBhcKZhBLZGOHpDG700zz
	iDoypnFGwUaomw4JuV4YDbFUiW6GCcAD1MXGWscoKRuaeT4xYedSyVwGDqfrOd0qmF5CtjYGfgg
	BcxTTK51JteK3KiLLiT2RsVZxiZTKNHf8=
X-Received: by 2002:a05:7022:6192:b0:138:e4:c44d with SMTP id a92af1059eb24-139dbae0ad1mr2171642c88.25.1782394303648;
        Thu, 25 Jun 2026 06:31:43 -0700 (PDT)
Received: from idcredbox1391.. ([2404:f801:8028:3:40af:bf67:9423:25ae])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f55b04sm8806333c88.4.2026.06.25.06.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:31:43 -0700 (PDT)
From: Subasri S <subasris1210@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Subasri S <subasris1210@gmail.com>
Subject: [PATCH nf-next] netfilter: remove redundant null check before kvfree()
Date: Thu, 25 Jun 2026 19:01:24 +0530
Message-ID: <20260625133124.970238-1-subasris1210@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvfree() internally performs NULL check on the pointer
handed to it and takes no action if it indeed is NULL.
Hence there is no need for a pre-check of the memory
pointer before handing it to kvfree().

Issue reported by ifnullfree.cocci Coccinelle semantic
patch script.

Signed-off-by: Subasri S <subasris1210@gmail.com>
---
 net/netfilter/nft_set_rbtree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 018bbb6df4ce..efc25e788a1c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -544,8 +544,7 @@ static int nft_array_intervals_alloc(struct nft_array *array, u32 max_intervals)
 	if (!intervals)
 		return -ENOMEM;
 
-	if (array->intervals)
-		kvfree(array->intervals);
+	kvfree(array->intervals);
 
 	array->intervals = intervals;
 	array->max_intervals = max_intervals;
-- 
2.43.0

