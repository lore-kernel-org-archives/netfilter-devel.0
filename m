Received: from dehost.average.org (dehost.average.org [88.198.2.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBFE2D4B7C;
	Tue, 24 Jun 2025 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.2.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750778867; cv=none; b=hpWMmEV7XsI4W96xJGrTV0FkSwa0+d1E+8DUAQX1WlZzquxAsRUNZTsvgRwdPF5Ne+voYZc8SLUZZpexvv02kPr26GJL4+RWFTRzOhfIcaFu3rwuwQ06k1bGCj7Qvq0t6tPdwDgC2ddGyeTZMq+1htuiSD3sbC3ElhXZGE1ls88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750778867; c=relaxed/simple;
	bh=LW2K4By87QwfIKLs1mg43Ax/0vsrlur/VYG1rCnP4qM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxqnGKm82eyMKXqVGEaxSgw/vZDkINZXsYjlD9QONir6sugn1gOYK1wKpUTvu6N+bd6MRkAcXZCx2F5n+4FM/BYM2F+Uz9zGc2JCHdzJZFSsSoorFB6wat2/ZnJFmB8yqr1lgUuWUlELlmOJOyQPDGOJaYhNGM2F7JNDppdjTcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org; spf=pass smtp.mailfrom=average.org; dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b=FLACPs/H; arc=none smtp.client-ip=88.198.2.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=average.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b="FLACPs/H"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
	t=1750778850; bh=LW2K4By87QwfIKLs1mg43Ax/0vsrlur/VYG1rCnP4qM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FLACPs/H/LYh2FVihnbVgHtJVDCSgvQB+3VkVDoEyTefDG7T4RXHB/mAtMC4W/SDS
	 3BC9DnCQVl2tNCdNKQBfhqV77VPoArVVyiyP8jtF8tX0cnhKZ5igi2I9TS/QiTEgmW
	 3/8ixT/Fq7ubxxh4aggpfaWaWZvYftUdJqlvtCZs=
Received: from [10.16.126.80] (unknown [212.227.34.98])
	by dehost.average.org (Postfix) with ESMTPSA id 6A0B64C9842A;
	Tue, 24 Jun 2025 17:27:30 +0200 (CEST)
Message-ID: <c5909e04-35c7-4775-bd17-e17115037792@average.org>
Date: Tue, 24 Jun 2025 17:27:23 +0200
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
 <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
 <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>
Content-Language: en-GB, ru-RU
From: Eugene Crosser <crosser@average.org>
Autocrypt: addr=crosser@average.org; keydata=
 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
 u3lufqBt0w==
In-Reply-To: <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------d5u7EaDF0OsL6jRlHweqTvqH"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------d5u7EaDF0OsL6jRlHweqTvqH
Content-Type: multipart/mixed; boundary="------------xe7mEe4zFFPze6r0cTv0MafY";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Message-ID: <c5909e04-35c7-4775-bd17-e17115037792@average.org>
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
 <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
 <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
 <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>
In-Reply-To: <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>

--------------xe7mEe4zFFPze6r0cTv0MafY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20/06/2025 18:20, Nicolas Dichtel wrote:

>>>> It is possible, and very useful, to implement "two-stage routing" by=

>>>> installing a route that points to a VRF device:
>>>>
>>>>     ip link add vrfNNN type vrf table NNN
>>>>     ...
>>>>     ip route add xxxxx/yy dev vrfNNN
>>>>
>>>> however this causes surprising behaviour with relation to netfilter
>>>> hooks. Namely, packets taking such path traverse _output_ nftables
>>>> chain, with conntracking information reset. So, for example, even
>>>> when "notrack" has been set in the prerouting chain, conntrack entri=
es
>>>> will still be created. Script attached below demonstrates this behav=
iour.
>>> You can have a look to this commit to better understand this:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D8c9c296adfae9
>>
>> I've seen this commit.
>> My point is that the packets are _not locally generated_ in this case,=

>> so it seems wrong to pass them to the _output_ hook, doesn't it?
> They are, from the POV of the vrf. The first route sends packets to the=
 vrf
> device, which acts like a loopback.

I see, this explains the behaviour that I observe.
I believe that there are two problems here though:

1. This behaviour is _surprising_. Packets are not really "locally
generated", they come from "outside", but treated as is they were
locally generated. In my view, it deserves an section in
Documentation/networking/vrf.rst (see suggestion below).

2. Using "output" hook makes it impossible(?) to define different
nftables rules depending on what vrf was used for routing (because iif
is not accessible in the "output" chain). For example, traffic from
different tenants, that is routed via different VRFs but egress over the
same uplink interface, cannot be assigned different zones. Conntrack
entries of different tenants will be mixed. As another example, one
cannot disable conntracking of tenant's traffic while continuing to
track "true output" traffic from he processes running on the host.

Thanks for consideration,

Eugene

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Suggested update to the documentation:

diff --git a/Documentation/networking/vrf.rst
b/Documentation/networking/vrf.rst
index 0a9a6f968cb9..74c6a69355df 100644
--- a/Documentation/networking/vrf.rst
+++ b/Documentation/networking/vrf.rst
@@ -61,6 +61,11 @@ domain as a whole.
        the VRF device. For egress POSTROUTING and OUTPUT rules can be
written
        using either the VRF device or real egress device.

+.. [3] When a packet is forwarded to a VRF interface, it gets further
+       routed according to the route table associated with the VRF, but
+       processed by the "output" netfilter hook instead of "forwarding"
+       hook.
+
 Setup
 -----
 1. VRF device is created with an association to a FIB table.

--------------xe7mEe4zFFPze6r0cTv0MafY--

--------------d5u7EaDF0OsL6jRlHweqTvqH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmhaw9wACgkQfKQHw5Gd
RYytMgf8D0uE7ZW4JoK+4usc8GqyLP9axpEKvnXTOJ/Vfzj9Tok/n1N6B0vfq/Uf
lV6ylJH87a7LPGcyMqqGr70CtwkF3pbMHJUMJoHgMn400oOyV9INHFUkFBxLmCZ3
kCG2lmUbOOciPudGEsI7B1mALSnfsJyHlLOR3vRPzoMgenub5k9E+3TIflovWP7l
g4+uNjuqpme613z5mftwlwgUxbdJ2Mb5r86McHmDS8Xt8h0h6iOdsu6Ad10DWutY
zvVV+Y5OP6+lhtz7hySLeu/6pE0KNpH7OLlXD6AdJjmtYl/Pp7sRdxpSU5CjNT52
WgLH7SqjiPySc4c96u6SRK+Bfw/8+Q==
=mLjn
-----END PGP SIGNATURE-----

--------------d5u7EaDF0OsL6jRlHweqTvqH--
