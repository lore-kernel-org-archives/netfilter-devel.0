Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F9A32BF52
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772904252; cv=none; b=HRWH9HlTuqPCZeLHubsAmXUPX0XGnr0Ylr+D9tidZrYXv3LNtNeiT9K/Ai+YhcjMKSL5ChvrRCC6LlDE7z6ajwlwBkTd341rV+7DksE6Q2wYF7sTQoTOwewXkH1/q9/uATfVuiNsW6advZegpU96kNZUKHTcfAoAMKyBO22FEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772904252; c=relaxed/simple;
	bh=gZ+JzdkG3tpp5v5mkGmBvNixpFXUOmaqnsWndspvqS8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NfL8c8jtLM1xNCXtW//E8kcHolwr0qcXcekZ+2uz2xzKotmRECV1CJ+w9mDq1+ZoTD2fZgOHxLV82bcxIOCqGWhnUFA7OaujHrsXgCaWzYVSPz2du61ZOB8lqat3H4Qti4hPJ2t5QxJnHUeDC6uoUog0wdHTM2A+QRIstSlllvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EVzbHH5m; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVzbHH5m"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-823c56765fdso5223102b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 09:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772904250; x=1773509050; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mkxoUjDwyEKhbXBPEFB5Rnx4oGaKmH57R3vhYiR1yRk=;
        b=EVzbHH5m5ph3K673go94pRukmHUCL4U1paVgy6Uqr4XtKOJCDAYay5PQez70MIAi6D
         5q0BZK85nEfrb+C45c35ygA5hFN/ZqBaFIG0y6s3ntnab0HZ7par3Ae7TDtluu5qWaVk
         zJ4CAq/JfLzHXtFvQ2W0QH07gokFQp6pfPeg5ARXnFOYeYm11Y8ECL+dpItbClZD6GTx
         V2Z8SfAfqOVLdGiiR3Y35srzTDfGG9Ovif8mPFESDDzt/nJS1hbYJtAH3YqIoxumc6AB
         bMP5kqKWTJCklEHgKYsVjRBuUvdGMpwTOv27BBGDUNTCX7Vli5h7XfaIqDDlzv49TzdW
         GqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772904250; x=1773509050;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkxoUjDwyEKhbXBPEFB5Rnx4oGaKmH57R3vhYiR1yRk=;
        b=Xxf7t8SBytzbh9sufZ5QeaM1Wh7ONocsfYNGgA7aGe7mPAIVwlT4vZjrl9kZtuz7Bm
         CckZLwQ/AfHOAZupR/jqOLiBYMaoxZVnDa69Qkp4flA77lpjKxjf+hi3ZTZ0Qhtwtsn+
         y/PAtTSIB8dX0W9yqiqRhvRDsSf9vQ6j5Yk/izYL481PR3Fi2nfEBM7M/+Ap9v2yT+51
         uDU3Zt4t8vin/+dbsvjAVKRCD3UuFHWPvnaYmlQ5H9e2XQ62z/CPnZkSI+MrZMaHxdyu
         qwbyZS5PFCC3z2EYEPZQHwV54AYvEXa8FTNiqrhSrUsEAWHleoMJA+NoHMfCx4Y2A0n+
         obgA==
X-Gm-Message-State: AOJu0YxOTB2SfBenffA7NbADLWChgbAGOD8zdHTIW1sVoedIa5YPDBml
	8A19vt0QjEXPCwc4OwBJxbix6RXETgszfSP2fp98NztAbNBXy8JZaIhP
X-Gm-Gg: ATEYQzzHWf0VpI+4bA0jvYQqYbdHpBCIRO1bxTUk/1KJYXUvvfScpFhZ7qEeDHh4bBC
	ehRLFQvgKbWv+si40GjT5jSlaknPJ1pAg3eYz7x/3y5fw1oZicD4mVUr1Q2kVqxKQiXsMyrwnm+
	Nwe9aB6d+BR9sFWvbglxCCjZPWeLSXp5O5lYwjAiXUcnT8NwlAsDA09rR9Eg54Th99c1YcXCkU7
	ufrboS2l+fviZ+lk1vX9JcK/RqZFeevdtCw8AHhdHR8jlqNNTruQTkJx6Z0QmI6PxidXURm1+WM
	PiE2h7AvFNnW6BGLm//MymPifxJLemXPvXxJkYVekUyHHxoh4Bs32yqKOzbsbJNq+4xkFzlk7wV
	XaRO9aXCPntD2b2a2ZbszZ3+0FspVzKGnJed8g+WdY94BfebvTtjimKBvZVmnJnIp2f4hrhwmmP
	6wnL5+WH6ycgrxoGg+MrgXDshl60/oYsKNeQJkc7ChYA==
X-Received: by 2002:a05:6a00:2d1e:b0:827:3845:921 with SMTP id d2e1a72fcca58-829a2e16119mr4719509b3a.27.1772904250125;
        Sat, 07 Mar 2026 09:24:10 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a4636973sm6437528b3a.3.2026.03.07.09.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:24:09 -0800 (PST)
Date: Sun, 8 Mar 2026 02:24:06 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net] netfilter: nfnetlink_queue: fix entry leak in bridge
 verdict error path
Message-ID: <aaxfNvmoiil_UhY-@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

nfqnl_recv_verdict() calls find_dequeue_entry() to remove the queue
entry from the queue data structures, taking ownership of the entry.
For PF_BRIDGE packets, it then calls nfqa_parse_bridge() to parse VLAN
attributes.  If nfqa_parse_bridge() returns an error (e.g. NFQA_VLAN
present but NFQA_VLAN_TCI missing), the function returns immediately
without freeing the dequeued entry or its sk_buff.

This leaks the nf_queue_entry, its associated sk_buff, and all held
references (net_device refcounts, struct net refcount).  Repeated
triggering exhausts kernel memory.

Fix this by dropping the entry via nfqnl_reinject() with NF_DROP verdict
on the error path, consistent with other error handling in this file.

Fixes: 8d45ff22f1b4 ("netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7f5248b5f1ee..47f7f62906e2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1546,8 +1546,10 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (entry->state.pf == PF_BRIDGE) {
 		err = nfqa_parse_bridge(entry, nfqa);
-		if (err < 0)
+		if (err < 0) {
+			nfqnl_reinject(entry, NF_DROP);
 			return err;
+		}
 	}
 
 	if (nfqa[NFQA_PAYLOAD]) {
-- 
2.43.0

