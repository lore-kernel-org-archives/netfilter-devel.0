Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC681DE8AE;
	Fri,  7 Feb 2025 12:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738931017; cv=none; b=DN56SwGRq1TByTx2dMnIxw/P4Vcy1M5DqhxVgJYSWWIuJWLi5okrMkjS4aYQB8BlteaGhC6bR3Pc6G+1dFcfe0QCWm04RdHGUp5tz2pEEdwwSmVStuundmx+LSZv4z2fhtPXoPNpWFVDEXhIqQLlzTDmseWEhm5rrxTYivcwqhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738931017; c=relaxed/simple;
	bh=6Yof+os6gFXj+ulCAt/INhfoL9VP78z82WJhNwth4n4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GycuoxSNHz9F8i+3OIwsZG7vPvn2oH3+EvovSe0wYQTWTlpdcyAzAFGhWLF7FWsEWdM4hEKQqxor/bd/ZDD3RDCuMS5BzOx6g2JsZKgopTJm+yzR0Adw/iAT7TiUt99nn3fpcw4YupROG3kWd0p7MhIv62ry5mozq5BggTrnKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tgN6u-0000NH-IS; Fri, 07 Feb 2025 13:05:28 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: donald.hunter@gmail.com,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] netlink: specs: add ctnetlink dump and stats dump support
Date: Fri,  7 Feb 2025 13:05:11 +0100
Message-ID: <20250207120516.17002-1-fw@strlen.de>
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
tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/ctnetlink.yaml --dump ctnetlink-get
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
tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/ctnetlink.yaml --dump ctnetlink-stats-get
[{'chain-toolong': 0,
  'clash-resolve': 3,
  'drop': 0,
 ....

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/netlink/specs/ctnetlink.yaml | 582 +++++++++++++++++++++
 1 file changed, 582 insertions(+)
 create mode 100644 Documentation/netlink/specs/ctnetlink.yaml

diff --git a/Documentation/netlink/specs/ctnetlink.yaml b/Documentation/netlink/specs/ctnetlink.yaml
new file mode 100644
index 000000000000..b477c6ddee9e
--- /dev/null
+++ b/Documentation/netlink/specs/ctnetlink.yaml
@@ -0,0 +1,582 @@
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
+    name: ctnetlink-counter-attrs
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
+    name: ctnetlink-tuple-proto-attrs
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
+    name: ctnetlink-tuple-ip-attrs
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
+    name: ctnetlink-tuple-attrs
+    attributes:
+    -
+        name: tuple-ip
+        type: nest
+        nested-attributes: ctnetlink-tuple-ip-attrs
+        doc: conntrack l3 information
+    -
+        name: tuple-proto
+        type: nest
+        nested-attributes: ctnetlink-tuple-proto-attrs
+        doc: conntrack l4 information
+    -
+        name: tuple-zone
+        type: u16
+        byte-order: big-endian
+        doc: conntrack zone id
+  -
+    name: ctnetlink-protoinfo-tcp-attrs
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
+    name: ctnetlink-protoinfo-dccp-attrs
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
+    name: ctnetlink-protoinfo-sctp-attrs
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
+    name: ctnetlink-protoinfo-attrs
+    attributes:
+    -
+        name: protoinfo-tcp
+        type: nest
+        nested-attributes: ctnetlink-protoinfo-tcp-attrs
+        doc: conntrack tcp state information
+    -
+        name: protoinfo-dccp
+        type: nest
+        nested-attributes: ctnetlink-protoinfo-dccp-attrs
+        doc: conntrack dccp state information
+    -
+        name: protoinfo-sctp
+        type: nest
+        nested-attributes: ctnetlink-protoinfo-sctp-attrs
+        doc: conntrack sctp state information
+  -
+    name: ctnetlink-help-attrs
+    attributes:
+      -
+        name: help-name
+        type: string
+        doc: helper name
+  -
+    name: ctnetlink-nat-proto-attrs
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
+    name: ctnetlink-nat-attrs
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
+        nested-attributes: ctnetlink-nat-proto-attrs
+  -
+    name: ctnetlink-seqadj-attrs
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
+    name: ctnetlink-secctx-attrs
+    attributes:
+      -
+        name: secctx-name
+        type: string
+  -
+    name: ctnetlink-synproxy-attrs
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
+    name: ctnetlink-attrs
+    attributes:
+      -
+        name: tuple-orig
+        type: nest
+        nested-attributes: ctnetlink-tuple-attrs
+        doc: conntrack l3+l4 protocol information, original direction
+      -
+        name: tuple-reply
+        type: nest
+        nested-attributes: ctnetlink-tuple-attrs
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
+        nested-attributes: ctnetlink-protoinfo-attrs
+      -
+        name: help
+        type: nest
+        nested-attributes: ctnetlink-help-attrs
+      -
+        name: nat-src
+        type: nest
+        nested-attributes: ctnetlink-nat-attrs
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
+        nested-attributes: ctnetlink-counter-attrs
+      -
+        name: counters-reply
+        type: nest
+        nested-attributes: ctnetlink-counter-attrs
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
+        nested-attributes: ctnetlink-nat-attrs
+      -
+        name: tuple-master
+        type: nest
+        nested-attributes: ctnetlink-tuple-attrs
+      -
+        name: seq-adj-orig
+        type: nest
+        nested-attributes: ctnetlink-seqadj-attrs
+      -
+        name: seq-adj-reply
+        type: nest
+        nested-attributes: ctnetlink-seqadj-attrs
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
+        nested-attributes: ctnetlink-secctx-attrs
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
+        nested-attributes: ctnetlink-synproxy-attrs
+      -
+        name: filter
+        type: nest
+        nested-attributes: ctnetlink-tuple-attrs
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
+    name: ctnetlink-stats-attrs
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
+      name: ctnetlink-get
+      doc: get / dump entries
+      attribute-set: ctnetlink-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0x101
+          attributes:
+            - name
+        reply:
+          value: 0x100
+          attributes:
+            - name
+    -
+      name: ctnetlink-stats-get
+      doc: dump pcpu conntrack stats
+      attribute-set: ctnetlink-stats-attrs
+      fixed-header: nfgenmsg
+      do:
+        request:
+          value: 0x104
+          attributes:
+            - name
+        reply:
+          value: 0x104
+          attributes:
+            - name
+
-- 
2.48.1

