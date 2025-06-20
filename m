Received: from dehost.average.org (dehost.average.org [88.198.2.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E9019CC1C;
	Fri, 20 Jun 2025 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.2.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435462; cv=none; b=HqWtd4d+I7tVmOXYtTtbFiygYo0VsAINe0lHYgH7IFTs/EJK2QAqCZDMzvUbkbnL+jUX3RZpnN9h46gRThLCuFFdbM6q3MdZidSdx2sHCovivCuYPRX5tDqmrVsXyjhQK6jRHab7SRa/uejYWvBZnZvIIZ2dQTH0169fdG/QqYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435462; c=relaxed/simple;
	bh=EmGIANHl+rlrNbTJLbUOGEJecEEWTsd05Um8EDSArxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SJoRA5ah/kj1jvqaUnRdRPEknCokLQpoZMUh70nbflknLgZQ8fD7mAk81bwriM81iIT8PPlqPJ7hCv8XmhvoPAemljpCp3SAjJBNstLks4KR1zz5EWgu695/aPl4sqgsm4a3TlnrYgTS97NEGwcESskV1hpBXrM21G30SnSaiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org; spf=pass smtp.mailfrom=average.org; dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b=riIZjLB2; arc=none smtp.client-ip=88.198.2.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=average.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b="riIZjLB2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
	t=1750435454; bh=EmGIANHl+rlrNbTJLbUOGEJecEEWTsd05Um8EDSArxE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=riIZjLB2CuSc6pSX6pK4cKBu1xPFfsk2a/rmkcFRT19a7mTSYVaaM3VqPNndzsgDi
	 LMlmW5m0NCDFo+WtjFY1Y37f09nd3K5d9DaONLKdlIA2fpuM9j4q5OcxVrAzqghsqX
	 mNt+dcEB1ccHB1OXcDCwh18Hch64tM9abdvQRylk=
Received: from [10.16.126.80] (unknown [212.227.34.98])
	by dehost.average.org (Postfix) with ESMTPSA id 56E554C87EB8;
	Fri, 20 Jun 2025 18:04:14 +0200 (CEST)
Message-ID: <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
Date: Fri, 20 Jun 2025 18:04:08 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
To: nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
 <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
Content-Language: en-GB, ru-RU
From: Eugene Crosser <crosser@average.org>
Autocrypt: addr=crosser@average.org; keydata=
 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
 u3lufqBt0w==
In-Reply-To: <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------7lUomzkTUOi8uEe0UaaVOnoz"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------7lUomzkTUOi8uEe0UaaVOnoz
Content-Type: multipart/mixed; boundary="------------yUZYwb3P0UD8vBWpbW0QK0Ug";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Message-ID: <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
 <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
In-Reply-To: <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>

--------------yUZYwb3P0UD8vBWpbW0QK0Ug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks Nicolas,

On 20/06/2025 16:56, Nicolas Dichtel wrote:

>> It is possible, and very useful, to implement "two-stage routing" by
>> installing a route that points to a VRF device:
>>
>>     ip link add vrfNNN type vrf table NNN
>>     ...
>>     ip route add xxxxx/yy dev vrfNNN
>>
>> however this causes surprising behaviour with relation to netfilter
>> hooks. Namely, packets taking such path traverse _output_ nftables
>> chain, with conntracking information reset. So, for example, even
>> when "notrack" has been set in the prerouting chain, conntrack entries=

>> will still be created. Script attached below demonstrates this behavio=
ur.
> You can have a look to this commit to better understand this:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D8c9c296adfae9

I've seen this commit.
My point is that the packets are _not locally generated_ in this case,
so it seems wrong to pass them to the _output_ hook, doesn't it?

Regards,

Eugene

--------------yUZYwb3P0UD8vBWpbW0QK0Ug--

--------------7lUomzkTUOi8uEe0UaaVOnoz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmhVhngACgkQfKQHw5Gd
RYz7uwf9HSohs4BarS6XcAMIAaNdRAQjTlXKAiWMjVmbIi2arLjqiV95PodAXO4e
tVqL3t/5vVsH0+bSmeSO9niN7HyDn1ZSHWi1mfHgoF8HeXGIMB3OPzMRxj6NjbN4
94Cbcp58DiNMS1LOLhP0FS8Ex2CJYeVpLvIE980NiL/ygMJ613doDYnEqjY7a1d/
7Gdnff5vXXHpKUbzGP3rC6ZBAJ1q5JSlj1v1Ry66q+ZI3oHvZ9yCaf6j0rEfXxe5
UvCtJBXzqhHLpVSysBPdt3Yog3VZQfe4Bu5KPu6MY6MSIPNjmqWetoMjpuso6JLu
xW5cNzAhK0GA9FbngcgLDgsLJfhPbg==
=KaWe
-----END PGP SIGNATURE-----

--------------7lUomzkTUOi8uEe0UaaVOnoz--
