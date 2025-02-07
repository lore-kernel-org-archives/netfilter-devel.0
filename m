Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EC61DE3A3
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738922103; cv=none; b=Gi4l4h54Ta/EE700XsFOyXNnGBqex0DfFhxHtYVGnTjY/1MClrotjYx02GFUjGNfdEuVjklk0RXx8tENahsw26eG6KuhvaXObJt5JXBQdY/cOoU4VoIZdaXA+yHAvU1cbcFldfhr/tYmMwSLG0I1ryfexYFo10EW6FBAjQZc0pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738922103; c=relaxed/simple;
	bh=fzNOAmySp+S5wsm0/bVNs3gVxayfd+hngZLt+CAdLjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emHKz/9SGEG9e/Vc2pgt3djhfQNnCiyzQuaqTP4mAtora8wQJ1MgeXlJvkoSEpdey5KuoazKH9dwPPQEIEuI40UsCZCshQjirjHc4xJm2k6ZIwv/X8W9KPgCVt36ODPp3tva+qH7kST5kaU0ijEQpyO/eBrBPiNDO9OcT65YD+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RFFoxIuA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RFFoxIuA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RFFoxIuA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RFFoxIuA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5FF0B60599; Fri,  7 Feb 2025 10:54:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922099;
	bh=H1sbur6hEWztTbwH7VCPyIoePTQSGscmLaMgSegQTsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RFFoxIuACqxKd5NLxnBGI2DF2HhvI3IGf3wTrUIvZyUZRqZmmV1CG+PuqupKhPKLq
	 +9cmfSpNYEjsjO6+mpqS3/Ni9vtkbaYfFVKb41qA/xliTiG9tS3WM1ifQzMfc05m6g
	 NR9XQw86imPpKBljCh7KTPLZeuHZtkMVZSbChJ93a75uPel6p6flxFE9YosQBUkb9G
	 c8qWuBDVSPZtr2FGo/fcuq8FZB+WbOO2rZsz4s7QpZ2h60sidp2WaGIIY0HFG4pimW
	 cHH9MNy2QdX6wYvYquZEAc+hVJi2Rz0otWokkB+QUAdP/kU64Qe5k6XN5tldHkwyxL
	 SfXfQuPMVOj5Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DC7BC60596;
	Fri,  7 Feb 2025 10:54:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922099;
	bh=H1sbur6hEWztTbwH7VCPyIoePTQSGscmLaMgSegQTsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RFFoxIuACqxKd5NLxnBGI2DF2HhvI3IGf3wTrUIvZyUZRqZmmV1CG+PuqupKhPKLq
	 +9cmfSpNYEjsjO6+mpqS3/Ni9vtkbaYfFVKb41qA/xliTiG9tS3WM1ifQzMfc05m6g
	 NR9XQw86imPpKBljCh7KTPLZeuHZtkMVZSbChJ93a75uPel6p6flxFE9YosQBUkb9G
	 c8qWuBDVSPZtr2FGo/fcuq8FZB+WbOO2rZsz4s7QpZ2h60sidp2WaGIIY0HFG4pimW
	 cHH9MNy2QdX6wYvYquZEAc+hVJi2Rz0otWokkB+QUAdP/kU64Qe5k6XN5tldHkwyxL
	 SfXfQuPMVOj5Q==
Date: Fri, 7 Feb 2025 10:54:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] tests: py: extend raw payload match tests
Message-ID: <Z6XYcKjChmqfrcX6@calendula>
References: <20250130174718.6644-1-fw@strlen.de>
 <20250130174718.6644-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250130174718.6644-3-fw@strlen.de>

On Thu, Jan 30, 2025 at 06:47:14PM +0100, Florian Westphal wrote:
> Add more test cases to exercise binop elimination for raw
> payload matches.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
