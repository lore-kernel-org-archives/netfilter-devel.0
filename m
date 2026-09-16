Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B07309EF9;
	Wed, 16 Sep 2026 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570938; cv=none; b=NG9gn1I7sVdFXR7TZ+oR+acOAetri6wVqxL3wbXfxYuo88NLJUgHs3wIsJwPEfkginr6qEWJ2dG4tL9/Bx74tub7iDCdXisbXVfjIXjbGUDkwumaQHn9DyuI/nbSxD/3+GLWe9oxMJ5af7aOWpK/Sfls/6tJhoPB7Xh3VHgJTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570938; c=relaxed/simple;
	bh=3btKcf3LaoULQBtdKkBOCtV8wD3a5X/OGvUDgyG+JlI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XEFrA0Er5+58+49PSM7Kk4ZEy/pHr7jeHLkVrijMWp05gW3USKsNvN0k8vBY3eMzSAjDVadRkMDsyRQ56t3guHsnX0J+7Q6s1gJdiaPgZWCdvUn1zAmg6V5al4qveqwQYGD/zkfcRajyY/xTDvgcuGDL3JlzQPrprxXA87Tf9zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.im; spf=pass smtp.mailfrom=fastmail.im; dkim=pass (2048-bit key) header.d=fastmail.im header.i=@fastmail.im header.b=EJ/Yoou+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TyIi+H7Y; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.im
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.im
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.im header.i=@fastmail.im header.b="EJ/Yoou+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TyIi+H7Y"
Received: from ams-compute-01.internal (ams-compute-01.internal [10.64.2.61])
	by mailfout.phl.internal (Postfix) with ESMTP id E779BEC010C;
	Wed, 16 Sep 2026 11:02:12 -0400 (EDT)
Received: from ams-imap-09 ([10.64.2.29])
  by ams-compute-01.internal (MEProxy); Wed, 16 Sep 2026 11:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.im; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1789570932;
	 x=1789657332; bh=NWI3WiWraJXbjOLrwEAx5r7o7HhCag9kGHUjZKRrvkk=; b=
	EJ/Yoou+9kCf+c8q49d3AFMSseKLEjoZv1pD2/YOPC89qDTeMoW4PY6+h6Kngyrl
	iVtovWFT7rbQqpLjntJLQY09XdCKfZpO8tyyTFANq+PwxL+bptzgaDFzcIPbBf3J
	lJ+UFIkFjNlZs5xn74LUrHa3UDBZocA9U3jUKEYwZ0/eoIxJeNxf6Yb/TPZa99G5
	BA7bryJoff438BjPGqo4mCfBOMSBv1H/FOcd7G4jGtc3Vi0rmDNa1H9nCL8hvEMq
	IjvvEqMyN31Yrz9vWPRuzymaLWo8Zzu9xvCvvSnb5pQ2WWqfmKJc9Z/1/9iXS7NP
	om8JfWmTZ+Qneh2fTKVD/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789570932; x=
	1789657332; bh=NWI3WiWraJXbjOLrwEAx5r7o7HhCag9kGHUjZKRrvkk=; b=T
	yIi+H7Y3Sk9zgfZp2Ny9jnp2stKIKM8va46fhZwXnjB/cGctPDKoZDiTC6TkmmB7
	z4MxL+GKaNp5BY7fuelaqWFBVxKjedKSehiZysYMQ7oU3xAcqz2S3mGitN0De1qe
	fFlNd9EoLqP9R/Du9ixq6TCACUyihCgcbv5EIWDQM53EMTfdgH5CnvOYGflqO0hn
	HO4Olht7CMgOGb0QNKvNbiUqV1KaYsiiGX8Xh6uipynUtYE7bEKnx9kIzBsK3XkW
	X33slhlvsV/6Lns0n3UQAw9tpjQBqONKLUV3lWJPaAGxZp4YrEYZP1ctEeFX5Mg4
	wHKYnxPOa58Injwzr/gUw==
X-ME-Sender: <xms:ba-qar4pqQDw1aLeE3Ge59f-LLeyj5mQCO6jCRe08Nf0nduhSYGr8Q>
    <xme:ba-qartNPl4fHFRy-XuJi6kM_QjR9e90lZJz1LTDHMtGqm-r5KQ_DH0zKp7jgBbKr
    Cx6BUmRhuLuRBHNhllAr5pbpnG35Czrnt1ZnZ0_y1N_jumaiftNoThI>
