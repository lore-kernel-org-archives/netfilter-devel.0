Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED51B6552;
	Fri, 30 Aug 2024 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038588; cv=none; b=hqcxE0ZejbwNhsFc5ADu4eKpOA8tdnW9D900+bMAaqn+fxH2qXVV3G1xQrfRizn4YUnEcjJSjkmmBOhcPxq2hfc2LoyWovCZG6rbXW+SIjlWNP1YitREStDtsPFvsRjGm5CT2A0hv40oVhEEuQj+gMrhMV1NwZkES84vQ8yxbkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038588; c=relaxed/simple;
	bh=Brr8sN57GNWRFpPZm9az4LhuYdjGjmnwTvEbe6xkjBc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Vl6EXZG4EV57vzL1NPHMAvDLazE6JtUBNrwwtefT56lw8c/QES5UHqE4oS96Ctv74Ez8me6yjtcK9K/1rna/qWV0yX7h74Ojz4Uw+WYobxs9t7GDiRnh/TLjGawToi+M4k6pGkI5MI+Mcd4AZWoDVC99rvNsAjwSAncYKbI1X+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsW82RbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsW82RbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFDDC4CEC8;
	Fri, 30 Aug 2024 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725038587;
	bh=Brr8sN57GNWRFpPZm9az4LhuYdjGjmnwTvEbe6xkjBc=;
	h=From:Subject:Date:To:Cc:From;
	b=HsW82RbWIyP4TPZMrcq3KgD4Y8TdqSH3IIMulALn80vjCLapSeeKIvRWKi8jkIsgf
	 Y09LCTAk7QowcupDH81JAiAqPOPVFZLIeY9kec4GGk0rn2kGRkFrJcSwmbk2UTRzh1
	 /ZjQNp0MKE+46/Pfs8hWe95hJjNA9z5+ybb3t3JhICtsd+wmpCzvP3xptv39Z3mjwz
	 UAn7dwh1bnDepw5G7Tw8Tq+QNjQKCp7OqaozZbu930QmEQ089ZFqIN8afnRchWYsCI
	 BOe1U8LOr7eWKTwxWoL8PIgpNlOkiqreeO8cuGHtj3LaygK3ZxQIZ3aBaBaim4gpRI
	 MgnU+Src46k9A==
From: Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next 0/2] netfilter: Add missing Kernel doc to headers
Date: Fri, 30 Aug 2024 18:22:59 +0100
Message-Id: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPP/0WYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDC2MD3bw03eyU/GRd4+SUpCRzMyML00RLJaDqgqLUtMwKsEnRSkBFeak
 VJUqxtbUAHJeSZ2IAAAA=
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.14.0

Hi,

This short series addresses some minor Kernel doc problems
in Netfilter header files.

---
Simon Horman (2):
      netfilter: nf_tables: Add missing Kernel doc to nf_tables.h
      netfilter: tproxy: Add missing Kernel doc to nf_tproxy.h

 include/net/netfilter/nf_tables.h | 2 ++
 include/net/netfilter/nf_tproxy.h | 1 +
 2 files changed, 3 insertions(+)

base-commit: d2ab3bb890f6a88facf89494ce50b27ff8236d24

