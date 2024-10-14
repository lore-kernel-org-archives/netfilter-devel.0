Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56664171E6E;
	Mon, 14 Oct 2024 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900587; cv=none; b=pd/P7Q9KntOHDwDt9bWzXJamjzs9JhcyaX5l/nWsfFz1Ni6ay/hm+urJBJWG5wmlbVIcfKFQOkKC01y7/y2mgpX/IpmkYx0xru4gv0ERXtZaFZ7jUoUR7e/rZN/5KSAgKDfTrkhChkcJ2DCradqfe63izemPDtrJR9q/OJq8nPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900587; c=relaxed/simple;
	bh=WuCyr1ov9qxMxhr45t+RuUr5/wANIzx5TVeuSjM+nXU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NagZqwQavCitKeGKybplOHvfUyv+9FJlNLtS1HRo4N+dHIQdvagd+lDUm1s25hs3Cd8iXC09dosVWSjIUtYT6797qsOW+YLSCOSDZU2g4fvJe8RAYhtjR48o5WBg+Os0ZEN2+jl86VKLiVqR/xbtuLRua1zeNX+ms0sSw+wU9z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43182 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0I1D-0068o3-27; Mon, 14 Oct 2024 12:09:41 +0200
Date: Mon, 14 Oct 2024 12:09:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org
Subject: [UPDATE] Renewing Netfilter coreteam PGP keys
Message-ID: <Zwzt4WOgB-0oIOHh@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Score: -1.9 (-)

Hi everyone,

The Netfilter coreteam PGP key 0xD55D978A8A1420E4 expired in October
October 14th, 2024. Hence, we have generated a new PGP key
0xD70D1A666ACF2B21. For more information, please visit:

https://www.netfilter.org/about.html#gpg

In accordance with good key management practices, we have also
generated a revocation certificate for our old PGP key. The revocation
certificate for our old PGP key 0xD55D978A8A1420E4 and the new PGP key
have also been sent to the public PGP key servers.

Thanks.
