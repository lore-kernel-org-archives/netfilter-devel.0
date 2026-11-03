Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744669;
	b=gyh8+wrjgpAz8gdPUxls2OMkVkTABeXN8EFLazMZsE/WiYpbR9Pm67uvjkpndWAFdtYy
	 0Qr7flvwt/3+jKN1vjh7ssvaNjP4lQbFITR6BDhAbPtkopINqPOtQABoLnskJhk+bN1NC
	 wdua6ISTsxF+wFLCA1eUKMEgsBni5STz+b2ZZMo2TAqtLSmznB1a0kWSm9tHfAe/Q+UiN
	 bE/jz8BhH+ZwVGFAZ2us62wEhnsxE6AzlfWvRhj9KSLTD7Fq1WPfswMS91XVt38nnnA0a
	 8z/C6Bsd5ZyeKDgIA5Vt7ZBmQauJXT4MrkJHXDzCj7sXaZ/xR8qZH8iCtd9R2wBZWSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744669;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=EMAdBXKIQjZ2eL7On2GKJg/pfvU0OBX71fOIYOXfups=;
	b=xHiI9No/H0l33Po6jQHg6A5dQXgdRnWoxPM9/AdfPYN8dfZ7Vz9YEb+eKpRcg2VIA/MP
	 wjbGtQj5dYp+IF/YXMZoMI+WOKO2PsfrzCO8B5KxsPSeksG4dhuBhVr+P9vhfIlEGKiee
	 1mD4seOUaRyeGIy2QkP/swD+Eqg7qThTNBW0wIsARIL9Dem2wJe8cV8FkjaXepsElh1ER
	 j3XFDu5600z/fESZWrlSDk++GIxZ3RXQVq3fruO/EmaJSvG1DCAxi27f9PQqMoPgS6EE7
	 dZKXiQ9k957N5WMs15IDPCiAKARGrEx5SAf9ndooalTUneiQOy1wTC0Igf6omad4W+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KnI0Qk2S;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ApWYkHN8;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E2A606A31B
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 22:24:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9E2A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KnI0Qk2S;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ApWYkHN8
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3LKjFG2395442
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 22:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=EMAdBXKIQjZ2eL7On2GKJg/p
	fvU0OBX71fOIYOXfups=; b=KnI0Qk2SbqDCLKnqF7TjJYZQN+gtlqsWfIsQUuoF
	kSui/QCIVGQvaHTCBXbPksOHvcgOFkQ/gSCp/m8J+luleeqzmqpiTJcrwPSMl9cl
	TlQkQMXxGYPahM9XwdiI72PsaO7IGZzm27vUoUx8Xi2ox/oh+g6zDQiF32KF+cua
	ymvlKl5EXvqZVTs8OXb31Vejxkbx7qNanoRQY43urT4iLc8l7lbafXp6F9jsTk6Y
	wLItYkj0IYNoDoS5vpcvd/ff8rEw+cdbcuymaC1TkKzX9Se99FiZ8luW6scBqEU8
	cy97EF65LuSO7nTk6WdEPqpasGKrsA+ivMAYVLZxA3v8jA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhyd1qxh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 22:24:27 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f1e62510cso33972385a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793744667; x=1794349467; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EMAdBXKIQjZ2eL7On2GKJg/pfvU0OBX71fOIYOXfups=;
        b=ApWYkHN83J43dj9FLgXWWDnltra4sEQoWcokoforB3BECeNzSq+Bed4FgQ9a+s/ZKt
         PzlPYv74WFMzV6G7HEnr7x7IulLd1M5DdhmLGVATbro80pYLMEtajZZvY4K/L+h58u40
         1cL6TMX5xvAaDgyYM3vWG2tN4pEXvSz7dydKHGXqdCwLCZNDkINJLQ+mEw524H+Fwh4C
         gl/9XNRKDII5OwHj/Az74H9Jz6EGrl1DcWMlYydADKizyje+z8Pq4Qj4k4Iu1HiLTWTi
         h5+V4vKy4TnkdkzR2DgmuPRLGzv+Q4/uCWZE9MfeWCPQpKNKPYK5jXS6TF8eD/GBO1Sq
         tqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793744667; x=1794349467;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EMAdBXKIQjZ2eL7On2GKJg/pfvU0OBX71fOIYOXfups=;
        b=dfW8PvF4Z2wklH1QDnQh9kjcD3BVruNbUb5IdwAGHLORmXeWvh7mhjt3WrbShJSSva
         S2bNeWiTY1RgMUukPuGxdM0qlJvK6mutlBVrF+qn4K/+rmsdvmnXsQBh0zrO19aOKW9t
         lkXgCrQVpPCKj+zEklnfqDEPDSCCtVhLioU7Mvg1rBCGCRi3HFO2agSmT8gmiFVjB/+V
         TfjrtPK59jht7eKLtvpC4p04on97vYxijy+2nri+8o7MlTW0AC5rOdTeYH7XG0P2qoVc
         7KckueY8fjfUl2jdsyhkuHZJataF8WXybqeuNOVrWYyr7PAFbRarZCmY1nXu+i7Aj7nu
         nY2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwgl2TMDo7ne+yII4mLXLpntWKSlQ7189gjjcMQV5olrJiwYR9gi+eoHHEvtD/b1ccGRYbiNUhCdZn8iPxwISg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9krhOys3SUoYHfQhkjPs3Pt3uaRyHFuNxW5GAuHcJL+RdQrnXR
	pHeOYKiWGDOAO5y6CkUUBdn73ZlJ0zZFmeOhlaQCyfEQUC2sfCZ3zCG6PyLggEoTWv/hs0bC8Zz
	MW2U5hHcZKijk3w7mDqxxtxoiHDZBJ52wNEXt7wu7aRKXxvJ4pRius3C6gi0SgbfrpkmH9qo=
