Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF403ACA7B
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776070109; cv=none; b=sSQyJHOj77nU19HwgAoeIIDUPlinoJqqFb37kqX+Yj3GVH9F8GaNC+yK/5wZmUkDtKNz9YpTZCO/MJ79EgVxj3rUxT7jlqs+MZlYKymMNqvzP2ctBWsO5l6fXpwpCZrS79lrnOLRJIb4XceRY786yjnnHAkLkePNy4+9kdVQppo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776070109; c=relaxed/simple;
	bh=8IMLk3ne7Zq7gCFJB45nqzF2wesVtWkMU7SvQqsWypM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RdJarcUaPaUwX1SnyS2qoQYjXAKp6du6BJ9eUIs7m16x1mOcNl79UjOBQQM8TSfsjW/p9mndADSx2EyiAeNmRgAJS6FkGZu2pfGHDE0PKEZa+NMZ1xws0qCPVDLnnecMtziSjRstGBb6quNwahoBJmTzDgBkCu3g/WLQR+VY0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLHREnpX; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLHREnpX"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2b4583f0a1aso5894875ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 01:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776070107; x=1776674907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m2fS7SSQov1oj9aq4GgwHcUoeWbd2x4UWXUE2U4OB5I=;
        b=GLHREnpXg2a+q2L9xxD/+X2Vd/XDjE0foMM92JQByGylOAP+sejpV2/ZOZRxJjhFMl
         EGea/6F+kn8irW+VSs1VaP7ZbAmAnwlJyvZKRJdYZRdlpG7wV2EuWIDSE4lPY8oXLRx4
         exWUITP9JJc65I19kG9nPAQVNXEvOhEEWTibNdSDJ4bsDJFZ7dvV64VE00AE9XIb/1g0
         XP1Zy2FKTYSWCOeMhSKIgcfc0PfBuxH952PCDPT3XMM4tgvayLd0B0BLCgay0mLbQsQZ
         bZM53pZnJeCNURz18aMMEFnSFf8xT/o5AOfbQYpVVnPbP2o2OZj9mHDCFDxQPEPwvtNj
         oHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776070107; x=1776674907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2fS7SSQov1oj9aq4GgwHcUoeWbd2x4UWXUE2U4OB5I=;
        b=Zti2eraxnr/UqVJFyMrAwPlNKPWicgWG/yGDoh0xm6/r4F3F6eX12FmZ/vqZJLb1fl
         nzKELq7vx5p4xKSYeZoCW/V8CSDyXqURi92u2DxRqXFGjBtEF6VMPaiCxS15vjhs4gk4
         6Y4IR6ptoNlhpxU68iayFMPL7m2cHTPY6szm8l3uj85rcVND5FB1IaBspZVv1bTwO+eg
         2QiExIkQ74c0xzavDKwsSNpHIywOD2WD6Fu7EHqKFQiSsDpiwrKtjD6nbcTSoxmqhEVu
         Kx0k206CYJWomvzSKDaa0GfJN+1RcjzV+s/Dr6Wtckgn1CPV9QEoRh6YgJKaTQRZq+XG
         +r3Q==
X-Gm-Message-State: AOJu0YwnUM31+pjEIgAVEi3XJL/PT8D9RzSP/k89a0V0zlakvpVHOpY9
	tuxLSglRcI9ic8UFsN3rTI4FJnyx3IPdngMnWw/wTgoV6W1HwHoZyyVrFrRtsakS
X-Gm-Gg: AeBDiesPNcowk5ys6AkWgl3gH3jnBlUpimj6v1xbfFke+C5A3a3ZdmLFKZfRn5yg+ZS
	HScxrnDJDV7DeuXv3C9Xaw2JwL2NWymBYyMg0HZ2I8TEeYrI2HRZwSo95dNKnpsY4qeMBfmpXJx
	b8yxltWfUZgl58H9zRS4F59aD8/8Lbze6y2sbL/Tbm3XeTI/80ESGiUNAwnRAZ5cGvhYXVq35zg
	MjE3RjZroQ9z/utY5FfFgTZw2vNq+37jKc8+tSGgrY/4v8LgSzWWTRjHe0N43iYy4ygMuQ2TGNY
	O5x59WFzVx2xcp9zbhyI+t0ObFTc8ccgfb+4aCwnrRXAsgYJKqrKLcHqiv/pZhVqfdjWlde6CaT
	VpTo0p2jIRL8q24mH+X3vLQmCXfHKAzlHUMjbIz/DnFK1m4Pp0XwXYL4hEahm4OqNEH759+YXLq
	hTsZksxYWZcQkVLP7N89BkFQQc1LKn8OLk7A7+FfHQepW4miQHqA6ZkAFi3whtsAIu
X-Received: by 2002:a17:902:d590:b0:2b2:b117:1e1b with SMTP id d9443c01a7336-2b2d599f553mr124015995ad.17.1776070107246;
        Mon, 13 Apr 2026 01:48:27 -0700 (PDT)
Received: from gmail.com (69-172-89-235.static.imsbiz.com. [69.172.89.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4daede9sm141700485ad.14.2026.04.13.01.48.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Apr 2026 01:48:26 -0700 (PDT)
From: Dudu Lu <phx0fer@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Dudu Lu <phx0fer@gmail.com>
Subject: [PATCH] netfilter: nfnetlink_cthelper: fix expect policy update copying only first class values to all classes
Date: Mon, 13 Apr 2026 16:48:22 +0800
Message-Id: <20260413084822.70754-1-phx0fer@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nfnl_cthelper_update_policy_all(), when updating the expect policies
of a multi-class conntrack helper, the loop iterates over all expect
classes but always reads from new_policy[0] instead of new_policy[i]:

    for (i = 0; i < helper->expect_class_max + 1; i++) {
        policy = &helper->expect_policy[i];
        policy->max_expected = new_policy->max_expected;  /* always [0] */
        policy->timeout      = new_policy->timeout;       /* always [0] */
    }

The new_policy array was correctly parsed per-class by
nfnl_cthelper_update_policy_one() in the validation loop above (line
336-342), with each new_policy[i] holding its respective class values.
However, the copy loop dereferences new_policy as a pointer
(new_policy->x) rather than indexing it as an array
(new_policy[i].x), creating a security vulnerability.

As a result, all expect classes of a multi-class helper get overwritten
with the values of class 0, discarding the per-class differentiation.

This affects helpers like H.323 which use multiple expect classes
(RTP, RTCP, T.120) with different max_expected and timeout values.
After a policy update, all classes get identical limits, breaking the
per-class expect enforcement.

Fix by indexing new_policy with the loop variable.

Fixes: 2c422257550f ("netfilter: nfnl_cthelper: fix runtime expectation policy updates")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d545fa459455..1e605d77796d 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -346,8 +346,8 @@ static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:
-- 
2.39.3 (Apple Git-145)

