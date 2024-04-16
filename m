Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63C4138495;
	Tue, 16 Apr 2024 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295947; cv=none; b=IvjFS/bTk+ONMsJ49eY/dJh5e44eagG1md+PkrfpqeK3nTt3uy+YRHagL5o90M47/ZdHFDagurlHYgBiPnL+DBO3bRliAvEuUZ4IhZL8l1rEjQ0k7TjcXNPqU9sraGtlqrMmH2imZElVM89hoIP0N3hnO/RQMRqLHg6oqfgu9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295947; c=relaxed/simple;
	bh=M9kPlV3Tkb6iNRq9eevfqvUBXOOA5mhlbAex4jmpQ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q8adSEzC4Q7+Dbuk0AIJZ1Y4202FLiHl/v5m9UmQW5bpIjYbrdI54IdoDmSsVsUhlHdset3sRUYBfEff1B7mYp99JSliDte97yV/9qAy5CQ/hG+zDRrfKujojSCYH8YbTLgkf0HE2GgHlxmKw0YfImGAmAfCvMrtjlAWlxkiDZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AyBdnyzn; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyBdnyzn"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6eb86aeeb2cso1197644a34.3;
        Tue, 16 Apr 2024 12:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713295944; x=1713900744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V6qfFQZP7KVfVX/le9sAEGhGA0Q1N0TUsb3QrPpHS9Q=;
        b=AyBdnyzndGuGiFtzrv/g2aeQ1G20wQ6q/FLhfHIRWcXJQA7bta7TxYVoMeQ61ce40G
         0msyNbD2wKnBi6uSFks8yZvDbZR09MPWtGH0huTE21FRQqxLAJ9cH/BKUJiHBtZdykq7
         fE/laaR1PlV1BUi+YhdVs/pz91jku1EsZzPkK0zvvJ6j418b8a4wG64Jm05SaCmUg1F7
         X8fFcGfCo34ah1lXtrqkpJCiUvYVoT9YAjVWqySdmmFf4Ptw0J4WbnOt1S1ALL7y651s
         l92x7QO+uxwBg0BWJLHlO3+tU6r3BM+/Q2+n4UMezcyR189w4CzPMN3Bzphs4jE70wqk
         F2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713295944; x=1713900744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6qfFQZP7KVfVX/le9sAEGhGA0Q1N0TUsb3QrPpHS9Q=;
        b=AnEvnDtAvNE4p0gmg2SU9TrViRmJH+Tjx3WOMnBDC/t5RGi398AikkEqdeDVhTOlml
         AI4HO/z+ZiZI5L7sauq3nNeMW/VdGEmtQKeG5GwKJazIi+GjucDzghP2RcwxQ8ZWZo8e
         in4bhsbrY8RnlcvF9E4MVDNxXp0cWdAd93gWhDWDFG0fvidW9GYxPM6joV0TiXf3Emxg
         8AmiiKhIo+KCKTxK0EKviQ+QcxZRsuTq/cO0Xx1geRiRP89oUDQDaG+rjIk6DnSMX7fK
         jrIT70de+30mfjEREri46/ySkm4qz6hitCP8Xigd9eYO5TRy8MZxV2vqjP5OLQZUc+Tt
         /Bgw==
X-Forwarded-Encrypted: i=1; AJvYcCWh06wwvYLbMvBIP3aGC3t6ler+te/KBwHor7Kaxn+PwLAITmHbKGwC3BlqZbJ0FMtLK0Yy50CwVqauXCdvcaATtnmT4j0jqezQzGhfJkO2
X-Gm-Message-State: AOJu0YxF5BCgyjoCSDzzfqN3tyWYqRJjkB2XwSq7ZHKRCV7aWsHMAPAm
	dWvgQ7d8bJ1zJLPgomoH52Mmk2MD5V5AktZg3h0OHGCU4VHvCL6ZWgRVEVah
X-Google-Smtp-Source: AGHT+IFa6fCMttFLWIu5sru5vkDayzIymxYSaZndOewONBdQIiSWGnVdGDB3TaWXs5cGFxsWyW4Dpg==
X-Received: by 2002:a05:6830:7302:b0:6eb:8ccf:2a8e with SMTP id ex2-20020a056830730200b006eb8ccf2a8emr4846354otb.38.1713295944562;
        Tue, 16 Apr 2024 12:32:24 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p12-20020a0cfacc000000b0069b52026a19sm6901757qvo.25.2024.04.16.12.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 12:32:23 -0700 (PDT)
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
Subject: [PATCH net-next v3 0/4] netlink: Add nftables spec w/ multi messages
Date: Tue, 16 Apr 2024 20:32:11 +0100
Message-ID: <20240416193215.8259-1-donald.hunter@gmail.com>
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
   of responses so that multiple errors can be reported.

 - If any message does not get a response (e.g. batch-begin w/o patch 2)
   then ynl waits indefinitely. A recv timeout could be added which
   would allow ynl to terminate.

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
  tools/net/ynl: Add multi message support to ynl
  tools/net/ynl: Handle acks that use req_value
  netfilter: nfnetlink: Handle ACK flags for batch messages

 Documentation/netlink/specs/nftables.yaml | 1264 +++++++++++++++++++++
 net/netfilter/nfnetlink.c                 |    5 +
 tools/net/ynl/cli.py                      |   25 +-
 tools/net/ynl/lib/nlspec.py               |   12 +
 tools/net/ynl/lib/ynl.py                  |   72 +-
 5 files changed, 1353 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/netlink/specs/nftables.yaml

-- 
2.44.0

