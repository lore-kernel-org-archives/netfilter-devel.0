Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE3A84A30
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 22:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637639; cv=none; b=SO4ic4W1/nkjLhQ1EHFiD981N/eDKnJcf5ugJVlIN5xoKBqXVeXw5KkJpNw7telWXwzOUvLvhHKo27Icc2drJMTSn9LIo/sU7kF8TYuuJIcp6vnh2HVX9CyBCAYsDBhJ9D12mu5mA5HlImtmU4jxmDR6GLL5x6HZ+otogdIKgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637639; c=relaxed/simple;
	bh=j5ReI+dkmLfYL3rhf/NbOzaERYSzmKe+G8J3O1wgkWk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FkoCYyuRrobXQqJZatKTxmBLrTIO4UvvME6B2K4Hq0SELVaSdV9kziVtdPWStAbQhu+On1UXNSy/+t0fMrx61thTSASo61VzJ7PidJK6GP7psiEmnDqutUWbygjHCdUjIKunhJ/hNx9zDGruNYjKknjtXztd8KcVW44/hzMi9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QQJ0LnVs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQJ0LnVs"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dee8315174dso3031221276.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715637637; x=1716242437; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G/WEADA0knahowoCwC0UB1tfsTxvAlht8Q4CeXdnap8=;
        b=QQJ0LnVsvqNWPdv7EWjZtImVoxdxAmw4OMYWm7O4ecv0xSJHHKfMfOMTuD+wRg9PU+
         oMkJyDPKmeZNFB2NCvz8UGyDkl9hON5kOYQ2pMYIknaFzQMDtQeRiatkoIWI3uYHZePY
         5Opo/91LOcKnn1Mx536BM3GFYkMjPg6XoZI+v5k/5gqQI4hDT6wT5yQKn5vjb6muhc7m
         amRIr2JRyWq3r7mgyzMIr4IDJxlDhl2OTJAbv76ZqXMT+Qdo9dPlNOiIZsG002JccSaD
         0GLRqY4E3ofG0bXQL8KVbIZYkB9tSHoOjbS+7KVjwiH8oAnsasHl8NGfM7DFqDo5VMgI
         17aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715637637; x=1716242437;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/WEADA0knahowoCwC0UB1tfsTxvAlht8Q4CeXdnap8=;
        b=B31Ygz1NtvqZjLe/0511CuMlRwb/AnWlWWfxE7vBP9+g+pQxtHVhL8EF8h2fcdiM+g
         O3NyMo49x/i+eibkl0JuAzuBwAOA/ck7lhnHZZY/FFzr5J5qIsJal+58y1NZuL17LSLq
         t2MCQZotYVItia5u7GkerYIYJlmXlswPqaqKKXVOsyN4UACPRIM61cQdoLWs3BMY+bvD
         TNFEafhFCwC4N/8f7eex4fWF9xdXuqYHpBiaaC6NYbJyn3Er02eAztcwawuw1oOYRQA6
         0tOCP/bIs9AfZ/zzmDMq2vCf2udV29FGDhNPI9ZFnvUsfvne16I65IiipSBOuP/6fnFQ
         1l9g==
X-Gm-Message-State: AOJu0YydFM8035/9zurKnAXZug/KF83mKTvf/PFDoVwt/FRLzyOKLk/g
	peTHRBcunCg4TKt3ntTTww3d9m7e0LKdnvD3ljhf89f2rjZ5f06OsRYtn3i5dvKQS7odS6s2VGz
	1KbuSIwO0IgsBt4M9hVTdLlYZzhGr6F0SNurTGH+YlhvTe2PdsftJ8WuS+zP1ICC5ulU3idmQZE
	KaAbi2ZZyBtCoyRcSn6Pyz7ihSS4ye10qpo+imHEs=
X-Google-Smtp-Source: AGHT+IFppv/DXCuaCRDVagTK23L69Tmz+SDRgfKqMfzLkWpFE7tvXk1v9kTuHzxt1hZ8tBNTQImL4QphSg==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6902:1028:b0:dee:7d15:e987 with SMTP id
 3f1490d57ef6-dee7d15f1famr1235770276.3.1715637637267; Mon, 13 May 2024
 15:00:37 -0700 (PDT)
Date: Mon, 13 May 2024 22:00:31 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513220033.2874981-1-aojea@google.com>
Subject: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Fixes the bug described in
https://bugzilla.netfilter.org/show_bug.cgi?id=1742
causing netfilter to drop SCTP packets when using
nfqueue and GSO due to incorrect checksum.

Patch 1 adds a new helper to process the sctp checksum
correctly.

Patch 2 adds a selftest regression test.

Antonio Ojea (2):
  netfilter: nft_queue: compute SCTP checksum
  selftests: net: netfilter: nft_queue.sh: sctp checksum

 net/netfilter/nfnetlink_queue.c               | 10 ++++-
 .../selftests/net/netfilter/nft_queue.sh      | 38 +++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.45.0.118.g7fe29c98d7-goog

