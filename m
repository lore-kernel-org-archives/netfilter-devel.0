Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715A311C27
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761724852; cv=none; b=rT4TA0pwALgNxOB5YHBRjmqdnxZvCxkNTZ3nVoYEN++dgl1sLJZENae5qM5nHDTsiVqzKIfiC/w1/eF534O158nqRnrK5CFF/u92pG+y0Tsyb7QR7K9Xd+LzdtNWScJtIS0Z5K591ZdNF5jokkKt/mkpR2xSfQKeviCbUYOs9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761724852; c=relaxed/simple;
	bh=gm1Hm8MSDu3+j8QCUDgUdtwVNZxkodcnpIrCFvktmaM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qC/MReUadWsUGgpecodDghO+SDvcFWsLDmEDgerNEn27aW16ure2i30OWlM0Jw0Y2vgx03OTQEC9PZsEHdN17VeaVqGI/n9O4OOv7J7LNwPZMft155Z3rhdduC6PL7CaAvk6QUPC3efhRTJkcbynUPKp9gyBwKFuQZCa1YELsxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=PGYcDepW; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="PGYcDepW"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4cxKH94W6WzGFDMs;
	Wed, 29 Oct 2025 08:53:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1761724387; x=1763538788; bh=4ofGHyqTDs
	NVHljgP8vMzATc8CG9TlXO3N83AzT8mWI=; b=PGYcDepWJSQlkHgLFel3r96u3w
	GaWHMTz2UPZQvEhmkc0E5eom/6Nkj5S54IjdECEll1nR/GTWfIbB288ZX8RswSNz
	W8C5F/vPHjOaV1w7XASPFE1VkWZUOMSLbDwHl3vk86Yymbw+5TxijlMZ4A4VNKot
	+J4ZG3JmPJvrj4dGI=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Xcg-wuckz7fO; Wed, 29 Oct 2025 08:53:07 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4cxKH71vXszGFDMp;
	Wed, 29 Oct 2025 08:53:07 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 222A134316A; Wed, 29 Oct 2025 08:53:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 20AD5343169;
	Wed, 29 Oct 2025 08:53:07 +0100 (CET)
Date: Wed, 29 Oct 2025 08:53:07 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jeremy Sowden <jeremy@azazel.net>
cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: ipset download location
In-Reply-To: <20251025160852.GF4413@celephais.dreamlands>
Message-ID: <fc75f23e-ebcd-6274-740e-805fb6c9ab01@blackhole.kfki.hu>
References: <20251025160852.GF4413@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Jeremy,

On Sat, 25 Oct 2025, Jeremy Sowden wrote:

> What is the canonical location for ipset release tar-balls?  The most 
> recent one at https://www.netfilter.org/pub/ipset/ (which is what we use 
> in Debian) is 7.22, but I spy 7.24 at 
> https://ipset.netfilter.org/install.html.

The two places should be in full sync. However at one server moving the 
sync was lost, which is now restored. Thanks for notifying about the 
issue!

Because of the sync, either location can be used.

Best regards,
Jozsef