X-Gm-Gg: AYBFou1veGQJMtJ+lMFEuybIkaWKkRBRbjPnENWP1Iuc1vA1XIyawuZ443n8dgDOwGh
	1XfxMBAtZQBHwHYWGfV+D76tDvgY+obNRhMSnroDDCbTR0aTfNzN0tsPcyXL4l/W75JG3sL9xKC
	+4aFIKravba0A+SfZldz3XppaxJCGUlvPe7tMTD+4aIzffG/45N1Pvd17qF2IznLk/3IsgdIsrf
	CoKUOvSrsl15nPOKB/jU5X6oRnpxSkUOeskYX1CbWu/X+ytmbwZJkmmL/q1P1+Wg/hK22yHEV35
	heyzIq9DAx/hSGse8Klbv7gzAQGh3/oEkW8B0Rb2alUanOM0QzP22BJ9TCzkXuN8gYSeaTT3Dl2
	cIEhKgHaB72jNQNMsmzRxh5qT/wF9zUC6Q4bZD6S8BNd60C957gHZnyvn+UEw5A==
X-Received: by 2002:a05:620a:2807:b0:93e:910c:5fbd with SMTP id af79cd13be357-944217b5558mr2432817885a.63.1793744666722;
        Tue, 03 Nov 2026 14:24:26 -0800 (PST)
X-Received: by 2002:a05:620a:2807:b0:93e:910c:5fbd with SMTP id af79cd13be357-944217b5558mr2432814885a.63.1793744666057;
        Tue, 03 Nov 2026 14:24:26 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b43cb234a1sm5835195e9.9.2026.11.03.14.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:24:24 -0800 (PST)
Date: Tue, 3 Nov 2026 23:24:23 +0100
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Marek Majkowski <marek@lysk.ai>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next] netfilter: flowtable: tunnel device poisons
 h_source of fast-path frames
Message-ID: <aupfF8g1DH2lQQkV@lore-desk>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
 <20261103213430.2850-1-marek@lysk.ai>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lbqjb6ASYjPDv1q1"
Content-Disposition: inline
In-Reply-To: <20261103213430.2850-1-marek@lysk.ai>
X-Authority-Analysis: v=2.4 cv=bp/Zl0ai c=1 sm=1 tr=0 ts=6aea5f1b cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=JOjV33QCGg08e02vQs4A:9 a=CjuIK1q_8ugA:10
 a=I-4OuOSVAtTkjluqnT8A:9 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: gnygvitQiToJluCRRY_tLcJ_FwTVpBus
X-Proofpoint-ORIG-GUID: gnygvitQiToJluCRRY_tLcJ_FwTVpBus
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA4OSBTYWx0ZWRfX00EOFDbn5Uaf
 bz4K9h07oX35YT6f/z+97VuTKuLCdEdYxb4iqXmrq6GgSpxKTcYnDGX6ObAjK4QBicoyR9Bvk72
 Z3Y8crblbrJAiRFtGwWUOwBkD51ZDyE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA4OSBTYWx0ZWRfXy2yr2jd5BJUI
 90VTn58jD1rsAvK5y/G7zj8wUOC/Kr6/eExrFUPHQk5FEbKTGAsYEV2KQkYhLORXcvlve5pj0xg
 H1ladV3W7QEFEaiV27RsHYMig5XSWewEpQ8Ocit7CGSXrdvmVws2gsjmBlsU0VIyT9L6RYT7zgA
 7j/WylytZGffR7sGg7Ues5FCxa2IRjamEpN7KXQ5q3p3f0ZZ+Mib9vMsBUH4iX/obh+1bm45teM
 GrFCPvrU+yeuJS6ofsbcCV4m58hxBsformw2UdajsfqZCzkca8zCjdWAi3iASt+iUEe7QDW9PDz
 2foMKD8Rc2D5x2831mFmfWadSTSYgN1CKAFc18CW7+rjoByu/JFdjWmab25JbYJGleYTNF2rKSO
 BbZDR1muTawKVjNx72BFfgZDpU72+XVLLs1ZTXMmWT1NGomYQBCK/d9lDj2x0iv+UBxWoPu7E8w
 /vxh7zzgdLTbwA8QwYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_05,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030089

