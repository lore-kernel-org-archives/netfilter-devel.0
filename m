Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890331F1537
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777214939; cv=none; b=uxaEdYQDbJdi0F7m2wOa0zjT14HYtMqRq3I8Ji7nIlPXbfhO0of+K8ehezuEQK7e05g3dsweyI/jkMMlG6wvYEHnRU6Qx8Ufm9HJeIll0rTMWF4vXJDXnsx+jVZtv7ISSYIPoRJ17QW/AksyWkKLjg9Hv2RfZjsgHY6Vx6GiUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777214939; c=relaxed/simple;
	bh=0/ZauZOQB/NP1QcAH+PDITEaXUC773OeN19DfxcW1yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RVmQAlhrEt7gPzqAOukC0gdSZ3grTKUoqgeZFcGLcXB2zS9s98lfREQxYR77FUi8JPFa/nloJgXyoN/+LWt6+47HHafkyVqlMPtzpY4hOHOZWnp5RKSNXS/fCA/Sx7QCXcz8ue+I999evZVPAugDSL3RlIdPaewyZf7nMWktvSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8Pb2hy+; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8Pb2hy+"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8aca2726f61so114420496d6.0
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777214937; x=1777819737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EMSX8d1QgLZUoJnKt34AnkG63ZeJBVmP3ekDSJT4BDs=;
        b=j8Pb2hy+d7PpZUfwcrhGzURJ3yc5i1yFgqmIuBIPKXfnfuyojj+p3psQHT7x2/N4dL
         FIL+orvjFmJA1KfPcPmVIkCHgn9oayoX3ZoCMwHHucFNJKcw1MP5H4c/khHVwb148c2R
         ww7ElTN7ZK1VTAoPz91nnXWZIKUjrsEyhEaVe5k/GIK6rEAXT/2rFYDkY7VvwK0y1yKx
         JvtmIpXZ107zb7jKjdMKdGZdL3wmlmFb3YN2tts5mogsR3EnaLPWHhnkWerfXCABJjJ8
         iVzt/kuvHy7TINI0C+i7UmYk6WIE5EKk8hu2AUCJE97/16kzdat2tOAoDxx9noU9tISp
         R8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777214937; x=1777819737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMSX8d1QgLZUoJnKt34AnkG63ZeJBVmP3ekDSJT4BDs=;
        b=BCxRG1ErUg3ybVZ1LX9lW8ShQNRQQMVLNB+zvW28KYTaAIzEAZwvz4d4ZEXBUJVvnN
         SR2ktgJgxTqy1GqihsHoRSye/GS6V5htnS3nbIlHDpjQJIK2q+17HNAabws0bv+W8aAU
         2FjwvBOnsMnO7WA2koCipb0rBUX2wgiwjOn4WAVE7bGFr0GYK5YReS80xbOaFng6ouP4
         uS0/YzH39A0U9t+LsngS5QkFLy4zBRlFxxqZ/z1kqGCp2u9iJkzFKtWG55LZgiPVzK8+
         4cYPYFUbI4f4mNDfHER3mYs9ubNkV/NUDRlWFDKmVTftaBjX3kqdKvYPf+jqJLjkaVy2
         3/gg==
X-Forwarded-Encrypted: i=1; AFNElJ+EhvjYhgmKrqG+YbOEWgh8NAsGprsGutyA2O0Gs0E0KGwIC5IJzOG0z3H577mvN2nOoJqS6JfWAlWF6e2NlI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzABc4wHaHUrPTsbOsQcoX95y5UwRvwj9acGkzTtKyxHwtUKJdZ
	61x0vlZcf77uRsQPUIHtyV1WmDpfLR7w/K3tvA9CwIcApjkjCKCxvurf
X-Gm-Gg: AeBDiesbZo/8zbCh7lH9iBsnHtn4SRt8AbPA96IkT2z4Uxs1rvDG+F6g5fDwa6RX6ok
	ybyf85MNF05HoaemuSIeSdrj3nOjRX1CW/5QJVh11kv2VofYghhkMdlB2ZP5Dwr6dX1aroRb7km
	Vxov3K/N6O+XmX8aFTun3eGgLdZ6gNVZnuZ/VcQpLXIYAZV9PoTHD1y1QA4Ans3uZMVlMZkdrSk
	GA+AnHQSw2yHRWyooZytNveQVcnEpqhsrkFt9n5GZui7ZyxWdBhebWrAJWpLUDd5asCZjUiVsux
	xLljIT87fztEX4fpZ9elEJwH8/hv1qByou0Id4tQwIdErvhhh5GVcougXDkK77TVsp90l/9ZuaX
	8Xi1+WHAvbnkITlD1LVz3d8rMxE3Aje8KgXGo3DFHYVVkQBuDiWGAtXqW1zB4o4oV4Dh62LtFk9
	Dxg1tCO+uDIMrLbgrrtWYw4MS7q3k6QjGgp5VD176WhTn8Qpp4UqDQjZkJOtmxD0HZah8lx0U4P
	JkuC0OAkPitp/0gPxPychS+BrcZmqfaK02xifW6BzoTai/bTEKvu+Mi/McbW315fa2c18BaGes=
X-Received: by 2002:a05:6214:d0e:b0:8ac:aa89:6bbc with SMTP id 6a1803df08f44-8b0446f0cb3mr459818986d6.16.1777214937472;
        Sun, 26 Apr 2026 07:48:57 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aebc655sm232579146d6.48.2026.04.26.07.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 07:48:56 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Yi Chen <yiche.cy@gmail.com>
Subject: [PATCH net v2 0/2] sctp: fix a vtag verification failure caused by stale INITs
Date: Sun, 26 Apr 2026 10:46:39 -0400
Message-ID: <cover.1777214801.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to Scenario B in commit 8e56b063c865 ( netfilter: handle the
connecting collision properly in nf_conntrack_proto_sctp"):

Scenario B: INIT_ACK is delayed until the peer completes its own handshake

  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
    192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
    192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
  192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *

There is another case:

Scenario F: INIT is delayed until the peer completes its own handshake

  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
  (OVS upcall)
    192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
    192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
    192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
  (delayed)
  192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *

In this case, the delayed INIT (e.g. due to OVS upcall) is recorded by
conntrack, which prevents vtag verification from dropping the unexpected
INIT-ACK in nf_conntrack_sctp_packet():

  vtag = ct->proto.sctp.vtag[!dir];
  if (!ct->proto.sctp.init[!dir] && vtag && vtag != ih->init_tag)
          goto out_unlock;

This happens because ct->proto.sctp.init[!dir] is set by the delayed INIT,
even though it is stale.

Fix this in two parts:

- In netfilter: Do not record INITs whose init_tag matches the peer vtag,
  as they carry no new handshake state in the 1st patch.

- In SCTP: Prevent endpoints from responding to such INITs with INIT-ACK,
  ensuring correctness even when middleboxes lack the netfilter fix in
  the 2nd patch.

A follow-up selftest for this scenario will be posted in a separate patch
by Yi Chen.

Xin Long (2):
  netfilter: skip recording stale or retransmitted INIT
  sctp: discard stale INIT after handshake completion

 net/netfilter/nf_conntrack_proto_sctp.c | 10 +++++++---
 net/sctp/sm_statefuns.c                 |  6 ++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.47.1

