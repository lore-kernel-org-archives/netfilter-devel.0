Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2667F
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2024 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714352918; cv=none; b=ZvaRhRNo3nBbqnd2QnUhDa6I4ldv9pC3ZzlXDme90miKFpNbnY9e8mlaL+E6aX27xtOqmWnGK7EXq0oB2kA1E7q0bZNTGqdl7i/dzBkFeTGrfodTb4X/PAZdSBSLLcQYq0wShQPjal0n+18Yils6tQZHLYwR31DkmqSz2oy/oiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714352918; c=relaxed/simple;
	bh=Tu9D+2NPsfNayYOgiQN9rn8wHC6VeJo2yo6JfyxNlbQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=q7FhBakFHvIfaUTIfVLnnVqzGIbmV+Mn8lyvq9A+FwC+288yAT+i5w73P4Y388yh3Fk0EZM0BNBOVhhObNkLL9vauln1umhrX0AiKt53xi0dqM00LLbISEt/h81eEKc0AFc0eX514T0XzX5D32F+K8/AlI0k8nX2/oqyFVBm4u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3wqTUT7; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3wqTUT7"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e3f17c6491so31998935ad.2
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Apr 2024 18:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714352916; x=1714957716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bvz19X/mAmzt3PgGq+TFbom+mP/aPWctu3H4YFDdrE8=;
        b=X3wqTUT7BtIWqjrZZ4kl4kuVVDfgRUZMfr+Cj9jLev033ok728T/GFlQCq60XR9dgf
         zIUS3P5jHPodYL9UcUH67ysqefNQBQz9ydGKIl4h3OPNTCfLDd/I8BKx25hYn8qNnDCC
         sHkMsgug5/Z9Lr6S2QBcyrILrNGWqgSiG52Dzg5+T+cDwMnaLGDEQXykMkoDtgZeNEZI
         WZjs+Ds7K1It7VJFBSomExYtG2AFSWM/DZUUw5s2BSjcM57reE5F+xiIB/dholdw4SRc
         TxobhOk7LWngyV2nj1aloY2w7OR+H5LFJHJBFeuh738x45Gk/COPyoLBNzfIiXipRLD+
         or4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714352916; x=1714957716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bvz19X/mAmzt3PgGq+TFbom+mP/aPWctu3H4YFDdrE8=;
        b=bLZruIKhZOyS5X7tOIlv9vsBnBHC8ppqJHMxOGG1ALAuSL91udPCfJHqxgr3B/gr4l
         FlYR6eMVW/4u+AGtJDaNYSgwfZ/VXfvcAKnlBt4PVXFuZIzkQ4+DoZZS2/+q2VfuZkEL
         f+Mq2DVfpaocTJ6h1OZeWp8nE/N8hJbrD75NtwLg/8OQjD4aQIHbB+JFucGJJr6cnzid
         KQ6rhEroRiux2aH7N39jPJJjFcQLK0zCwrv6BYShjXqkRzbZNtIwqL9vUOEW7DHuNKbB
         JvhbJ2C3q63GHU3KRPPx0pVy1pugUuVE/f3CZnVLE3QnPLzErR/bE5olHP3DILFFCSRi
         ejWA==
X-Gm-Message-State: AOJu0YyFAMUFujTnnnLkwi8rG7Gl+v80vvEBhOdNO/IZtrJXJrW5bE31
	OVipyZYfgSz/aDE3i699zdxZ1JfiQvjntoEefuzlJ7RLJBkY9uemzNs0RQ==
X-Google-Smtp-Source: AGHT+IErS68qGjRM5qxYhC45jaeEvK2VwzJNyCeGX3Dn+IMec5LAzuUCz5gFlHqA53I6qthAX+e/xA==
X-Received: by 2002:a17:902:d487:b0:1e2:1df:449b with SMTP id c7-20020a170902d48700b001e201df449bmr12180675plg.69.1714352915607;
        Sun, 28 Apr 2024 18:08:35 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id p23-20020a1709027ed700b001d8f111804asm19406904plb.113.2024.04.28.18.08.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 18:08:35 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] Update .gitignore
Date: Mon, 29 Apr 2024 11:08:31 +1000
Message-Id: <20240429010831.1453-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ignore Q editor artefacts and other junk

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index ae3e740..b544bb1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,3 +22,7 @@ Makefile.in
 /doxygen/doxyfile.stamp
 /doxygen/html/
 /doxygen/man/
+RCS
+.qrc
+cpp.qm
+*.scr
-- 
2.35.8

