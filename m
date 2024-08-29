Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9346B91;
	Thu, 29 Aug 2024 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946482; cv=none; b=eNed2XQMQjq9hGx+BlHKQR/cxxMOze7Wk4mkVaqcIpasGsHaDIQ5lbg2AViNhv6RG8fUOcT4K0UTtO9gk+El5KO4NLH770FbOaViQnTRHaZkv6V4TtLnw3B3V1NNX+otmvPL/DRTndJoBLbCc00hcIknmk7PG4OoYXCxbsv1SZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946482; c=relaxed/simple;
	bh=IYol8vffAanEehdxKgQtxRHvFjFEN7AzetmvEjAPKag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FPiOtlJT+YflXwLTzhbG5nFxLk5s4y7AClk+KPupgtOaFwIBtZkovV+DgBWGraWxeRcKu/gQIlUnkcr5KT0uJsoaUGpWgXKE5SB48Hv5wscPmN4rjWxtSNqMiLA/gB8RGKTVcY9KeNlG40XQNLVfGMsmxKfmdCt74BFZCAd2HKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgJZYa3b; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgJZYa3b"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a86cc0d10aaso99920766b.2;
        Thu, 29 Aug 2024 08:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724946478; x=1725551278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SJLR2r7hoLlycJq5mFtOxpziPrZr+jGxDXRczrn6yWg=;
        b=OgJZYa3b4bUaliaI22GShujl7ma0e7UgxstQ75+UNeaPf9L36cKJ8GbTmjr4K8kml3
         jCH3NZap8VQlq9VOwLddKyTdRhVBfmCYP+ruAc4n4wcD7lWLgu4YsUkjgr8hAEnWW095
         qN6op/ku1NboKPdNaLtKj8h50uXsxTquqhTyZPq/27g6lCLLrq8tSy4qegYOgffaXvrH
         /kdQoZYaJTTpj3iadgn7RFlyBk8vFNwFcVV21PCEoeBB8mFm2OwcIIws7TIsfGYz/CAM
         tbliIr3dOoNdFbyUY5rMRh8NOeIuJPZe96XxZ/t9q9z6j+9wa3yYl7H/EYZdidOaj+uA
         wA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724946478; x=1725551278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJLR2r7hoLlycJq5mFtOxpziPrZr+jGxDXRczrn6yWg=;
        b=wqN7RB7in3MUyaidH9CeTmoeso41tCUJ7pmor6LYw4OMMNr4GHtU9f902vnJaSJY+n
         Zu8bnxjqiuPioybQLkYAz0uumc9R6kBDO8CDKGO4Lkc3Kvk52ZzRslqoKsh2jqTcUu5o
         HtSEaO1H5lAsmcnHxvGmCxVXDu02feawo2wsZ39srs1BaBs/aAHGSLEBHnA1sA00ghek
         5ypf+175EvnVaAD2XQZIF8eOGJLntFp3Z/2yhv9dqKfzzycc/JkHofUy/Zuo78ykO27C
         c4nQ2NAaC+Ajf4Wz00j5AXZYx2n14qG0n5rY4aQH1jI+MxG3/WpCdPcIh80Y1KNE56Cs
         c3dg==
X-Forwarded-Encrypted: i=1; AJvYcCVAL+5TdnMmLhBOEMDJXu4vgEDjaxiMLifniGWUR9xkE5kthHw3NKNtWNLr8yhUjxTZWw26keSHtXtZMAk=@vger.kernel.org, AJvYcCWgpT2dO7hAwKtEVWRn+siNYAAAfgJm6mYLEXxAGAYd0OtNQ7L8FD7SKPuj6jL0Wa3my2nZEOgS@vger.kernel.org
X-Gm-Message-State: AOJu0YxxE0WqMvljPpm9S0F3DTnppImq9p06ZBl5qcvRNaCoUubaYSr+
	3BMrUbgUtz/DXSz2NKopsTcYremmkrxz5UVWYAolCbLnaXa8gd2w3SRh6w==
X-Google-Smtp-Source: AGHT+IHej6UB6RVTuXWNJJDyKDVowCjiKS0YrVG8dHDKSJ988SzOj7dTiOnFeFiagEmzk4yXFfkuFw==
X-Received: by 2002:a17:907:9812:b0:a6f:1443:1e24 with SMTP id a640c23a62f3a-a897f91fb05mr310071066b.34.1724946477717;
        Thu, 29 Aug 2024 08:47:57 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898900f29csm93489466b.64.2024.08.29.08.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 08:47:57 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 0/2] netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c
Date: Thu, 29 Aug 2024 17:29:30 +0200
Message-ID: <20240829154739.16691-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
and percpu address spaces and add __percpu annotation to *stats pointer
to fix percpu address space issues.

NOTE: The patch depends on a patch that introduces *_PCPU() macros [1]
that is on the way to mainline through the mm tree. For convience, the
patch is included in this patch series, so CI tester is able to test
the second patch without compile failures.

[1] https://lore.kernel.org/lkml/20240818210235.33481-1-ubizjak@gmail.com/

The netfilter patch obsoletes patch [2].

[2] https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240806102808.804619-1-ubizjak@gmail.com/

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>

Uros Bizjak (2):
  err.h: Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
  netfilter: nf_tables: Fix percpu address space issues in
    nf_tables_api.c

 include/linux/err.h           |  9 +++++++++
 net/netfilter/nf_tables_api.c | 16 ++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.42.0

