Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF6D29BDA5
	for <netfilter-devel@vger.kernel.org>; Sun, 28 Sep 2025 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759050418; cv=none; b=t6sMAxOnQnZmouq+1+qkL/cBCgKI/W95Mq+NpNZb1RgXFTa60/6IbmJj57wyh3ICZgKCr35TB9UldxG9oc/1kzMsWy3D74DO/pdszEn53fYy716wCYSI/gQ2CvCCEzXEaq+crwhPVYTUCYJD7NXesaCGXhcKDF7GqNG8GSfCcsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759050418; c=relaxed/simple;
	bh=Y+50z69wHQgmYE75T43OiVjDFR01y5QfxylJD8UIr9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gq94kXeV90hYJ6ir31tJZPsGXlJe6icLFH3vtjjaAwGwYYy2Cte9TYn4QYBWZHYaJfs7mFgolOj6IXq4sCCsgNfpMH5oZjXFnbfzXo3SXGPIQj0cr4NC5ow/HXxLYZ/sdjb8cOqszu8UYuBff/FOC9qGcnaIiXvjB9SSE91IlPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n4TOsES6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cu5FR5Xq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n4TOsES6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cu5FR5Xq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 23F726027B; Sun, 28 Sep 2025 11:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759050406;
	bh=Y+50z69wHQgmYE75T43OiVjDFR01y5QfxylJD8UIr9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4TOsES6LvZcSj0Jn22PxmFQtvt8K3DwwhcpVcTIzTWsm1z+sFRqsRKrnEvdgwYSJ
	 hk9CDt/YUQXutP8nMnxW7ZhbyD6XPZmI/ME4+l6fnehq3QNakREFmCbyr1ad1/EC2d
	 gVFIZ42TWtcnzN4vePyPsBKxMAViJe0JHhPZ/SESMVf63vrfHe1Lav7wp0y0ZmNoNs
	 NEERpjSdR7SgvBR2d06Ve2DxIHDWsJI4aOqngC+GYUUFPrpMdIgNp30ItI7jGb8iCO
	 CCY+eZkwq3MWBydK4CX+0+wPcqKpdiF7KZH4rvRlobv4wQTbUibGoGiVpK+g2hOuKn
	 XW9T6btHInO+w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D064360276;
	Sun, 28 Sep 2025 11:06:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759050404;
	bh=Y+50z69wHQgmYE75T43OiVjDFR01y5QfxylJD8UIr9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cu5FR5XqLfYdWqciCKwJuQ0xIcNhVvN3QkeOFmfGFbnqicItcYEUwPwuSZJ7au89f
	 VXmFf02Xp3OPdj9wohEEIhk/BUPCijwiLEtX/3eFxN/i4gHlaUkrSJbZAGqAld6UaY
	 COqcQqXEdJFbbdhShR3Izi8SLHXhjDfnQqdCRmNyzxpwycoM1YpjC7pJu51ww3Baam
	 HB/p63HyHwLs64nSqroK9cD31x/VPZythu5SqBpdJv6I6RnXtpdSxF52VNzUWwCiLe
	 giTUL079jAMwuXSNrm82zf9egQ41ihxM9mUNQp9xsIvZGYYkYhft082dFgcIxiwSgn
	 iZsChukSsEcHw==
Date: Sun, 28 Sep 2025 11:06:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: Bugzilla down
Message-ID: <aNj6oWgvILmUAYsk@calendula>
References: <20250927151054.GA2784745@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250927151054.GA2784745@celephais.dreamlands>

On Sat, Sep 27, 2025 at 04:10:54PM +0100, Jeremy Sowden wrote:
> Getting connection refused from bugzilla.n.o.

Restored.
