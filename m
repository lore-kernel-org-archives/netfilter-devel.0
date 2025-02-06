Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979DF22A1C2
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738845888; cv=none; b=JucyjitxNz7t6HTPwLLlrkWSdeFzXmYQhK1bjB7NcZYTtymFEk1miChZDc3fQBvQ/J0/Uv/eU8eR2kYrYZavXUHRTGE8QVWbW0gLBIBTZO8I75pYTBuEvebBGeVNhzudM00cnvIoZw7OYFaPHd3eZiHCWUMZOetUnY353h5Pcbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738845888; c=relaxed/simple;
	bh=33PaaslzXF7foJBCVlG1W3Y8LxNY+lg+syO07QzirS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzJ32I9rqj3VYyrOrqoTgnmz1irJ6z52zTw5yxAREuWmiAZv4wb0Ihu1LkYWwxL7S154xwGKGnczmB+RS6hATxuCiy0yx5nf+R9KMPzL9eEXdDugXjAPXO5V9l5B3GYgErc68uh7QTEG4FW+19JGXw3d+NVQRnZy8w0qYk8wWKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pRGTFHgj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S7Ap2JWo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pRGTFHgj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S7Ap2JWo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3082760572; Thu,  6 Feb 2025 13:44:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738845882;
	bh=XCx4f6/ds8k2hgrMX7IumRIi3t69cxj9HRDmh/6jQr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pRGTFHgjsJ1kWRDv8nifbbq5OsovlBtyfabOeSZKfACBXVPoNHhFULDYFnjngKCSq
	 GLojy0/uPjDqO4EbFAZPNSRKSwzx5AerVPoKY85tYS/yhIOY3kamsZpam11Z+LZhPF
	 n/NjFuWDoPhvg8DAARSsoX+fIIGKYwSC5NGmp2tlcbDkb4h1o+i+Sz0AVL1JeGGums
	 LbXSPwMq68Pd0jaMnNwdNguLYNYNjsF5aoCcFC4dO+hS906Y0juyzPxwF5hFz9R3DC
	 teoVKl2XF0DExjlLN0LDvaiU+/ZJkMEr4S3IF+TzcDERyJvblC9cKSEktNwKkLypXe
	 2fWA7ElsT9o3w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ACC4E60569;
	Thu,  6 Feb 2025 13:44:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738845881;
	bh=XCx4f6/ds8k2hgrMX7IumRIi3t69cxj9HRDmh/6jQr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7Ap2JWoXIUb+sLAViTSOHX4+w4Pb7mkY/Fnij+thx50NPRIj5xTREM+KhvpkKYL4
	 2a5PvGsKNTfe+CyfeVsHhqFssK0QrgW1aiMMzqhJaUfQmpzWn3yQlT3IitaoVLlIxR
	 KqN6ykX2rAYt7H7i2nBS16Iuelg+CkIAU+dOSttgDpvMwW4e6nqlpqGy+05ZghqlaK
	 2w+bCKPLfU+OB7Q21n7h6GspcRBy8as1MSbiLhWqEcGd8LujY23iMR31z2SxLKF0nF
	 gDR6+i91ecKcsOyHBD76VKTnG1hSAnijcV8+Zi4GkO3759Kj7vC13EnP6ISzH8h8o3
	 7lHU9MobG0Xgw==
Date: Thu, 6 Feb 2025 13:44:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexey Kashavkin <akashavkin@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] parser_bison: turn redudant ip option type field
 match into boolean
Message-ID: <Z6Sutl6FEaq9lcbc@calendula>
References: <20250131104716.492246-1-pablo@netfilter.org>
 <20250131104716.492246-2-pablo@netfilter.org>
 <D068290E-A9A3-4CD3-9C75-413626D540D6@gmail.com>
 <Z6SjIEKagIkqvo57@calendula>
 <5A90BD87-D18D-44FE-B504-FCDB279BB252@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5A90BD87-D18D-44FE-B504-FCDB279BB252@gmail.com>

On Thu, Feb 06, 2025 at 03:02:38PM +0300, Alexey Kashavkin wrote:
> Hi Pablo,
> 
> Yes, I agree. If a template field like IPOPT_FIELD_ADDR_N with the required offset will be added.

Something like:

addr[1] -> first IP address
addr[2] -> second IP address
...
