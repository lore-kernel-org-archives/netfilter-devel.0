Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA71EF363
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919222; cv=none; b=iGWsYLS4WuNm3F/ZdsZqGSQk6ZnPLPUpVzzwHV3R1U59bLHRh6ROxqM1ZaAOQ3lRJCz9z4vloqj/UtBEyVwEa7HE5dYwuJBuiJ/iztuP3gnhcW0XSISpDG8TBsFUuDQoXL8AHy1+7LWk+lnVRO26kKKWWbIA7V3C9Z44prQFskU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919222; c=relaxed/simple;
	bh=lLYG76WYWeYAVpz+C4LYnhoa5yWZ2FQm8pbXl0wt2DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/1bAMIb9m78zsboYrBEDoFjSgH58AjvQTJDx5pLeKn6hDPl7LxDHOU8CgSVRUWC87GFtADxMCHqfANp1utzcxy4tG68xQpshguZppFQzbxrbcxAaAFNFY/NR/qbTzE3ZbfOH8ZYGeJ+HnMscccS9nThhqyQX7++5OBYYArNoU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SdQUhmy0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=neM0ndUA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SdQUhmy0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="neM0ndUA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F3A4760276; Mon,  7 Jul 2025 22:13:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751919219;
	bh=/6WdyDM49Kf/7rKkVJnxTBeP1N3YSCYmMwAMHVeiH4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SdQUhmy0U85+gJ8s3Gy57kLgy4YBY5NXhTH46DxR7umtsgI9qebZWI0UiNvmHEqBW
	 CMgNptt/8h2ZrKy5tAQwp2y4Sa0F6pfmDOPNrY8Qi7K3vbhcsNMIffjlqkpab7TwGs
	 PJ+Ogx1vcaGCAb7xRsiRaSyZIMEK5Qbc8zS7nK6M30OtESgxuQBUBV5UY5U+SMiHPZ
	 SJc+JhrZNLwftXi6d6LO4ZBbH97abi8/DQdjwFav9RFja27QMEEJwBg/hlUexLq5l7
	 WmbTi7PjyExckvtdobVk/AB3VtdMh6eaGziYWNSdGZ3yKh2srsvrsKOpso0lR5jZvB
	 eKJkd8RSn6miQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 710C860273;
	Mon,  7 Jul 2025 22:13:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751919218;
	bh=/6WdyDM49Kf/7rKkVJnxTBeP1N3YSCYmMwAMHVeiH4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=neM0ndUAgJjZfVlC6Y1pY9bDflE1Z3YwqybcC3eBtOYVVIAQPk1HnxevnwgLG4B5A
	 gpclkKAsrXY1NLTI8QjKVPptFXbtzd/DtC8zLxUfpgRqqiyYSfN7II1xb3SEpNA+gv
	 i872Yd5l6BF2Z7eOVQghYQDOi9oueTfTbr5BDX1VLY2iOHPkafcMvEBwBnOZFbh8gM
	 /uH15Lzif0auF5I03saYcl+f6DNWBlNruDoQKXsidypTDZ2yo7El446N6X4eylQzHR
	 eWpcLFdib1Aj3WU1TOw9CzaHzmgO5OG+VfkDrbzaNZo3a0IsBNqwO8uzi5HTsYi/zM
	 t7KwnFCc0h/Wg==
Date: Mon, 7 Jul 2025 22:13:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] src: split monitor trace code into new trace.c
Message-ID: <aGwqcI2iiMMAFDWs@calendula>
References: <20250707094722.2162-1-fw@strlen.de>
 <20250707094722.2162-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250707094722.2162-2-fw@strlen.de>

On Mon, Jul 07, 2025 at 11:47:13AM +0200, Florian Westphal wrote:
> Preparation patch to avoid putting more trace functionality into
> netlink.c.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
