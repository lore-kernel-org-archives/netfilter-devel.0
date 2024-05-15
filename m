Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4717441E
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715777439; cv=none; b=fq/ssjTqu5Bwsj6f5EpgFYoYsF2qZHh+CgfH5QBomL3Y4HY5dfGJimDNHzxGP9ZQ0pDwsD8RRSlKW64HU9g3fb0q1zsX9zf0VLi0Gw0exPSGJv2T6uqSmB8bhl/vZY4ROeHwT9Eyk7ILP64JW0zsp+MDI7/Ruz8FMSHwgcTIL5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715777439; c=relaxed/simple;
	bh=HyoFBCVHjWAaEsXYDZGDPR3zPUhbcHZK+2Q1Jp3y1wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0TXbDFg6pJWHajIdTp+nmXSagz30UuCDQdwR0bYaawpY4RhhPOHt4QlbsLXcayFVRjDhG6H7+kzNE2XgCIZhT3gf1u9sG6Tbejvv4kVgiZorbmYlYj3FxMimv3gjaZ6baHtZqvvjbN1lkmUPjcMIzs54FueDco9lvADfp6WO0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZjypOt0P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZjypOt0P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=njdNs9qDcIM4VQRSXkCHC9CZTv7VNH3YBJyC/Pi3FqI=; b=ZjypOt0PqtOEHnAg9vR8cwodt7
	3q0BPsHtxVmw4mteI9DwkDyjun2prH/A5X9jIZ9ndPjgSc1iMWJjyZioXTDOtVXrHVuuJsMVUM1t2
	kflhgMtpEx6d/+tr8vCSf7Dr8M/wtAQQv/ZhbB3Ou01SFaE4aXLM/FJsgPX8fe+fM2TzWHD9T6GNI
	lSgHcMCyW2eXpaKVX8dVvwVBb/cnwffcSuDgJuKNVpAAc/ELwR713mIWngHi4m8c6XP5ujblQ7Chb
	9+Rdm0azjOOI4d/h7FJ+4T7MPRUNBD7RF5mV4Zc7izKKHaTmMotU3p07nsfaYhegxS1z0sKP9BSL3
	7hOpSyJw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7DmE-000000005OI-1Sdu;
	Wed, 15 May 2024 14:30:34 +0200
Date: Wed, 15 May 2024 14:30:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [nf-next PATCH 0/5] Dynamic hook interface binding
Message-ID: <ZkSq6nfq0fE9658S@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
References: <20240503195045.6934-1-phil@nwl.cc>
 <Zj1mlxa-bckdazdv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xcoFuiKr+GF5t9xL"
Content-Disposition: inline
In-Reply-To: <Zj1mlxa-bckdazdv@calendula>


--xcoFuiKr+GF5t9xL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

On Fri, May 10, 2024 at 02:13:11AM +0200, Pablo Neira Ayuso wrote:
> Before taking a closer look: Would it be possible to have a torture
> test to exercise this path from userspace?

Please kindly find my torture script attached. It does the following:

1) Create three netns connected by VETH pairs:
   client [cr0]<->[rc0] router [rs0]<->[sr0] server

2) In router ns, add an nftables ruleset with:
   - A netdev chain for each interface rcN and rsN (N e [0,9])
   - A flowtable for each interface pair (rcN, rsN) (N e [0,9])
   - A base chain in forward hook with ten rules adding traffic to
     the respective flowtable.

3) Run iperf3 between client and server ns for a minute

4) While iperf runs, rename rcN -> rc((N+1)%10) (same for rsN) in a busy
   loop.

I extended my series meanwhile by an extra patch adding notifications
for each hook update and had (a patched) 'nft monitor' running in
parallel.

WDYT, is something still missing I could add to the test? Also, I'm not
sure whether I should add it to netfilter selftests as it doesn't have a
defined failure outcome.

Cheers, Phil

--xcoFuiKr+GF5t9xL
Content-Type: application/x-sh
Content-Disposition: attachment; filename="nft_interface_stress.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash -e=0A=0Ansc=3D$(mktemp -u nsc-XXXXXX)=0Ansr=3D$(mktemp -u nsr-X=
XXXXX)=0Anss=3D$(mktemp -u nss-XXXXXX)=0A=0Acleanup() {=0A	for netns in $ns=
c $nsr $nss; do=0A		ip netns del $netns=0A	done=0A}=0Atrap "cleanup" EXIT=
=0A=0Afor netns in $nsc $nsr $nss; do=0A	ip netns add $netns=0Adone=0A=0Aip=
 -net $nsc link add cr0 type veth peer name rc0 netns $nsr=0Aip -net $nss l=
ink add sr0 type veth peer name rs0 netns $nsr=0Aip -net $nsc link set cr0 =
up=0Aip -net $nsr link set rc0 up=0Aip -net $nsr link set rs0 up=0Aip -net =
$nss link set sr0 up=0Aip -net $nsc addr add 10.0.0.1/24 dev cr0=0Aip -net =
$nsc route add default via 10.0.0.2=0Aip -net $nss addr add 10.1.0.1/24 dev=
 sr0=0Aip -net $nss route add default via 10.1.0.2=0Aip -net $nsr addr add =
10.0.0.2/24 dev rc0=0Aip -net $nsr addr add 10.1.0.2/24 dev rs0=0A=0A{=0A	e=
cho "table netdev t {"=0A	for ((i =3D 0; i < 10; i++)); do=0A		cat <<-EOF=
=0A		chain chain_rc$i {=0A			type filter hook ingress device rc$i priority =
0=0A			counter=0A		}=0A		chain chain_rs$i {=0A			type filter hook ingress d=
evice rs$i priority 0=0A			counter=0A		}=0A		EOF=0A	done=0A	echo "}"=0A	ech=
o "table ip t {"=0A	for ((i =3D 0; i < 10; i++)); do=0A		cat <<-EOF=0A		flo=
wtable ft_${i} {=0A			hook ingress priority 0=0A			devices =3D { rc$i, rs$i=
 }=0A		}=0A		EOF=0A	done=0A	echo "chain c {"=0A	echo "type filter hook forw=
ard priority 0"=0A	for ((i =3D 0; i < 10; i++)); do=0A		echo -n "iifname rc=
$i oifname rs$i "=0A		echo    "ip protocol tcp counter flow add @ft_${i}"=
=0A	done=0A	echo "counter"=0A	echo "}"=0A	echo "}"=0A} | ip netns exec $nsr=
 nft -f -=0A=0Afor ((o=3D0, n=3D1; ; o=3Dn, n++, n %=3D 10)); do=0A	ip -net=
 $nsr link set rc$o name rc$n=0A	ip -net $nsr link set rs$o name rs$n=0Adon=
e &=0Aloop_pid=3D$!=0A=0Aip netns exec $nss iperf3 --server --daemon -1=0Ai=
p netns exec $nsc iperf3 --format m -c 10.1.0.1 --time 60 --length 56 --par=
allel 10=0A=0Akill $loop_pid=0Await=0A=0Aip netns exec $nsr nft list rulese=
t=0A
--xcoFuiKr+GF5t9xL--
