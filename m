Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43EA2ED141;
	Thu, 10 Sep 2026 00:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000740; cv=none; b=E37L7GwKMimypjR2CXUr6Q4sT5E/k0TQ/vGhvXedehrTyKj5gm+TBSw0zfTDypei1PobUw7Dy94H/dGOyPRPPrPkP3e3P2WtxdBCgu/LHEhyoUZpOZ6Ip3e6qwZDfDaXSPx/nHtIKhUDxSX6jd0pgdhwWcD6SxqsHC1me6QjAh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000740; c=relaxed/simple;
	bh=8hHonr/10mfxOkrkzXWVRhkJRBtZSJpQeADO+Tc5WEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddLR4ksU2fssqimDs27Sy5pa9sqac1K64xbEhngidwdaNv/dTvlyxcu5G9KK6UWQlSHEwRtbwR0yfgIXqOiPmrpF7a31kfM2LSnUgPo0pCrE0VbOMnHgao6uxYZuutO8LB1/nHEun/JRbB07zgXnAWS1lV6GEmQ+/LFVH42Nug4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwMkg2Bh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwMkg2Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68301F0089B;
	Thu, 10 Sep 2026 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000739;
	bh=gIz6q4zqDDVQkAk8KGHUFzu+AYmyavpBt2mDIvx2snA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwMkg2BhC4CdXxpu4XFVJ9dRQ7gIC6sulmcnNbjapCKkp4bv+7qxIlbpYVBtb9geT
	 c0DmsiDz5rkjg/zm0cDZRTqSqmAuJmUMTCB9miLKh5ljhl86js2cQh2h81GBVBMVxC
	 KAS3Y1kc5mrJ287tuyYUTBhn9YLXp3S/e80oR9TG3r4ocBZ6kNhAT4K2KX9TTsPcG8
	 5/EuTqZuFgNybQs/J/0vKvO0vTGTyd12vmfmC0HM3JxRpkFPhQobUCSZDSwF7IRetD
	 jSS7GS/T1nz62GOCZcruyzGQzqlVosaUeeSeNjbgkihzIQi/BCCdKq8XXeexZC+DhL
	 cKA604b/71vlA==
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
Subject: [PATCH net-next 2/7] netlink: specs: conntrack: fix the get reply attribute lists
Date: Wed,  9 Sep 2026 17:38:46 -0700
Message-ID: <20260910003852.2184031-3-kuba@kernel.org>
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

CTA_NAT_SRC and CTA_NAT_DST are input-only.  The only references to either
are cda[] reads in ctnetlink_setup_nat() and the rejection in
ctnetlink_change_conntrack(); no path ever puts them into a message, so
neither belongs in a reply.  nat-dst was listed twice on top of that.

CTA_TIMESTAMP is the opposite case - both the do and the dump reach
ctnetlink_fill_info() with extinfo set, so ctnetlink_dump_extinfo() ->
ctnetlink_dump_timestamp() emits it, but the lists never named it.

Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260826220444.4054714-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 2b7f16cc4133..174697ce125e 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -596,20 +596,18 @@ doc: >-
             - status
             - protoinfo
             - help
-            - nat-src
-            - nat-dst
             - timeout
             - mark
             - counters-orig
             - counters-reply
             - use
             - id
-            - nat-dst
             - tuple-master
             - seq-adj-orig
             - seq-adj-reply
             - zone
             - secctx
+            - timestamp
             - labels
             - synproxy
       dump:
@@ -632,20 +630,18 @@ doc: >-
             - status
             - protoinfo
             - help
-            - nat-src
-            - nat-dst
             - timeout
             - mark
             - counters-orig
             - counters-reply
             - use
             - id
-            - nat-dst
             - tuple-master
             - seq-adj-orig
             - seq-adj-reply
             - zone
             - secctx
+            - timestamp
             - labels
             - synproxy
     -
-- 
2.55.0

