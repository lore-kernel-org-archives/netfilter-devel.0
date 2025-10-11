Received: from bumble.birch.relay.mailchannels.net (bumble.birch.relay.mailchannels.net [23.83.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59898F5B
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760143645; cv=pass; b=sRp+Ka82AxWpUaQYLFMX/Ri00VtzYcTr1m95T438kPcPJluL2kWj23Ylu0yKnrBRc4TxeRR3CtB4vuinordUP+q0QXh1pqnm91HV5b9i1YHWPy921i2j5CNQDarIa/EHS5lo28fh8aEWmf5Sq5WiL0z3UgKWhaEMWO1stoOrCdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760143645; c=relaxed/simple;
	bh=L6qmXwIbcsPOKlnuXIcvDofK6UB3BABCCcQ+ZjGWlJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAFlZ+PknyEwl7NPlu2lOF+In8zTVaQ8jytV8CL77yO3NOGv07oYI08vOhjDx4cShF0kJGxA+X51o9Kweyl+Rt1/gM+AkV0/46pk8VFyFhKsqRZZs2QlG/veFtio63t8UeH8uRhhSNHP1/7K4HzEWI6+2GKMjfeOsEIeMAz4VzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8FF3A41895;
	Sat, 11 Oct 2025 00:29:36 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-9.trex.outbound.svc.cluster.local [100.116.242.83])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id C5B864182B;
	Sat, 11 Oct 2025 00:29:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142576; a=rsa-sha256;
	cv=none;
	b=dRbotiic9mKIjB6Maxfv+YckXLzkQsIU58ycbklj/kPJf5sJRU1b/WGeckfW+vsM0IuBgE
	wEn0n3VirGQ1R0UUcEnUVPeVzZGcNR4ivuQQd9xQxvpgQkWagOn+xfQeUzoeNt6vFcnIgd
	T79ovqOtNKKU7Uy9czrmy0Gn+edp7DyeWKoILi4mha/6KfaUAdXoNxZq1Po0PgN3EcuFZy
	B718PEcDF2M3lQfiXv19/rcOSM9kIYwo669y/bRUzgGBI8z5o6tPhlARo0rOHGnNoh8Bdw
	DVaEzh6MmDhgoplx0RSH3kwrbgbQPweLSHccQVNbnmyMjr8Rq7DGB39RLPv5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwJ7VjZtVP0syI9zdqYx2D9JY91k0ShmQa9tR31P7/w=;
	b=S7sBn+vaNnUvubaV4MXXY4G+ALwVnFLiKUnBh4attNCR7OyhIvie4us8eTpv062PoQxNQ8
	+TeqC6ScihI7f6geHsZtRYbsCpcWFhTCJeh7Yve7YYXxW7N7ZOwW91oRC2+6d+98Z5quzX
	WQfb2j+UFrg/1XTyXto9EOPQMAVkIPvBk6U5brOhmvrmxlMoFFa9PNAJ/62c3wRrovlvrR
	DYKRu1gP2CGH6a1v/+eud1IHqaVfAIkfYfnLQSxjQ/igzTL7Zh8bbXJTMfqLyx+eEI+eK3
	03cL+UBkFObxhTvi2eJya5QnUqYYTOTKDaJY3mvytEmh/N4TsSsSouKjtB1HSQ==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-vrr96;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Abiding-Power: 07e0d6455fcbfa14_1760142576488_1311331950
X-MC-Loop-Signature: 1760142576488:1269812268
X-MC-Ingress-Time: 1760142576488
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.242.83 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:36 +0000
Received: from [212.104.214.84] (port=13604 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUO-00000009buu-0xMC;
	Sat, 11 Oct 2025 00:29:33 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 92AEE58D12CA; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 3/7] =?UTF-8?q?doc:=20minor=20improvements=20with=20res?= =?UTF-8?q?pect=20to=20the=20term=20=E2=80=9Cruleset=E2=80=9D?=
Date: Sat, 11 Oct 2025 02:23:59 +0200
Message-ID: <20251011002928.262644-4-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Statements are elements of rules. Non-terminal statement are in particular
passive with respect to their rules (and thus automatically with respect to the
whole ruleset).

In “Continue ruleset evaluation”, it’s not necessary to mention the ruleset as
it’s obvious that the evaluation of the current chain will be continued.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt        | 6 +++---
 doc/statements.txt | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 88c08618..a32fb10c 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -910,9 +910,9 @@ actions, such as logging, rejecting a packet, etc. +
 Statements exist in two kinds. Terminal statements unconditionally terminate
 evaluation of the current rule, non-terminal statements either only
 conditionally or never terminate evaluation of the current rule, in other words,
-they are passive from the ruleset evaluation perspective. There can be an
-arbitrary amount of non-terminal statements in a rule, but only a single
-terminal statement as the final statement.
+they are passive from the rule evaluation perspective. There can be an arbitrary
+amount of non-terminal statements in a rule, but only a single terminal
+statement as the final statement.
 
 include::statements.txt[]
 
diff --git a/doc/statements.txt b/doc/statements.txt
index f812dec8..850c32cb 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -54,8 +54,8 @@ those are not evaluated anymore for the packet.
  either the base chain or a regular chain that was reached solely via *goto*
  verdicts) end evaluation of the current base chain (and any regular chains
  called from it) using the base chain’s policy as implicit verdict.
-*continue*:: Continue ruleset evaluation with the next rule. This
- is the default behaviour in case a rule issues no verdict.
+*continue*:: Continue evaluation with the next rule. This is the default
+ behaviour in case a rule issues no verdict.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
 Userspace must provide a drop or accept verdict.  In case of accept, processing
 resumes with the next base chain hook, not the rule following the queue verdict.
-- 
2.51.0

