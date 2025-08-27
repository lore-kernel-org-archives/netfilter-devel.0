Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDAA338F40
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756298436; cv=none; b=bqp5xdYgvsjzmqjMBJtsWNipVI/y/2VsNcqZlCUuvgdOfldGuSS5y1kmbdPJxt+DL9RIu71sIKYudf/bpWC+oKMcClQ5ZoHPnzXiPf4QNBq8tYyDEyeXRBxrK8WBBp8me+f2dfwFiSWyE2TqufxdasQ2tttrBy+E4FyZV/4Mf04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756298436; c=relaxed/simple;
	bh=Iq3jV6colbyjQEiJzgealRi1CczHmPxMn2MvxQ7EmX8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oYVO9D3XEoTzFzNRDBIT3HBcjLnML8ouzbXDfx0e0wJy17u2CX2a3Q28fokcafBcwx7DhaCM0rivkA/TwS+/VFV3MeXGFW56u+1YWMKFWPAlUlYsV2sRIYnRpU5yfeRrWtKlwyMa02FLO6BRoIXXNxN+h1UJljC1o35akMgiHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 92AAC1003D9D0A; Wed, 27 Aug 2025 14:40:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 90ABB11010EB79;
	Wed, 27 Aug 2025 14:40:23 +0200 (CEST)
Date: Wed, 27 Aug 2025 14:40:23 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Fix for 'make distcheck'
In-Reply-To: <aK74iFRHm3WTCEbq@calendula>
Message-ID: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr>
References: <20250826170643.3362-1-phil@nwl.cc> <aK4N56uzuIWgBiG5@calendula> <aK74iFRHm3WTCEbq@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2025-08-27 14:22, Pablo Neira Ayuso wrote:
>On Tue, Aug 26, 2025 at 09:41:27PM +0200, Pablo Neira Ayuso wrote:
>> On Tue, Aug 26, 2025 at 07:06:43PM +0200, Phil Sutter wrote:
>> > Make sure the files in tools/ are added to the tarball and that the
>> > created nftables.service file is removed upon 'make clean'.
>> > 
>        make distcheck
>
>/usr/bin/install: cannot create regular file '/lib/systemd/system/nftables.service': Permission denied
>
>This needs a fix.

I encountered this previously in other software and know a pattern;
let me cook up a concrete patch .
