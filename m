Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B598265284;
	Tue, 12 Aug 2025 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754995418; cv=none; b=ZFRCP8Q3K8YfipwOWL3phiDVnlnEfjX5quG7Wk27is5bljanFieWwB1N/rBaG//8P9ka6iDy9kiwcWfWfsqOitKYsXdfeB8toL9rq7qwIiXIZiJeh+Ih7iM+s14m+vO3LwbInwJwLeozngAk7ymNGKrRce5iWsD6aLhB+dqJPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754995418; c=relaxed/simple;
	bh=+VIezC9DLfCKAoqJQtZWx8/Xzm16vjitVHVeUQk+gSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyMPXzQetZDo/bE1BAKoer8OP9GFTVSD75rSlKqsI885z3+eTb6/++56Mg0QjmPCsFPt6diFtWNK4CMb/qNQ67RHFBoEPwRtn5m918wdwzcKDe1IGmeU8tcGf9fo9qnY9idJ+W4O9WiO99bs2W8rW0aYyiOHJjMEUBYuHc3tDDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9D58060172; Tue, 12 Aug 2025 12:43:27 +0200 (CEST)
Date: Tue, 12 Aug 2025 12:43:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: nft_flowtable.sh selftest failures
Message-ID: <aJsaylkoOto0UsTL@strlen.de>
References: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
 <78f95723-0c65-4060-b9d6-7e69d24da2da@redhat.com>
 <aJsH3c2LcMCJoSeB@strlen.de>
 <f1ca1f95-c85c-48a3-beb0-78fff09a5bb2@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1ca1f95-c85c-48a3-beb0-78fff09a5bb2@kernel.org>

Matthieu Baerts <matttbe@kernel.org> wrote:
> I don't know if it can help, but did you try to reproduce it on top of
> the branch used by the CI?
> 
>  https://github.com/linux-netdev/testing/tree/net-next-2025-08-12--06-00
> 
> This branch is on top of net-next, where 'net' has been merged, all
> pending patches listed on Patchwork have been applied, plus a few
> additional patches are there to either fix some temp issues or improve
> the CI somehow. Maybe one of these patches caused the removal of
> CONFIG_CRYPTO_SHA1.

Yes:
    sctp: Use HMAC-SHA1 and HMAC-SHA256 library for chunk authentication

removes it.

> I guess that's the case, because when looking at the diff [1] when the
> issue got introduced, I see some patches [2] from Eric Biggers modifying
> some sctp's Kconfig file. They probably cause the issue, but the fix
> should be to add CONFIG_CRYPTO_SHA1 in the ST config as mentioned by Paolo.

seems like these two are the only ones that need it. at least
xfrm_policy.sh passes again after this change.

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -115,6 +115,7 @@ CONFIG_VXLAN=m
 CONFIG_IP_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_POLICY=m
 CONFIG_CRYPTO_ARIA=y
+CONFIG_CRYPTO_SHA1=y
 CONFIG_XFRM_INTERFACE=m
 CONFIG_XFRM_USER=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -98,3 +98,4 @@ CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
 CONFIG_INET_DIAG=m
 CONFIG_INET_SCTP_DIAG=m
+CONFIG_CRYPTO_SHA1=y
