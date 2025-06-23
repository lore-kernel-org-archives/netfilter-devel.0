Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A2E2673B5
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750698530; cv=none; b=leJ8l1moa1PxBdRikcyR04Gb+URnW7tkldQync0NY3ouDTXf/9YVzDggQUZgqPwD8CU9Ho7Z+fRuqgv4qPIpkkMxbVSnDreRz0AC3yxQWegGRPZ5/Qyt9uDfaB+/4BFaDQCLRtIQBDaFu4YatCIzfajvxM5zfVUQUvDeLiMk4z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750698530; c=relaxed/simple;
	bh=fFEVMqtLxothMJpNCShd3lTJk6yFORGmeSpYelTD6B4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQ7smIUwuBHafVXMqx0OfDWsaTR3gM+loFiB4bElyybX0vUycPS/HmOY7DNMEpsKn2/ETTaUrdcl8hPdx1t9k59k6XSN5pDIj0jURppurFhW+cKVR0+/rd2El5ggtTGFBBTMTsOChuqFy28aBLQ+veNvpBud5Bu6ysS2D4VLEq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QIYVYK6q; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QIYVYK6q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QIYVYK6q";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QIYVYK6q"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3BA756026D; Mon, 23 Jun 2025 19:08:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750698526;
	bh=LRrr3R3eaz7z69blS4s5BvnOjL4lhPxU1pulo0HkpRM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=QIYVYK6qWRKj6v/ZldfGWTCxVW1kxdQj5YMc4Tb7YEcRJqT+IBIoiJHKd/PjHERtZ
	 acvxMgUq4tFt7Iy2BHd7XLxJcslTmlpLr0L0J284AT2dDhchS+X7gSmDz+CohX7FEc
	 CnM3UsbbwU0eIUFuYe85MkE4nsmPdNra4GYrlDoXQMkGRL6B0TW/V6Qpr4Tf8yJBMm
	 enwOGaL7Mvxdb2u4IwODOEacTOiHUgX32Yri8VPaHrQeP7jp8UlpmivMDm31rN5GV8
	 +gJI7+o/PYSGhiA089a9y2Yyu/N5HFnkMSfGpt9r7MXN8tG6ubRr0daeLzMVR3mCOZ
	 Dcew5iQEjVNag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D664460265
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 19:08:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750698526;
	bh=LRrr3R3eaz7z69blS4s5BvnOjL4lhPxU1pulo0HkpRM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=QIYVYK6qWRKj6v/ZldfGWTCxVW1kxdQj5YMc4Tb7YEcRJqT+IBIoiJHKd/PjHERtZ
	 acvxMgUq4tFt7Iy2BHd7XLxJcslTmlpLr0L0J284AT2dDhchS+X7gSmDz+CohX7FEc
	 CnM3UsbbwU0eIUFuYe85MkE4nsmPdNra4GYrlDoXQMkGRL6B0TW/V6Qpr4Tf8yJBMm
	 enwOGaL7Mvxdb2u4IwODOEacTOiHUgX32Yri8VPaHrQeP7jp8UlpmivMDm31rN5GV8
	 +gJI7+o/PYSGhiA089a9y2Yyu/N5HFnkMSfGpt9r7MXN8tG6ubRr0daeLzMVR3mCOZ
	 Dcew5iQEjVNag==
Date: Mon, 23 Jun 2025 19:08:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] memory reduction in concatenation and maps
Message-ID: <aFmKGxU_fet3rdlj@calendula>
References: <20250616215723.608990-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250616215723.608990-1-pablo@netfilter.org>

On Mon, Jun 16, 2025 at 11:57:20PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This series uses EXPR_RANGE_VALUE in maps to reduce memory usage:

Pushed out.
