Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40891EB1B9
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Mar 2025 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740944263; cv=none; b=RpCJVMbPWEsw2ws7cHd9HFDbpaE/UtYK1l1x0je6GwBtvXWLVnyZHjWg8lpwJYuazqGzbYR6Pfryh9Ik2otSgOczgy+z3KvxsOGUq0GYsi2hneQYimO2vMDCmCGAa9c/Coxt0kefhN8lfRtD5FIc0howyRNffs5mShQY/kjBjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740944263; c=relaxed/simple;
	bh=X0GYYCJONC/mvf7EYnoQ9QBm6HP9Mia7eZolrrMOypM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eRofYoqvvXrw1HPC6IqpnT8sQwqUAgxoytX+bEjdKHctiab00bcSN3aGdI2y3ZvmYNQUKrxs1Ni/2ZLSjrcp0GgvsrFDKH8WLSdRac1CmjbKNJn3sM0jt+qJWEeQopcid6/s2DDG81pa+cY1l7B/8yHkkxLUwdjWfskqpYBhwV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXuwRF1W; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXuwRF1W"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-30ba92c846eso11226921fa.3
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Mar 2025 11:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740944259; x=1741549059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uFBa/LwY/dZy8wlQ+uu8jWlW90fnr+X9cgqjoxqzb5w=;
        b=WXuwRF1WdAMphadgFSStCGX55TPgOxBveSvNRjgrNKNZsbqMMQQxC/3v3wynXzhB0l
         /b4nyonDlpPpE0pv/KPEiWESBhoHNS7EzO42sJu0C1grY1Hh/2D8W5MnH86iHI0K9KEX
         VfEET2WWAPD6DV7a2u/pFhIOHE+PpDhC+9n0lrKj19+SMmELai8bf1GU3OGZlE4WiYHn
         TVFcXb2cwzB3oBaxXaFV08plNRoFXZT7baPxbpLoq6iPEjYn876HgEUTe28afEdR+xYO
         0nJvAiIA57wYOlgiV3CZDZ3ZxAuiciyRYqRFacMKtcDs7x7rK6bVQ5HGjYX1TGoEvjbt
         mc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740944259; x=1741549059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFBa/LwY/dZy8wlQ+uu8jWlW90fnr+X9cgqjoxqzb5w=;
        b=AEFPqSu+m2M4d8uG5V6oOlfnW42cvJX3Wf5rjuUXVBNFMp6VySjjU5RGrF3yoer8L6
         7ZVAW7cyT4cMRf9HgySYiZqW3ZSIQz2l97SxoDNAzy4KKXofhksQOoEuHD1iNCo8BgCU
         TcXZYTVSy9OAHO9XNqC6tLmAzt1cu/QgUFNrxGIJpIkZzsCFSNoWM9bGg/bo6Zt98a+r
         PzNOYaWx1swao6UNcMPGlbRYhYm7vSkZ5mwBO2Gax9+4HYYViHPMQ8kGyQOjQCt/4umX
         oEH8wbCZMgkqMz56PfRZrhXKv3xtDhOdQz65rpi9Z2nuRb1/dnA+cnyCyfVhJv1uzzaw
         TF1w==
X-Gm-Message-State: AOJu0YylPgGwv3/Se15NNy92ybABxlWnBY2F3KKysECkjaE3BewTarBd
	8yEivlTs+J+2iBYCJdc/FAkdstekzoKz3P6K+0FQvnvjmsMERHxVHj85nVgl
X-Gm-Gg: ASbGncvrSYd1aHpp1IVlT0hZWzCcNCuUPvwJafEj7Zk08F5lzf51etmObTOZdTHPh4W
	i60tRyZ2G3hYzZ8N5S1LaimrdAzRwzx2HNCJj4haQTLmOVvSDznEz7ggLLkKk558PQSMRmbJrN1
	w8gkXcVjUV6yNePWGpm/OX21jayr1n3mdy8IovzXoOdCNxlakVJu9Q8qtQbcGrM6sQarYjh9zI1
	PKqyDb7NO0PzDbuPI7CmjltU6PA4W8mrBhFFm0OMsjXy+hBV8H7Wjm/MXYQ2+k+bK49++Tvv7tQ
	cv8d+66LCQ4gIxxbhEaMm+DbqI9yIxM/5zPkXAVjSL8TplRJG283PVSh7fT1nA0QyznYAn7vjrq
	AMACLxGLocl0asyq/3Vwz3IDih1o=
X-Google-Smtp-Source: AGHT+IE6kPMts9a2uAw9LManEWjpd2hUoN7iy1y3wgiTic0o+PwWJygJDUItoCMHq1okRBjrUABKRw==
X-Received: by 2002:a05:6512:281d:b0:545:56c:36c7 with SMTP id 2adb3069b0e04-5494c3521famr4441592e87.41.1740944259244;
        Sun, 02 Mar 2025 11:37:39 -0800 (PST)
Received: from astra-student.rasu.local (109-252-121-101.nat.spd-mgts.ru. [109.252.121.101])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5495df758a0sm336657e87.246.2025.03.02.11.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Mar 2025 11:37:38 -0800 (PST)
From: Anton Moryakov <ant.v.moryakov@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Anton Moryakov <ant.v.moryakov@gmail.com>
Subject: [PATCH] src: fix DEREF_OF_NULL.EX in rule.c
Date: Sun,  2 Mar 2025 22:37:28 +0300
Message-Id: <20250302193728.665764-1-ant.v.moryakov@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 src/rule.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 59d3f3ac..5e04a922 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1556,7 +1556,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 	const struct set *set = cmd->elem.set;
 	struct expr *expr = cmd->elem.expr;
 
-	if (set && set_is_non_concat_range(set) &&
+	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
@@ -2423,6 +2423,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
 	case CMD_OBJ_FLOWTABLE:
+		if(!table)
+			return -1;
+			
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_flowtables(ctx, cmd);
-- 
2.30.2

