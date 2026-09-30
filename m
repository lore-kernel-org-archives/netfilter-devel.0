Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552DE3D0908;
	Wed, 30 Sep 2026 07:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754280; cv=none; b=i/3EHVtbAZOxTBat+pJ3U94pFbW3ePwlay1TN7ZRN/BYMl9INIapY/FdUMdDMsK1SwhpgE1Rf2fLu8NJmaSfAkv7YJOV6s5B1H2dPedebu/hRQ9zJxKJmAWGRFVnoFoFRrEwp6u9xU45JHCdn8ntvcP6bREf5e5ZZSxP5UrPCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754280; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K6e0+FhtFB1Bi6cU54SvpyRTcBZimNPkAP7T81uwyOP8JLzR6AdqiN5LV5KayqKGVwlv5JHL69C4Rs67FFTRiSBFtmKIQm5O20Pa9YJjzkXpvBkWVTtlXIti7hRZ6vZGJQcWsogbfbKtiX2OnHDN+qynzvxh067rf8Fv6LXc++8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeC5ow/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeC5ow/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531331F000FF;
	Wed, 30 Sep 2026 07:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790754278;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FeC5ow/xVi5rtHUgfzh9bCnKd7olruBvkXaekF3aZiUVrGCZjmiGi3ecubFdfU3KD
	 yd75mnqQytkjFRBAo4RnyGr+SqXxBbgNMrtZefdaxKhcjP8gqEfkgqDcAn0WWordo8
	 FuxQmQIp8DlD4KgUfF0IQMhL7GrnXaz0MZ00HLwYI+f1KDKcMQoTg3Q0uBbWGCL505
	 tQy48SYoLumQQpnT5zvquF8eKroR7Akrn45SSgKJ+lh7h/nWXjebjuHvqF65eBYTZ3
	 buOPjA62D6NwFYH2KxysPu6qIsaUppfynWE1qlN6wnwUyrfF9GXAeiBHrxWtVLJPNj
	 FsRHofvj00Xjw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/10] netfilter: ipset: do not update comments from
 kernel-side adds
Date: Wed, 30 Sep 2026 07:44:37 +0000
Message-ID: <179075427791.31693.9282935044953902190@kernel.org>
In-Reply-To: <20260930074142.298353-2-pablo@netfilter.org>
References: <20260930074142.298353-1-pablo@netfilter.org>
 <20260930074142.298353-2-pablo@netfilter.org>
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
