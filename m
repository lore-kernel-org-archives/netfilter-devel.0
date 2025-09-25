Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548E5321457
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 21:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758836565; cv=none; b=byoN7AoEMWsPqGYiI92JYUDCnzo4lrkVZ3SRc4KReCjDKXhxCw++A7GDPIXRSK8cTxP5JcCJgfiod6zvXG2PFJuatNHobmALnxWvC/S0658/uBALjNDx3L86ysjUFOKhdbHYDJ3n5x7OCIvTA6oODty0037PfqjXYKwtwcvXlfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758836565; c=relaxed/simple;
	bh=MimpK8IVyXFk8aaAAmfitqkfATb+Fnckr6sKh1rUi5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrTd+gxkXKll/1wEELhmIb5IcfjhmoEyTFVZpNlbI6d0i8Jc/dFbvGxPzULushvkPCOJ8qx+HJztbFjpeq5H7dAa2M6KMqctj1rOszGLF7ogKn81ewdfTJqeFbrgSwvLv6cNbLQJMtgRXFJZP44BqN2YSMALgy/yZ8jwBsCGI5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZwdZT7uI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OXsYSnF2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZwdZT7uI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OXsYSnF2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 205276026D; Thu, 25 Sep 2025 23:42:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836559;
	bh=6Y9Tc7dh2rMAkLd0qrGOOz7yuK1aI0e8LFv9jdalF/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZwdZT7uIXaov9/JxSiHxZAp18IraYvUIzJtM+H8UPoyDVnrgN8jW1OHBNjrJdbA7b
	 InN7K/PvybBn9feokog639BPvKyWg+ig4sfcPDeF+nU1ZvKuxM6UDAt/UoitruRrtL
	 /zKp5Y/+uIapOk8vP0RqKmk27nE1E6rqrInIdlLd3cicy8wOViKwo1sdT6yxP1R++C
	 gHnxihzrwq0tGxl0T5MM2fLPhSilIghhAmEf0aM90IFYtNS65C9L8MlQT7hT/qTH+6
	 jVbmVvvhBIZfQturgAnsOmMYL4zMHdAJPXVgZ+f559DgOJZxJ95RGOUDb4iJPICJR8
	 uk8FEQyVgBUHA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9104260269;
	Thu, 25 Sep 2025 23:42:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836558;
	bh=6Y9Tc7dh2rMAkLd0qrGOOz7yuK1aI0e8LFv9jdalF/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OXsYSnF2ZRPc+99j5UR3pB5ancgCllPXHEm+0BGucXXrJJrlNo+Ih2HeFq2NH+jyZ
	 xinIwQRCyJym3PdJ/axgLYBsZlK/4RAyqydu4S2hU8BN+RqpkiiOx33M00KajABjUE
	 dvcC0cGDteOSRHvm90mOxwkhLWL2bdth1uKse6d3FF14ISsaQi0VB93wUKrGa8JuhB
	 MqfKMbrJX+jLOB5DZP+svY0Gsjud7ZrqyGjVkoxPzO6ulTUsjlLjQsPXuS576+dJTI
	 kFlgSpMUmDyVq/f0yutAIlfzV5lqWXwIVlaR/AWZP1rIAek1qKhhUMznLzmolpciwl
	 TKkpnnj+hcTQg==
Date: Thu, 25 Sep 2025 23:42:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] libnftables: do not re-add default include directory
 in include search
Message-ID: <aNW3TCHbapIJ1wEA@calendula>
References: <20250924222119.191657-1-pablo@netfilter.org>
 <20250925200036.GC6365@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250925200036.GC6365@celephais.dreamlands>

On Thu, Sep 25, 2025 at 09:00:36PM +0100, Jeremy Sowden wrote:
> On 2025-09-25, at 00:21:19 +0200, Pablo Neira Ayuso wrote:
> > Otherwise globbing might duplicate included files because
> > include_path_glob() is called twice.
> > 
> > Fixes: 7eb950a8e8fa ("libnftables: include canonical path to avoid duplicates")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Tested-by: Jeremy Sowden <jeremy@azazel.net>
> 
> LGTM.  Will get this into Debian.

Applied, thanks for testing.
