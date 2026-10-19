Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766114AA033;
	Mon, 19 Oct 2026 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792406816; cv=none; b=t8WkJ/C3Yq73wSRzPcnv10TflGWzTHTNqitHVr1lFxRx1huB6QcgtQf7aqykqmoabV7aDVElU+K4Av2VD6o/tDzXYphJRhxLtXeQq8HYGUymyNMLqlQvRG2r7l1VQC1rm3kK6svCTJ/IsQxwtuERcHyVIlSrtc5RfIJTZvVnSe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792406816; c=relaxed/simple;
	bh=gLdCKqrr6hcol62cMYJ/wZT3hr6HJcc86qpKgWaGz0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fN6hlvC09oUaCE4cLTOwckcX4sEIYxDoysrHmMnuX4YrDUkTYSF3J+1VQklJ5kBwSFMm9PzDjet2DeKbEjA7XEyp3YqYkyBwluSMjVicf4Xlck9uVmlDKBbEDQB73OegLgJtOjQncZu/dE2U38BVzdwsaQbAnnlYHu+UEdgjgbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NqVuHlVG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NqVuHlVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792406810;
	bh=DGKm1vhuj3qCRyUFCSi87tHJ9Sjbvs34QoGxyJaq/U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NqVuHlVGqYNGtJPrfTBSZYC6IvshiQAopEuPHAKaHufOVliZDN4oa19PRWoaDBuuo
	 Ew7+fbhIhlG/DEaiwrd4pvwSbfSynNCPBoai+RA785ryGnNL0RlgBGsuO8KUIdsmES
	 +yF5JvMrsS7yRsgDpaa9N34/5Y0IV6izDzCHXaiJD7qe6rkCfT6GsE3vbQbyu/dyZe
	 AkpYRrQSgkIvAnpnESpCnx1rP6doQVrTKowxJzUGAddJfFQN5SwLEuoVARc3xZoFjG
	 9LX64SC9eJkBUKuZIsi/FqsK9m3+GPgxIZS8Y+3OVpkVVsiflEjnK9010JY8BIHuev
	 7r+SpndYyCDxw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9ABE860051;
	Mon, 19 Oct 2026 12:46:50 +0200 (CEST)
Date: Mon, 19 Oct 2026 12:46:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: fix pmtu discovery in
 nf_flow_tunnel_ip6ip6_push()
Message-ID: <atX1F6DbOdaKVd43@chamomile>
References: <179240514712.3290.6021443998153366667@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179240514712.3290.6021443998153366667@kernel.org>

On Mon, Oct 19, 2026 at 10:19:07AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

Sashiko reported this.
