Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0661118410C;
	Wed, 10 Apr 2024 22:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787076; cv=none; b=UGN6FqBhuf/MsGV2qEqPGpye9yAaaJpVqqzXlDjDBf/KnKSFXBcuSWPkyp6L3kpwZL+tpzoPcC68Qcs/BjYZsJWcLSCPV8Ae3Riv4MHNkbSPNgguFkN2d/R58vS73aHJwyw5l2lO2ChGK4dD0Kn0UEIoBEo4X749dwmLIBKUvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787076; c=relaxed/simple;
	bh=NbU1qtXVX4ovXCPQOmuYpJ4Y9uxrvDK7WKWgFU/3L30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hFNa/WePwGtJbKy1teCs9PX7ZQ69pq9z3T3laRfI/ov39XU1Ca3c1l+vUoVMiFSr1xVMQnuPj8+kgSQJSWgkLrtcfpzL/SVbker7TJJA+X1vrJpFqbkl069UuPqoQpNJBoc6LNra4UB9EmIPLOCjJBhe0uNpwpnAyJ6hNa/tUNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSeMJnnE; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSeMJnnE"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-416a8ec0239so1688265e9.0;
        Wed, 10 Apr 2024 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712787073; x=1713391873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6UAu58j3M52qW7N2+bAkzOyjKkh+1htnZYDwlGxQ0Lg=;
        b=ZSeMJnnEVA0nO/DY7ul2mTkSxytVPfYntPu5YGfWhQtVnwk3xPXAaKz9Cq567m9RqU
         ILhPm7/LMQ9VyDnkwpih7IsiPTFCFbDH1+evLFLXrvtLxfy+rizdb1fUaJ1fbv7tzTvL
         OjB0CaTUdxgamfTGFDEBJVXIk5/MkSwevJZvReSEYyojBb9KBq9ZxXncZaY6oSQGEZkE
         105u4nilYuoyDI1YR6ot1Qdw7x/ihb/34K6prSl0cX4FB5DgZ3R2gP2iOsC68j5xk2Qn
         e/CckX1Rp3A35eISiLYBJa7QhrtxK0OQ8GYDSAJZcbofbjyVUFbRLVSURr1gfeknaWV0
         jILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712787073; x=1713391873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6UAu58j3M52qW7N2+bAkzOyjKkh+1htnZYDwlGxQ0Lg=;
        b=ZG9eIh9V8j9pKWxM0IUwd5xZrgHKmJuQBZHleqjwiJMSnpa6AiUM1ve/mK7spe7rbA
         TYxf3DXxWGU4yiMREhUsX31r5M12DqoabBmI4WCIprNE5MYtkQQ84aGL9lghgaqs0OPp
         5tBcZqKcWbfDo2NNokBogwOXIOpwMWWxVET41HrOE4obbZaQa/UmIDDFSWFesJeSHsj2
         hmmoo9alas4vjNwSru77TFzrSeGFkVT6g/vBfc2VZmLm9+JObmNEs7+5gYgDThMtsmhT
         fOKdrNkB+UH0cBN4fMQ5D/Nr9ViCMQSsQGXPeVfzDePRp9bAMJ1XHJBc6UUvg5de7FlR
         kC0g==
X-Forwarded-Encrypted: i=1; AJvYcCXTKeOZ6Tbb+6dKLq/meW/AI/yqMaO4AkaPyNwlcjWMeTxQi0YKoVKTQZZIV/mmNoLkCIUUlOhqz4wROvdvBau/nmXFT3zVIRcs0TDN99kU
X-Gm-Message-State: AOJu0YzGkDHP+6/6Q788NV+JH2YWzNetZzSyB02kiytF9wyA9v2/6s2n
	xa2X5VFpR+5QkvtNReb8bwlE5qix/0HmX02Eig8NRxFvOp9envctwaHSejbX
X-Google-Smtp-Source: AGHT+IHsrmzOc7Xfxld4LYld/52PeoZOnbrQkbOluCS94yXOuQBC5m/vJjFxkaDET/GDJDsUb76Auw==
X-Received: by 2002:a05:600c:1c08:b0:416:3ff5:ad62 with SMTP id j8-20020a05600c1c0800b004163ff5ad62mr673120wms.14.1712787072850;
        Wed, 10 Apr 2024 15:11:12 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:2cff:b314:57ee:c426])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c470700b00416b2cbad06sm3531244wmo.41.2024.04.10.15.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 15:11:12 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 0/3] netlink: Add nftables spec w/ multi messages
Date: Wed, 10 Apr 2024 23:11:05 +0100
Message-ID: <20240410221108.37414-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a ynl spec for nftables and extends ynl with a --multi
command line option that makes it possible to send transactional batches
for nftables.

This series includes a patch for nfnetlink which adds ACK processing for
batch begin/end messages. If you'd prefer that to be sent separately to
nf-next then I can do so, but I included it here so that it gets seen in
context.

An example of usage is:

./tools/net/ynl/cli.py \
 --spec Documentation/netlink/specs/nftables.yaml \
 --multi batch-begin '{"res-id": 10}' \
 --multi newtable '{"name": "test", "nfgen-family": 1}' \
 --multi newchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
 --multi batch-end '{"res-id": 10}'

It can also be used for bundling get requests:

./tools/net/ynl/cli.py \
 --spec Documentation/netlink/specs/nftables.yaml \
 --multi gettable '{"name": "test", "nfgen-family": 1}' \
 --multi getchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
 --output-json
[{"name": "test", "use": 1, "handle": 1, "flags": [],
 "nfgen-family": 1, "version": 0, "res-id": 2},
 {"table": "test", "name": "chain", "handle": 1, "use": 0,
 "nfgen-family": 1, "version": 0, "res-id": 2}]

There are 2 issues that may be worth resolving:

 - ynl reports errors by raising an NlError exception so only the first
   error gets reported. This could be changed to add errors to the list
   of responses so that multiple errors can be reported.

 - If any message does not get a response (e.g. batch-begin w/o patch 2)
   then ynl waits indefinitely. A recv timeout could be added which
   would allow ynl to terminate.

v1 -> v2:
 - add a patch to nfnetlink to process ACKs for batch begin/end
 - handle multiple responses correctly

Donald Hunter (3):
  doc/netlink/specs: Add draft nftables spec
  netfilter: nfnetlink: Handle ACK flags for batch messages
  tools/net/ynl: Add multi message support to ynl

 Documentation/netlink/specs/nftables.yaml | 1264 +++++++++++++++++++++
 net/netfilter/nfnetlink.c                 |    5 +
 tools/net/ynl/cli.py                      |   25 +-
 tools/net/ynl/lib/ynl.py                  |   64 +-
 4 files changed, 1335 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/netlink/specs/nftables.yaml

-- 
2.43.0

