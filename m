Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400322528E1;
	Mon, 10 Feb 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739200959; cv=none; b=S3MsIUL6/X3oAjOT01YzjS3VwJ9UNIvF88nKNxDMvppATo2bIRWrv1CBHBuConcq+L88IIfirN8+aMHQKqjKhUZTylK/LSW+svbnCahJ2/wtE8f4bB3F6ZNsXIN8bK85mVB7ErSB4x630aEiobrCd+zqrvYHaAnfgY7kn4N4DWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739200959; c=relaxed/simple;
	bh=7GPDD1p5x/nzF4Ei8HQZImikaglz3PbRapLaFGCOQt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GJ2aDuunSATJv2AJehPGS5sejQFFI4ppszSGTUkmlvMyTWuyKdFN5uODTXGmamPFZsHlA6LVn77PlO8UPg4F+yO3Bh+G/wLP8sUG+YyMMnI6XoFMjhnnW5AprNIuZbCzBwZkWg2ydoBBAl0JxA6rJWijPedL9rpHMA8HEPQMJo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1thVcA-0000ID-O8; Mon, 10 Feb 2025 16:22:26 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	donald.hunter@gmail.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next] netlink: specs: add conntrack dump and stats dump support
Date: Mon, 10 Feb 2025 16:21:52 +0100
Message-ID: <20250210152159.41077-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support to dump the connection tracking table
("conntrack -L") and the conntrack statistics, ("conntrack -S").

