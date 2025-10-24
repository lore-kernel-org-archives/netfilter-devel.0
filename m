Received: from cow.ash.relay.mailchannels.net (cow.ash.relay.mailchannels.net [23.83.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3778E259CA5
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273335; cv=pass; b=dPOW/RPnldDJU1YWgSO1VKcqtWTyLvi6kXvTkB5ohAIqRvtxL/f/jIJHtxWiudx4fwEGYw3QMrz5UzENc/x1zMqeRiP+1KnrzBDWRvlbxuzCma/3H9KqPyAHpXYiJEcysUpXFv+0+VzJbRTv6NyqyyXg7en30UAJolgsPx4BRQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273335; c=relaxed/simple;
	bh=PhA2VeGhaqOZY76QuW7xc+QgWMeBtqAwTbF7d6r5Lrs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ak8I6Ge/3J0M7AKOS6eSWkRt5PTxdLLPqQwrx7yGwpHbQZD4eB0x74nuZS8tpEN6Z3AxPR55t8g1YU/JbojgYA9PK381rxE1aM8hs/vywicCJkYxoBJ8qYT8kSCGXDTBTHFzkUUAlYgc7+luElDt0gPtBY57EBbtgG2OcuE+BCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EFFF8361366;
	Fri, 24 Oct 2025 02:35:25 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.119.74.21])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 564B5360A32
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273321; a=rsa-sha256;
	cv=none;
	b=vx/TAw2osbOrthj5x6RIB8u8NTBPOny6/8ulUgnhyTI00jAAVzPtVd03D/DMyQ8yJ0GmOv
	uzQecZmHf1ajzPxYDxdSVCIiekswL/D9Jw/xCboTvthnxnqOFi1OxGJw0ueB5oAwZ/m57Y
	CK+PUjBK5lTwN65xDrDhzVODUovXRMkApiuuKecfrXoedsk7FZ4eQxz0Z6Bqr8TmTnMZHs
	SR5XYwLqG+tYNcmC0ietPfQHYaCgCDQrCNW49VwuhcyMUqhz5YnTV72Wz/nEZ6bp/+rl/R
	O/Dx2t0+CabL74QimJZgFq1Kuw2/hf1iVF41ENJBPVua52DXjw68B5aw3tHTIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDLmJVEmDDa+mY10rf7BXrx/9nJ0kULxWlyAn2T1p/A=;
	b=PI4QNT0xAmhrvISGrYF4QoYCO+mGw/9iprGwWujgKOu1sD2bRG2A9xPGjETtLugJ4gX0QB
	8Q42kgKFMiRTyec33zalOkwbSbTT2I63eymBACW2gX+RDxyywl6OWd2opaZJSrCgsWmlEv
	er03oaKvRjxXQXWA5uxTFxutt4Qwja1302iAw7SxzdbxxCFSf34hZK8u0zcRptwshB9qc8
	pz7QWJMVTYFwOwQ9rCmleTP5v5oKNFRAxNsO+A2si332Uew11SxcEE+BduahDnOLWboD9a
	uszmWWv/37oMvE05D9Z4q+p+Y2944cc2IXYl6p05k++6qWk9Kamzc/bWEinsdg==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-b6rbj;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Harbor-Hysterical: 34cb9c755f2ca172_1761273325871_2943943558
X-MC-Loop-Signature: 1761273325871:3705826662
X-MC-Ingress-Time: 1761273325871
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.74.21 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:25 +0000
Received: from [212.104.214.84] (port=52501 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eD-0000000FtWV-1rP0
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:19 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 10A125AA5C06; Fri, 24 Oct 2025 04:35:17 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 8/9] tools: flush the ruleset only on an actual dedicated unit stop
Date: Fri, 24 Oct 2025 04:08:23 +0200
Message-ID: <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

In systemd, the `ExecStop=` command isn’t only executed on an actual dedicated
unit stop, but also, for example, on restart (which is a stop followed by a
start).

There’s a chance users either don’t know this or (accidentally) confuse restart
(and similar) with reload.
In this case, there would be a short but non-zero time window in which the
ruleset is flushed (and any firewall rules gone), which for security reasons
shouldn’t happen.

Even with the pure semantics of restart (and similar), there’s no good reason to
actually flush the ruleset (on stop) before reloading it again (on start),
because the start will already do the flushing.

This commit adds detection of the job type to the `ExecStop=` command and,
depending on that, either actually flushes the ruleset (for example if a
dedicated `systemctl stop nftables.service` was executed) or doesn’t do so.
The latter is the case, on restart respectively try-restart, which prints
however a message that actually no stop was performed (mostly intended for the
journal), as well as on any other job type (which currently shouldn’t happen).

In order to determine the job type, first the systemd job ID is determined from
the service’s `Job=`-property.
See also https://github.com/systemd/systemd/issues/39316.

The service is referenced via `%n`, which needs not to be (shell) quoted, as –
as of systemd 258.1 and as per systemd.unit(5) – “the "unit name prefix" must
consist of one or more valid characters (ASCII letters, digits, ":", "-", "_",
".", and "\")”.

Programs are invoked by absolute pathname to prevent any of their names being
used from `/usr/local/bin`, which systemd includes in its default PATH.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index 5f367a24..0ad66b8c 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -19,7 +19,15 @@ RemainAfterExit=yes
 
 ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
 ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
-ExecStop=@sbindir@/nft flush ruleset
+ExecStop=:/bin/sh -c 'job_type="$$( /usr/bin/systemctl show --property JobType --value "$$(/usr/bin/systemctl show --property Job --value %n)" )"\n\
+                      case "$${job_type}" in\n\
+                      (stop)\n\
+                       @sbindir@/nft flush ruleset;;\n\
+                      (restart|try-restart)\n\
+                       printf \'%%s: JobType is `%%s`, thus the stop is ignored.\' %n "$${job_type}" >&2;;\n\
+                      (*)\n\
+                       printf \'%%s: Unexpected JobType `%%s`.\' %n "$${job_type}" >&2; exit 1\n\
+                      esac'
 
 ProtectSystem=full
 ProtectHome=yes
-- 
2.51.0

