Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFE02FD7BC
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776944949; cv=none; b=OoBT978uDNZ1zQWJ4G3AdG4aFSSyZd+WCrYNszS7Q+xyMrohXZqZzgTlAwvLvZpCdNBRkdyHyFH2GbJGcclOQ/XhdUvgPWsZZb8udp5SGVZJ2CLBqY3nTxHgB8hq9SuyWIJI6xGBbecK63mxvatF1vehg/m+U/Fd66yh0mGLtKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776944949; c=relaxed/simple;
	bh=q45kGb/XeOcfcJMiPoQzWJSV2fNNocfSEnai+7Itu7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/v4bgHnP8L3Mgh0qk5L/ysF9jU2A4GTMFSWTxR2E/YtHIR+MrHuF9bOZiYLTZu2dIcPZCSTaRVsFIyN4xjr6tf9bwWGpzGS7RDo8dE6uPVrehTVTTcIWbLQGJZh2ul5C9sFfZSZtlnQPmMglDSGlfaFR8b4Ja4UHHHH2ng/+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LuOW9/kO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LuOW9/kO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9BC6160177;
	Thu, 23 Apr 2026 13:49:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776944945;
	bh=q45kGb/XeOcfcJMiPoQzWJSV2fNNocfSEnai+7Itu7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuOW9/kOdn+eC1xVxDMLxze85C/KF11FtISXKtHPynQJEXdRnp4MP0+T281qqu+Gm
	 F5eetBgJZkkif/cxZlTB9FnOCRtHTbby47PGZSlN4Ur10kxhZ9SHLHJwto5SaQZDXL
	 amwwuuw5VZpbd3Tx/r7YB+383TWjzhbWZPNstJDRkOhbCK5J2dgllfO0nTNxYS3bok
	 IzZa0K5B9urfFFHIELBDdbRhbANRzFUr3Ht0CJPQnFdDV9/vgjosg+SPhzUhiFI/ks
	 TtafS8Z0QCrFJrjDLN4notpwhIv1pTvcIL1sQXn38QQVpOqF8eKCOl0Sq/JGQTs0iu
	 JKdWxK+BH4w6A==
Date: Thu, 23 Apr 2026 13:49:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ramesh Adhikari <adhikari.resume@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: nfnetlink_queue: fix missing padding in
 NFQA_PAYLOAD attribute
Message-ID: <aeoHL2ODYU6Xt28h@chamomile>
References: <CAC-THR9QmgG9Vnhjw0YQUE=YSZ8GuPi7HbSKW_YA1FnUkDzQOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC-THR9QmgG9Vnhjw0YQUE=YSZ8GuPi7HbSKW_YA1FnUkDzQOA@mail.gmail.com>

On Thu, Apr 23, 2026 at 04:54:35PM +0530, Ramesh Adhikari wrote:
> IMPACT:
> Correctness issue - violates netlink protocol. Could cause userspace
> parsers to misparse or crash if they don't check message boundaries.

I see no issue at all here.
