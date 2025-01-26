Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D717825A65D;
	Sun, 26 Jan 2025 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737897585; cv=none; b=bscvE+vXJAjIHoc0iwMx+phl+F6eI+kxKk2dwADxvqtY6QEvDrgl+aGtBfvl+nIqymPaPSeGIetIr8xnp2HSBNMc6u6Uekx5jwPk1ZKZ/eGa97Dbg4czDWcoU3ys7fSuQ46mH8kKpRmIvxawjjZw4BsR2YtP8MnZcc3it86EQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737897585; c=relaxed/simple;
	bh=zXDKAU4VJmLZ6ToTMZQVoZJKwLDD9YijXRaPTATsquY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XIfxpTCnbQ7H6dAFeK/tx1UmfMqoLvWv/rIT9YkhWSw1ilvxSTPraAme5EsnAcipySN0yYocDM4Ro1gmiRDV9xOlpBxUhIcEJ9/Y0j78D4zzEPWUp86UOJOjhH43NExV3UyCJKGTXh7hhhIdyaD5czJW+1PfYieahQGRlQyp17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GuMCZ6fB; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuMCZ6fB"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-305d840926fso29775641fa.2;
        Sun, 26 Jan 2025 05:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737897582; x=1738502382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EEKDecmejXifWffv2tVsuiNZVs59PculFTK7zvYm+zc=;
        b=GuMCZ6fBDglLwRJbKxHb+4+T8E/sIKDTzxf9rtZraRYFzX1mdQ8shv06Ike7dJiO38
         C5zEisyp/JvVA5t6/M4bRAhgr9EcPIDOU/L300MRJbtfl0wpdkL1KZvIpeiqkDlGz/y5
         tqqbG9c5PvAQ5cNM0+ygNb+lE6Vh5MkjDvUu7tiTbjAQkTWShGqSxRiBwvgt+id+xeO5
         0l0A0KYgN00cDwBh2ZahiD90pGzfD+yFPdEu53ONJ34CzWOSRPdPO7o7EfCNUj0MwTG8
         t2bqMCytcB0yn1QVqy6YuaiNdZPtAKXhcIwOLTGmo1oXMMdSaxIaS1GOvbPrPiFfPbrv
         uptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737897582; x=1738502382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EEKDecmejXifWffv2tVsuiNZVs59PculFTK7zvYm+zc=;
        b=PmyxV31FuTc/ufSS6yTZlmF+LdbS1Xr7XSUCCgBObEQNDP9va3r6KSVqPilwaWKhqm
         JQ7B79+AooxTq5CbLjvCdlSgHoegpAWlWV12yOKr0biF2cU2NYjqyc4qwz8VIm+ZTNTP
         BvWad58vLTfkVEeJYgUv+qPjNzO6+fQqFwGa/Wcp6DEY8nUjcfB64TkLV8PB+SZULvBJ
         plu8JYTdK4OabJbMU0FVLap0v5BVAn9oCAHPmFuvi2CpKP2ewu3FalbR4yMCd3SFfum0
         Mqf0Uv98gArqGlMwt6AKFiFI971mvlRrrB4iwke6D4fFTC/oT+asECVsbJlzG13akmrx
         8y/g==
X-Forwarded-Encrypted: i=1; AJvYcCUj93/GE8YA4T7bPeZdwx1ZZeZFLGVxvP5lfWQdj8K41zmQF06ifce4jlHGNjARMPjQRenU4lA=@vger.kernel.org, AJvYcCV+d8XOLQ1S3ZH8kyBHuUM5X++qxQbZX2eAjo6lAUV2UZgkOSViwh+20tqTRPuVDEoACtIRyLhZ9okSnEq2fq9o@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2t16TrJdv58w8dXIHURbSTMW4h0MLrK37cOjADNj/AIpgvNCQ
	de2ENoMYB5+vQnpWajqA48MjnqGp6c32vm35vrSWxi82k8qBPTC5
X-Gm-Gg: ASbGncsnVL0Ya5fuWIkD2JUdYbsSXdV7NdC5QIfJLSN63aycVyL4xrpThxGurNVmnca
	QclURCflj4FbJDgUWlsDt+tqfn4aAMaFinETECJPWqldT+cjqpa1TcGYiDS+O96P2RqFO17paHW
	/knoJhqS0iD8RSW15C31+oVqPKS4nmTO2MTfUfF6qFGq3yytWWYapsCj+ESE5ySpcF9PHZ8AoJI
	L3CwueaDOFQInQq55SexP48dtKOb9To0kX8p9XUED8JLkUI8AsNSibgEPuQLzb55N0pZUn+74v8
	lRdGLNzBC3m2uzs=
X-Google-Smtp-Source: AGHT+IF7MWAEXQNQa5Bbm/WQ3/aMuc448vhbJt/p7tmke8PyxAa2D+g/jRWO2FoTf23oBLyBpVO6uw==
X-Received: by 2002:a2e:b535:0:b0:302:3356:7c55 with SMTP id 38308e7fff4ca-3072ca89aebmr108339681fa.10.1737897581609;
        Sun, 26 Jan 2025 05:19:41 -0800 (PST)
Received: from localhost.localdomain ([83.217.202.104])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3076bc194cesm10496101fa.72.2025.01.26.05.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2025 05:19:40 -0800 (PST)
From: Denis Kirjanov <kirjanov@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Denis Kirjanov <kirjanov@gmail.com>
Subject: [PATCH nf-next] netfilter: xt_hashlimit: replace vmalloc calls with kvmalloc
Date: Sun, 26 Jan 2025 08:19:24 -0500
Message-ID: <20250126131924.2656-1-kirjanov@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace vmalloc allocations with kvmalloc since
kvmalloc is more flexible in memory allocation

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 0859b8f76764..4132c37dea28 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -15,7 +15,6 @@
 #include <linux/random.h>
 #include <linux/jhash.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/list.h>
@@ -294,8 +293,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(struct_size(hinfo, hash, size));
+	hinfo = kvmalloc(struct_size(hinfo, hash, size), GFP_KERNEL);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
@@ -303,7 +301,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	/* copy match config into hashtable config */
 	ret = cfg_copy(&hinfo->cfg, (void *)cfg, 3);
 	if (ret) {
-		vfree(hinfo);
+		kvfree(hinfo);
 		return ret;
 	}
 
@@ -322,7 +320,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	hinfo->rnd_initialized = false;
 	hinfo->name = kstrdup(name, GFP_KERNEL);
 	if (!hinfo->name) {
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	spin_lock_init(&hinfo->lock);
@@ -344,7 +342,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		ops, hinfo);
 	if (hinfo->pde == NULL) {
 		kfree(hinfo->name);
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	hinfo->net = net;
@@ -429,7 +427,7 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 		cancel_delayed_work_sync(&hinfo->gc_work);
 		htable_selective_cleanup(hinfo, true);
 		kfree(hinfo->name);
-		vfree(hinfo);
+		kvfree(hinfo);
 	}
 }
 
-- 
2.47.2

