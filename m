Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794906193;
	b=J7OSW8OLQkmKzNGQFrhXMDnrv1FJ2Qnfjo+vSJyRnlovLncOU+NjC5eNEQodn+6V5t2o
	 MwCy796nmJCqe42eziDV6N/gYpCV6kNYIaL5hv2iMy8quiYBvLEhkbXD+USPXZsXEkBnG
	 G1K1XZZxA6FNRDF0CpwWUMXTPWfcuSzTUOnbT862hCJ+rhq5CImJBAhUvHdDddnHPy7Fq
	 yBFj//bqIY6XVjMHkyFR33A0ns5/hB0f3Jv7xW1jjKhF32cP72yC681kbKdVwzJx8LDth
	 dvZqgHUpZs+crUSsZhhhlQaRMPMp4rFyvj5gGCT0YqrmkMULDVPlCrazQV1KN5Wfo1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794906193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=hvg3RQBiwirhAQjdPWfa0+UsARg13XFMJIhD/81V4SsNNjQhiVGV71jJddl3K6QspaoO
	 DDfcSbr5bfqPPT03QY3YLaw+meQ6xj8vXkvO8d08zqAtvAfxefWP+boykGp1fXvisoMu3
	 u1PyzJ1ngfqYl1T4S1nmiD/RGpfrQmMLT4yAaD7bTvjItF7I/P6kdE5yL3lOCRaNOSlPr
	 Noe6/El3SuEuQjpQp+zYq/F6W0OO73bgcOEJOTTD5QWDXUkHQ1EmZ+Yr3LwJ9FLMquPol
	 SFNDizvuldewJebxRvUrLxaCv36jAGZQm77AoX6W7tCNVB4lIZu2xNriwpX45T0Uhew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5WEjPAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091A8606A335;
	Tue, 17 Nov 2026 09:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5WEjPAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CF61F000C5;
	Tue, 17 Nov 2026 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794906192;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5WEjPAoAR2qci/dM9sNSuv00gVgwdrXdvDS+OKQl1UySWpng3QruyZ7xW0FeLaGy
	 0Yer9coIr8qHfxDW7c3DRy8x4F8lVcZUTqJHqWssdBSmubMOEyMumoEBCt1OGJ0LX4
	 QpRyGeev3pht9M/h+qxvYpCi4XV2/BW5LLZ6DUgsst8Qf5AxVWUGHv8jedRgX3mMsF
	 4Os3DQVKmp7dQEJbXB/ee4/MAgjTwMo562Z+y7fUBOLoIFaDJAzrNM7XAJsCUMM93Z
	 2uf8dkBS5lD+TrBmLhZ71Rgzu5BWDRo+7JLuLIK9JjGKj0+hv/ATgfAMm+KWIp+rop
	 6Hs9G59M3RGbg==
From: netdev-bot+sinfo@kernel.org
To: Ma Xinmeng <1564938642@qq.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH net] netfilter: nf_tables: don't unregister hooks that
 were never registered
Date: Tue, 17 Nov 2026 09:03:11 +0000
Message-ID: <179490619175.3291.4042436087847232013@kernel.org>
In-Reply-To: <tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com>
References: <tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
