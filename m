Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B40A3BB48
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 08:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728462140; cv=none; b=pPDWVhnhRbNN1K90766meMkLDuJncOv4FId6uNMtJC5USSdTGAWGK98MSI9fHWu+a0uRq5tc48BTRBopI/o6LLRnBAKitBuWJZ1iv962Oqd1sEf7TAYkN0zwybEj8ZdDpj9J0GsFrQdn+RNrfNodAH7+thLedWTEws5MjhhZM+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728462140; c=relaxed/simple;
	bh=ofGt1sX4ias/W3zg0IczxDPzLRkZn4JaOBX56xXKY90=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=hNMNMOuLkT19wSoLgm/AeVvS8yxDepO5Je5vesuoVqjGsaes1XvJ0BSd3c/Aulog3punu7y/GBQXGKSj04eLcIZSoqODcKSIAWpggGaQkGPeyn0xooPOFjHQDnPfor/EI93mObz5ag64nshvd1lc5igd7scKyx2qfndN3TCZH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com; spf=pass smtp.mailfrom=tutanota.com; dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b=Yzp64Ei2; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="Yzp64Ei2"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id 53A2B2AD0E14
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:22:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1728462136;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=ofGt1sX4ias/W3zg0IczxDPzLRkZn4JaOBX56xXKY90=;
	b=Yzp64Ei2BGXPLfMbLKsCbBcfkmF/7siuqc4Alzj1r09RDwQLq9r/3sLN7tX2DVAn
	lGhMrTSZKracm4JDOgjTKOOA50DyWYHDkLQk3mh4DeBMD1qHR4RtiGOCJw6WY5geDHQ
	yb4chEJKCBClcZaXOBBEKiYxPQReMizD+1AdVQKcWcuRki8JAlw9W5iNzZxEXIxb/sW
	riRaafJWttfsMsfiy2AYmJiJdY0D4wLqMQszgzkf7FjC0rrbEzKYR72POju6LeHJbAz
	VNxlUKTxeKHcM2WVZgDZ3YS/+aHpXsKLTgiCo2UOJShaGFc+2FIsVjfWL8FyWjlXtt+
	y+La29WaWg==
Date: Wed, 9 Oct 2024 10:22:16 +0200 (CEST)
From: Nicola Serafini <n.serafini@tutanota.com>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Message-ID: <O8kMltx--B-9@tutanota.com>
Subject: Argument -S (--list-rules) in ebtables
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi list, I noticed that ebtables command line utility has not a "-S (--list=
-rules)" argument which is widely=C2=A0adopted by the other command line to=
ols (arptables, iptables).

I think it can be useful for many reasons, so I'm here to ask whether it wa=
s deliberately omitted or not and why.


Thanks.
Regards,
--
Nicola
