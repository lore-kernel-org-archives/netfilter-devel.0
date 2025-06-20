Received: from dehost.average.org (dehost.average.org [88.198.2.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE5D28B4FD;
	Fri, 20 Jun 2025 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.2.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750427293; cv=none; b=WY8yoi8Nle89FzJQRpFnMjVtD/EqLOdgRWTtjLpP4IqKEp0g8MRIHSRAXgeuRj63v0H2oMFFmM6E3bfqXLWQ3Bfz75AiFvzP/i/uW/sZ7PSztS+yorcnfuC+2w7sDKsGJgg31n2XZ2WsPNlfPaBERDSED7Q12F3s/5EzNKLpqiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750427293; c=relaxed/simple;
	bh=WhWToY2gFgoji2enDe1Nyb8LomNvws/2+8zZTVs0T7U=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Ll6t181Gz1fpFXa3ZWh9pqzefcyrBmO798JOal/8TFbpjEJV+tEaiArbRzgZBlnYW9tPrNjLGW8YxV+t+Pn/dnxDKyOl0+qJOjX36WYvzBEvPkr4F5FTp8wkubDKKbYyQ+EMqDf3EuItku5y1y9xUIRWk1+D1jLftaW1+ehgpQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org; spf=pass smtp.mailfrom=average.org; dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b=di7jMW1X; arc=none smtp.client-ip=88.198.2.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=average.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=average.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=average.org header.i=@average.org header.b="di7jMW1X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
	t=1750426721; bh=WhWToY2gFgoji2enDe1Nyb8LomNvws/2+8zZTVs0T7U=;
	h=Date:To:Cc:From:Subject:From;
	b=di7jMW1XYhQxWvPksg20urXNLbfEyt3lmIOD46D0bdCjcBVTN7ap2a7x5nWzzjskr
	 /ll8A6bjbgUa0vNKCjTysaCxIJ8EDtuIr/0exOg9l8Tuih1tbkAaNvrjwC2NGyCZK6
	 YH+XveYgxS1geKMDK2mnvlx7aHvgHyr9MDc30fW4=
Received: from [10.16.126.80] (unknown [212.227.34.98])
	by dehost.average.org (Postfix) with ESMTPSA id 68CA74C87C1E;
	Fri, 20 Jun 2025 15:38:41 +0200 (CEST)
Message-ID: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
Date: Fri, 20 Jun 2025 15:38:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, ru-RU
To: netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Nicolas Dichtel
 <nicolas.dichtel@6wind.com>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
From: Eugene Crosser <crosser@average.org>
Subject: When routed to VRF, NF _output_ hook is run unexpectedly
Autocrypt: addr=crosser@average.org; keydata=
 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
 u3lufqBt0w==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------G6lT0ME0MREdbUBsN5ZKv7y4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------G6lT0ME0MREdbUBsN5ZKv7y4
Content-Type: multipart/mixed; boundary="------------Jx43KJnnGY0YnxvQvju5FtWm";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Nicolas Dichtel
 <nicolas.dichtel@6wind.com>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Message-ID: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
Subject: When routed to VRF, NF _output_ hook is run unexpectedly

--------------Jx43KJnnGY0YnxvQvju5FtWm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello!

It is possible, and very useful, to implement "two-stage routing" by
installing a route that points to a VRF device:

    ip link add vrfNNN type vrf table NNN
    ...
    ip route add xxxxx/yy dev vrfNNN

however this causes surprising behaviour with relation to netfilter
hooks. Namely, packets taking such path traverse _output_ nftables
chain, with conntracking information reset. So, for example, even
when "notrack" has been set in the prerouting chain, conntrack entries
will still be created. Script attached below demonstrates this behaviour.=


So, in order to control conntracking behaviour, it is necessary to
install additional rules in the output chain, despite clearly only
forwarding takes place, logically. Also, because "iif" is not available
in the "output" chain, it is difficult to distinguish such vrf-routed
traffic from true "output" traffic in the nftable rule.

I suppose that if the packet is being processed by vrf because it
followed a route pointing to the vrf interface, output netfilter hook
should not be executed. Possibly(?) a forwarding hook should be run
instead, or none?

Thanks for consideration

Eugene

=3D=3D=3D=3D=3D
#!/bin/sh

cleanup() {
	for ns in 1 2 3; do
		ip netns del tns$ns
	done
}

trap cleanup EXIT

for ns in 1 2 3; do
	ip netns add tns$ns
done
ip -n tns2 link add ve21 type veth peer ve12 netns tns1
ip -n tns2 link add ve23 type veth peer ve32 netns tns3

ip -n tns1 link set lo up
ip -n tns1 addr add 172.16.1.1/30 dev ve12
ip -n tns1 link set ve12 up
ip -n tns1 route add default via 172.16.1.2 dev ve12

ip -n tns3 link set lo up
ip -n tns3 addr add 172.16.3.1/30 dev ve32
ip -n tns3 addr add 172.16.9.1/30 dev ve32
ip -n tns3 link set ve32 up
ip -n tns3 route add default via 172.16.3.2 dev ve32

ip -n tns2 link set lo up
ip -n tns2 addr add 172.16.1.2/30 dev ve21
ip -n tns2 link set ve21 up
ip -n tns2 addr add 172.16.3.2/30 dev ve23
ip -n tns2 link set ve23 up

ip -n tns2 link add tvrf1 type vrf table 9999
ip -n tns2 link set tvrf1 up
ip -n tns2 route add 172.16.9.0/24 dev tvrf1
ip -n tns2 route add 172.16.9.0/24 via 172.16.3.1 dev ve23 vrf tvrf1

ip netns exec tns2 nft -f - <<__END__
table inet filter {
	chain rawout {
		type filter hook output priority raw; policy accept;
		counter # notrack  ### NEED THIS ADDITIONAL "notrack"
	}
	chain rawpre {
		type filter hook prerouting priority raw; policy accept;
		counter notrack
	}
	chain forward {
		type filter hook forward priority filter; policy accept;
		ct state established,related counter accept
		counter
	}
}
__END__

ip netns exec tns1 ping -q -W1 -c1 172.16.3.1
ip netns exec tns1 ping -q -W1 -c1 172.16.9.1

ip netns exec tns2 nft list ruleset
ip netns exec tns2 conntrack -L

--------------Jx43KJnnGY0YnxvQvju5FtWm--

--------------G6lT0ME0MREdbUBsN5ZKv7y4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmhVZFsACgkQfKQHw5Gd
RYyXNgf/SmW6JMNPITGAwM8e0I1U1VhJeGLMBslRip/FbyChPhXeZ1PpGbXjw37Z
8vkzO+NlAoUcxpYa6yFkp5ljiplMyKPcgpDxHPpxrQ9SIl4JEDBocb7mkg3/lN0j
XgCqC7t47AZhuF1HPvRvvJnGDMpdWSACMJCeyfbCIyH4d2IqO2QOlF9YHKAkH4Pl
j7XktukGqi7NNYAFryPtMpgAWWANS3XvEN1NrR3BUTtJP0CT7pv8rbgzQhP0IFnJ
JW7GNBFFtpz2lMa6ggzZh1NAI7XZS42idKtf9NnkswgR68P0uIl1DBvmOqnu0Io4
NMlXc+5oDjbgfn5YZ4MpCdIh1pJxeQ==
=eDCm
-----END PGP SIGNATURE-----

--------------G6lT0ME0MREdbUBsN5ZKv7y4--
