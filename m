Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715048;
	b=iwORk6GL7p4Nn7IqHhJm6+S2z7sz0WJV+CD3aDeTv/XtATnCNdYpCNUy6rKiR/PUwhBp
	 e1+5Aoi9czet+F34odQIa0G6NYenJO4TiMsAp2rE0k1lunJ4qlSZofUmP7jmCHUa/1KKf
	 5VcK3TA2hmT+NGD8c7mcI/L9X4iF9mM8UkCMerjw+NRqU5Dk4EZ0QPG4Nuuym672LKe1Y
	 9dEkOE8RXeVEcOTgx3KZhS7N59mCUpLaLUIu1hrtdxK94u20+dbZqWfod+h1GjXvRt3P9
	 WiY14HWszF+P3DYaUhMTRH50tEYfveuWboCTbuS83POX3HV0jEZ5xoOe06jeF7KB9JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715048;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=FsqjxlqG8u1XDqlLty8eerFOgEp04Ke+7TabMLXwYYA=;
	b=cVen1Imz1aubeCceQBwjfvXPlu1dyZgWqH02irtiNHL0g8KNgAiT5wntKc6EaTd67oeH
	 E1GDjw6hqyt68zKSVgWXUbb8OdxGelMcmvaxZb8JxVQdnn/qPTolwviN2SIaNRKbNXjuJ
	 R8uBcABjPL32RHVPaBDQyqfJMTVP+jp45kOKP5sJcvDls/1PbNGE4AYL2CGnUC8AlSJZM
	 Yp28JJhVAPaCDkqU9Nnwm0xOVsn+oFXj60eMphulC/SZE0Iq48W/nje6ejQlLY+lyRxHP
	 hEVI7koxGaDkR08c7r70tD+eOeLrmbUp38j1cNHHSkcMXsZjGBpPFhtuuze0gwy3Sxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SuQfjuMt;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9E5DC606A32F;
	Tue,  3 Nov 2026 14:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E5DC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SuQfjuMt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793715045;
	bh=FsqjxlqG8u1XDqlLty8eerFOgEp04Ke+7TabMLXwYYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SuQfjuMtAqFkcqInvUzT8G9JyL1h9ou2AGfCHafVGm2gqFJ64V5EbfISkR95krjJ2
	 MTVU2qjDXBJwKASMx6DnFkOmoMcQ6JontpHRQySXzKu/F/r4HC7n9+mtvGfUKtJ9Ii
	 hJ4zdYXY8fh+r3C0IluR5x9eZYhUv0y9glWbbJSkX4VXrGtKJlMEwwyP8DpH1qZfzy
	 zXnwfV8tlFdbFLNms1WHti5IBKKDHR7/l2NMGiwi+357mAH+JYdBIwaK4dwbQtZ0Fr
	 xfz+m+aaJapEY1xCui9Ss4KkdcQmCZ0l/kFR+ODpsLETkgu5x98DYpxQYZrWCMKwfU
	 +Y7K5cMg7iSKA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5A78B6008B;
	Tue,  3 Nov 2026 15:10:45 +0100 (CET)
Date: Tue, 3 Nov 2026 15:10:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH nf-next] netfilter: flowtable: do not scrub as crossing
 netns
Message-ID: <aunrYtF-hfPRxUCG@chamomile>
References: <20261103140308.591690-1-pablo@netfilter.org>
 <20261103140308.591690-2-pablo@netfilter.org>
 <179371488692.488859.8707984454002960043@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179371488692.488859.8707984454002960043@kernel.org>

On Tue, Nov 03, 2026 at 02:08:06PM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.

This came from ... :drum-roll: ... a LLM unrelated report, providing
with a patch that was not looking very good, but I could scavenge this
subtle aspect from that pile.

> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
