Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D7F138496;
	Tue, 16 Apr 2024 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295952; cv=none; b=R29snsMBTeNlBK5dgIa1F3264k60VikuUYFAxKh8AdXWeT8IsNYjEEW248cDwYFKKbKfqWc/0VMQEsTxZg/tMmit+pNA3pKvELivaL/BeN758SCGDBHmVeAqOfD4Wt+sH/WRbwbRRAnNW0QOjRS+/cZJ6Ln+9h82YLv23oj5ZHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295952; c=relaxed/simple;
	bh=O+UqMcCS79jOyq1iWue0XKO/fs2v42fPL6+Kbmo5rB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY18rxb8R7dCP4fV89guZdIcwV6JbkcFy+13PR3JUReUWF+MHzDm5Pg6UjrveI7acm72NJAYysP6fbVI5g72xVPvXrjO3rFNYnK93xwpu7PtD4G426LBtNPRo5PsMi6qwiscYQCWiAcg+C8u282PrOofaA4J6Z8z1wvAYNX4uME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fa3eCRCM; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fa3eCRCM"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-69b6d36b71cso11337556d6.3;
        Tue, 16 Apr 2024 12:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713295949; x=1713900749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrwA1x20/xC+pYy5KqYqlGXxArd1oHVz7kN0iSqFPGs=;
        b=fa3eCRCMyC4luX3lvz0/XhrwQwlUgyVL195jW9yIjF4q62DEenv1jMS4cdbhHm51NY
         FDdrfIj2R++rOumsqJZXgevdWnr6qlRE/yHATpM7wa0uTi22X61UvOSpkKLeediPoM3j
         x+hopusdRAihKG6/ToHhbem9Axuy/4sPOXBNAGHM6F6dp5TviXN/Pb6JZPgraur+oUmA
         fvtOUuWpayKXxsPxtm4PvUj43lc8zhZtOjteoNKuLV8BuhXh8ByeaT0EmLVVCDoK0giT
         0Uu5lKIFrt2HK5KnDpR47uYpTmoQxKsz0N8ivmdU5S/D90LYvGW3Fvlc+CR/RyYlBqsU
         f1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713295949; x=1713900749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrwA1x20/xC+pYy5KqYqlGXxArd1oHVz7kN0iSqFPGs=;
        b=WzDTrMJT2Nt03dsttcFZ/AvHf/9cJVnyJTa6brERf8eqmXjnQ7nQzx0qyzZkHONrnr
         ZzlEz2CX0NSXXGx6CLu7T29uIQ5KqU7ZAmILkMbjLZ4Ar+r5AZXw5dvk0YDe4p1lIsjO
         0ZFWVmroif515DCr9zIKKKue9p2ginJhjzYYQYze5jrBpyMHne+gnvYqq0jFnhnR20MT
         1mqdrMWkZBLWtv5DUjdiff27GicFsEAKq6a/HQ7MGDF0oLSdiazccahWaxDVcVtcXk/A
         /xrA7Ds84ze6aFLB+Nb9IUOy1+aSU1wfnHfAQQ0Rr6wtoPz5xk3RDSUjBHwXKTe6VAB9
         AoAA==
X-Forwarded-Encrypted: i=1; AJvYcCWrm05viOSd0bC5JLHuhWu8OPivYuK0HPitYhkbDKV1bM9rm4L02PrMlS3XaDWfrVFt7AcGcLFxx12JEJYzZ3Ouo93Q36y4Aarct6fHLnUu
X-Gm-Message-State: AOJu0YxYRu7LLr0lEG1aRCesZ0stIyvA+kd8STvj+N0UgsTThr6I72oq
	69itmTutilNybaezC9TESrdYnrgiRuUgYRG5167RjZvyr4/jYu9iFzH8U0WR
X-Google-Smtp-Source: AGHT+IHNqMOHUAiyRbK9uQZ4ks9L7Brx6gtbIcJeSAwGRbMtggh/PiTuenhni5HtP17oY1ZaTJHFDg==
X-Received: by 2002:a05:6214:17ca:b0:69b:1ae5:bc2e with SMTP id cu10-20020a05621417ca00b0069b1ae5bc2emr13022430qvb.40.1713295948577;
        Tue, 16 Apr 2024 12:32:28 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p12-20020a0cfacc000000b0069b52026a19sm6901757qvo.25.2024.04.16.12.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 12:32:28 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/4] doc/netlink/specs: Add draft nftables spec
Date: Tue, 16 Apr 2024 20:32:12 +0100
Message-ID: <20240416193215.8259-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416193215.8259-1-donald.hunter@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
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

