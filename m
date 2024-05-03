Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668CE15251A
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714736130; cv=none; b=c9nv3EJnhcEl006FvgHK+WJikzE7afRmCx0uSmhQk3KXY9asHXI3hNGSCkWhVJmKmXXG1UJCfeVF21HQCZQVlsamFDQ1+lOUKTCkgSrhn8qtxPCMKExGQreh8zX5wXMJErs52TUuxxadUIM1iLUIcFgFfNyx9ffp7sXuKJqcchQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714736130; c=relaxed/simple;
	bh=c5+0ZcuPH5pFwb2hqFlG/GotqFsBHTqrOuz6u1ohptE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qanlQPQpSXNfkORpuwZac2IMch3xuErTi4ansZ+6A2IqOUy8kfFt8wYoWMJTEYr2X7ACbzg10hWwNL3I2vMe16+QtT5duY3xniidZf1PXYhAvPm7MPo5Jb+2kSbqAJZW7g3rr/PaEGfqhDvwf46m2tnRj6RtnEJHhNhi2hn03x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mE9jnVpd; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mE9jnVpd"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de57643041bso14931140276.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2024 04:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714736128; x=1715340928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lQO985nl790Wibor+XlZMKdFimoX/pDv7wmLKz64h5g=;
        b=mE9jnVpdP4nwndwzcjH4NZ64kSsvb7HwZUt5bLlee0WV8UduPoOzQdcrCjvV4aL3cT
         Kwp+bmLZ/HRsmDT2HLWpgpzLQmnw1ue9jOQHubYiGRMhfMbqn6dyVrSIgRu2mta4XwTE
         Tj8sWRCyra005rPeQ4tPNTwByzlXOzEvffBXuYCOE/amvj1iYABfd9WmGp0ef8rNMD4m
         Lj1Jk3FjWVpXwJ9Kd2LIEWLThzoX83yybftbIkGsWhnj6M3qCS1zsGhs22EX9kTEChSi
         if6kmdHzpqWM4LR71Xlihk0Z4rLkb+o1ad2w0SmOvb2ZyWZMyuT2dpI+ZQ866Vrxir7A
         maaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714736128; x=1715340928;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lQO985nl790Wibor+XlZMKdFimoX/pDv7wmLKz64h5g=;
        b=UEckTt24n6+ogAdln55SEUCY1PWNaZ+zajsHCV5zWg7NCyVNqzW0EAT5nsObKanh+g
         rJ8NRwjDzmAvNMTeAO+e2smSAAMJ+lDivFfU5QIoeDgQL9j6fjmYQOIMFMPf3rOSzvU8
         2Q5i0OvvY1YBUJhXA1t2ZWdTSDMhTcnJitdt5jy9eT3B7v7CK8zBQpnQ699CUUbYevoO
         nutT1Kr549EJRfPnrDYEM3dk1mwbGH/fhnE2AJsRt79LbUl6E0JfptxHk4UTjCqqsvxZ
         u0PQzrD+KSY46KAl/9ckCgkMBapbjHzYakllTriA871nIIYzlMqCBWW3Epl7+1oTr7Ss
         dV0w==
X-Gm-Message-State: AOJu0YxTk+xdefbKoNPZXFPR+lxMw/liJ3cnXuZl1RAbtqyCsqSTh4tj
	Y9yGDLrBFJXaIabDCWLqvh/0+5ODmnm2H4NpZ4W2eS3iZPn3tQW1eMSjx0LIW3Rgpx/OszFGj8Z
	qZ+eYAjcICNPQn6p1dCUYEBozDnnI8lILI0Bh+L7i2gKQkCbzHkDaMdblNf2jaZHSrzNh7jf1Iu
	tSFSGUwLO+8IHvXeMrhAsOzMmJVjg3PDa0qqNvd0w=
X-Google-Smtp-Source: AGHT+IEnj0Ld6CFY5nFVNAiqxT9VALNZ7skU4oO70ibvLtNnkb9dnbr8B6A+XyZUfKAwqLHtbS3Dfo7Ruw==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6902:c0b:b0:dd9:3a6b:11f8 with SMTP id
 fs11-20020a0569020c0b00b00dd93a6b11f8mr802245ybb.5.1714736128332; Fri, 03 May
 2024 04:35:28 -0700 (PDT)
Date: Fri,  3 May 2024 11:34:53 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503113456.864063-1-aojea@google.com>
Subject: [PATCH net-next 0/2] netfilter: nfqueue: incorrect sctp checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org, willemb@google.com, edumazet@google.com, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Fixes the bug described in https://bugzilla.netfilter.org/show_bug.cgi?id=1742
causing netfilter to drop SCTP packets when using
nfqueue and GSO due to incorrect checksum.

Instead of adding a new helper to process the sctp checksum, patch 1
implements the same solution used in net/core/dev.c using the
skb_crc32c_csum_help() function.

The bug can be reproduced with the selftest in patch 2.

Antonio Ojea (2):
  netfilter: nft_queue: compute SCTP checksum
  selftests: net: netfilter: nft_queue.sh: sctp checksum

 net/netfilter/nfnetlink_queue.c               |  1 +
 .../selftests/net/netfilter/nft_queue.sh      | 38 +++++++++++++++++++
 2 files changed, 39 insertions(+)

-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

