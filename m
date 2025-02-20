Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C911E9B0A
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 08:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740039054; cv=none; b=WeF+ilRuks3o3QSfDrJwbkfonPt5pI71mwfMoeFBoeKuiSdLenGEjC4qRgfbZ7QmSwBW86CarvmZ3Lygd5fEnupfSEIYDLtPKvG0YetB1U/x4I3E3lMZxiChiqAuVBtC7pvnObufEVVYgLgbk0zM1J0u0bHTWnwoKaupw3OQVfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740039054; c=relaxed/simple;
	bh=FwRKWpIRTYtsY8kXVyvHchHwksQ+uz6/N0jernNcJIE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OkQ57PbThmHH4Jzj89CCXsdzsJ0I38DhLtP5veQVMiNZBwZ/8iwJ1qDcxO0iOV+hyd/HYs/j10hRTOjPJvQ7yUkG2E6i1xW9ymWR+vtibAwWQWx0UiK7NgyaRX3Dzi+gh2Y8uF7QJtlqhTxJJdCA5ICSkvFK9vXPnS13W15V2S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 3F6EE1003C0D51; Thu, 20 Feb 2025 09:03:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 3F3771100B0CC0;
	Thu, 20 Feb 2025 09:03:45 +0100 (CET)
Date: Thu, 20 Feb 2025 09:03:45 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Vimal Agrawal <avimalin@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: Byte order for conntrack fields over netlink
In-Reply-To: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
Message-ID: <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr>
References: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thursday 2025-02-20 07:03, Vimal Agrawal wrote:

>Hi netfilter team,
>
>Why are all conntrack related fields converted from host to network
>byte order by kernel before sending it to userspace over netlink and
>again from network to host by
>conntrack tools ( even though most fields are not related to network)?
>I am referring to packet exchange during commands e.g. conntrack -L
>etc.
>
>Is there any good reason for these conversions?

To be consistent with the rest of networking (IP addresses are also
passed MSB-first), which goes back to RFC 1700 and
https://www.rfc-editor.org/ien/ien137.txt .
