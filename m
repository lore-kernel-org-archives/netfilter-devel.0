Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24EA2737FC;
	Thu, 10 Sep 2026 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000740; cv=none; b=cq7u6fliKP+8rbNOyKQWa51OnmjwXXDHtc2dM5Q38utdgEXMGwk9rOoiBf0SSs5iK5V2eyb2Fyp5svD6AOikRLVDd1wU1kqwUBJP6oPCIzu7GPnNKI8u0s7ttjMW/uKDN3FxL3nI6WLW0FlvwW5vSvUOzNTm9uf9AvBwR+P2XNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000740; c=relaxed/simple;
	bh=8S+VC+QLjFC9N1DvXRNaZ5cr0lG3r5sPRjk+EySz4GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O00+9DlMhVGYYDe3hqPww1XNekn1DrSClJu5Tabdp45oTkty/hXA2iNjEG+edbvxhD54jGfSwzDf3Uq8iT4EgKAlYgF0RlDTWZjkeBmNGE1t+3zNYO10pEaIqBZYSJnZzIi3BFpTC9tHdg7cC7Z3S8j7OuDn7tfVdvJqNPBTiIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQk2LM1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQk2LM1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592001F00899;
	Thu, 10 Sep 2026 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000738;
	bh=fd7uF2EC+ShQ6FKopQiXVcQaj22x5FqWP/Zmd7ZvjM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQk2LM1O/cHY8tRO79QSsKHHaYjlZmtxYO0dBKPM7Qfyukk6VxmKyUXtIIYiqDLm4
	 jMZ/IwWfYNJvScZmo4uoZS49XEPB669t61lrDW0IFpZKkeEmwAUyIxrdB3DZ2Rpwxi
	 VODrgjm6PWhVAD8QPlaL8zLrz48LB5nntIIBRtjHGAAnJ+E3dCd9Cv29YSpIHrNfbq
	 Nxp5auuQlWnp65Nfn7cQ9NcYSv3JA0McrxnitsfJ8dJZeSZbS7iMzmzWehY6mG3Erj
	 +kZ7Ys1eZepaOHayNIUtyq1UrGgFXO4TAZEfFCo2KDgWoyuS2vprPtmkEKYiBXIX3T
	 FAy7uJ5b1KVrw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	donald.hunter@gmail.com,
	ast@fiberby.net,
	i.maximets@ovn.org,
	one-d-wide@protonmail.com,
	fw@strlen.de,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sashiko <netdev-bot+sashiko@kernel.org>
Subject: [PATCH net-next 1/7] netlink: specs: conntrack: timestamp is a nest, not a be64
Date: Wed,  9 Sep 2026 17:38:45 -0700
Message-ID: <20260910003852.2184031-2-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910003852.2184031-1-kuba@kernel.org>
References: <20260910003852.2184031-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_dump_timestamp() wraps CTA_TIMESTAMP_START
and CTA_TIMESTAMP_STOP in a nest, but the spec declares CTA_TIMESTAMP
as a flat be64. ynl picks reply attributes out of the attribute set rather
than the operation's attribute list, so the mistyped attribute stops
the whole dump:

  Error decoding 'timestamp' from 'conntrack-attrs'
  Traceback (most recent call last):
    File "tools/net/ynl/pyynl/cli.py", line 314, in main
      reply = ynl.dump(args.dump, attrs)
    File "tools/net/ynl/pyynl/lib/ynl.py", line 1082, in _decode
      decoded = attr.as_scalar(attr_spec['type'], attr_spec.byte_order)
    File "tools/net/ynl/pyynl/lib/ynl.py", line 291, in as_scalar
      return format_.unpack(self.raw)[0]
  struct.error: unpack requires a buffer of 8 bytes

The tstamp extension is only attached when CONFIG_NF_CONNTRACK_TIMESTAMP
is enabled and nf_conntrack_timestamp is turned on, which is off by default
and is why every dump does not hit this.

stop is omitted for live entries, so it stays optional like every other
member here.  The pad member mirrors counter-attrs, which covers the same
nla_put_be64() padding.

Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260826220444.4054714-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index b1eb102ab843..2b7f16cc4133 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -345,6 +345,20 @@ doc: >-
       -
         name: secctx-name
         type: string
+  -
+    name: timestamp-attrs
+    attributes:
+      -
+        name: start
+        type: u64
+        byte-order: big-endian
+      -
+        name: stop
+        type: u64
+        byte-order: big-endian
+      -
+        name: pad
+        type: pad
   -
     name: synproxy-attrs
     attributes:
@@ -458,8 +472,8 @@ doc: >-
         nested-attributes: secctx-attrs
       -
         name: timestamp
-        type: u64
-        byte-order: big-endian
+        type: nest
+        nested-attributes: timestamp-attrs
       -
         name: mark-mask
         type: u32
-- 
2.55.0

