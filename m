Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AA4313523
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779549988; cv=none; b=B7HEDI+81GA6alYiLf0CmgVVjMSFBQQv03b93AvmhbzPhox8A7AX7qcH0TzgVsB3SNICCaYwekt+RHTMpEz8HQ46TRIE+lf68pfed7cc/kydSG8DvqGZgKBAzDghLesQha16DuAD//xPT5MRgsTyTALJCxNc1+1yUHUq+NpUT1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779549988; c=relaxed/simple;
	bh=+W0lClMlP6AGBczS6QM9IYnRqQO8vnGqznmuI/qcPjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CwlOeKJ3yUuGPHjfOkqRjlPkSJbTlFOLVDBJAdUDB6AHlf7AR7WTPv/03qdvvfeUXbT16gfBgbePDDrJUCCpwbmy2RK3Q+6jgo9nTQdoT73F/hDyS3wEBJj7oLKRxcSnnnz+bu+l5vd2SNGNunPtT3nzNMbxrOG2i5TPNCkxhFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OvMgPCmF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OvMgPCmF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490426d72f7so16141075e9.3
        for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 08:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779549985; x=1780154785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GR+4fL0PGlkXhCcZaGs/e5Y6ZryBZ08nVorvm+PvDxo=;
        b=OvMgPCmF2x2bEsnQAPmtt3fv4szcC6KOYwMnjZ/Y1CMzU/tdnzZT4qLrSJmecflDlg
         XJT1JG1qkzfMipBDMi5LimhzT43qKlUm782jfYsh2a7j/MSW3qnoI3bQO7RnBDBDxQbO
         l6AQzpREySszKQiYeYOIb5xt7uUckIHDEZomQssFR7WuyDGXel0Asq0lKHLtplcjkWt7
         tzf2gus/iFAX995hWWT0On3Kxfb7U0M93s30rhbulSrJcO9A0vCk7znIR1qdIzbC6t+O
         DApFetG4JJ+XSRF0K+u8M+NafI0KThxXgrVYv5roYgFCt/xAj+l3mENLC7d97KLAQREB
         nFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779549985; x=1780154785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GR+4fL0PGlkXhCcZaGs/e5Y6ZryBZ08nVorvm+PvDxo=;
        b=SUHTzRpxUi24+2J5drl9PdXSJHyLxZ37PiTKoAl8lTkLEdUsR0rGTe/VXEAJEhP9Rt
         dFCQgKJxs8UZA51Osv7WNLfvAiv2929bgrLBwaGx5K4sGWp+9u1UEegnzUi5ZSQXQpIL
         hdHh+qf8bBH/PKnabsLCXcFKfUXjnpc2KF+QQbkZTU/ekzN4oenmMmdcOe/Ahj6vQBMC
         vtiZm5TEBZVM25ctg3c87+h4t+Zy1J30HivnyaEo0hNfRay3qmOvmYLoXUnI7MUoVGwf
         ta479M3KJku/po3YUhg+fYV3X8EA3UMkS+Nr13YKNe/Q1xsV9fAE4PNS7UbwOLQYFtZg
         +onw==
X-Forwarded-Encrypted: i=1; AFNElJ8GusPZp4tyPGheIWRIxbU9ueisZTD8pkjhpAB7AIL1HHAaI6p7zoQD50ANBXEVTXgOyoDWa2FuM1TiCFVf8hw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVcHaoUePa65lnzxmV85ixj3buxPDL2CD0BqGlswoQLdcVKeAZ
	QVn8dcXBiDOBWNNS8bMV/it9ZwhL/IVpVNdlUEsDoT6JFrIBT9vLfoD6
X-Gm-Gg: Acq92OH4dof0w84a0AnM66fFsyIbXYrsBBwrpyul3dWUyTpzUkn5r7xNKHwCpsnHZyp
	gTVqYMoT0Wa5WjRoXKpHQXbqRj3d2Rgsv/w/sHAQhcpLTSlhFaCf7Rk+3lYx7JwDkgEv07rEmCU
	B2ZOOMnsA4pVAdIfmkQmRKTbhIZxKRfFWxjRdIZnO9sc8rpgrAH3JxdsVM8frAeshRM0vs5ihQd
	XhrC8HItxm46PbHQlM+jS2YryV3aHrFxkfWaUseMeBVH2PqMsSI6l6ePTPn/J11bGX1wwKoLkmK
	78SAWX9LwKKOJ9D7Crv54l+v8qlRcC1OscdVpGPuGwK2GfYio8e29idAYR4kJYeC5D4HRGmHrop
	i64HkCUFUGg7WPlDrCGzkTq+Dk4a1euLqtY38OexirePxMvUEeVlkhSncvZwrBljLQRzNf/UQwa
	ttGH/8XUBRuFCGSdpqMOsMQAh8+n3EXCi+NeSRaCYaW5I5HFLbQihNNy3WEQNfg17IEtWF1ooa3
	4FOI73jzGco5KOchdnmdw==
X-Received: by 2002:a05:600c:4fc9:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-4904248afc4mr109914165e9.3.1779549984777;
        Sat, 23 May 2026 08:26:24 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428f6786sm48617045e9.25.2026.05.23.08.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 08:26:24 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH nf] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Sat, 23 May 2026 16:26:21 +0100
Message-ID: <20260523152621.58576-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
decrement still happens and wraps it to 255. The break only leaves
the inner switch -- a later path entry can set info->indev back to
a real device, and we end up returning with num_encaps == 255.

nft_dev_forward_path() then walks info.encap[] (size 2) up to
num_encaps, which means an OOB stack read and a bogus count copied
into the route descriptor.

Should only happen on a malformed bridge path stack, hence the WARN,
but worth handling sanely. Move the decrement out of the WARN.

Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 net/netfilter/nf_flow_table_path.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 9e88ea6a2eef..6263e07a1276 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -163,10 +163,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+				if (WARN_ON_ONCE(info->num_encaps == 0)) {
 					info->indev = NULL;
 					break;
 				}
+				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.53.0

