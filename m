Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213E1E3DE5
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Feb 2026 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771175104; cv=none; b=NXydJNi7nis+3LOtJGo85NxFDr9lcqQ4piScAHz+yS6D2m7VTRfkmZGCBywL1ywb5MHig/KJqUDUbA9HTIrS01JR9B0f4LeXHWEcp/g+r4H7dBCeDiDQqsR94uQApE2KNnKNwau8GcxMSuYZtbFOpfM7+XjhsUX5iQfPYWrgp7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771175104; c=relaxed/simple;
	bh=f+Tyh2hLJ+Cne3xUFe0xnTyFnLfXyVQunrlA9JTEsbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JkBMz0cfdBINbTdCqK/f0E6A5AEq53JRnsm5mCcSMb3emCM0UCKGuoEncFtvw73Z1hK79HICXCNiGiG9ioHYiqBhZ6FdnrM+OzXrBNmhl76bhfhi+rgce+lsM3K9ZdEj76C4S1bmgGlGw2g/KEAE0WslP/VBPeiyqLSwlhfy22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai; spf=fail smtp.mailfrom=sleuthco.ai; dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b=ghzfrOo7; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b="ghzfrOo7"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506aa685d62so11900941cf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Feb 2026 09:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sleuthco.ai; s=google; t=1771175101; x=1771779901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HPsdSB/iF5HKTkmUBRnibeO6Imspxqd/mhWEIPbcdnw=;
        b=ghzfrOo7RT5MGmw54Qzjsduq/+hkCx+xmAIh17ykwEpBdk28H6ksdpgWDl3UXLIjFP
         4lU3a0vIJGOiIumtVHOkLlhoiFOwjYOWyvHEyz7cBzAP5uaqCG4LZ0iLbB0ddRfJYWWE
         Dw7z/NtyFaKOupgNdlqi/fWtUBVwjgzXdq8V9pF+09MmWYY5MQ9Jy/URPTkZeNLDYqIs
         nArTq/MhEUTaNq7RTcAofMrU095R/kgMa7Y0WSxrsPI/mAfc0fKozGPRTM/qfkP96NGj
         PSrjAI8HZQYQvmdp0YkTNj/AFuWoqAWlVt31BE4Cfm+WMdiWwWYO2bwIUpG692DHQuJa
         06cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771175101; x=1771779901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPsdSB/iF5HKTkmUBRnibeO6Imspxqd/mhWEIPbcdnw=;
        b=Lj9FRUhbguFn8S8MKsgJl5H76dWFaoqzB6zmjSnVa4dgJjfkqXtY5qlrxfM8BKLKoU
         p2mWUJG/+zuFzDr3TVHr4DJxqUFbLXkcTAckfIbepZeiGEAfSyMi9Wjr3GgOiKsoYCkk
         N/s6dCMomDtLZr9ttGAMDEtWLCeTl8joVjIgLQme+o+WQAP4E6JeCS5CBB390F7+l2RM
         GW+HI+JJcH1RiM7ztd+e2Z7iBMydsU8znUMYWJTCJPgbQfQrcAVksuyDQaG4mx5mSSr2
         nuS9hw7zJ0B6GU4YBfu5muYKGK8/1ba45LhBdBgkX3UR6KQMcD3lVf0xXqRU6hEQ2JMf
         ZaPg==
X-Gm-Message-State: AOJu0Yw9HWhv8WK1/PmGk3xRvAkuNJ0qb8YKPofab+uAFoRU2r6Ut+/2
	NEniks2K7EUhs0mheA5eBomKP4eYluMyzvleLPQFImMtvFToHeDIcz9kKRlpbphC+ZK1ACENdRu
	0hAab9n8t
X-Gm-Gg: AZuq6aJL5JGhFrOWSx4bT6dGPhHqM25waFlMrxYLhwyzhdd57e7vu8AjoiKD+Fv7KQ+
	5L4KzIcFuj/RafW8zlPUrhoWnZX8Bnamy3x/Z58htmkdeXR59Ho7HAYZgFPVzDp7rsCFubXAfqS
	sBcVDCb1RCoeMAG7tSdfCBi+ls4/B/wBc4526+oFfgaTt3VE8EdPlBMV1N7y3CwADLVOCJEg/5n
	NbYBneo2wxYx7AhyDM8ZXkzCKfnbhSI8YcSrxXeiEEEFScfIGD2ou3EPWI1nywfRhN9y4Xf33zX
	gYgJqIpmbB718SoPvArTZFATQCFO0201cqZjQ73xImLg/ONLLekMkHBIo1ZBrzlwjAYK3/rMOYU
	tLZ9J9HnvLUOG36EqoZbNuPx+YA5IFPDraFVAVeSiDayXPH/38F4yLerxjqeYoK6cV7PYAeRRcl
	E0wzImWbb2U3fbsxb8eO2aYawVIVbXvnAReFy0xIE=
X-Received: by 2002:ac8:5713:0:b0:4f1:abb3:7571 with SMTP id d75a77b69052e-506a829184cmr102136821cf.33.1771175101367;
        Sun, 15 Feb 2026 09:05:01 -0800 (PST)
Received: from localhost.localdomain ([2601:195:c200:c890:8d78:275e:d0a0:a365])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506849fbb9dsm118789881cf.15.2026.02.15.09.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 09:05:01 -0800 (PST)
From: Alan Ross <alan@sleuthco.ai>
To: netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	pablo@netfilter.org,
	Alan Ross <alan@sleuthco.ai>
Subject: [PATCH] ipset: refuse to run under file capabilities
Date: Sun, 15 Feb 2026 12:04:53 -0500
Message-ID: <20260215170453.20653-1-alan@sleuthco.ai>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refuse to run when ipset has been given file capabilities
(e.g. setcap cap_net_admin+ep) or is setuid/setgid.

Running networking administration tools with elevated privileges via
file capabilities exposes the same risks as setuid: any environment
variable or file-descriptor manipulation the kernel does not scrub can
be leveraged by an unprivileged caller.

Add a guard at the very top of main() that calls _exit(111) when
getuid() != geteuid(), getgid() != getegid(), or
getauxval(AT_SECURE) is set.

This follows the same pattern recently applied to iptables
(commit a2a733e9f0da) and nftables (commit badb2474ca8b).

Signed-off-by: Alan Ross <alan@sleuthco.ai>
---
 src/ipset.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/ipset.c b/src/ipset.c
index d7733bf..fff1ca6 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -11,11 +11,13 @@
 #include <stdio.h>			/* fprintf */
 #include <stdlib.h>			/* exit */
 #include <string.h>			/* strcmp */
+#include <unistd.h>			/* getuid, getgid, _exit */
 
 #include <config.h>
 #include <libipset/ipset.h>		/* ipset library */
 #include <libipset/xlate.h>		/* translate to nftables */
 #include <libgen.h>
+#include <sys/auxv.h>			/* getauxval */
 
 int
 main(int argc, char *argv[])
@@ -23,6 +25,11 @@ main(int argc, char *argv[])
 	struct ipset *ipset;
 	int ret;
 
+	/* Refuse to run under setuid/setgid or file capabilities */
+	if (getuid() != geteuid() || getgid() != getegid() ||
+	    getauxval(AT_SECURE))
+		_exit(111);
+
 	/* Load set types */
 	ipset_load_types();
 
-- 
2.43.0

