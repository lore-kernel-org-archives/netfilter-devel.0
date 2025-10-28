Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CA91531C8
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663299; cv=none; b=bmsVXXT3FgMH7esT7yHGwn8cU4s4+du2pHCrwFk5AlR9J4Z4LTAiTuVnx2YZeucnH/GSdV6tEMGHSMg3PeDqyCjx+ihPEfyiJmgUYqVs8d1DHdzIaIIJVAnvD5GGNLTERaz/bBmaahfks4BCDZWcSk84qkF8eSXYIQ89+gz0XDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663299; c=relaxed/simple;
	bh=iiaSoWrmJA5JT5R48t807Fwrbx+N4mbB54jFeCZwRXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loDWyfkZEseE2F0cTKnP0rIrb9QKNtskZUCRk+vCKj+ZUy37MoYFfSlRQGp9wVcVcblrxdEL0c/CwgJOY5TW4G/ZUh6GwibUpdsnLj2IpZlIoimQZJVLI0n11qSQdfz2KMxCQ4btgaWtp0+I03jZs0suwtNpE+OCCL7m/IgIHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EB23E61B22; Tue, 28 Oct 2025 15:54:55 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: mail@christoph.anton.mitterer.name,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v6 3/3] doc: minor improvements the `reject` statement
Date: Tue, 28 Oct 2025 15:54:29 +0100
Message-ID: <20251028145436.29415-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028145436.29415-1-fw@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 5d197aeb0cee..f380a60aaa71 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -1,3 +1,4 @@
+[[VERDICT_STATEMENTS]]
 VERDICT STATEMENTS
 ~~~~~~~~~~~~~~~~~~
 The verdict statements alter control flow in the ruleset and issue policy decisions for packets.
@@ -201,10 +202,11 @@ ____
                  *tcp reset*
 ____
 
-A reject statement is used to send back an error packet in response to the
-matched packet otherwise it is equivalent to drop so it is a terminating
-statement, ending rule traversal. This statement is only valid in base chains
-using the *prerouting*, *input*,
+A reject statement tries to send back an error packet in response to the matched
+packet and then interally issues a *drop* verdict.
+It’s thus a terminating statement with all consequences of the latter (see
+<<OVERALL_EVALUATION_OF_THE_RULESET>> respectively <<VERDICT_STATEMENTS>>).
+This statement is only valid in base chains using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-- 
2.51.0

