Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F6D3CA4B6;
	Tue, 13 Oct 2026 23:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791935414; cv=none; b=Fqf3GTUkhRW86GVRtu90RRIyeWRY90LERMVo0Z2fZi2KVNRsWDVzVZsnwRyUId+k4nZ+tqx+VLYD/wblwB7hGaBTABwJpDJz7o789+EnyximHUI8AKynyQSxMkzHIRNr/q+VVBqi1CAqDeHoXtAetjo9qVsaijVit7uCy2GKpHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791935414; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pbSurBmaLO+jjVlK88m7n4H8nIH51K8lc0EeaBrftVsP6Rkocn0Wygqp4b7RK79kUigSmf+/YZJFpCdblQhbP/O4swouzOCzNlSdtqkWg7APFUPHZToIYFKdFBl+gbNe5Nm1PA2YEdsZ/wTYBmgZ2JFPoi/9TZ4ZwS05lm5ZDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqcvU+tA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqcvU+tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128261F000FF;
	Tue, 13 Oct 2026 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791935412;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqcvU+tABf0awpdfD3MUHM5Yb0Bdi+MxGQcO21eRLcZrjUUXJFAupBKs4mirOm18k
	 jdonN7USIzLrtEKZ8NmXesUWuHzcYOJmc3lgpuSTAneaW3lCkrKUY7DnxgFO20WEFv
	 P2+B4F8muR3w3noD1Sr1GWMY3lrwyoI7dJfes/1SfNVzXFPMXRw3FNdocO1lmcro1z
	 eIQeIe3Wafih3IAk6mLJDud6zq5kjD3O6jqdNeKRkEcUJvdJJjq0kc0ki0T3jZei4O
	 JTa6cQQdXjwOiEg0ltoG/NQ3NR6oEaUItjwcMrb9+eZN7+LK71KRT78RLbNpuDMkmv
	 YwCUcv6ApCs0g==
From: netdev-bot+sinfo@kernel.org
To: Tristan Madani <tristmd@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Christian Brauner <brauner@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 Tristan Madani <tristan@talencesecurity.com>
Subject: Re: [PATCH nf 0/5] netfilter: pin file with get_file_rcu() before
 reading f_cred
Date: Tue, 13 Oct 2026 23:50:11 +0000
Message-ID: <179193541159.160550.12220807019134258858@kernel.org>
In-Reply-To: <20261013234329.2797868-1-tristmd@gmail.com>
References: <20261013234329.2797868-1-tristmd@gmail.com>
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

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
