Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A261548C
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142588; cv=pass; b=d2JbM3bVtCLya359Bv2qllzgwBe33jyxOtAvjunMk5JxOk+FXciQqSX6DKKqy9Vwni1ehtNJaPoyaqhnZUzyie0IEE7T5z1az6f3DpCQeEcowQXHivrJxa1Rjuxd5gqWjxR+z70Nb2UCL3YYS62VHlipdcPDa9NyCG6l8k7HH/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142588; c=relaxed/simple;
	bh=7wxu3r5kXuECr89uDnWEu4p3joL4rayi3WB3QKD/YTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqOXT0wAR08Nxb4DqmNd3qdoB9o2+MewvERd5EwnrSEs1SHafyVFh6KdutwPmCBLlqNwjE/9/jZPbeDnqxRqohaRlUDCgbOiYWU3Bfbe6UXgTXWW01ZG6Yrb1BGgoId/Ogp+5Ae+CAD5Dm3OI+hvfKVo4i5TewtvM+Xoy9yh6/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 88EDA8E2257;
	Sat, 11 Oct 2025 00:29:40 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-7.trex.outbound.svc.cluster.local [100.113.157.12])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A2F5C8E22AB;
	Sat, 11 Oct 2025 00:29:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142576; a=rsa-sha256;
	cv=none;
	b=GPlU7JP774ugI5ISRibCr0ROlgxG4NWaESb8KiiNpI8kgci/bZjcpcwqxW7wfp02ODiwWG
	dMouv6gm9N0exv0bGv6UF6bMQ0i78OsXbo2wmMoFznU7AfqpTq9cNz9QBvuQuLTEBJ2uIN
	+XEo3UmMSTzSGx/oBCjtQxmCaVKNzuYK5SKuK4lHz/zRJuJpg+3P1ZA8LApFfouHhmoS4b
	raNEekrt9VuWXWfIy/OYcBY1e3kmXQY8ERb5n6nvM5/PQOmx4/7erljVcWwl1ad8lhG47W
	ZiHf8EaLgdEiWPvkq2TKOB8E7+giPmuda/AraEN009Z93/Z332bJdJQ6DPHhKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7wxu3r5kXuECr89uDnWEu4p3joL4rayi3WB3QKD/YTs=;
	b=pBJZkS/iXSlP0pXDAMpgm1CSaeeCD+M11M95vOytAmqKXLoGCD7vIbXW70vZwpXZNt2sdk
	oZGhqiQWzlJAWHa/j0Imov+nN3kZzoN7buci0yzaZoo67Z/Cir2rCirLSyi3j2cYhD9vyn
	KkPoKR1RMbmwQ24keRC0JDC/K8d4LMUy7G07Hs3WRBw7w7kDJ2lSh4u2Ll2dOAY+2bu324
	sX5nMfZA0hwBB4ZB3EBdyV/GmplNjw6hbUkAnrdAgro/WUwLdSabEW2q6w5Z/oyfDf1QdJ
	/iEr4xgjhKIPlPZqC92bmxyEtohnct79yXh7Bn+3VmOiSBr7i1cBraP+cZzMCA==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-7gqf2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Tank-Tart: 3685d25b74fc4f0d_1760142580461_250122091
X-MC-Loop-Signature: 1760142580461:4220186127
X-MC-Ingress-Time: 1760142580461
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.113.157.12 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:40 +0000
Received: from [212.104.214.84] (port=15067 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUO-00000009bur-0dy3;
	Sat, 11 Oct 2025 00:29:33 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 84B6858D12C4; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 0/7] doc: miscellaneous improvements
Date: Sat, 11 Oct 2025 02:23:56 +0200
Message-ID: <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Hey.

This is v2 of the series.

Thanks to Florian for his review and helpful comments on v1. Given you've made
significant contributions I'd be happy to add your Signed-off-by to the commits,
if desired so.

I have taken most of your comments into account, for those where I didn't (yet)
I've explained so in the mails I've sent a bit earlier.
Of course if you still think that something should be changed, just tell. :-)

Also in these mails were a few further questions, which someone can hopefully
answer, so most likely there'll be a v3 of this series (to the least).

Thanks and best wishes,
Chris.

