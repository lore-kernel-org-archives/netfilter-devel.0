Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77041EFF9D
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742636471; cv=none; b=Q1aUMOPBCPItcURu43FutlRfh3/kjrhhZNHfDxYJo/mq87fpSohbPYe6dx2MfWiPPE5BbwVB2oskDdScOxEE6vrdvCIq4/Ryv3bDUuoDEnE74j9F5y282opUaIa9NTyQ6SweLcmSccVs0lx6pJ0AuHUEDsUDcL2du5mM1p7/qYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742636471; c=relaxed/simple;
	bh=xroatHh9wAgLBtUZV+qJDjeXJLlrBiT6N1745aavX+0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GJ948BJ17L3kzY4YbshFbXbI7C3og6raSJkKMyMG4xOxCstle1cYN+zt0r24/hCoYb5oUWTVzsYGW1ZWGuY7Dv7n3EpZ61Rc4FcWWMKPKNAtbLHKdto2yXI/B61iodkQ6OEsVSw4EPZSrrAFiABWZWmpCw8JEqqxVobqv3TsK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 87B8F1003CFAD2; Sat, 22 Mar 2025 10:41:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 860E61100C2DA7;
	Sat, 22 Mar 2025 10:41:03 +0100 (CET)
Date: Sat, 22 Mar 2025 10:41:03 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Eric Garver <eric@garver.life>
cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org, 
    fw@strlen.de, pablo@netfilter.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
In-Reply-To: <Z8muJWOYP3y-giAP@egarver-mac>
Message-ID: <21n3p554-628p-rp58-9n30-ons568967243@vanv.qr>
References: <20250228205935.59659-1-jengelh@inai.de> <Z8muJWOYP3y-giAP@egarver-mac>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2025-03-06 15:16, Eric Garver wrote:
>
>to save the entire running ruleset. That's what I do. Mostly because I
>want to make sure runtime accepts it before I make it permanent.
>
>Perhaps this is not mentioned due to the `flush ruleset`. We could
>suggest saving runtime to a file that's included from main.nft, thus
>retaining the flush.

I'll add it.

>> +[Install]
>> +WantedBy=sysinit.target
>
>The service definition is pretty close to the RHEL one [1]. The major
>difference is DefaultDependencies=no, i.e. early boot service. I think
>setting this to 'no' is okay for nftables. I don't see any
>incompatibilities with the RHEL version.

The patch already contains DefaultDependencies=no.
https://lore.kernel.org/netfilter-devel/Z9wgoHjQhARxPtqm@orbyte.nwl.cc/T/#m8f856650f1553a3b6a0ed17af37ce1ad5acb3227
