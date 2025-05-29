Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF101D63D8
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748554923; cv=none; b=TskP8fkYIgllqOPpE6xcQtz+OSn7h3FPgWRq5MZi7B6QrmiJCCa8eTRTTxUNx7YNxxGF6LQ3nQKYlC6Ji3LyhnWw2LV3D4wlw09Vzm1cKTl4+ZCzZX2F5i/VYypzt1GGyLBxFpozu1Mvg8KEUPiQjWJpyhd+AJki6vjgGMlBsck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748554923; c=relaxed/simple;
	bh=vdZokMlMZu/owgf1wdgjoHWzTFOrYihJ1i5XauTPMfU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oWYMn0qpi7ar0YqlGmWVFqnPEuIFXIiZ2KbJA9H2tH/Rlk2lFAb6RUwRFCfpxb8fQWsuUNMX5uLBrnpC+nLdsJR06NqBH1e1vlVbHpS9iLplzh6Xb17FI9aa4GQuaG/JbRSBsNGyTSX93hVB2A0tLX0K7kMg6MP/tVWsYWFr7gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id AEE561003D93F2; Thu, 29 May 2025 23:36:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id AD2BB1100AFC16;
	Thu, 29 May 2025 23:36:17 +0200 (CEST)
Date: Thu, 29 May 2025 23:36:17 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Jeremy Sowden <jeremy@azazel.net>
cc: Jan Engelhardt <jengelh@inai.de>, 
    Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons v2 0/3] Some fixes for v6.15
In-Reply-To: <20250529204804.2417289-1-jeremy@azazel.net>
Message-ID: <or242rn3-qo30-351n-8r72-0q1ro27r3p67@vanv.qr>
References: <20250529204804.2417289-1-jeremy@azazel.net>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thursday 2025-05-29 22:48, Jeremy Sowden wrote:

>Replace a couple of deprecated things that were removed in v6.15 and bump the
>maximum supported version.

So applied.
