Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC732D4816
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 19:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772824361; cv=none; b=TmcORvhyg3ktpRFlJ8uODzMFGhu8cQ9qKv/8TmVaTsKSKIKEAf2YqBQpzM7ZCQv/nOlbaDN2osRIvES2eTaa5SP5CY7cPdNb50TQxtXXunYlMfpaT4afa3BCV2pf3EyhwFbMSPJIXE1csHfbOa+5VmWE7vP+5n2FKGOc95zbF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772824361; c=relaxed/simple;
	bh=L2hiLvGKBv7d8yhbcarIF8ra8IeF5q5tyCzOhmTpEZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FN8gUK/hS5/VqpaRr5IZ6MeZuJ67IfS0b3NKuq7A9AIDJpRY/JcQK3bJbNHla0nEkkO/uV6UzPbwLsVT0E3uEosnnnTjFCP1bGHASFfK5dOEYoMmHqs0hw75CdJJYv0g0HzdCLJX2MSCDx/T3rgEmQGOQVr+8MuFb1hx6hM/mAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSXxx0eZ; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSXxx0eZ"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cbb6d5f780so960082485a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Mar 2026 11:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772824359; x=1773429159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SqXQ6+uMTYxVS8znPfDnulqYlObSmjX7AH8GMsEC6YI=;
        b=kSXxx0eZP5obhSv2s1bxDc1F8v5lTBbhX6D3wZWekARxdzAnOweXpQTW/2OItrwigM
         AodUDE4kgSZ2Wk4HNCQUo9yila9mR1DEdzUxn1b36UBZiFudNOIOJmKCzm/OYl52FFz3
         JoOOCnU5ub6MU+sB2czkxAGGuUnudSxZM7J2Wh11KlSeOHYpoZw+csNvDao3emxeTJx/
         je2kFliFvNW+M1sC3xE+3n1D+xIpNWynwopENdjWkIGVFhheMZ1IfEQuGaUdBzBBT+PJ
         fzN9XByP3aOYoVBX4L4IHvmfLJjM1r20v1x9+tfMAAgdD8+l63kn6/+CLy3ljv1YpOPI
         pc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772824359; x=1773429159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqXQ6+uMTYxVS8znPfDnulqYlObSmjX7AH8GMsEC6YI=;
        b=FqDWhKFkn/6OkxwhPdKdAEWiHncfalC4TBgah6emyE3X9TTk787uQ7VPdItxTafhlv
         P/2QVDWSbBy2lcDCJj8MDJTmHtl3KMglTwOOxQ9yMYb4U6nh8qPjezuCgJgG2jMjQt9u
         VCTSgk1a0SI7hqn7StHbdwgByiS4urkMGgplmnOEHx/ojSzuHkjT9Jq/mvNb7oOEmHZB
         v1Um5QhaKC/2Ivzgg4ajeKx2TceLiS11LfRgTgXh0LR+AAdxWM6SMWNCA2a0xfBpPV0q
         ydMlZOoN8hnhYTwM4pW7mTvwOIhNximM0ZqzLENb8qBeN69cDftXZml9iZAmtJHJtZ9e
         CvKA==
X-Gm-Message-State: AOJu0YwDbIMjUQxOl23njs2yjHN112du3P5mH6kc5DbgmLEA9rHvl9PS
	N2MFMrizjMe4nDjr2Bmkq+MIVz/eyZ2QD9JhApsO5AeK6T1lZ6wNgcI6015wMixJ
X-Gm-Gg: ATEYQzxrr/FRO/g4EMo7Um9S4SlhNotdq1vrml+LFFKpqATuGiPjU2rgbYXwgzpw5Os
	HCOMmc6jw7DDlZPR7JuFkWwQ8AJNKK8xbF/MlH0InAvS7VdR97MGz9MpKZzHb37JGw+cvnpyaVi
	VJn/IQUIvJfOeskbYqO4t3imo2nK2xWCUEcL64w+7u5uDJkMVLfB2nB2mbLxBERO+uu8Mh8/NYe
	aWM+a1nxA5oKXmQX8kXaCSvv+7uozPZbc9PR+qSB+GdkofmQvza1FUftJRs08yS3KjyW0hoYYxu
	SwZDIEFxPHbyeljRaTxYC9876dUNUgRjIVvbf9wl7yjgfZOj0184IgyWwjcSXc1x1mLa4mYY9tW
	ChasPg6OGsAROXqpR7zIVfANimcIAW0QkoYBiylDWOuoNI7eWJnPncZvoUXm8giECSBelI36J+l
	Y9tUqbJeHgy25emo1vz8CO3jHYig8YgjiNLqosXaVtiwYO
X-Received: by 2002:a05:620a:25d0:b0:8cb:4289:6c3a with SMTP id af79cd13be357-8cd6d548a09mr419951685a.74.1772824359129;
        Fri, 06 Mar 2026 11:12:39 -0800 (PST)
Received: from 192-222-50-213.tail19a0b.ts.net ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f566fd5sm171804285a.43.2026.03.06.11.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 11:12:38 -0800 (PST)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	w@1wt.eu,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH v2] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
Date: Fri,  6 Mar 2026 19:12:38 +0000
Message-Id: <20260306191238.937530-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pipapo_drop() passes rulemap[i + 1].n to pipapo_unmap() as the
to_offset argument on every iteration, including the last one where
i == m->field_count - 1. This reads one element past the end of the
stack-allocated rulemap array (declared as rulemap[NFT_PIPAPO_MAX_FIELDS]
with NFT_PIPAPO_MAX_FIELDS == 16).

Although pipapo_unmap() returns early when is_last is true without
using the to_offset value, the argument is evaluated at the call site
before the function body executes, making this a genuine out-of-bounds
stack read confirmed by KASAN:

  BUG: KASAN: stack-out-of-bounds in pipapo_drop+0x50c/0x57c [nf_tables]
  Read of size 4 at addr ffff8000810e71a4

  This frame has 1 object:
   [32, 160) 'rulemap'

  The buggy address is at offset 164 -- exactly 4 bytes past the end
  of the rulemap array.

Pass 0 instead of rulemap[i + 1].n on the last iteration to avoid
the out-of-bounds read.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nft_set_pipapo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7ef4b44471d3..f43227fc3de1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1640,6 +1640,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 	int i;
 
 	nft_pipapo_for_each_field(f, i, m) {
+		bool last = i == m->field_count - 1;
 		int g;
 
 		for (g = 0; g < f->groups; g++) {
@@ -1659,7 +1660,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 		}
 
 		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
-			     rulemap[i + 1].n, i == m->field_count - 1);
+			     last ? 0 : rulemap[i + 1].n, last);
 		if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
 			/* We can ignore this, a failure to shrink tables down
 			 * doesn't make tables invalid.
-- 
2.34.1

