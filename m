Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A391021345
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Feb 2025 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739592289; cv=none; b=JC20XIVD/MMPj1ur1Y3XCIOI2CtDx4L/vNa0zZbsjKP+I8GcG15TFGuLT9KkDmbkP9bIO989/Dh56+i9uK3bDp7STlhcNTtGQVDO3Jv47UYOmpAADC77Q42V2Sqj8MGFLCvbhNqF2I1T5vXoFIPKxgaYqI0R7YDSai13iFOQnUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739592289; c=relaxed/simple;
	bh=1gOH6crV2YaNVmWeP0CbM4AAfo54+OWWdxBK1JEo7TI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnRZPMPJXVX/FEKK9FcIeGomyPyx6MEvkLixVxV8oYAYAVtiJ2ZUnNF8sVx/p0Da1H3NkHJj7JiUL+ZdFmDuDC99lIBTi82nfjm1yZ9xvI+EFAvL9o+XqcT96pp82u4iLPeJA6fMDSXFo29AxXM805EXNUt02SHY4jM3OThJn6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Ci3Wh4Fr; arc=none smtp.client-ip=185.70.40.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Ci3Wh4Fr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1739592279; x=1739851479;
	bh=1gOH6crV2YaNVmWeP0CbM4AAfo54+OWWdxBK1JEo7TI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=Ci3Wh4FrZgiJAH+8lrgOa79+oCXrKZu6c3X/pkKg111mmCTSORanyE3O5QUldhY80
	 7QdXG3iHnsePYFsQM+v9Bed/kwhWMjK+4j5+mYkqaUd7INKaogmEcOXNTgAuXx6ctM
	 GaydBOODyPEigtRTJz9yUUfcARP2mBlnVnB1fpHV7bvO/40JXFBHUg6yoEox/H72Xm
	 nHvd3MBIze0tmb18O7DM1jKB7P4aQFi5sJidWeMBjZkMUQtLHRcgYSXHnPCprvbe8R
	 0Ymwy9LBmyirFQmTqB4Lpy8OfNHTZAczm8yY3cmaaXlOl6zSyGCHpp5vorXMB90VLE
	 y5iTFxr3rhfSw==
Date: Sat, 15 Feb 2025 04:04:35 +0000
To: Florian Westphal <fw@strlen.de>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: payload expressions, netlink debug output
Message-ID: <McKbB2cEvPxOmyKfy1KlmmOo-EHbhMMXLTV4vlWcsqNV9S27KMGydN3sxa0vDAsHXNURw2ev_uobFLQwRTT0TZ4LiEDl23UOaXKtcHv2KNk=@protonmail.com>
In-Reply-To: <20250214072020.GB9861@breakpoint.cc>
References: <iUf9BfY67Kl_ry63O6gOxJ2YHKmO-OFslzCRzfWVOxIe15iVlUV2G07XiT0qu5bsF9vvyrDRT4TQODjt2ksTfpiv1-nYlhgG5ryzcidhdug=@protonmail.com> <20250214072020.GB9861@breakpoint.cc>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 1d4f047f4d01ca7e391010659ae6dd3551b743fe
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Those are stores, not loads.

Ah, thank you.