--lbqjb6ASYjPDv1q1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> When a flow enters an IP tunnel, the forward path discovered by
> dev_fill_forward_path() starts with a DEV_PATH_TUN entry for the tunnel
> device, followed by whatever carries the outer packet.
> nft_dev_path_info() handles DEV_PATH_TUN in the same switch case as the
> Ethernet-like path types and copies path->dev->dev_addr into
> info->h_source if it is still unset. For a tunnel device dev_addr is not
> an Ethernet address: ip6_tunnel stores the 16-byte local IPv6 there and
> ip_tunnel the 4-byte local IPv4. The tunnel entry is the first one on
> the path, so its "address" wins and poisons h_source: every fast-path
> frame is transmitted with the first bytes of the tunnel local IP address
> as the Ethernet source MAC.
>=20
> Seen on a DS-Lite setup, LAN -> ip6tnl (IPv4 inside IPv6) -> PPPoE ->
> 802.1Q VLAN -> Ethernet, with conntrack flows offloaded through an
> nftables flowtable ('flow add @ft'). The first packets of a flow, still
> on the slow path, and the fast-path packets of the same flow differ only
> in the Ethernet source address:
>=20
>   slow path:  d8:58:d7:00:2e:bd > 80:ac:ac:39:ef:c2, 802.1Q vlan 35,
>               PPPoE [ses 0x454] IP6 2a01:110f:4328:c400::1 >
>               2a01:1000:0:1::2216 next-header IPIP, 192.0.0.2.40010 >
>               1.1.1.1.53
>   fast path:  2a:01:11:0f:43:28 > 80:ac:ac:39:ef:c2, same frame otherwise
>=20
> As you can see 2a:01:11:0f:43:28 is the start of 2a01:110f:4328:c400::1,
> the tunnel local address. The PPPoE endpoint binds the session to the
> subscriber MAC and silently drops the frames, the effect is that every
> TCP/UDP flow dies the moment it is offloaded, while ICMP, which is never
> offloaded, keeps working. Received traffic is unaffected.
>=20
> Do not let DEV_PATH_TUN poison h_source: skip the assignment for it. The
> real link-layer device appears later on the same path and provides the
> correct address; for a path with no Ethernet device the address stays
> zero as before.
>=20
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Signed-off-by: Marek Majkowski <marek@lysk.ai>

Hi Marek,

thx for testing the series and fixing this issue (I guess this is occurring
since the PPPoE path forces the xmit_type to FLOW_OFFLOAD_XMIT_DIRECT).
Since the issue is related even to IPIP or IP6IP6 tunnels, what about
targeting nf branch instead?

Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

> ---
> Found while testing this series on a Turris Omnia (Debian, armhf) behind
> a DS-Lite ISP: with the series applied, IPv4 flows through the ip6tnl
> were offloaded but no fast-path frame ever got past the PPPoE
> concentrator. The problem is in the existing DEV_PATH_TUN handling, so
> it applies to net-next with or without this series; with the fix the
> series works here (tested: UDP flows with a fixed source port, TCP, bulk
> downloads through the tunnel). Without the series the same wrong MAC
> should affect ipip and ip6ip6 tunnels in front of PPPoE.

Since you actually tested the series available in [0], can you please provi=
de
your tested-by tag? Thanks.

Regards,
Lorenzo

[0] https://lore.kernel.org/netdev/20261103-flowtable-sw-accel-ip6ip-sit-v3=
-0-60b5f063f1df@oss.qualcomm.com/

>=20
>  net/netfilter/nf_flow_table_path.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 841f09943..4ca6e09c7 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -121,7 +121,12 @@ static int nft_dev_path_info(struct net_device_path_=
stack *stack,
>  		case DEV_PATH_PPPOE:
>  		case DEV_PATH_TUN:
>  			info->dev =3D path->dev;
> -			if (is_zero_ether_addr(info->h_source))
> +			/* A tunnel device has no Ethernet address: its dev_addr
> +			 * is the tunnel local IP address. Take h_source from the
> +			 * real link-layer device further down the path.
> +			 */
> +			if (path->type !=3D DEV_PATH_TUN &&
> +			    is_zero_ether_addr(info->h_source))
>  				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
> =20
>  			if (path->type =3D=3D DEV_PATH_ETHERNET ||
> --=20
> 2.39.5
>=20

--lbqjb6ASYjPDv1q1
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaupfFwAKCRA6cBh0uS2t
rGH+AQDgda84U4c6W4mIKUck4bn7r0IPxlKt96wo/OmRNwWvDAEArTJ5Z5WqcuNg
/xoQ4b16WmI9WymzJHhiWTivWLa+Swg=
=KkDk
-----END PGP SIGNATURE-----

--lbqjb6ASYjPDv1q1--
