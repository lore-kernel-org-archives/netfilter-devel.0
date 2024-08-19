Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CCD1891D2
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724094252; cv=none; b=h73XHxWD7aZb04OQzNe8CqZFhAeRXbsk68b7Oj2sNfPmQyIHfz0UzVYuXk0gAMOUBx08XIhpvudWpqCLYh6t7/yfYyBa5NdGLfxJ8Ttq42VzmiYqCcNey9eZiYGpKr0GFBaRPzjzROemDB5Q17CcoYzRcaixeW4I/RjWIos78q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724094252; c=relaxed/simple;
	bh=WIISdmp6EXT3KozGjO3fv3OzxgEcSqXbItXM16zenug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/t+E4nTsZjgjbSx/wqtdPpWdwyjuAAO/XYGp42Kn0IPV/oWRDz1/3+j6cfsOonSdEKru0l0gKnQcvWFsakijC/2sj4l3PuIkyUqp+ruxduCPhCpagIXkUIm+YMlxh6mYxhHuJotEe3J1lS3auOO3nLdC5R6JW0uYs4hzjoroRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jd0a5CaA; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jd0a5CaA"
Received: from phl-compute-08.internal (phl-compute-08.nyi.internal [10.202.2.48])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 79C9B114E500;
	Mon, 19 Aug 2024 15:04:08 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 19 Aug 2024 15:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1724094248; x=1724180648; bh=WIISdmp6EXT3KozGjO3fv3OzxgEcSqXbItX
	M16zenug=; b=jd0a5CaAqBvLjogv3n07j/6XoR7RN2y5mlKQtxlkhACdvUbHfnT
	jt/G6ifV5kw4a6N4g+3nZ2miTtlaYwOxCr8K/z7Zej3M2n6CXGV8MttUXwEUMKW6
	Qzsl0O74UWnbBtYTXWwGe7AftUYCvcSqBxUnyaJitZJsWEDOw8cSoTnmY7AzXSdB
	tpIeUNQlSx9XqtwI+joeByFSet+u87Q62kAJxPP8088B8AayOkNYpJxGdlmiima+
	F4gVH8zr/xLvnCm/vH0J7tj0zfdL+PeaBy4DIhSnrnU9QKuoHtsmc3KQ5O+43sx9
	WOMK6Jl4rJxunRsr1AiYvJz30zKq7aPYORw==
X-ME-Sender: <xms:KJfDZpkJJ_VddLMNvYCNgPEZmY_fYjf0-LWw5wklwaMRdQ-9jp62Jg>
    <xme:KJfDZk2oQEMwC7sBaIiXuu-ZHSYW7wud4TKzXoYcECrbUQ1ni3T4sAEKW_-Js86VD
    7mBI08rjJ3chjIA>
X-ME-Received: <xmr:KJfDZvouGZ5lLQPYAbd2BxIZ8HNXeAk5VMd3Gw6p-l8dJP5G4CD5PJ2tdKWcpiENSEgvxIZCMmNMnYolnQ5oqjz8CWqfX5aEyyaByg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddruddugedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgg
    gfrhfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepphhgnhguuceophhgnhgu
    seguvghvqdhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnheptdetffehhfekuefgve
    dvleegffekgfffvddvvddugefgfeeuheeiudehffevuddvnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehpghhnugesuggvvhdqmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopedvpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehprggslhhosehnvghtfhhilhhtvghrrd
    horhhgpdhrtghpthhtohepnhgvthhfihhlthgvrhdquggvvhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrgh
X-ME-Proxy: <xmx:KJfDZpkISVAGuTAZTBN73YXdXlNxd49bZrREP_wOEFRYFXn9CKWwLg>
    <xmx:KJfDZn3jIaQ-lymHorWipHhG1DfBRPMNDkymF3ltf1pl0DF_wbdFCA>
    <xmx:KJfDZovG8vKd-2qog76CkBoFCwFGFGGnoTsGrLllLir6yojIZWYP-Q>
    <xmx:KJfDZrX8gJQLN0I8-ZmIwqcwn0au6qvAgQMwQUXPlxXSUb9qTkb-Ew>
    <xmx:KJfDZn9mBgieXqqB4bgX0OoB5S-ojg39HkXYt6JKmDeGq1grnpTTonWP>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Aug 2024 15:04:08 -0400 (EDT)
Message-ID: <2408b714-a7a5-4c84-b108-64dab86eea3e@dev-mail.net>
Date: Mon, 19 Aug 2024 15:04:07 -0400
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
Subject: Re: Fwd: correct nft v1.1.0 usage for flowtable h/w offload? `flags
 offload` &/or `devices=`
Content-Language: en-US, fr, de-DE, pl, es-ES
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
References: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
 <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
 <ZsN9Wob9N5Puajg_@calendula>
 <70800b8c-1463-4584-96f2-be494a335598@dev-mail.net>
 <ZsOQCgbMuwsEo3zj@calendula>
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <ZsOQCgbMuwsEo3zj@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> driver needs to implement TC_SETUP_FT
> hw-tc-offload support is necessary, but not sufficient.


ah, thx o/

https://lore.kernel.org/netdev/20191111232956.24898-1-pablo@netfilter.org/T/


