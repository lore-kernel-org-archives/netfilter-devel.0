Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5847F258CF2
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273329; cv=pass; b=e7FI6yAs0AZblKTWC/2PJf2Nx5Sb252VC7ZnCQZPy9GmngSDlF+qQLCaOOyPirCOML/vbHDv28ejT5c+lVZsqTJSVrK/uYvrb208TGaxbcgEMfIBTfmS6rikyG02nGTlI8PzR1tJdFn4A/t2EHpHUExFN80p5gDf7rEqhHOSfj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273329; c=relaxed/simple;
	bh=bdFM53Wv1fxE5I9zTPLlVArFQocewMJWP4RWrRmTRtU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCEJ/6BmXkv+mKGztmLsYRHahMrr60vz2wzbQykF8eEO0I5LHgz8cNtG1Jvuktb4rb1a78p881CuGP/x6NFMjMEFFn2KcJD4sGS6K69u3HONIvaLCWZP7WgfKh+tgM/wu8maH96HZgIrmoJcYCGjBKLDtGjQApoIizk60lTyWVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 4778336122E;
	Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-5.trex.outbound.svc.cluster.local [100.121.167.245])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id C649E360F96
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273321; a=rsa-sha256;
	cv=none;
	b=rI44lnjdyu8xou2/8OwgetCi0Z4Vr4i24J1iZmyteUo/MbCDi4ZfoEl41j1o2pi3s4oziX
	UefMsl8wQMQN4qP8kpcijMCs+Tuw8iLztvSNLQplNw0RsXR5+m/rmYHusTKXc4R5u3HlQa
	nQgGuOQ1gsm7XhRMcn/M+OhX1Kbw0akdybSRjPn9XDSSfxe2/c5UXQH2gkuXo2TrxJAyXE
	aYmC2lddMzOyfb7cnIXXnTkhC/FtY0TXBV0tiAlTJOJSbkRM1LX8He4ZKC1vkOMLttNL7O
	U+veOY6f4+wLbqcbnQp3vVSsu7FQ8zUpW1lcsJbjVjzyPLWc0ckwUQXA54YIJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu3mvOgxPNL6tMskP8yUSWHlClGa2VR5/1TG1Ml8Tlc=;
	b=kzsSafiTMVUdmgK8FpXNE9cFhw7EQopGfCVjZ9Z+v5QZ8eeALFzx/eas3YcoLG99E9x25r
	SO5+8KEXsvv3TWGryDSPLwDJUeH4a/3I77gAPN1yL4dUk+z3ybzsuHmjpuKGoblvhMj25B
	u5P5fn+JQRcnwr/sTMxoF4/A6VC15TmS/Aw+2Tn7wAciA7RjAK9L4Vz3szjCgIj4qvSHvY
	7fgLttAUId9EQh25NIuEqpGB4TrdccKvUdD8VecelgfC4TUP3ea8oiE33UpV7YuTSQ78Kc
	eYZVpemMoxY62m/aXrFS8RezxMnI4+q1CwwwYq8V1dcW066ioZgvh6NGUn0+GQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-lwqpg;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cure-Well-Made: 01e3d9cb5445b90b_1761273321186_2091508245
X-MC-Loop-Signature: 1761273321186:1351522503
X-MC-Ingress-Time: 1761273321186
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.167.245 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:21 +0000
Received: from [212.104.214.84] (port=43104 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eD-0000000FtWL-0rjE
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:19 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 038535AA5C00; Fri, 24 Oct 2025 04:35:17 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 5/9] tools: depend on `sysinit.target`
Date: Fri, 24 Oct 2025 04:08:20 +0200
Message-ID: <20251024023513.1000918-6-mail@christoph.anton.mitterer.name>
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

As of systemd 258.1 and as per systemd.service(5), `DefaultDependencies=yes`
implies for non-instanced service units:
Requires=sysinit.target
Conflicts=shutdown.target
Before=shutdown.target
After=sysinit.target basic.target

Previous commit messages don’t indicate why `DefaultDependencies=no` was set,
presumably because systemd.special(7) suggests for `sysinit.target` that
services pulled in by it – as is the case for `nftables.service` – “should
declare DefaultDependencies=no and specify all their dependencies manually”.

It’s however unclear why the dependencies on `sysinit.target` and `basic.target`
were dropped.

This commit adds the ones on the former, assuming that at least `@sbindir@/nft`
and `@pkgsysconfdir@/rules/main.nft` are required. As per bootup(7),
`sysinit.target` pulls in `local-fs.target`, which should make these available.

`local-fs.target` might have been enough, but some other services pulled in by
`sysinit.target` (the “various low-level services: udevd, tmpfiles, random seed,
sysctl, ...”) seem to be reasonable, too.

`basic.target`, which as per systemd.special(7) and bootup(7) seems to
additionally pull in in particular `timers.target`, `paths.target` and
`sockets.target` seems rather not required for nftables and is thus not added by
this commit.

`remote-fs.target` can’t be pulled in either, as `nftables.service` shall run
before any networking is brought up.

It shall be noted, that this doesn’t render that `WantedBy=sysinit.target`
superfluous.
The (added) dependencies of `nftables.service` merely specify what nftables
needs to be run – the `[Install]` on the other hand specifies “who” pulls in
`nftables.service`.

Typically, networking is configured in later targets, usually
`multi-user.target`.
In particular, `emergency.target` should run without any networking, so nothing
needs to be done for that. Similarly for `rescue.target` and while networking
might be started, nftables rules being loaded before it is not ensured.
Scenarios where networking is already brought up during the initramfs are not
covered by this and would have no nftables rules loaded.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index 15c3b5da..8388ae68 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -3,7 +3,9 @@ Description=nftables static rule set
 Documentation=man:nftables.service(8) man:nft(8) https://wiki.nftables.org
 
 Wants=network-pre.target
+Requires=sysinit.target
 Before=network-pre.target shutdown.target
+After=sysinit.target
 Conflicts=shutdown.target
 DefaultDependencies=no
 
-- 
2.51.0

