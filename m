Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10FF034C155
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672676; cv=none; b=GZBbBXXlXkb1sWCIg3mV5zXnc1UxWLLQBGSZjN6QWW0SVoFtFwo6QZjil3ZjRxCf83uuB3ObFRvJBw112+ZOlzUdLMiPx1DWOcYzargOgM9xnNuVQk8aI5+A+AmTZVGvzl7mlaq0jqdvHzr5PP8gZuKrY/8qcaT7WwQqTu/1xPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672676; c=relaxed/simple;
	bh=j/2MOrNBI5Mm5DX3hm8MFbYlOfjIGnbkfAlDkKhOGL0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aPMT+Y/WyJ5saaiDqWLG+y87n0KrE2jHd6X39bpXTwzVwj7ATiBkOOBMiHLIlnJz35VmbyE0Hjq5qvraMEwBrJmeEMBgpqRZUNZXt5/K1zYo7C2eCeH29dO3usm6VbpLM+MKSsq8U6XsSkcPCmYpyKiHUCJWv+ixceKexi42iOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 011621015FA992; Tue, 28 Oct 2025 18:31:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 00DBB11020CBFD;
	Tue, 28 Oct 2025 18:31:13 +0100 (CET)
Date: Tue, 28 Oct 2025 18:31:12 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual dedicated
 unit stop
In-Reply-To: <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
Message-ID: <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name> <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Friday 2025-10-24 04:08, Christoph Anton Mitterer wrote:

>In systemd, the `ExecStop=` command isn’t only executed on an actual dedicated
>unit stop, but also, for example, on restart (which is a stop followed by a
>start).
>
>There’s a chance users either don’t know this or (accidentally) confuse restart
>(and similar) with reload.

I do not see room for a confusion, for I cannot imagine a Linux newbie in 2025
starting off with a sysvinit-based distro (good luck finding those)
and then deciding "yep, I'll edit nftables.service".

>@@ -19,7 +19,15 @@ RemainAfterExit=yes
> 
> ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
> ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
>-ExecStop=@sbindir@/nft flush ruleset
>+ExecStop=:/bin/sh -c 'job_type="$$( /usr/bin/systemctl show --property JobType --value "$$(/usr/bin/systemctl show --property Job --value %n)" )"\n\
>+                      case "$${job_type}" in\n\
>+                      (stop)\n\
>+                       @sbindir@/nft flush ruleset;;\n\
>+                      (restart|try-restart)\n\
>+                       printf \'%%s: JobType is `%%s`, thus the stop is ignored.\' %n "$${job_type}" >&2;;\n\
>+                      (*)\n\
>+                       printf \'%%s: Unexpected JobType `%%s`.\' %n "$${job_type}" >&2; exit 1\n\
>+                      esac'

No, let's not do this.
