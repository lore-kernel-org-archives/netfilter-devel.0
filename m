Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4729930BF69
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 12:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770811260; cv=none; b=agaA7DCtxb8GsfbzTlX2O/oqA+V7WdieT7EYwhYgdKCGTEbVJi05wOz43jMjJuEOognaFXTtlf2IA5G1YsDWRObXl7GhLmRz6TCDgscDbCL0lcflg5Q2Bp/lcXvldZAw99PImxriV9qmO2MDvsceMl/B3bt4adShNp9HeCr8uH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770811260; c=relaxed/simple;
	bh=06Ku5KSUQFjfmCPK/JBMC9fINF+3UA3jFK52ZPLiJEI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SL50uiGKjwip7TnZe8O09cAaBWTU44pJLHkPWyLf7fXddNl2ieR8KwNIYD38j4vLFTGDYiU5Jr5W+mskfaE5gGPVKLLt00r5z8JFMjYIz1qkDX9Q1QT8COG1JV+Q3KazVNwCBb/luxWw1oMTkpi+KOXosWTA3XDSvvPJgvOkAyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84798605E7; Wed, 11 Feb 2026 13:00:56 +0100 (CET)
Date: Wed, 11 Feb 2026 13:00:56 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: [ANN] nf-next remains OPEN
Message-ID: <aYxveCxwSezABhIa@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

while net-next remains closed until Feb 23rd, I would like to keep
nf-next open for new features.

So, if you had changes targetting nf-next that aren't in the
patchwork backlog[1] anymore, please consider resubmitting them.

I have queued the 'commit mutex deadlock during reset' series to
nf:testing, no need to send it again.

Thanks.

[1] https://patchwork.ozlabs.org/project/netfilter-devel/list/
