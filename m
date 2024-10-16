Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1929A11711
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 19:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729106216; cv=none; b=S8tEWrg2pZK0EWMdSH0U73hEcv8sV/YECdSNtclwBYrhRKwi3QD2lzX2m6ZC4dRXyAygWAF5H60dP/UVO1c3Warmxvfi81MQTSjK6K5U/XDPZuoELpoFjYRtVoLKC8gvwmCkvxn8g8D/M20tuFRHmAg7SXKiST2XwtiZ+3CiC0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729106216; c=relaxed/simple;
	bh=Hp8APie2zEBrLR7XXMcYnBKqJfJSYGfYKbgWCM2lggo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XXPT3CN/E1rYqNIaC0pweIBzxnHL52nfelG+37W8OF9hwf8F4zSJJSAKYH7oDAFzf30NE3r3hczK4creDR990DFVOVHyMfqvnIW1AqY/Gg6zSxrAOGFxSeDVPYyHCwjXlCVl2G25mMoQivufp64WQGv+T/aRA3IbB5g5dLgcyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id D6B7F1003D14DE; Wed, 16 Oct 2024 21:16:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id D5A061100A4395;
	Wed, 16 Oct 2024 21:16:43 +0200 (CEST)
Date: Wed, 16 Oct 2024 21:16:43 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] examples: Fix for incomplete license text in
 nft-ruleset-get.c
In-Reply-To: <20241016170550.26617-1-phil@nwl.cc>
Message-ID: <9544rp65-2np8-922r-56qq-oq3r83on62r7@vanv.qr>
References: <20241016170550.26617-1-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2024-10-16 19:05, Phil Sutter wrote:

>When converting the license from GPLv2 to GPLv2+, the first line was
>dropped by accident.

I mean at this point, all the blurbs should IMHO just be replaced by

// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2024 Lee Developer // optional

as is already practised in the Linux kernel proper.
