Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0102176252
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 18:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724091779; cv=none; b=b0oOI7sh2GV4yPp0kaHvowmaSbKnNDn9l4W88Uj3UgjVr88RIU5HV0kgW6Mb6O4eIb++VN5rrwMUs1NRxLxlPwaRh0Gfcy43cgL5J8uPSTGxOlygBQcKL5HubsjrIAwUA3Q8k6eB1PlSnnaF2hVX94QXQufXRGOZLFRB3BTBhN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724091779; c=relaxed/simple;
	bh=tN1p9R+YGZxbHUnYjcdQ9h5HD6CGPnrCS39KCdbbp4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLtp5HLDLtvJCH4sjk4qRsJrN6RSKQ9AWjVTfEJsr1U6iKQh/memejXQnJ0hZhrsRrEcPxYkX1B3x0RSORB1E5f3tVArsMn+pUgIZqm77u9DFwYNqmDPs3kFVzw8IMv5hhzp9xnelKYyKobI1Na/udHGLKXqK0PAOW8Vo4ovl4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QA99Oa4E; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QA99Oa4E"
Received: from phl-compute-01.internal (phl-compute-01.nyi.internal [10.202.2.41])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 78C66114F0B8;
	Mon, 19 Aug 2024 14:22:56 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 19 Aug 2024 14:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1724091776; x=1724178176; bh=v22LzGIPUpD8UfvLCH2nEe017zsF2r7Jxds
	utSVLl1U=; b=QA99Oa4E5t+UHA4riggpSODje9FzXOp8Gk2QRxquSM0xZmKEeLa
	Wgza+ZNpKLjJjlNJpRkKkfTQA8oEVTrWMFyB0zcmR3nLl9X411qIvrNPQQclaqMI
	fnXf7SESpRP2FPSSb0g+q+lRyaKwbFegtru8K28kjhlNJjNeRyNLtBJdIsTIW/g2
	Vn9wSDQgaxNBevaiYgN21AG9NRziEu3KRBaQyO7RcmY45gZHxFudDvDPCKR4SOq5
	dVvrnVWE6nGqYjbXmqGTIC3YLiXv+z9HHRe9GkxnM+BAB7QPSE/89cevIbIYFciU
	SgDjRfSyKmifr/hsrJeJwa+8lWcS40zZCJA==
X-ME-Sender: <xms:gI3DZkG0Sk_zVHeRSVsBjQvMfWIxQLZQsFNhuVwYlBzGLkN7EnnkHA>
    <xme:gI3DZtVBo7K5k2ExNLyE_yv0if9-OipkF_0Pj4vgjdkzNsd4uefUYFvCakCJb1f7Z
    PslXMSzQuvAAOis>
X-ME-Received: <xmr:gI3DZuK9ZBrTsrx74ySsP7zPb1OzMJpbOGajSUtw7b66u2pYDJEw5dXgkI1U4tZyO7Hh_khvTwL-GFPSI8-wR8n7qyIxL4svmoYefQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddruddugedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgg
    gfrhfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepphhgnhguuceophhgnhgu
    seguvghvqdhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnhepudekieetveeiudfgge
    dufeeggfetjefffedvtedvhefhheefffekudduvdeifedvnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepphhgnhguseguvghvqdhmrghilhdrnh
    gvthdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    phgrsghlohesnhgvthhfihhlthgvrhdrohhrghdprhgtphhtthhopehnvghtfhhilhhtvg
    hrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:gI3DZmFRuQyJH0lQzXHpUh5gH4X7_-RsUAdHxl4ixXM1PLUbPr_FsA>
    <xmx:gI3DZqWQtElu9IBRwwy-jztypODNTwaqGm_7j_eRYHzOVgfBECvYAw>
    <xmx:gI3DZpNw2IpVGa1aPKcOMlTuy763H-FpgZRO_4G9pn7XxfBji8QcJQ>
    <xmx:gI3DZh2SbUf5vB3C3YG5MqhBS-OPfzet2JQDpKpm-7F8ZwJFObgsvQ>
    <xmx:gI3DZsfUZgDsZD-MhBdaEiQxVZSiC7zz13nSarqhqRYrMXw1BsFBIzd5>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Aug 2024 14:22:55 -0400 (EDT)
Message-ID: <70800b8c-1463-4584-96f2-be494a335598@dev-mail.net>
Date: Mon, 19 Aug 2024 14:22:55 -0400
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
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <ZsN9Wob9N5Puajg_@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

hi,

> Driver does not support this.

what's missing that tells you that from looking?

i _thought_, incorrectly, that this was sufficient

>> 	ethtool -k enp3s0 | grep -i offload.*on
>> 		tcp-segmentation-offload: on
>> 		generic-segmentation-offload: on
>> 		generic-receive-offload: on
>> 		rx-vlan-offload: on
>> 		tx-vlan-offload: on
>> 		hw-tc-offload: on

on the intel I350 cards.

what specific parameter needs to be enabled for the h/w offloading?

is `ethtool` the right tool to be checking with?
