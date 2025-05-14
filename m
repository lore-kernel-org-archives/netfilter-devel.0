Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94661187346
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 11:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747221012; cv=none; b=gzEShV/5HxuPSqPYueIuwWkvdugUkAMmEX//ItZrCw+1PMjKB9cjKiKJXA+Ad+/YwBKOdN6z3/DWWNx9PAtgKbpgkmmEqzo5f03NaJfR66aXaaOvYJDAFQ0qvUCKMbgH+l4H95Aqspp+Hq6pVkAoEScwKV+tNyi9D4zI7QtzRrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747221012; c=relaxed/simple;
	bh=DyOWe1c+6gKFHJ76bJYFNkoDuqom6xIQREMLO8THF50=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=NzvzvE29YUTTpYhd5hCU8CWE+pOipnWBtIoVAzvf/wPxKqykeGh76cRTnGV1OQcIPC82PblxBd3FxCtPOMxNa+OfZdwYLGGlAcm7owjZJkM6u2vAAiGq1r68fWIOKtd/nGSohMlRHS3etFDShRu9F9NBd5RvtljGjZig3rJiksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=sLcWYulw; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="sLcWYulw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1747221008; x=1747480208;
	bh=DyOWe1c+6gKFHJ76bJYFNkoDuqom6xIQREMLO8THF50=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=sLcWYulweY0/3nWkB9sKffX4KwixHfPNDFKbontbe4P4uKPs/6Kis0YsHaGd4eldy
	 rZeK4g8NNSHzwnptjS7z+D/VOpLrpw+2sjzsxeYpStOnfqD4umeUVKKsR36fgTu7s0
	 pC977he8ra2AYujalfAUsroWfjEWMgWEA9sQINRnN09IqYwtIFqrGFEZj6Ysj17YkC
	 Jm3AexYu9mCoKNXi+YV6zXXWb3aQlJ/C9R4TO2wLjj2Q/VHsULUccTMELutS7S6z4S
	 jmgP6reRlwcsSzFa1TadRTk7oAM3lgm6jIPjZSN4y5uY2+yvTCpDm2XRFBS287e34S
	 dEq642PnSEKiA==
Date: Wed, 14 May 2025 11:10:03 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: Recommendations for choice of compiler; does it matter?
Message-ID: <SRLtfZ6eGM6qGVpUykifwV6ggKvTCCAtuMGO5zTeh5HC6bpJK7CcmJMURd94L6bS3JFOPq1NWZTwSjcm74aN_rid2YOt4u1wegfTaQRh-7E=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 5665f3f3d63a2adad9d059bf1492d2ce8c632116
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi mailing list,

What is the recommended choice of compiler, when compiling NetFilter?

gcc, clang?

sunny
