Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4901097B
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.85.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058687; cv=none; b=G7WKSsGWZ9lr5gZQOxrUcE5Ul9QiExvLxx6D5Re6yvvVWmD/WHHtZleMmbe+iCEXQ58InxIK6GrgdIOz47xc/SIA0W6GW389/xflNkUp5Tasdbaxdl27og7hwfsqVeqPyHzClRZZhU1NKHGebYtKmHJ+Og//3kWidM67OaUaoHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058687; c=relaxed/simple;
	bh=xmCrzHu7Z6DcbkZPBK/kD2MHkE175KQ9fdSBTmiAU+0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UGY5TFn8XR25DWO+gnkAY4HDMjzGcGex23CCCrBnH7yqthbr47ucPxakJnAOx3ypK1CWMoec3UwPA0QaMuUMrfutjd3Oz+Wnxvtsc+/mxK/aY4LWA8+Y7ssPLelTq8kqkZ5mZbdDTX+39I+beymS7fZH8SeNVyBM9JHbV/Ly/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=88.198.85.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 85021587264A2; Wed,  7 Aug 2024 21:18:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 82C0B60C28F40;
	Wed,  7 Aug 2024 21:18:49 +0200 (CEST)
Date: Wed, 7 Aug 2024 21:18:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: josh lant <joshualant@googlemail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: compiling with kernel headers
In-Reply-To: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
Message-ID: <s6pr83q7-53o0-6q76-635p-28479r7rsor2@vanv.qr>
References: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2024-08-07 16:36, josh lant wrote:
>
>I am trying to build for the Morello architecture, which uses
>hardware-based capabilities for memory safety, effectively extending
>pointer size to 128b, with 64b address and then added bounds/type
>information etc in the upper 64b.
>
>TL;DR- The uapi structures used in iptables which hold kernel pointers
>are not compatible with the ABI of Linux on the Morello architecture,
>since currently kernel pointers are 64b, but in userspace a * declares
>a capability of size 128b. This causes a discrepancy between what the
>kernel expects and what is provided inside some of the netlink
>messages

I would think something like that would fall under the CONFIG_COMPAT
umbrella.

net/netfilter/xt_limit.c:       .compatsize       = sizeof(struct compat_xt_rateinfo),
net/netfilter/xt_limit.c:       .compat_from_user = limit_mt_compat_from_user,
net/netfilter/xt_limit.c:       .compat_to_user   = limit_mt_compat_to_user,

>I suppose I am generally confused about why iptables uses its own
>bespoke versions of kernel headers in its source

Because it is not guaranteed that the .h files exist anywhere else in the
system. The kernel may even have removed extensions, but there is the
concept that modern iptables ought to be able to run on old kernels with
those long-removed extensions.
