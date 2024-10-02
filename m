Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E64E81720
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727898935; cv=none; b=WXSaNL8W3nYq1oHaGOBsKIgZKMTEghfLvXGnXoCOkgQDVdUvaaTU8pAwcNcBRyj40+Fe4vCNYCfl1Dh8ql2LoJum1/tm0vuuyMJiUgM1//TRDqIHybSMywfWxLcZNdkuT+yraLwtuogAnD08k8jcTbMrOa+AQvwkEzCFumCfEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727898935; c=relaxed/simple;
	bh=kIlL5fjI5nttF4240+DzoZ8/ofwOPLrLyvb2bGW5H8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B49pKH3vUQFdRNwA2Uq+q7a6OA9wmQ3LB31MdN1FG8zKJK9zhGsBSNsg9DukEFGI2Q/pAXPQR/nWOxrgfn1lvJcEuCKaZ86TWUJ1I/XzjAkqUGAtdO5RXWO6G9LLWiplDzRymBvSCQmLoPjQU/WZJfAmjqrsMUNkDKA6zZk211k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=k26HYe7z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="k26HYe7z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b9d3WMrxp4CE/3CkLEVa7jZuncSf1sD//oyMkt5JuQ0=; b=k26HYe7zlrmrQEQ0GCpLGXx7kU
	pHtIN7oK4KezRHNZYKfweBss0wO0ivN9sgSZK5/olty2yW/AgoDlm7TLtfIo1STPB5bFTsZwfKRy2
	vULGF176GTATkYLiyG2b6w9ObG/bva2wM/PDguRsquKiYOcGqqJmMzy4oRmnyrE0dmo4NbcstZbK0
	0a1rUOdIZ3j6pPXg90n5OBxfet3wvDrxHq1OeDGQEtCmspkEELz3LfYgzqKCqjZ6JNQnqbbNEY1Xf
	5ffmTGsYEujr6R2IyvUtvlB/YG0Pj1ObN8PIGlSJ1d8oy3eygsAQ3ASv1BXYbnwYV7vDkXijXLq8C
	vAR1LlwQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Rb-000000004Pl-3iGE;
	Wed, 02 Oct 2024 21:55:31 +0200
Date: Wed, 2 Oct 2024 21:55:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 9/9] monitor: Support NFT_MSG_(NEW|DEL)DEV events
Message-ID: <Zv2lM4oSU190U_mS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241002193853.13818-1-phil@nwl.cc>
 <20241002193853.13818-10-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002193853.13818-10-phil@nwl.cc>

On Wed, Oct 02, 2024 at 09:38:53PM +0200, Phil Sutter wrote:
[...]
>  tests/monitor/testcases/chain-netdev.t     | 66 ++++++++++++++++++++++
>  tests/monitor/testcases/flowtable-simple.t | 56 ++++++++++++++++++

And as foretold in patch 4, the new chain-netdev.t clashes with similar
content in flowtable-simple.t. To avoid this, both need a trivial
adjustment:

diff --git a/tests/monitor/testcases/chain-netdev.t b/tests/monitor/testcases/chain-netdev.t
index 3c004af0cd855..414040045dd20 100644
--- a/tests/monitor/testcases/chain-netdev.t
+++ b/tests/monitor/testcases/chain-netdev.t
@@ -48,6 +48,7 @@ I add chain netdev t c2 { type filter hook ingress devices = { wald* } priority
 @ ip link del wild23
 I delete chain netdev t c
 I delete chain netdev t c2
+@ ip link del wald42
 O add chain netdev t c { type filter hook ingress devices = { wild* } priority 0; policy accept; }
 O add chain netdev t c2 { type filter hook ingress devices = { wald* } priority 0; policy accept; }
 O add device chain netdev t c hook wild* { wild23 }
diff --git a/tests/monitor/testcases/flowtable-simple.t b/tests/monitor/testcases/flowtable-simple.t
index 113b15f20d1dc..2c82f4907ed93 100644
--- a/tests/monitor/testcases/flowtable-simple.t
+++ b/tests/monitor/testcases/flowtable-simple.t
@@ -48,6 +48,7 @@ I add flowtable ip t ft2 { hook ingress priority 0; devices = { wald* }; }
 @ ip link del wild23
 I delete flowtable ip t ft
 I delete flowtable ip t ft2
+@ ip link del wald42
 O add flowtable ip t ft { hook ingress priority 0; devices = { wild* }; }
 O add flowtable ip t ft2 { hook ingress priority 0; devices = { wald* }; }
 O add device flowtable ip t ft hook wild* { wild23 }

I'll wait for feedback before including this in a v2.
Sorry for the mess.