X-ME-Proxy-Cause: dmFkZTFr1KRExiZG+9wJ0gBKXAtXJ/uvY8GuD6EGAYfTMzR3nEnricooFfX3b4cHrXsS32
    D0brZxwZ9JrDwxPrcD1hFgJmxKlPEiSoBHxuLaP6zK4Ji433m28cvZ1aRea8KmmJFoG7H6
    lPr80fPCQ1LAVGuP5gU9OQqVfixQp3THlvrpUkNimuqap4OsLWuRIZCBwln99GrfkRjMyX
    T3UfWDanfFtWuK+smZrgRmlVIE40PrQ2fRjJ4M6RCyGStq5aXCw7TJa6Ghqci8sjcf6d4w
    MsLmwuMUhpjXYwYjRYe5cTtJbxsKbUCPv40Mynd+PufMkcgJPrpTl0DsrWZXtOCdOfazJz
    UFVoAv5Wqt2NM0O4Wczv/vVAbz/ZuyV3Gm7m+Ngb0LbXl8gJ2SpMYA9QU5Hc4MN718UdfL
    viawCO82V3T4JIyQ05z0VQzcNfABegOE5VZI/D1flWIzwSSKyw7fIa9DkpRNEFA391osfG
    UfHpEJmVBYLGxLe2KnMwMmZ72q3TGswjI0SoNk1RhqTBzdarXX7syPfxidq9/NNBFYyJLh
    T6z+lGyiHdFSni3ugHKwCQdNfCQDju5vUlg6sunPt+pPKO8LgUtANxrfkgP0sjjnajA264
    csCUw3J/0Y0vNbQFMlM1W5JZcfd4Fgq1lz19zkyyocXIjUiqVvrN1wZTsAhQ
X-ME-Proxy: <xmx:cK-qaiQFcpKGUuovm-hZdZYrYU-yFTFG77eO84NHVL2o6i5oVQbSzQ>
    <xmx:cK-qanXHeF50y50H1atX_Ky-sVxGgWFDj1nqYqtuts4t2h0BXjb31A>
    <xmx:cK-qakKe9_TUuCUxUfXsBzRs7lCi5qU9kMwacFKoVpWzgePHxXGnuA>
    <xmx:cK-qagguVieFFzOeEba_hSUa6-aTKcPbNJlVXT1sP1V8M9z0haLYlg>
    <xmx:dK-qaikLbslOR17H1JJRmOzpoMzwmqo9i1nQ6LZy6za8U1KKIIXcpXq7>
Feedback-ID: i559e4809:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4CF18180088; Wed, 16 Sep 2026 11:02:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ApbeBSghDXrk
Date: Wed, 16 Sep 2026 18:01:19 +0300
From: "Alice Mikityanska" <alice.kernel@fastmail.im>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc: "Florian Westphal" <fw@strlen.de>, "Phil Sutter" <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Felix Fietkau" <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 "Alice Mikityanska" <alice@isovalent.com>, Sashiko <sashiko-bot@kernel.org>
Message-Id: <806ac4ac-43b7-43d0-ab72-35a95996d570@app.fastmail.com>
In-Reply-To: <aqPmghtf5zrFaFao@chamomile>
References: <20260910162052.94648-1-alice.kernel@fastmail.im>
 <aqPmghtf5zrFaFao@chamomile>
Subject: Re: [PATCH net] netfilter: flowtable: Saturate 16-bit flow_tuple->mtu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Sep 11, 2026, at 14:31, Pablo Neira Ayuso wrote:
> Hi,
>
> On Thu, Sep 10, 2026 at 07:20:52PM +0300, Alice Mikityanska wrote:
>> From: Alice Mikityanska <alice@isovalent.com>
>> 
>> ip6_dst_mtu_maybe_forward clamps its return value to IP6_MAX_MTU, which
>> is 40 bytes bigger than U16_MAX. While it can be a valid IPv6 MTU (IPv6
>> payload_len doesn't include the header), this value is assigned to the
>> 16-bit flow_tuple->mtu in flow_offload_fill_route.
>> 
>> To avoid the overflow, use U16_MAX for all MTUs bigger than 65535. Since
>> flow_tuple->mtu is just a threshold for the software flowtable fast
>> path, packets exceeding it won't be dropped, but rather punted to the
>> normal forwarding path: nf_flow_offload_ipv6_forward returns 0, and
>> nf_flow_offload_ipv6_hook returns NF_ACCEPT.
>> 
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901195714.673548-1-alice.kernel%40fastmail.im
>> Fixes: 4f3780c004ef ("netfilter: nf_flow_table: cache mtu in struct flow_offload_tuple")
>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Alice Mikityanska <alice@isovalent.com>
>> ---
>>  net/netfilter/nf_flow_table_core.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 03241d4bfd5e..8f15540ae206 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -107,7 +107,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>>  		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
>>  		break;
>>  	case NFPROTO_IPV6:
>> -		flow_tuple->mtu = ip6_dst_mtu_maybe_forward(dst, true);
>> +		flow_tuple->mtu = min(ip6_dst_mtu_maybe_forward(dst, true),
>> +				      U16_MAX);
>
> This reminds me we should not catch the mtu.

Sorry, I may not have enough context here... Do you mean "cache the
mtu"? Should I go with a different approach about fixing this bug, or
should I drop the optimization instead of fixing it?

Thanks,
Alice

>>  		break;
>>  	}
>>  
>> -- 
>> 2.55.0
>>
