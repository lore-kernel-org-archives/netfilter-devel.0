Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F766216446
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731444761; cv=none; b=DnGijDbGng33UHkGPOE7+YSsMXOQRWbhhJjTiATHFB1p/1rlbJAEGIhjAzIf2U7YmQeRSEnKP0SLKI+NhXEAGqXy+jhbMUSy2JqpsskHarTs0hy4Ni4t6l7A+3kEcUcm9z3cK/qpLV/pNHtnO2IAfw2HJ+aDvSgc1peiwE8/fxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731444761; c=relaxed/simple;
	bh=+SZL0JrjSa1Hbt9vX0pWBt9prNTHQqntRGBTkanoPjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpZe8VgHXuSjOFseV7ZXJBOOxpFTUSitZtw/6QQKz2iuEpE5buz8fvDrZu5fcJGeGRaRaYUAcmGYXQyAIYqglkn+1tuFaWCnyxGaEJr4h2gL1e3pCnQcR/KM43cqo8j7WAbfcbXssg1UYC5qgTFv3SoiB3EoyhQPmV04eF7FIrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FbkZLzG9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FbkZLzG9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sC6KXM7SeMKJXVC/SKyViV149OK1bOtFfqbpsxmMm60=; b=FbkZLzG92M4o07s2/7Mxkr3rtX
	y/T7MrShDinaQ3e2CX7InK0tJzvx/zHc8CFKRxXm/Yt7GXEQgCGKC4HtHqTtgp1dEKqqsRj2dJ2Zb
	2b5ZHNRYP8ask9swHbvQg+ZvWdDfr6sR8gc6bRTcQBCL5owkHVItmMGx3qSgSqRqezXo3cxOFyrxu
	GZA8riLZ9nop/xvupD7//IGsmQd4DTEBaZLWC+S7a1Ww94m83iJKAC0L3RLNNbRn3/l89Mr99TPTN
	Z05lxIgZJ448DMOdBUV6O66RXu/8mz2SqhDIwOi6BobzzowPp9IyiYGi0q3uPDBz+ObqYgAmJB18G
	gsFh5dxA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tAxsJ-000000000G9-2uad;
	Tue, 12 Nov 2024 21:52:35 +0100
Date: Tue, 12 Nov 2024 21:52:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZzPAE3Gj6qoA8ZAk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, eric@garver.life
References: <20241031220411.165942-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2K0Rw+evxlsTLrNh"
Content-Disposition: inline
In-Reply-To: <20241031220411.165942-1-pablo@netfilter.org>


--2K0Rw+evxlsTLrNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> Side note: While profiling, I can still see lots json objects, this
> results in memory consumption that is 5 times than native
> representation. Error reporting is also lagging behind, it should be
> possible to add a json_t pointer to struct location to relate
> expressions and json objects.

I can't quite reproduce this. When restoring a ruleset with ~12.7k
elements in individual standard syntax commands, valgrind prints:

| HEAP SUMMARY:
|     in use at exit: 59,802 bytes in 582 blocks
|   total heap usage: 954,970 allocs,
|                     954,388 frees,
|                  18,300,874 bytes allocated

Repeating the same in JSON syntax, I get:

| HEAP SUMMARY:
|     in use at exit: 61,592 bytes in 647 blocks
|   total heap usage: 1,200,164 allocs,
|                     1,199,517 frees,
|                    38,612,257 bytes allocated

So this is 38MB vs 18MB? At least far from the mentioned 5 times. Would
you mind sharing how you got to that number?

Please kindly find my reproducers attached for reference.

Thanks, Phil

--2K0Rw+evxlsTLrNh
Content-Type: application/x-sh
Content-Disposition: attachment; filename="standard_many_elems.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0A(=0A	echo 'add table ip t'=0A	echo "add set ip t s { type =
ipv4_addr; }"=0A	for ((i =3D 0; i < 50; i++)); do=0A		for ((j =3D 1; j < 25=
5; j++)); do=0A			echo "add element ip t s { 10.0.$i.$j }"=0A		done=0A	done=
=0A) | ../install/sbin/nft -f -=0A=0A
--2K0Rw+evxlsTLrNh
Content-Type: application/x-sh
Content-Disposition: attachment; filename="json_many_elems.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0A(=0A	echo '{"nftables": ['=0A	echo '{"add": {"table": {"fa=
mily": "ip", "name": "t"}}},'=0A	echo '{"add": {"set": {"family": "ip", "na=
me": "s", "table": "t", "type": "ipv4_addr"}}},'=0A	for ((i =3D 0; i < 50; =
i++)); do=0A		for ((j =3D 1; j < 255; j++)); do=0A			sep=3D''=0A			[[ $i -e=
q 49 && $j -eq 254 ]] || sep=3D','=0A			echo '{"add": {"element": {"family"=
: "ip", "table": "t", "name": "s", "elem": [{"set": ["10.0.'$i'.'$j'"]}]}}}=
'$sep=0A		done=0A	done=0A	echo ']}'=0A) | ../install/sbin/nft -j -f -=0A=0A
--2K0Rw+evxlsTLrNh--
