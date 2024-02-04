Received: from shin.romanrm.net (unknown [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6317D10A01
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Feb 2024 23:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707090740; cv=none; b=kQ/Y0QkiwRg/RhFNL3zeNfEfVTkeoLaC1c1jaDtNsA/rqhBPpM/y83XDF32dcFgOtds2BSaOkfiRvBbPl3ViAJaOw9788f/75jef4dn9BjnBD77Y0dghLEK+SK0r4iqc9r/Vp9qsjeJNb+bYEprsWwDz/dygkYlUIgvV6Otz8J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707090740; c=relaxed/simple;
	bh=oFpsdy8ukbHFmAqg9tzelv0yXInSI54a8ci0qczWNAs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=aohZbWlXXr6ZP/VaIUl4ZgySvNCUgGwa/RyWsrHluOrEvXHobROUGTRVRjG2tIIwdho1sSHpR3o0vO97jXxHsoBNTPCoY+e2tVgumusPeQA/JYmHZ3aT1eRL9V7M5VzuD4UVGF3AbX/+0d1ZTAREZWKQkQouSnNXQS9H5ggsfZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
	by shin.romanrm.net (Postfix) with SMTP id 6C2463F4A1
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Feb 2024 23:45:28 +0000 (UTC)
Date: Mon, 5 Feb 2024 04:45:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: netfilter-devel@vger.kernel.org
Subject: iptables: considers incomplete rule in -C and finds an erroneous
 match
Message-ID: <20240205044519.45334f8e@nvm>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,

According to my ip6tables, a rule like this already exists:

  # ip6tables -C INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT && echo Exists
  Exists

Except that it doesn't, and an extra IP filter is present:

  # ip6tables-save | grep 80,443
  -A INPUT -s fd39::/16 -p tcp -m multiport --dports 80,443 -j ACCEPT

Is that the expected behaviour?

ip6tables v1.8.9 (legacy)

Thanks

-- 
With respect,
Roman
