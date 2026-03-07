Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE51FA59
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772919758; cv=none; b=HBIrjQY4JmzWPBVhA3KlEWZ/Rvwa0F+j0kc0ec0s0/5TGrWK8/UlirmwRnKcSTDlP6a1YfMPloYVExvSVXOQoSHO8heDDZOfwNBwKSwH0b5peze0EV7qCCZ4K5YFHZ8L5GjlDl/L5lgCsU6yrdEwSAiUQKgM9F+qfo2HZ0mOB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772919758; c=relaxed/simple;
	bh=JBmYqYj+ly1oO/Lbkh369Gp9ml6cCcDXXpGPuv/yl8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSFwT2XSqiJqWcr5wStZtk/Z1ti0yTpyDDAmAbR4PlED6HCkZy3PkV8L5iubAs3TNQkB0PKzOZQjzszFJMFvzLW+vd1AnXyrc8iAYcxZDBl4sUEcgwfgnw6aQIQTPz8WS26c4N7jrIQo3xdie8kxJHbOqHcIK36bJGJMHuuFjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REAI0K8C; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REAI0K8C"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4807068eacbso87081775e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 13:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772919755; x=1773524555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBmYqYj+ly1oO/Lbkh369Gp9ml6cCcDXXpGPuv/yl8s=;
        b=REAI0K8CGcnL0Ol3GLnYuc/P9k5HbLqtrJrzjJPqTLgbu5a3r4HwJv/0ZRcoip1wSn
         MKquGoMO+KZ/tnxLrDW0xOUMnwkK4DEHvSvfCACfambBqVhTYoLlGChmKOqzQBGm22yO
         laRTue4f3qLL43RNYbGRna2uepnCgbp3gXZCXeFmSuKjD1HKq3z4/BNkBKp61WsLaKWo
         QON0zmui/HwGYHWN4eJMoqaDlm1FNpYmj91tY6IF7VWmB5Y9ZtyaHm9a7X2HU1bT/AtO
         0YmiYglqWo3r6YBIzAADWUpm3/e/+qTIcOJfNnvj5b/w5+x4iS623z/bQ+TWXDevJ8Qu
         YXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772919755; x=1773524555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JBmYqYj+ly1oO/Lbkh369Gp9ml6cCcDXXpGPuv/yl8s=;
        b=UefZ1SAMDdb3nD/MxTg4JyRkHUt34bAqCSaM1V3ewYubqtQIaDwz1nTYjAaDW7tEtO
         fCuQwe3kKMLBQ8dxn4YGhOLO4WVxi9nm9S3gJVy4UH+LISq73XYmJbVSBQBdNgNiNTQJ
         cPQfEK8AfBdJ7qephO/ZijC+u4mgtFhUYMk4tPvzw43IsHa6jsUT7yl/6kYmWI4exiIw
         9ol6h/W8KgARJ3QE578kg3cPVazmR41AqhZcM61gtw3rAz9kP48TS7nif/BxfivFxyVR
         Rb8JQY9B4cozHW9moiq23xlNYE2btLbpEUuwYmwYDHHQwurpEfON4Q4ULpgOlzBuQ1L2
         rXOg==
X-Gm-Message-State: AOJu0YygHCPbffGoFY7U077EbEaPs4sAd1hbDKG2fXzKXuZTYwSB9Dbv
	TPOxJEpBwryogVAfap0Fq4LGcfKZ8xT8FcfyZuCRKuUa+UNMeCktS2oqFp4h+Q==
X-Gm-Gg: ATEYQzzWwijptG5Kp/cGrZCqOYaqiENSuxuExuNQnnJjlBBK+CWj0JX+hdWkonYIoSN
	PtsJorH7eS6lqA302zeqROMLh3eeCTSIZy4DnuoTqZfG7mCDLteK9/riIn/3/UN8hyfMAfDs1eO
	OxcEl3YmNyBHIAMh9x9kG/iNVR/LbZw7kMfRfE9jxwIAFrsaZX1JCFYmKaOYObvbvAXS8fwwfqf
	uso2JgwgE10G/reYHyAAMyeIoEmwqXKN0Ps/y6ep0tInijmqf4JbzaqVfCoOdTlFAE0GdJWGFtM
	8buyDYOtNQNoP42ontW9X5Sdb1vUrsBw9vv6fjgGk+f8aMXLsJRqOBKe3aFMMPvO0g+YUJvkrBR
	2Gq1ofIQi5UWgq/pZpT5ZlH+wSHer0nZ5MZ2QCc/JaZGNeH9xQecY71XxQCD+EUuPjfbVO+HHUV
	QQf4DgETutQTCUfgTiDLTeD2LcQg1Pwm26ehPjHMaI
X-Received: by 2002:a05:600c:8b8b:b0:485:16d8:4741 with SMTP id 5b1f17b1804b1-4852690f681mr114837635e9.6.1772919754941;
        Sat, 07 Mar 2026 13:42:34 -0800 (PST)
Received: from localhost.localdomain ([102.164.100.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851fb3668csm350404515e9.13.2026.03.07.13.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 13:42:34 -0800 (PST)
From: David Dull <monderasdor@gmail.com>
To: imv4bel@gmail.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	David Dull <monderasdor@gmail.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path
Date: Sat,  7 Mar 2026 23:42:15 +0200
Message-ID: <20260307214215.1499-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <aaxfNvmoiil_UhY-@v4bel>
References: <aaxfNvmoiil_UhY-@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Hyunwoo,=0D
=0D
I reviewed the change and the reasoning looks correct to me.=0D
=0D
nfqnl_recv_verdict() dequeues the entry using find_dequeue_entry(), which t=
ransfers ownership of the nf_queue_entry to this function. After that point=
 the function becomes responsible for either reinjecting or freeing the ent=
ry.=0D
=0D
In the PF_BRIDGE path the code calls nfqa_parse_bridge() to parse the VLAN =
attributes coming from userspace. If the attribute set is malformed (for ex=
ample NFQA_VLAN present but NFQA_VLAN_TCI missing), nfqa_parse_bridge() ret=
urns an error. Before this patch, the function would return immediately in =
that situation.=0D
=0D
Because the entry had already been dequeued, returning directly means the n=
f_queue_entry object and its associated sk_buff are never released. That al=
so leaves any held references such as net_device and struct net references =
alive. If a userspace program repeatedly sends malformed verdict messages, =
this path could leak queue entries and eventually exhaust kernel memory.=0D
=0D
Your change fixes this by calling nfqnl_reinject(entry, NF_DROP) before ret=
urning. This matches the error handling pattern used elsewhere in the file:=
 once the entry is owned by the verdict handler, it must be reinjected or d=
ropped so the resources are released correctly.=0D
=0D
So the logic now becomes:=0D
=0D
1. dequeue the entry=0D
2. attempt bridge attribute parsing=0D
3. if parsing fails, explicitly drop the packet via nfqnl_reinject()=0D
4. return the error to the caller=0D
=0D
That ensures the queue entry and skb are properly handled even in the malfo=
rmed attribute case.=0D
=0D
The Fixes tag also makes sense since the leak path was introduced when brid=
ge verdict handling started using NFQA_VLAN/NFQA_L2HDR.=0D
=0D
Overall the change is small, consistent with the existing reinjection model=
, and addresses a clear ownership leak in the error path.=0D
=0D
Reviewed by : David Dull=
