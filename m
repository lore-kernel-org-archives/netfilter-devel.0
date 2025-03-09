Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4376025
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Mar 2025 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741540186; cv=none; b=KT5MPI7bKKMfwnf6PqpKszsN0wX7gcPOIyEISq/qm+Z/pM3wV+O82ygNuOjCy6AndtrRMgNRynaVxsA1zSDgVKm1OzBdFfhvA6n23CHSEqmB0nIlQAMj/o0NGAGCI0P38qnuLNJ8IVYyXxQSPC0LoAGaJhLIcl01Jamh95Bl3K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741540186; c=relaxed/simple;
	bh=PQQsqE36jCRFPATwdn6wE+h6nXbbpwF0xN0ueQOVk9Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EMHrovqbqoH86yms2bC/b/L2wErFE3boyQA/WU7TQX5M6qzbf7f/lO86FeT5V2k7bhNGGv2efuHPijEu4X0thXMUzDhOIvVBokbN0snHFRAWwHIc1dDFydCgiMOfBNDCcxVezmwcwqymzsQqJ1/ugLytc/8VdafJ4pXrpIvgMIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 533A51003BB14A; Sun,  9 Mar 2025 18:09:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 51BA61100ACBF3;
	Sun,  9 Mar 2025 18:09:40 +0100 (CET)
Date: Sun, 9 Mar 2025 18:09:40 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Jeremy Sowden <jeremy@azazel.net>
cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/2] A couple of build fixes
In-Reply-To: <20250309164131.1890225-1-jeremy@azazel.net>
Message-ID: <s4922o5r-568s-ss65-14n2-7r9o60957s45@vanv.qr>
References: <20250309164131.1890225-1-jeremy@azazel.net>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Sunday 2025-03-09 17:41, Jeremy Sowden wrote:

>The first of these fixes the building of libxt_ACCOUNT.so and libxt_pknock.so.
>I sent this once before, at the beginning of December

Indeed you did, and I wanted to investigate why automake would not accept {}
in that spot, but I guess I got distracted.

Applied now.
