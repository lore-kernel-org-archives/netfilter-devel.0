Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492F306776;
	Thu, 10 Sep 2026 00:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000741; cv=none; b=PB/YBgdQyT5Fpfp3o9AVNQWA14RPxZb1qzZfaYxDTVGF5G/eN2P/FsuZkhqEMYk0vX5PSO/r0Q3zfU8NMhaWSy8vfEycxxarR4ow+PVZbDWnB/luG9+PMV3GuoPue806n5SdBbIDnfdITB1Jt0Fk4rQR2AwSVxPoN0/+BCm5X/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000741; c=relaxed/simple;
	bh=3Kf+/1IHAfx1hHzdmSAl6NXf5h+jnVxjjoAM3Cw71jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz5oo+rIWsUp0GBDJsIPen8ftDaKT0bqsag77SV847rJfPM25N8nghm3Mth+YagjE7wMOC0+6sYTVLqP7OJXUa8+7BlrwKMslWETS7y9OjzSG59rWyD+3g3BkaQVZNL6o3znCbSzWGcKNMHkoV9gYvELljkDx/FLJasVoeXTD9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k81H6KYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k81H6KYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC711F00893;
	Thu, 10 Sep 2026 00:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000739;
	bh=RvAma3AJ17+ruNnmTaKzZVaauSAScAkwHRXag8K61VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k81H6KYgmD0CYQVIiQLzJFd/qIh0Zd7fgvZkIgxhRlxFX6Z5iTnl4Imb89M6rcLDp
	 Kt7WndQ+AkVN5wAbUBZnu6x1qyyWgYKvvcskvsohHfkL7rY1HF0PFLOTlll23/GGp1
	 v+kuTzMbIGa0B5g3oVQ/BTPHAzggiDZrLHqVhBhQgA/X5fyWhyifvxDivXwjGQajWb
	 5FKCe9bImOhKzuatGwBuuGTHamyQfVfFPDUAjeP4vfRQ23ePslGNA8HTUVqZ7sMree
	 hTb/uqiHJqUs84wDkMh8dFCFfrDZ9Ksqg0jOq1+f9FYzEup8HFXCGIir6B62VInVLI
	 tdvqRJjZcxPBw==
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
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/7] netlink: specs: conntrack: fix SCTP conntrack state names
Date: Wed,  9 Sep 2026 17:38:47 -0700
Message-ID: <20260910003852.2184031-4-kuba@kernel.org>
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

Correct the names of constants:

Value 1 is SCTP_CONNTRACK_CLOSED, not "cloned".
Value 6 is SCTP_CONNTRACK_SHUTDOWN_RECD, not "shutdown-received".
Value 8 is SCTP_CONNTRACK_HEARTBEAT_SENT, there is no "shutdown-heartbeat"
state.

Note that there's also a value of 9 (HEARTBEAT_ACKED) but sctp_nla_policy
caps the attribute at HEARTBEAT_SENT and HEARTBEAT_ACKED is marked no
longer used in the header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 174697ce125e..105b53d4b76a 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -72,14 +72,14 @@ doc: >-
     type: enum
     entries:
       - none
-      - cloned
+      - closed
       - cookie-wait
       - cookie-echoed
       - established
       - shutdown-sent
-      - shutdown-received
+      - shutdown-recd
       - shutdown-ack-sent
-      - shutdown-heartbeat-sent
+      - heartbeat-sent
   -
     name: nf-ct-status
     type: flags
-- 
2.55.0

