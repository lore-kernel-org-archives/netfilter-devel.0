Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B2198E7F;
	Fri, 16 Aug 2024 10:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723805612; cv=none; b=D0qRowZwTcyy00n21JDX4LYAxZes3kMnfYMx/UAjMvRx6QxUtWAzsylTPaFLJwuzvPyc88fzly0Jav4vJcRscpOzKk1bv0NUY5u6GjxvJf7KVh6QpAw6YxmiSnd1y9GzwsufEQruma9zaIVV0UoMZmfRs0N7TFQn7nGi6ynUEdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723805612; c=relaxed/simple;
	bh=tO7V0fKpegM4QFifu5oIvbvydGoA0w+xIAowzqH8XR0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Tr3xyeiuRtSfU9RHmTmflhLH034PRS2ihaOKBSGGOSlpqTU3mlTF6XOU6IXLVQS+Qky0LtYe9KakGTxuMaW5vDgegvfdVwhf3agB/7zlXecCPZeEggTqhkUcSg4Dq0SjXyRLtXj/HAFxi9J/sXXRjaq1TokIMWsFU2XAkSJrnx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52506 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seuaD-000sa2-M2; Fri, 16 Aug 2024 12:53:27 +0200
Date: Fri, 16 Aug 2024 12:53:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] Security evaluation by ANSSI of nftables
Message-ID: <Zr8vpKWg2hs9PBci@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.9 (-)

Hi,

We are glad to announce that nftables has passed the Security Visa for
the CSPN certification provided by ANSSI for Debian 12.1 with Kernel
6.1.55.

Created in 2009, the "Agence nationale de la sécurité des systèmes
d'information" (ANSSI) is the French national authority for cyber
security. Its mission is to understand, prevent and respond to cyber
risks.

Additionally, for your information, the English version of the
certificate report is available at:

https://cyber.gouv.fr/produits-certifies/nftables-sous-systeme-du-noyau-linux-version-debian-121-noyau-linux-6155-1

Regards.
