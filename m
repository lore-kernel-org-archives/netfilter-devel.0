Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8F18DB26;
	Wed,  7 Oct 2026 01:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337790; cv=none; b=jmY/vDEIriC9/fPe98tAEAhR75vB6o5GM7z6qyYiHOyn7ewc0nRPaB1Ld/XtXyMqx5jVt3ZZMXN1n8vflTka5iLBrAVrlqofvy5HxrJHd/qzeMdcUjD55sSlMaWDUQ57lVkrwd5PFQOzYMWM7MvMiuWSaj4hHTyvki+YQtt/r2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337790; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p9M3311lazxYOqkMmyGNtAINxLqs1cg8dFSgxqUzYYn7RF8DESRdyfOcesXIAfpr09V8LbrP8xl5XJD6nlFd/oVUwM2RbXac2u7EzAtR3l5BnylUIMfD1BFXAcylBpWZb4FCxmLQeBrTHoep5oq+CxL9mxq63D1UUCA1lFl+NYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNplL1MX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNplL1MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D6C1F0089B;
	Wed,  7 Oct 2026 01:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791337789;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNplL1MXhybF663iFJecEB7haDn89F8qX3JzVA2WklSL5SHo2ARizfALrCP0sAPdz
	 XqgKg+i1xtW791JK5B8Wcq1GxONpqYu+mx+4WuMDuE9AMaSURXkhjUryvgVoS3Qlpb
	 gJ/QBnteH7/btGgPl0nhU2hdkPnitA2n1PFBZxq9ZkSNoqz/tl9Tbqdwh0jywNbrvp
	 VhFICpZGKnvujj5JItws20RATnizGgl/PBWcfh9pCd+RrSpPaesszfdjpmVNxW/dKA
	 +e6/vmcO3YVtOuPCdbeyHHvls6KqZpC0313yxVcAI37W72IDKN0EEu3HJ8VFubpN32
	 XvVyofYzPjVfA==
From: netdev-bot+sinfo@kernel.org
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, stable@vger.kernel.org
Subject: 
 Re: [PATCH net v3] netfilter: conntrack: avoid recursive master destruction
Date: Wed, 07 Oct 2026 01:49:48 +0000
Message-ID: <179133778820.2527009.8977366499446726018@kernel.org>
In-Reply-To: <20261007014802.2615503-1-4ncienth@gmail.com>
References: <20261007014802.2615503-1-4ncienth@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
