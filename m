Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D5E15CD73;
	Thu, 18 Apr 2024 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437266; cv=none; b=ZAYsSiyQkNyS4S6fruF8Rtwr/jFZA9VtGB6/aQ/PMFcDBG9sYgk/GtTgtJ/Q5AHnt7ThxRHH7z8fkVPK9pUkOazeVzzSI+c4njjxQm+n8zCR2pnmIgwwJijNRCG331C8XD3V4Ie82FRFlfDEwls20AMKepPDarQ/jiRrM8BiG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437266; c=relaxed/simple;
	bh=O+UqMcCS79jOyq1iWue0XKO/fs2v42fPL6+Kbmo5rB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCsSyGNM1tvvDQakumMKTOXwDmrRr0xQdaDAQ/FViP26DWEgDcGW5mzpsfsRScRm4DX2Sj0zY6iMRPoKndhLCqDu/NWT2KAPf+fYeZ1F0zy7j5SVV0kFk+ja9Xy4ufqWJ7k5O3gy00jDz7b3pp670Vsz09UEaGZVp/JoccmGBiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFnWfLFZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFnWfLFZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4187c47405aso5060445e9.3;
        Thu, 18 Apr 2024 03:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713437262; x=1714042062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrwA1x20/xC+pYy5KqYqlGXxArd1oHVz7kN0iSqFPGs=;
        b=mFnWfLFZfrWDKS5hrO26fLwfIYS8jxaR5QEz84Q3yNaRl/5Zby2Lq+e2DiOOHC7Ihd
         j1JVWYmaiKrTcFyj7yAsShnv1evF+P4M6uobYflPias3gzafi/HYmCqqlX1lOfdf7iyX
         TCjB5hDlsBAGfbhr9ZnvbLOGZBZIjVRnTj+v+6ss0SW5pLiV/F+z1TNsMiIyGDAWKzXY
         JnmvoCVkNBk5E4tpsnxPRegqudBg6qUVINTBITCbgZMUYHfx2C8vWsHqH/xQ022Qy8co
         mGJ42wNTZRpqI0PttGRocwSBesq/t0D+GqTMb0s7SLpqagK6aSxirIUbc+we7hVHNo+N
         R16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713437262; x=1714042062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrwA1x20/xC+pYy5KqYqlGXxArd1oHVz7kN0iSqFPGs=;
        b=tf9IsatkLTM5AKybChZ3qcQsOlrB97di18ru4qSebvLdFb5Pt1CLqHGJZmGRfT4it+
         a+4wE8SweIfpzmNKh93RwScU0rrvbjb9BQJcL9fwqpK7Eyt2QZhEGiQY4O3QibFE+2RR
         3oV2TR8p9mU1u3zVetQgwC+iaKLFet+CKwxWbd1i78zTEymyCbxqJZmZq4XwOv88EPcy
         sxaUy6gIommECAKBYei8wsb2x90Anv/C6VwRm1iKkxCBTACyIio7Q+4HPatLsMjv3Q2s
         tGZebnoY3rPGbjJmJZ4wXBPA3S+KrTOZwhHFhaWf4RNiDgmgsZ1ZZTvpVPdU9urTwzdH
         t4OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEDbVSfjpA1KmAPTbv1fncQOhlEwGifvjmhfLoy7ytxYy4t2cwA56kur7hOs2rWiJ+scwvAr/GKMJITNoqfRBW570uyM7WsHpshHxfnU7X
X-Gm-Message-State: AOJu0YzerHwUbpI3b2k9/bQY9bJdRcirwePI4P/a+KmyqBunqdP10bmY
	ZK3A9WEuTbV0y+MKIY6cc7DF1joNkFIMFB6NfK6/b5zqtld+GjSoWQwlIZ5+
