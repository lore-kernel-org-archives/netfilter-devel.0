Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E1C2C3259;
	Mon,  2 Jun 2025 18:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748890308; cv=none; b=B+adnH40ut+xZdo86W0HveGSpJY4IgKExoyUubdGEL3tsfZGKlxmJSYdXackXH7TQii0i6QYP7i+XBjLslyJ52RYPAJtw3VHkRIdBKCnQ1feqPElpOuJQjwTDiHTsVYkEf7niuZqMXQTyNExIp+hqn/qJ5Y2JvlhaCJTyaDdj3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748890308; c=relaxed/simple;
	bh=USPYj4wNHP10EUrCkd1PRZjBIkNjkOZO1VvwhdupL3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcUobQkWGEnUrKsWopb5UhUnvN8Z2ZaIt1NgSrDwL77tpv8I7saIKShAjR+MGZGXMY1VMiRXf8sTHoM6XPwxo/oMc5jdzhBO2n5zidzgX1z6ZAeukTV21RtUwyYDKrHF8PtI5bj+YE2c8bhirz9bn9RlVJ1j9WGGj1IvUD4LZrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r++w5tCr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZaPzs+b1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r++w5tCr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZaPzs+b1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8FE4E6027C; Mon,  2 Jun 2025 20:51:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748890295;
	bh=+ulpBVanxH0UrfdRT7Z3xXqskJvgwq1PMNuyqv3rFKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r++w5tCrsyC0a80yYeyNnl4Dx8phB/eRfPP9a1kSDpRH+kLwwzcO7FSzpaVGFH6vC
	 LTMF6s5GOgeb/sgvIsXbVDG8cjixtTqT+1/IJe1Pd6ZOL7/7DBY0PgBWgkSOZ4Pu5T
	 dpEVch+kG65cX9vDO36tzwhuDNIVxmt/0xFwgIsfkb4zxcu//cWH/e5uQQZA9DtI05
	 MbLDGdS279SwiROHvRnGY4urvEeSse35q6BYEYCAcr2rwGyvK7YZiWXJy6cCaoQo/z
	 W8HDY0vTqQ1yaVka1HwL/0K1y+1BV8ICVxxqrql/99uoLjQKCxwelUnrVET5L14yuq
	 /dKxUDp1pbsUQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F1D1360272;
	Mon,  2 Jun 2025 20:51:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748890294;
	bh=+ulpBVanxH0UrfdRT7Z3xXqskJvgwq1PMNuyqv3rFKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZaPzs+b1QqA6jKxcE5hzFNLorLXEaKddHhLmTvcQSiujTLXN4W2ztpX9P359Ka3fy
	 vWLzGubn5+k9iU7buJVVP38Z0ljXqxYsXh/NX0KYj8lXAwPN+4dz4TnQzVHa5T0zD6
	 gfaorUrQH3z8DsV/VlCIykpHu0JaQnPDCX0fCAOtyT5qLa9SM7V3B0caExeXNij3Ej
	 TKh4Wkn/CSnElqsvmjWTp4PSgw14jUhc/tCgch7JeQDZ0ERgM8IY5JOmx3oaEdyFbG
	 jzFK/985KidZ1GsaXGkt2v4oJK7SLTdHXxRwaDp/JqSfBJXv4wfe1dIe+rESk6sFhx
	 xM97SkuqqCvNg==
Date: Mon, 2 Jun 2025 20:51:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Denis Arefev <arefev@swemel.ru>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] netfilter: nft_socket: fix sk refcount leaks
Message-ID: <aD3ymi8DguYXw7ri@calendula>
References: <20250602123948.40610-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250602123948.40610-1-arefev@swemel.ru>

On Mon, Jun 02, 2025 at 03:39:47PM +0300, Denis Arefev wrote:
> From: Florian Westphal <fw@strlen.de>             
> 
> commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c upstream.
> 
> We must put 'sk' reference before returning.

I have a backport for 5.4 in the queue, I will take care of this.

Thanks.
