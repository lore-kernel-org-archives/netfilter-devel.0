Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442575;
	b=kooE6DFt5mL+Iok5uRUwtQ9YyzF1TMc7VujMqCiNZQ+/DSCtzEPlmHqu4tOOZO4E7Kjv
	 n//RNglGO6R8E3ugBWNA1eYPjsXzffSoXoRmdvGLsmYK2JfvFnHdnorsWzldzQAx8euY9
	 Q+pLleXez09EAt5RbIkoAJ3B2MQ1sGICmo9zE18RQGQdTL2vmeXPSjS4QNcL0D+syHBAh
	 pnaoaGCADFtVc+yv1U6+sUHQuuHf9G8sh5HoFn9v/G3tftU32WsIv0A27tCMfFhYsCsMb
	 +AzhxU+MEaqj87HvFa6i7+fCyxSZ8LxXtKIZsmZa2O1EdZwCbDXqRp8ev1DLOkvJPgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=QjTa/jyN4p0GOHh9j8Qxsjb1nFfr9pRNPP9QlQhrWmM8d3Mk0qSr4qePMgoULCkPO+yW
	 KpCeqhRpcTx/D7PHdyRhQM42RXDeUziF3adm9Qw6bo5kkBd3GzWRoqjquULxulEWug/2e
	 HgAgAF6kWI3dsEvoXj4Xf46VqWbaW1ZNowMWhitSGDi8f9ylnUVGnEIkSIULsDpaQoScg
	 ZmJwQ3j25aWbiB/0mx53I72CT5eyf9N4m4RQrImOBBz5BcuIjVb5RgJ1Hm9nvs/KYb8gn
	 m1LkBxmfnobiRN0OhCVIoLTE4gldRIzSxjinLaDI4aYUig95ZmjKwSeaCFA8nfVXWRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V7JTQXVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C2606A31A;
	Mon, 23 Nov 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V7JTQXVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E71C1F000C4;
	Mon, 23 Nov 2026 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442575;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7JTQXVal4JvJHpm/1hxqPkcTr0CT6cxd3+H6yT5nlMH0S0I3tepr4cYbkP65UIlD
	 Iab3ujwpzykBKLrbNmTecFiJGB4/aNZZDWR8pJ19Un1zJya4cJ11IZEbjY3PgOPvcy
	 BzbMFSMrJjur9x362O6Q/WPpNAsw43exdxbg6LVNP1q5PLTlUP2tpoLHjIiDsf96ra
	 2Pufr28FGyCDYZ7HZpKGuK9UY7n/dA+onaYpuEYlyLfmrXGur2BxL14ilDRmhBYv88
	 dn3oZsxIMimRfoMsUcT+PSlNTVsI+fE0gwNqYT6+6/A9b7Y7fqOjRcKFRibtb2Wd0V
	 GuXk/2W30JaOg==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: conntrack: prevent
 nf_conntrack_buckets race condition
Date: Mon, 23 Nov 2026 14:02:54 +0000
Message-ID: <179544257400.3294.16481017816141150879@kernel.org>
In-Reply-To: <20261123135726.3940688-2-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <20261123135726.3940688-2-pablo@netfilter.org>
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