X-Google-Smtp-Source: AGHT+IE3JnxG1kavzaJvzrDA0ZAhcpHGv/ZVUVInocOOTUv0PsMIq4UbCkeNDSiblndA/Miv0esisw==
X-Received: by 2002:a05:600c:5489:b0:418:df23:ae0e with SMTP id iv9-20020a05600c548900b00418df23ae0emr1146954wmb.40.1713437262389;
        Thu, 18 Apr 2024 03:47:42 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:702a:9979:dc91:f8d0])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b00417ee886977sm6135807wmq.4.2024.04.18.03.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 03:47:41 -0700 (PDT)
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
Subject: [PATCH net-next v4 1/4] doc/netlink/specs: Add draft nftables spec
Date: Thu, 18 Apr 2024 11:47:34 +0100
Message-ID: <20240418104737.77914-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240418104737.77914-1-donald.hunter@gmail.com>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a spec for nftables that has nearly complete coverage of the ops,
but limited coverage of rule types and subexpressions.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 1264 +++++++++++++++++++++
 1 file changed, 1264 insertions(+)
 create mode 100644 Documentation/netlink/specs/nftables.yaml

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
new file mode 100644
index 000000000000..dff2a18f3d90
--- /dev/null
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -0,0 +1,1264 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: nftables
+protocol: netlink-raw
+protonum: 12
+
+doc:
+  Netfilter nftables configuration over netlink.
+
+definitions:
+  -
+    name: nfgenmsg
+    type: struct
+    members:
+      -
+        name: nfgen-family
+        type: u8
+      -
+        name: version
+        type: u8
+      -
+        name: res-id
+        byte-order: big-endian
+        type: u16
+  -
+    name: meta-keys
+    type: enum
+    entries:
+      - len
+      - protocol
+      - priority
+      - mark
+      - iif
+      - oif
+      - iifname
+      - oifname
+      - iftype
+      - oiftype
+      - skuid
+      - skgid
+      - nftrace
+      - rtclassid
+      - secmark
+      - nfproto
+      - l4-proto
+      - bri-iifname
+      - bri-oifname
+      - pkttype
+      - cpu
+      - iifgroup
+      - oifgroup
+      - cgroup
+      - prandom
+      - secpath
+      - iifkind
+      - oifkind
+      - bri-iifpvid
+      - bri-iifvproto
+      - time-ns
+      - time-day
+      - time-hour
+      - sdif
+      - sdifname
+      - bri-broute
+  -
+    name: cmp-ops
+    type: enum
+    entries:
+      - eq
+      - neq
+      - lt
+      - lte
+      - gt
+      - gte
+  -
+    name: object-type
+    type: enum
+    entries:
+      - unspec
+      - counter
+      - quota
+      - ct-helper
+      - limit
+      - connlimit
+      - tunnel
+      - ct-timeout
+      - secmark
+      - ct-expect
+      - synproxy
+  -
+    name: nat-range-flags
+    type: flags
+    entries:
+      - map-ips
+      - proto-specified
+      - proto-random
+      - persistent
+      - proto-random-fully
+      - proto-offset
+      - netmap
+  -
+    name: table-flags
+    type: flags
+    entries:
+      - dormant
+      - owner
+      - persist
+  -
+    name: chain-flags
+    type: flags
+    entries:
+      - base
+      - hw-offload
+      - binding
+  -
+    name: set-flags
+    type: flags
+    entries:
+      - anonymous
+      - constant
+      - interval
+      - map
+      - timeout
+      - eval
+      - object
+      - concat
+      - expr
+
+attribute-sets:
+  -
+    name: empty-attrs
+    attributes:
+      -
+        name: name
+        type: string
+  -
+    name: batch-attrs
+    attributes:
+      -
+        name: genid
+        type: u32
+        byte-order: big-endian
+  -
+    name: table-attrs
+    attributes:
+      -
+        name: name
+        type: string
+        doc: name of the table
+      -
+        name: flags
+        type: u32
+        byte-order: big-endian
+        doc: bitmask of flags
+        enum: table-flags
+        enum-as-flags: true
+      -
+        name: use
+        type: u32
+        byte-order: big-endian
+        doc: number of chains in this table
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+        doc: numeric handle of the table
+      -
+        name: userdata
+        type: binary
+        doc: user data
+  -
+    name: chain-attrs
+    attributes:
+      -
+        name: table
+        type: string
+        doc: name of the table containing the chain
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+        doc: numeric handle of the chain
+      -
+        name: name
+        type: string
+        doc: name of the chain
+      -
+        name: hook
+        type: nest
+        nested-attributes: nft-hook-attrs
+        doc: hook specification for basechains
+      -
+        name: policy
+        type: u32
+        byte-order: big-endian
+        doc: numeric policy of the chain
+      -
+        name: use
+        type: u32
+        byte-order: big-endian
+        doc: number of references to this chain
+      -
+        name: type
+        type: string
+        doc: type name of the chain
+      -
+        name: counters
+        type: nest
+        nested-attributes: nft-counter-attrs
+        doc: counter specification of the chain
+      -
+        name: flags
+        type: u32
+        byte-order: big-endian
+        doc: chain flags
+        enum: chain-flags
+        enum-as-flags: true
+      -
+        name: id
+        type: u32
+        byte-order: big-endian
+        doc: uniquely identifies a chain in a transaction
+      -
+        name: userdata
+        type: binary
+        doc: user data
+  -
+    name: counter-attrs
+    attributes:
+      -
+        name: bytes
+        type: u64
+        byte-order: big-endian
+      -
+        name: packets
+        type: u64
+        byte-order: big-endian
+      -
+        name: pad
+        type: pad
+  -
+    name: nft-hook-attrs
+    attributes:
+      -
+        name: num
+        type: u32
+        byte-order: big-endian
+      -
+        name: priority
+        type: s32
+        byte-order: big-endian
+      -
+        name: dev
+        type: string
+        doc: net device name
+      -
+        name: devs
+        type: nest
+        nested-attributes: hook-dev-attrs
+        doc: list of net devices
+  -
+    name: hook-dev-attrs
+    attributes:
+      -
+        name: name
+        type: string
+        multi-attr: true
+  -
+    name: nft-counter-attrs
+    attributes:
+      -
+        name: bytes
+        type: u64
+      -
+        name: packets
+        type: u64
+  -
+    name: rule-attrs
+    attributes:
+      -
+        name: table
+        type: string
+        doc: name of the table containing the rule
+      -
+        name: chain
+        type: string
+        doc: name of the chain containing the rule
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+        doc: numeric handle of the rule
+      -
+        name: expressions
+        type: nest
+        nested-attributes: expr-list-attrs
+        doc: list of expressions
+      -
+        name: compat
+        type: nest
+        nested-attributes: rule-compat-attrs
+        doc: compatibility specifications of the rule
+      -
+        name: position
+        type: u64
+        byte-order: big-endian
+        doc: numeric handle of the previous rule
+      -
+        name: userdata
+        type: binary
+        doc: user data
+      -
+        name: id
+        type: u32
+        doc: uniquely identifies a rule in a transaction
+      -
+        name: position-id
+        type: u32
+        doc: transaction unique identifier of the previous rule
+      -
+        name: chain-id
+        type: u32
+        doc: add the rule to chain by ID, alternative to chain name
+  -
+    name: expr-list-attrs
+    attributes:
+      -
+        name: elem
+        type: nest
+        nested-attributes: expr-attrs
+        multi-attr: true
+  -
+    name: expr-attrs
+    attributes:
+      -
+        name: name
+        type: string
+        doc: name of the expression type
+      -
+        name: data
+        type: sub-message
+        sub-message: expr-ops
+        selector: name
+        doc: type specific data
+  -
+    name: rule-compat-attrs
+    attributes:
+      -
+        name: proto
+        type: binary
+        doc: numeric value of the handled protocol
+      -
+        name: flags
+        type: binary
+        doc: bitmask of flags
+  -
+    name: set-attrs
+    attributes:
+      -
+        name: table
+        type: string
+        doc: table name
+      -
+        name: name
+        type: string
+        doc: set name
+      -
+        name: flags
+        type: u32
+        enum: set-flags
+        byte-order: big-endian
+        doc: bitmask of enum nft_set_flags
+      -
+        name: key-type
+        type: u32
+        byte-order: big-endian
+        doc: key data type, informational purpose only
+      -
+        name: key-len
+        type: u32
+        byte-order: big-endian
+        doc: key data length
+      -
+        name: data-type
+        type: u32
+        byte-order: big-endian
+        doc: mapping data type
+      -
+        name: data-len
+        type: u32
+        byte-order: big-endian
+        doc: mapping data length
+      -
+        name: policy
+        type: u32
+        byte-order: big-endian
+        doc: selection policy
+      -
+        name: desc
+        type: nest
+        nested-attributes: set-desc-attrs
+        doc: set description
+      -
+        name: id
+        type: u32
+        doc: uniquely identifies a set in a transaction
+      -
+        name: timeout
+        type: u64
+        doc: default timeout value
+      -
+        name: gc-interval
+        type: u32
+        doc: garbage collection interval
+      -
+        name: userdata
+        type: binary
+        doc: user data
+      -
+        name: pad
+        type: pad
+      -
+        name: obj-type
+        type: u32
+        byte-order: big-endian
+        doc: stateful object type
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+        doc: set handle
+      -
+        name: expr
+        type: nest
+        nested-attributes: expr-attrs
+        doc: set expression
+        multi-attr: true
+      -
+        name: expressions
+        type: nest
+        nested-attributes: set-list-attrs
+        doc: list of expressions
+  -
+    name: set-desc-attrs
+    attributes:
+      -
+        name: size
+        type: u32
+        byte-order: big-endian
+        doc: number of elements in set
+      -
+        name: concat
+        type: nest
+        nested-attributes: set-desc-concat-attrs
+        doc: description of field concatenation
+        multi-attr: true
+  -
+    name: set-desc-concat-attrs
+    attributes:
+      -
+        name: elem
+        type: nest
+        nested-attributes: set-field-attrs
+  -
+    name: set-field-attrs
+    attributes:
+      -
+        name: len
+        type: u32
+        byte-order: big-endian
+  -
+    name: set-list-attrs
+    attributes:
+      -
+        name: elem
+        type: nest
+        nested-attributes: expr-attrs
+        multi-attr: true
+  -
+    name: setelem-attrs
+    attributes:
+      -
+        name: key
+        type: nest
+        nested-attributes: data-attrs
+        doc: key value
+      -
+        name: data
+        type: nest
+        nested-attributes: data-attrs
+        doc: data value of mapping
+      -
+        name: flags
+        type: binary
+        doc: bitmask of nft_set_elem_flags
+      -
+        name: timeout
+        type: u64
+        doc: timeout value
+      -
+        name: expiration
+        type: u64
+        doc: expiration time
+      -
+        name: userdata
+        type: binary
+        doc: user data
+      -
+        name: expr
+        type: nest
+        nested-attributes: expr-attrs
+        doc: expression
+      -
+        name: objref
+        type: string
+        doc: stateful object reference
+      -
+        name: key-end
+        type: nest
+        nested-attributes: data-attrs
+        doc: closing key value
+      -
+        name: expressions
+        type: nest
+        nested-attributes: expr-list-attrs
+        doc: list of expressions
+  -
+    name: setelem-list-elem-attrs
+    attributes:
+      -
+        name: elem
+        type: nest
+        nested-attributes: setelem-attrs
+        multi-attr: true
+  -
+    name: setelem-list-attrs
+    attributes:
+      -
+        name: table
+        type: string
+      -
+        name: set
+        type: string
+      -
+        name: elements
+        type: nest
+        nested-attributes: setelem-list-elem-attrs
+      -
+        name: set-id
+        type: u32
+  -
+    name: gen-attrs
+    attributes:
+      -
+        name: id
+        type: u32
+        byte-order: big-endian
+        doc: ruleset generation id
+      -
+        name: proc-pid
+        type: u32
+        byte-order: big-endian
+      -
+        name: proc-name
+        type: string
+  -
+    name: obj-attrs
+    attributes:
+      -
+        name: table
+        type: string
+        doc: name of the table containing the expression
+      -
+        name: name
+        type: string
+        doc: name of this expression type
+      -
+        name: type
+        type: u32
+        enum: object-type
+        byte-order: big-endian
+        doc: stateful object type
+      -
+        name: data
+        type: sub-message
+        sub-message: obj-data
+        selector: type
+        doc: stateful object data
+      -
+        name: use
+        type: u32
+        byte-order: big-endian
+        doc: number of references to this expression
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+        doc: object handle
+      -
+        name: pad
+        type: pad
+      -
+        name: userdata
+        type: binary
+        doc: user data
+  -
+    name: quota-attrs
+    attributes:
+      -
+        name: bytes
+        type: u64
+        byte-order: big-endian
+      -
+        name: flags # TODO
+        type: u32
+        byte-order: big-endian
+      -
+        name: pad
+        type: pad
+      -
+        name: consumed
+        type: u64
+        byte-order: big-endian
+  -
+    name: flowtable-attrs
+    attributes:
+      -
+        name: table
+        type: string
+      -
+        name: name
+        type: string
+      -
+        name: hook
+        type: nest
+        nested-attributes: flowtable-hook-attrs
+      -
+        name: use
+        type: u32
+        byte-order: big-endian
+      -
+        name: handle
+        type: u64
+        byte-order: big-endian
+      -
+        name: pad
+        type: pad
+      -
+        name: flags
+        type: u32
+        byte-order: big-endian
+  -
+    name: flowtable-hook-attrs
+    attributes:
+      -
+        name: num
+        type: u32
+        byte-order: big-endian
+      -
+        name: priority
+        type: u32
+        byte-order: big-endian
+      -
+        name: devs
+        type: nest
+        nested-attributes: hook-dev-attrs
+  -
+    name: expr-cmp-attrs
+    attributes:
+      -
+        name: sreg
+        type: u32
+        byte-order: big-endian
+      -
+        name: op
+        type: u32
+        byte-order: big-endian
+        enum: cmp-ops
+      -
+        name: data
+        type: nest
+        nested-attributes: data-attrs
+  -
+    name: data-attrs
+    attributes:
+      -
+        name: value
+        type: binary
+        # sub-type: u8
+      -
+        name: verdict
+        type: nest
+        nested-attributes: verdict-attrs
+  -
+    name: verdict-attrs
+    attributes:
+      -
+        name: code
+        type: u32
+        byte-order: big-endian
+      -
+        name: chain
+        type: string
+      -
+        name: chain-id
+        type: u32
+  -
+    name: expr-counter-attrs
+    attributes:
+      -
+        name: bytes
+        type: u64
+        doc: Number of bytes
+      -
+        name: packets
+        type: u64
+        doc: Number of packets
+      -
+        name: pad
+        type: pad
+  -
+    name: expr-flow-offload-attrs
+    attributes:
+      -
+        name: name
+        type: string
+        doc: Flow offload table name
+  -
+    name: expr-immediate-attrs
+    attributes:
+      -
+        name: dreg
+        type: u32
+        byte-order: big-endian
+      -
+        name: data
+        type: nest
+        nested-attributes: data-attrs
+  -
+    name: expr-meta-attrs
+    attributes:
+      -
+        name: dreg
+        type: u32
+        byte-order: big-endian
+      -
+        name: key
+        type: u32
+        byte-order: big-endian
+        enum: meta-keys
+      -
+        name: sreg
+        type: u32
+        byte-order: big-endian
+  -
+    name: expr-nat-attrs
+    attributes:
+      -
+        name: type
+        type: u32
+        byte-order: big-endian
+      -
+        name: family
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-addr-min
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-addr-max
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-proto-min
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-proto-max
+        type: u32
+        byte-order: big-endian
+      -
+        name: flags
+        type: u32
+        byte-order: big-endian
+        enum: nat-range-flags
+        enum-as-flags: true
+  -
+    name: expr-payload-attrs
+    attributes:
+      -
+        name: dreg
+        type: u32
+        byte-order: big-endian
+      -
+        name: base
+        type: u32
+        byte-order: big-endian
+      -
+        name: offset
+        type: u32
+        byte-order: big-endian
+      -
+        name: len
+        type: u32
+        byte-order: big-endian
+      -
+        name: sreg
+        type: u32
+        byte-order: big-endian
+      -
+        name: csum-type
+        type: u32
+        byte-order: big-endian
+      -
+        name: csum-offset
+        type: u32
+        byte-order: big-endian
+      -
+        name: csum-flags
+        type: u32
+        byte-order: big-endian
+  -
+    name: expr-tproxy-attrs
+    attributes:
+      -
+        name: family
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-addr
+        type: u32
+        byte-order: big-endian
+      -
+        name: reg-port
+        type: u32
+        byte-order: big-endian
+
+sub-messages:
+  -
+    name: expr-ops
+    formats:
+      -
+        value: bitwise # TODO
+      -
+        value: cmp
+        attribute-set: expr-cmp-attrs
+      -
+        value: counter
+        attribute-set: expr-counter-attrs
+      -
+        value: ct # TODO
+      -
+        value: flow_offload
+        attribute-set: expr-flow-offload-attrs
+      -
+        value: immediate
+        attribute-set: expr-immediate-attrs
+      -
+        value: lookup # TODO
+      -
+        value: meta
+        attribute-set: expr-meta-attrs
+      -
+        value: nat
+        attribute-set: expr-nat-attrs
+      -
+        value: payload
+        attribute-set: expr-payload-attrs
+      -
+        value: tproxy
+        attribute-set: expr-tproxy-attrs
+  -
+    name: obj-data
+    formats:
+      -
+        value: counter
+        attribute-set: counter-attrs
+      -
+        value: quota
+        attribute-set: quota-attrs
+
+operations:
+  enum-model: directional
+  list:
+    -
+      name: batch-begin
+      doc: Start a batch of operations
+      attribute-set: batch-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0x10
+          attributes:
+            - genid
+        reply:
+          value: 0x10
+          attributes:
+            - genid
+    -
+      name: batch-end
+      doc: Finish a batch of operations
+      attribute-set: batch-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0x11
+          attributes:
+            - genid
+    -
+      name: newtable
+      doc: Create a new table.
+      attribute-set: table-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa00
+          attributes:
+            - name
+    -
+      name: gettable
+      doc: Get / dump tables.
+      attribute-set: table-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa01
+          attributes:
+            - name
+        reply:
+          value: 0xa00
+          attributes:
+            - name
+    -
+      name: deltable
+      doc: Delete an existing table.
+      attribute-set: table-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa02
+          attributes:
+            - name
+    -
+      name: destroytable
+      doc: Delete an existing table with destroy semantics (ignoring ENOENT errors).
+      attribute-set: table-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1a
+          attributes:
+            - name
+    -
+      name: newchain
+      doc: Create a new chain.
+      attribute-set: chain-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa03
+          attributes:
+            - name
+    -
+      name: getchain
+      doc: Get / dump chains.
+      attribute-set: chain-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa04
+          attributes:
+            - name
+        reply:
+          value: 0xa03
+          attributes:
+            - name
+    -
+      name: delchain
+      doc: Delete an existing chain.
+      attribute-set: chain-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa05
+          attributes:
+            - name
+    -
+      name: destroychain
+      doc: Delete an existing chain with destroy semantics (ignoring ENOENT errors).
+      attribute-set: chain-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1b
+          attributes:
+            - name
+    -
+      name: newrule
+      doc: Create a new rule.
+      attribute-set: rule-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa06
+          attributes:
+            - name
+    -
+      name: getrule
+      doc: Get / dump rules.
+      attribute-set: rule-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa07
+          attributes:
+            - name
+        reply:
+          value: 0xa06
+          attributes:
+            - name
+    -
+      name: getrule-reset
+      doc: Get / dump rules and reset stateful expressions.
+      attribute-set: rule-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa19
+          attributes:
+            - name
+        reply:
+          value: 0xa06
+          attributes:
+            - name
+    -
+      name: delrule
+      doc: Delete an existing rule.
+      attribute-set: rule-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa08
+          attributes:
+            - name
+    -
+      name: destroyrule
+      doc: Delete an existing rule with destroy semantics (ignoring ENOENT errors).
+      attribute-set: rule-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1c
+          attributes:
+            - name
+    -
+      name: newset
+      doc: Create a new set.
+      attribute-set: set-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa09
+          attributes:
+            - name
+    -
+      name: getset
+      doc: Get / dump sets.
+      attribute-set: set-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa0a
+          attributes:
+            - name
+        reply:
+          value: 0xa09
+          attributes:
+            - name
+    -
+      name: delset
+      doc: Delete an existing set.
+      attribute-set: set-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa0b
+          attributes:
+            - name
+    -
+      name: destroyset
+      doc: Delete an existing set with destroy semantics (ignoring ENOENT errors).
+      attribute-set: set-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1d
+          attributes:
+            - name
+    -
+      name: newsetelem
+      doc: Create a new set element.
+      attribute-set: setelem-list-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa0c
+          attributes:
+            - name
+    -
+      name: getsetelem
+      doc: Get / dump set elements.
+      attribute-set: setelem-list-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa0d
+          attributes:
+            - name
+        reply:
+          value: 0xa0c
+          attributes:
+            - name
+    -
+      name: getsetelem-reset
+      doc: Get / dump set elements and reset stateful expressions.
+      attribute-set: setelem-list-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa21
+          attributes:
+            - name
+        reply:
+          value: 0xa0c
+          attributes:
+            - name
+    -
+      name: delsetelem
+      doc: Delete an existing set element.
+      attribute-set: setelem-list-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa0e
+          attributes:
+            - name
+    -
+      name: destroysetelem
+      doc: Delete an existing set element with destroy semantics.
+      attribute-set: setelem-list-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1e
+          attributes:
+            - name
+    -
+      name: getgen
+      doc: Get / dump rule-set generation.
+      attribute-set: gen-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa10
+          attributes:
+            - name
+        reply:
+          value: 0xa0f
+          attributes:
+            - name
+    -
+      name: newobj
+      doc: Create a new stateful object.
+      attribute-set: obj-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa12
+          attributes:
+            - name
+    -
+      name: getobj
+      doc: Get / dump stateful objects.
+      attribute-set: obj-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa13
+          attributes:
+            - name
+        reply:
+          value: 0xa12
+          attributes:
+            - name
+    -
+      name: delobj
+      doc: Delete an existing stateful object.
+      attribute-set: obj-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa14
+          attributes:
+            - name
+    -
+      name: destroyobj
+      doc: Delete an existing stateful object with destroy semantics.
+      attribute-set: obj-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa1f
+          attributes:
+            - name
+    -
+      name: newflowtable
+      doc: Create a new flow table.
+      attribute-set: flowtable-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa16
+          attributes:
+            - name
+    -
+      name: getflowtable
+      doc: Get / dump flow tables.
+      attribute-set: flowtable-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa17
+          attributes:
+            - name
+        reply:
+          value: 0xa16
+          attributes:
+            - name
+    -
+      name: delflowtable
+      doc: Delete an existing flow table.
+      attribute-set: flowtable-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa18
+          attributes:
+            - name
+    -
+      name: destroyflowtable
+      doc: Delete an existing flow table with destroy semantics.
+      attribute-set: flowtable-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0xa20
+          attributes:
+            - name
+
+mcast-groups:
+  list:
+    -
+      name: mgmt
-- 
2.44.0

