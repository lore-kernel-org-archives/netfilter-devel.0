Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5EF15B96D;
	Thu, 18 Apr 2024 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437265; cv=none; b=SFnvTZSDUE+5+y7PWD5wKfIX6RXTY4nXPyOJfu5oqwmEVlgpdGXIFDvBuiu7907jAlBpoa5perD53G/x/i6aAr+D2wJcT/+2EhGpEVSYB7zKIUK870maM3JAJCu6t6/f1IpY8/+pT5+Uw31zK4lWGtbJU8oxxRj1sbRuNr/YnVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437265; c=relaxed/simple;
	bh=fmuYLUML59xhwPIg8hOiLimfCuFW7JEI89Br5g+pv4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KB+QXiRYb9leLk+z3RqVss7Zo5Wow/SEHMoM5jXIVCCV674ebgh88AIpUzht/hHPySIYiqXW3tEdiTfx1RubY92r7rCnjlUIvRt+ejxV0pBvGmjhOmXwtMrRA5QADkfVV7WRfmKZZo2sz+mLxLDvkQ3k5bJPA2YVjLnS9824I9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWAqzrKC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWAqzrKC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-418dc00a31dso5815515e9.0;
        Thu, 18 Apr 2024 03:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713437261; x=1714042061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wODG72EXEIGpgfZQLFr8h5BEPPdCsI8cQeQT73zhGRk=;
        b=TWAqzrKCMSKChc15R3i787MQ6uX3WBPxFKkQdlAqvMrcHX6Kz5H9BH8o49NfTEQYsz
         X/tTDvoDzXDL8+wS8FK4NUPJaN9yAgdCFcnfiIT0zpGVnjxCoz5BPglY2QWh0ov3Bo67
         mZG5SY8cHNyWAeJbhSDgRHfr0EyjxT3jK03WtTK/WH4qGqhdVpSNeGmTxghyvDaAgYFR
         7sIyF6nVlFZDQpThCh/nXPY5Xa7Qv169I12tkqoY0y7Mc7LTUKjqJ1KrOaMWsu/vEZPf
         2aAc43gl54XxXNGsw6A+5/mNZ2IVzSCNMTTrFh0TBg84BiSaMJhbiU9Uxor8UqS6Kkpj
         d6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713437261; x=1714042061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wODG72EXEIGpgfZQLFr8h5BEPPdCsI8cQeQT73zhGRk=;
        b=PAuW+ID9VNfqsvL2tLY+kRouBgF5x/DXKYvMP/iiVr2vFjAsWG1DXQorCX9boyTTKS
         1v4tFd3ovoRSIdCAu7eLN6GmUO9iqJejxYsJGRTyadVPtRIIUxEQO4d1x4uOYbIo+Ajk
         nDPvP6ya3FP0dg24BywmOykwXp+Qua1uJtRlZF6Z0UDWoGcLTFg8XLsQ7ukNJtb+eGv+
         fYiYmcKZVJ+LD2kMOIpDAAjJsktw/0A3jW9uttERrpYx8EYNktOq+r47fxs9IL5M6GAm
         gO0nuhjwQ30ItFdQztgsu2OkRotikIFjPJKy/j8gQT+VvxIVdZOWaDLWwf2HG62dXAcS
         +0hg==
X-Forwarded-Encrypted: i=1; AJvYcCWI2f+sVXUzsKxAUbBJg3eO5I4W/aifZQJfsvubJUgMeStZuIWj8ASyT8fAxWe/zzuPWtcU3NUygjAhr216qswYaiSqV6xSlkMwTVcxXLnu
X-Gm-Message-State: AOJu0YwNkYr45xz4X1/eQ4lchahjfWYAdbZuULbvCH8v1e7XB3hXREc5
	LMkcwfbaPJNDoYKqhI2a7SCjKwyyBLwTBaRLQuJJdqScWoyYilk9nEXydFjc
X-Google-Smtp-Source: AGHT+IH9jQCjBbh5pn2kxVtKHc0ETLBmJ1l0DOscj9VubHKyeDjJK4Ty4H1QcLgztK4Hsz8Sax33Dg==
X-Received: by 2002:a05:600c:470f:b0:418:6eb6:5cd5 with SMTP id v15-20020a05600c470f00b004186eb65cd5mr1626809wmo.32.1713437261189;
        Thu, 18 Apr 2024 03:47:41 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:702a:9979:dc91:f8d0])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b00417ee886977sm6135807wmq.4.2024.04.18.03.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 03:47:40 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/4] netlink: Add nftables spec w/ multi messages
Date: Thu, 18 Apr 2024 11:47:33 +0100
Message-ID: <20240418104737.77914-1-donald.hunter@gmail.com>
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
[None, None, None, None]

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
   of responses so that multiple errors could be reported.

 - If any message does not get a response (e.g. batch-begin w/o patch 2)
   then ynl waits indefinitely. A recv timeout could be added which
   would allow ynl to terminate.

v3 -> v4:
 - fix the underlying extack decoding bug and drop the
   workaround patch

v2 -> v3:
 - update the ynl multi code to match the latest return value
   semantics of ynl
 - add a ynl patch to handle acks that use req_value
 - update the nfnetlink patch based on feedback from Pablo
 - move nfnetlink patch to end of series

v1 -> v2:
 - add a patch to nfnetlink to process ACKs for batch begin/end
 - handle multiple responses correctly

Donald Hunter (4):
  doc/netlink/specs: Add draft nftables spec
  tools/net/ynl: Fix extack decoding for directional ops
  tools/net/ynl: Add multi message support to ynl
  netfilter: nfnetlink: Handle ACK flags for batch messages

 Documentation/netlink/specs/nftables.yaml | 1264 +++++++++++++++++++++
 net/netfilter/nfnetlink.c                 |    5 +
 tools/net/ynl/cli.py                      |   25 +-
 tools/net/ynl/lib/ynl.py                  |   82 +-
 4 files changed, 1346 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/netlink/specs/nftables.yaml

-- 
2.44.0

