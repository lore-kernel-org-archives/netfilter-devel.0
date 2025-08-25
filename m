Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D12C0290
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2025 09:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756112878; cv=none; b=TKbMnwh/qzKQpDYMaBSPi/kFOFqWHr44lL3RJpTE0cPiG7o63wAVomd+H1Uu/WOx6xjG4+9XCVWFdwvXnqctSzECypCqYsk41CRx7oWG3vKUDHUT7zNEkmt39nMIWf+G0yQ99vYYGAT7+fcLuEq3TjlGMjm88DjRcfO05pYI6fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756112878; c=relaxed/simple;
	bh=yFhh/Jj/pwnM54AqIifxvpAc7gy/xAVnTFFBOMX8A4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cbjc69xalJlZyysbCnv54ii7z4KYm1xmoD/tuT9aAtlOLiBjdkqT1+EC7MVSEzpQfMy5y7UizedijXvA9fcynlALnlL5wD4reFwy1sUKhIr5yx1R1RAoSHDrP2b5lVQp3tQh/0WPT5HvdReWMsHq+cZKPQyG0FjklcjOZZjUNkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 523AD604E7; Mon, 25 Aug 2025 11:07:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables] man: iptables-restore.8: document flush behaviour for user-defined chains
Date: Mon, 25 Aug 2025 11:07:35 +0200
Message-ID: <20250825090743.12198-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no way we can change this after two decades.
Add an example and document that declaring a user defined chain
will flush its contents in --noflush mode.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1242
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/iptables-restore.8.in | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index df61b2a623f6..abf8d6decc27 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -48,6 +48,20 @@ Print a short option summary.
 \fB\-n\fR, \fB\-\-noflush\fR
 Don't flush the previous contents of the table. If not specified,
 both commands flush (delete) all previous contents of the respective table.
+Note that this option will flush user-defined chains if they are declared.
+Example:
+.P
+.in +4n
+.EX
+*filter
+:FILTERS - [0:0]
+-A FILTERS ...
+.EE
+
+will flush and re-build the FILTERS chain from scratch,
+while retaining the content of all other chains in the table.
+.in
+.P
 .TP
 \fB\-t\fP, \fB\-\-test\fP
 Only parse and construct the ruleset, but do not commit it.
-- 
2.51.0