Example conntrack dump:
tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/conntrack.yaml --dump get
[{'id': 59489769,
  'mark': 0,
  'nfgen-family': 2,
  'protoinfo': {'protoinfo-tcp': {'tcp-flags-original': {'flags': {'maxack',
                                                                   'sack-perm',
                                                                   'window-scale'},
                                                         'mask': set()},
                                  'tcp-flags-reply': {'flags': {'maxack',
                                                                'sack-perm',
                                                                'window-scale'},
                                                      'mask': set()},
                                  'tcp-state': 'established',
                                  'tcp-wscale-original': 7,
                                  'tcp-wscale-reply': 8}},
  'res-id': 0,
  'secctx': {'secctx-name': 'system_u:object_r:unlabeled_t:s0'},
  'status': {'assured',
             'confirmed',
             'dst-nat-done',
             'seen-reply',
             'src-nat-done'},
  'timeout': 431949,
  'tuple-orig': {'tuple-ip': {'ip-v4-dst': '34.107.243.93',
                              'ip-v4-src': '192.168.0.114'},
                 'tuple-proto': {'proto-dst-port': 443,
                                 'proto-num': 6,
                                 'proto-src-port': 37104}},
  'tuple-reply': {'tuple-ip': {'ip-v4-dst': '192.168.0.114',
                               'ip-v4-src': '34.107.243.93'},
                  'tuple-proto': {'proto-dst-port': 37104,
                                  'proto-num': 6,
                                  'proto-src-port': 443}},
  'use': 1,
  'version': 0},
 {'id': 3402229480,

Example stats dump:
tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/conntrack.yaml --dump get-stats
[{'chain-toolong': 0,
  'clash-resolve': 3,
  'drop': 0,
 ....

Changes since last iteration:
 - Address comments from Donald Hunter, in particular, fixup "get" and
   "get-stats" descriptions, the former operation supports both dump
   and normal request (returns a single entry, if found), the latter
   only supports dumps.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/netlink/specs/conntrack.yaml | 643 +++++++++++++++++++++
 1 file changed, 643 insertions(+)
 create mode 100644 Documentation/netlink/specs/conntrack.yaml

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
new file mode 100644
index 000000000000..840dc4504216
--- /dev/null
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -0,0 +1,643 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: conntrack
+protocol: netlink-raw
+protonum: 12
+
+doc:
+  Netfilter connection tracking subsystem over nfnetlink
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
+    name: nf-ct-tcp-flags-mask
+    type: struct
+    members:
+      -
+        name: flags
+        type: u8
+        enum: nf-ct-tcp-flags
+        enum-as-flags: true
+      -
+        name: mask
+        type: u8
+        enum: nf-ct-tcp-flags
+        enum-as-flags: true
+  -
+    name: nf-ct-tcp-flags
+    type: flags
+    entries:
+      - window-scale
+      - sack-perm
+      - close-init
+      - be-liberal
+      - unacked
+      - maxack
+      - challenge-ack
+      - simultaneous-open
+  -
+    name: nf-ct-tcp-state
+    type: enum
+    entries:
+      - none
+      - syn-sent
+      - syn-recv
+      - established
+      - fin-wait
+      - close-wait
+      - last-ack
+      - time-wait
+      - close
+      - syn-sent2
+      - max
+      - ignore
+      - retrans
+      - unack
+      - timeout-max
+  -
+    name: nf-ct-sctp-state
+    type: enum
+    entries:
+      - none
+      - cloned
+      - cookie-wait
+      - cookie-echoed
+      - established
+      - shutdown-sent
+      - shutdown-received
+      - shutdown-ack-sent
+      - shutdown-heartbeat-sent
+  -
+    name: nf-ct-status
+    type: flags
+    entries:
+      - expected
+      - seen-reply
+      - assured
+      - confirmed
+      - src-nat
+      - dst-nat
+      - seq-adj
+      - src-nat-done
+      - dst-nat-done
+      - dying
+      - fixed-timeout
+      - template
+      - nat-clash
+      - helper
+      - offload
+      - hw-offload
+
+attribute-sets:
+  -
+    name: counter-attrs
+    attributes:
+      -
+        name: packets
+        type: u64
+        byte-order: big-endian
+      -
+        name: bytes
+        type: u64
+        byte-order: big-endian
+      -
+        name: packets-old
+        type: u32
+      -
+        name: bytes-old
+        type: u32
+      -
+        name: pad
+        type: pad
+  -
+    name: tuple-proto-attrs
+    attributes:
+      -
+        name: proto-num
+        type: u8
+        doc: l4 protocol number
+      -
+        name: proto-src-port
+        type: u16
+        byte-order: big-endian
+        doc: l4 source port
+      -
+        name: proto-dst-port
+        type: u16
+        byte-order: big-endian
+        doc: l4 source port
+      -
+        name: proto-icmp-id
+        type: u16
+        byte-order: big-endian
+        doc: l4 icmp id
+      -
+        name: proto-icmp-type
+        type: u8
+      -
+        name: proto-icmp-code
+        type: u8
+      -
+        name: proto-icmpv6-id
+        type: u16
+        byte-order: big-endian
+        doc: l4 icmp id
+      -
+        name: proto-icmpv6-type
+        type: u8
+      -
+        name: proto-icmpv6-code
+        type: u8
+  -
+    name: tuple-ip-attrs
+    attributes:
+      -
+        name: ip-v4-src
+        type: u32
+        byte-order: big-endian
+        display-hint: ipv4
+        doc: ipv4 source address
+      -
+        name: ip-v4-dst
+        type: u32
+        byte-order: big-endian
+        display-hint: ipv4
+        doc: ipv4 destination address
+      -
+        name: ip-v6-src
+        type: binary
+        checks:
+          min-len: 16
+        byte-order: big-endian
+        display-hint: ipv6
+        doc: ipv6 source address
+      -
+        name: ip-v6-dst
+        type: binary
+        checks:
+          min-len: 16
+        byte-order: big-endian
+        display-hint: ipv6
+        doc: ipv6 destination address
+  -
+    name: tuple-attrs
+    attributes:
+    -
+        name: tuple-ip
+        type: nest
+        nested-attributes: tuple-ip-attrs
+        doc: conntrack l3 information
+    -
+        name: tuple-proto
+        type: nest
+        nested-attributes: tuple-proto-attrs
+        doc: conntrack l4 information
+    -
+        name: tuple-zone
+        type: u16
+        byte-order: big-endian
+        doc: conntrack zone id
+  -
+    name: protoinfo-tcp-attrs
+    attributes:
+    -
+        name: tcp-state
+        type: u8
+        enum: nf-ct-tcp-state
+        doc: tcp connection state
+    -
+        name: tcp-wscale-original
+        type: u8
+        doc: window scaling factor in original direction
+    -
+        name: tcp-wscale-reply
+        type: u8
+        doc: window scaling factor in reply direction
+    -
+        name: tcp-flags-original
+        type: binary
+        struct: nf-ct-tcp-flags-mask
+    -
+        name: tcp-flags-reply
+        type: binary
+        struct: nf-ct-tcp-flags-mask
+  -
+    name: protoinfo-dccp-attrs
+    attributes:
+    -
+        name: dccp-state
+        type: u8
+        doc: dccp connection state
+    -
+        name: dccp-role
+        type: u8
+    -
+        name: dccp-handshake-seq
+        type: u64
+        byte-order: big-endian
+    -
+        name: dccp-pad
+        type: pad
+  -
+    name: protoinfo-sctp-attrs
+    attributes:
+    -
+        name: sctp-state
+        type: u8
+        doc: sctp connection state
+        enum: nf-ct-sctp-state
+    -
+        name: vtag-original
+        type: u32
+        byte-order: big-endian
+    -
+        name: vtag-reply
+        type: u32
+        byte-order: big-endian
+  -
+    name: protoinfo-attrs
+    attributes:
+    -
+        name: protoinfo-tcp
+        type: nest
+        nested-attributes: protoinfo-tcp-attrs
+        doc: conntrack tcp state information
+    -
+        name: protoinfo-dccp
+        type: nest
+        nested-attributes: protoinfo-dccp-attrs
+        doc: conntrack dccp state information
+    -
+        name: protoinfo-sctp
+        type: nest
+        nested-attributes: protoinfo-sctp-attrs
+        doc: conntrack sctp state information
+  -
+    name: help-attrs
+    attributes:
+      -
+        name: help-name
+        type: string
+        doc: helper name
+  -
+    name: nat-proto-attrs
+    attributes:
+      -
+        name: nat-port-min
+        type: u16
+        byte-order: big-endian
+      -
+        name: nat-port-max
+        type: u16
+        byte-order: big-endian
+  -
+    name: nat-attrs
+    attributes:
+      -
+        name: nat-v4-minip
+        type: u32
+        byte-order: big-endian
+      -
+        name: nat-v4-maxip
+        type: u32
+        byte-order: big-endian
+      -
+        name: nat-v6-minip
+        type: binary
+      -
+        name: nat-v6-maxip
+        type: binary
+      -
+        name: nat-proto
+        type: nest
+        nested-attributes: nat-proto-attrs
+  -
+    name: seqadj-attrs
+    attributes:
+      -
+        name: correction-pos
+        type: u32
+        byte-order: big-endian
+      -
+        name: offset-before
+        type: u32
+        byte-order: big-endian
+      -
+        name: offset-after
+        type: u32
+        byte-order: big-endian
+  -
+    name: secctx-attrs
+    attributes:
+      -
+        name: secctx-name
+        type: string
+  -
+    name: synproxy-attrs
+    attributes:
+      -
+        name: isn
+        type: u32
+        byte-order: big-endian
+      -
+        name: its
+        type: u32
+        byte-order: big-endian
+      -
+        name: tsoff
+        type: u32
+        byte-order: big-endian
+  -
+    name: conntrack-attrs
+    attributes:
+      -
+        name: tuple-orig
+        type: nest
+        nested-attributes: tuple-attrs
+        doc: conntrack l3+l4 protocol information, original direction
+      -
+        name: tuple-reply
+        type: nest
+        nested-attributes: tuple-attrs
+        doc: conntrack l3+l4 protocol information, reply direction
+      -
+        name: status
+        type: u32
+        byte-order: big-endian
+        enum: nf-ct-status
+        enum-as-flags: true
+        doc: conntrack flag bits
+      -
+        name: protoinfo
+        type: nest
+        nested-attributes: protoinfo-attrs
+      -
+        name: help
+        type: nest
+        nested-attributes: help-attrs
+      -
+        name: nat-src
+        type: nest
+        nested-attributes: nat-attrs
+      -
+        name: timeout
+        type: u32
+        byte-order: big-endian
+      -
+        name: mark
+        type: u32
+        byte-order: big-endian
+      -
+        name: counters-orig
+        type: nest
+        nested-attributes: counter-attrs
+      -
+        name: counters-reply
+        type: nest
+        nested-attributes: counter-attrs
+      -
+        name: use
+        type: u32
+        byte-order: big-endian
+      -
+        name: id
+        type: u32
+        byte-order: big-endian
+      -
+        name: nat-dst
+        type: nest
+        nested-attributes: nat-attrs
+      -
+        name: tuple-master
+        type: nest
+        nested-attributes: tuple-attrs
+      -
+        name: seq-adj-orig
+        type: nest
+        nested-attributes: seqadj-attrs
+      -
+        name: seq-adj-reply
+        type: nest
+        nested-attributes: seqadj-attrs
+      -
+        name: secmark
+        type: binary
+        doc: obsolete
+      -
+        name: zone
+        type: u16
+        byte-order: big-endian
+        doc: conntrack zone id
+      -
+        name: secctx
+        type: nest
+        nested-attributes: secctx-attrs
+      -
+        name: timestamp
+        type: u64
+        byte-order: big-endian
+      -
+        name: mark-mask
+        type: u32
+        byte-order: big-endian
+      -
+        name: labels
+        type: binary
+      -
+        name: labels mask
+        type: binary
+      -
+        name: synproxy
+        type: nest
+        nested-attributes: synproxy-attrs
+      -
+        name: filter
+        type: nest
+        nested-attributes: tuple-attrs
+      -
+        name: status-mask
+        type: u32
+        byte-order: big-endian
+        enum: nf-ct-status
+        enum-as-flags: true
+        doc: conntrack flag bits to change
+      -
+        name: timestamp-event
+        type: u64
+        byte-order: big-endian
+  -
+    name: conntrack-stats-attrs
+    attributes:
+      -
+        name: searched
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: found
+        type: u32
+        byte-order: big-endian
+      -
+        name: new
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: invalid
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: ignore
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: delete
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: delete-list
+        type: u32
+        byte-order: big-endian
+        doc: obsolete
+      -
+        name: insert
+        type: u32
+        byte-order: big-endian
+      -
+        name: insert-failed
+        type: u32
+        byte-order: big-endian
+      -
+        name: drop
+        type: u32
+        byte-order: big-endian
+      -
+        name: early-drop
+        type: u32
+        byte-order: big-endian
+      -
+        name: error
+        type: u32
+        byte-order: big-endian
+      -
+        name: search-restart
+        type: u32
+        byte-order: big-endian
+      -
+        name: clash-resolve
+        type: u32
+        byte-order: big-endian
+      -
+        name: chain-toolong
+        type: u32
+        byte-order: big-endian
+
+operations:
+  enum-model: directional
+  list:
+    -
+      name: get
+      doc: get / dump entries
+      attribute-set: conntrack-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0x101
+          attributes:
+            - tuple-orig
+            - tuple-reply
+            - zone
+        reply:
+          value: 0x100
+          attributes:
+            - tuple-orig
+            - tuple-reply
+            - status
+            - protoinfo
+            - help
+            - nat-src
+            - nat-dst
+            - timeout
+            - mark
+            - counter-orig
+            - counter-reply
+            - use
+            - id
+            - nat-dst
+            - tuple-master
+            - seq-adj-orig
+            - seq-adj-reply
+            - zone
+            - secctx
+            - labels
+            - synproxy
+      dump:
+        request:
+          value: 0x101
+          attributes:
+            - nfgen-family
+            - mark
+            - filter
+            - status
+            - zone
+        reply:
+          value: 0x100
+          attributes:
+            - tuple-orig
+            - tuple-reply
+            - status
+            - protoinfo
+            - help
+            - nat-src
+            - nat-dst
+            - timeout
+            - mark
+            - counter-orig
+            - counter-reply
+            - use
+            - id
+            - nat-dst
+            - tuple-master
+            - seq-adj-orig
+            - seq-adj-reply
+            - zone
+            - secctx
+            - labels
+            - synproxy
+    -
+      name: get-stats
+      doc: dump pcpu conntrack stats
+      attribute-set: conntrack-stats-attrs
+      fixed-header: nfgenmsg
+      dump:
+        request:
+          value: 0x104
+        reply:
+          value: 0x104
+          attributes:
+            - searched
+            - found
+            - insert
+            - insert-failed
+            - drop
+            - early-drop
+            - error
+            - search-restart
+            - clash-resolve
+            - chain-toolong
-- 
2.48.1

