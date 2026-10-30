Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348435;
	b=N5HjzSeEmXqnZKK03FrQG/9DdnpKLqYz4bnyDgKSZKXO0uQF/b0FBLBycz6ueTFcL0m9
	 qmZq0YQwC0YF+eRTxk7QJ5MOztgev1JGIh4Sw9JUZibYgqCpxdflU4VQK0n4kgZjFV6e2
	 UWnBvg8t/t4t5SAUAJqqh2iNFoIdmP6vOrwwFnUyQQce5EbuOVE1fmwKkgLpWvJ/pcD9t
	 +ar5x4MS6wt350XW0rgr+LE/iCaP/CUjuHvRQvbjUB50tEXoMgOIVCztJnJvXaMkUfD7U
	 1dpgN+u5S7N4jf/ieSQQVP5gTY2ZnWkikLsJny1uhWywM+8hh6hRYiM5fkahy7n8jMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348435;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=lIPzTuhussiig+aEn2mZeROStxtfOxwExgWef6pP0yc=;
	b=HXiRdhdJJ0Cvx65+jOvLBRrhd8Z+j3J6IHYMt0AF2O6M8G0H2t0nvqhLtCYWCfllx2Qq
	 l0jNeSp3bTBk5N+fVWy+PRXLfOLBsLMNcnnef7IiOlWrw+gmfRIfpJm7JQ5YP86vuQzId
	 3QwT+jOMYcKWrF7FD3yL3oHlycp2eQyFXZVJcgAjQPBp+Y+LQfsI4yJKRXitFHaBOUzw9
	 jax13SecS7y8+QhTBPKRHgitLBNl8LCVipuarIm7fOoH8/xmR7F3KV5OWbtGr/2JeAkx5
	 9j7zt7J6FF+coqraVYsdA2idZ0DorlUOAAgE38tQtAetK8kqFN+eLcdh+o7PoFZjBKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SNzxkYDL;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kvnb4lzy;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD082606A32E
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 08:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD082606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SNzxkYDL;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kvnb4lzy
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8FIFm2733217
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 08:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=lIPzTuhussiig+aEn2mZeROS
	txtfOxwExgWef6pP0yc=; b=SNzxkYDLAXzpsny7h/UM+IgX6WF5LAIfnCyrglve
	7xSqnpMslNfHzuKPJZQ2QMN3Zs34YqfCe/7kMON6xG3J1f41+w7tIy5N2TlNnjp5
	KJJUyWXUNjyoG9QivhWAgkwWWUcAwNU1bbAE/QKFzWXQUAS4Sio6iQ6w2dveRxCl
	WtHWBXFFAa8EsHO+mMPh7Rag5vndVCEKo0EUr7qlJNzSySanIZbO5D2BduKpp1Nc
	gevlKgISR2bvahCScNq4ko7bt9/Phf65roMbbv+oSrC0taHbbGd6yjGq3ixAHlaS
	aeRtfW0BUPU31XqrO4jbbwxN2h+KQFj383H5kxfHOglf1Q==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qhy2q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 08:20:33 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5338c59f90dso30824321cf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 01:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793348433; x=1793953233; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lIPzTuhussiig+aEn2mZeROStxtfOxwExgWef6pP0yc=;
        b=kvnb4lzyV8jf4WWorgOoU2fnrLmB2lmGs0hgxKKzA+Cr84N8678653PASGYSh4Htwr
         Dp3GoFxWiGRB9WhrAabptJSlyZItlOOioKADDgzDk5O0m2uCtmP+RMyrL4n7W7pEkvIh
         N9KW1mSuPVzDeEJKsD+CyFh63Ulusu5FxaCIMfm9+GcN22p6n/q2dKtjMqO6zbrFx37e
         RrRRBWlk1hqInfvihThrRcrDvKcFKe9dqm8GmfHtS2xCLfzPfNmMbtUNRkg6gTTlZ27t
         tPyjZ7cEbyO8uWbF9baBRsxyad/HhCFMI/AIuVT5h8sMsQTqvaeXRRXYh1IvaVd8ynEj
         c+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793348433; x=1793953233;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lIPzTuhussiig+aEn2mZeROStxtfOxwExgWef6pP0yc=;
        b=Wmjc/b03FTpc1wDjuJBi1JG5aTo1JPL/hwcCCSR/kp8awuacv+pEPNMyZMYxfM0SFB
         dEize+KnL901m20ItMmnOzycap6RxNkA5OB/8yR4uQIxBFbC3LBZsnvw4DxYgfv6HoFD
         YsFaL5YyWie1zE/h/SUPLHIVykKuEtdHDMCoFctRSdWNSSBNzTJzNEhz2LcfJ4EV4BVk
         BzDvkxSwqge67FCh6Bhdi1yRzQPL+GL6VhPluRv9Yg3LUKmqncFhjnIyYPp8H+osZPQ6
         HrE5SPYT78t/jPzz+na/wp29sQWI1hKGWWoiRd0r6S5xajXii5jvlS/gXXP8T6zIg6iY
         FwhA==
X-Forwarded-Encrypted: i=1; AKwUvBzcglDSVWR4ZRonTMXKSeP/4LBcwzZlOkFVPTz7b9ieHriy8m4x2MOwliALJogAFN+GbtlL+U7FI/qs5WQVCrs=@vger.kernel.org
X-Gm-Message-State: AFq9FYK3Y38Wss5yndraJpeyf1qCrg9NXjfB/VGQpOkjtoBKZTo8qax4
	kJtsPkEYpSn0vRxKzcnG/XeH2I+3ILMB4LdCbwHS7Z6LqK6Fn9KSOBH3Yu6sGFhMazZNgangfui
	6fAzssRz/UchFCwhmi/zKf5UAYjw3CbVQsUmQJawW0+5eLku2RgCfl77DKb/XeJewmtEMhWyIwN
	VUILQ=
X-Gm-Gg: AYBFou2K8EkPOqRYr2BW7UhbR/EFmqqyL4FeBC97RY/yOtoa3Ci6RJIP04P9I+4tRKt
	PSR/+h5DAyOQ55ya8yJK9nzYI0aEIfsY6GfeaLlx/Axil/jn/eHlRZfJli5P1f8KyWXqWZmfAcC
	MK/lwsUGfoxqRPmzTzax/ZbzJyGBG/jsfNBarW2ph+3D+i3kiQGHhwaoKTS1Go3UFIaTxzKr4eX
	3Zghl4eqYE+HbvpbNhfNur/sN7J5saxi0OQ9cYPEXQ0Ey+jRCY8/KNdBHFCd0uvQvmZlVJ9jpCD
	Q/1TlG0YTXDsMXJ098q6Uol3IYjzbfeBPDaaKqGywKHcRyKJvkhs4qAh4HMsh+3FOMnY/h6/pYY
	+tRa12sgLTJC+5Zk5SWLeDzWDIfY9WNABqZbPNCqn6AbkcYdvDgi0VpsJaqq6V6MsZSE+SBMNmR
	2orK1P78Mx820CuKHFnXJVYQ==
X-Received: by 2002:a05:620a:1a20:b0:93f:2b65:593b with SMTP id af79cd13be357-944133ecfd3mr741679885a.38.1793348432659;
        Fri, 30 Oct 2026 01:20:32 -0700 (PDT)
X-Received: by 2002:a05:620a:1a20:b0:93f:2b65:593b with SMTP id af79cd13be357-944133ecfd3mr741676385a.38.1793348432139;
        Fri, 30 Oct 2026 01:20:32 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b725b8sm1972421f8f.20.2026.10.30.01.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:20:30 -0700 (PDT)
Date: Fri, 30 Oct 2026 09:20:30 +0100
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: kernel test robot <lkp@intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Shuah Khan <skhan@linuxfoundation.org>, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next 5/8] net: netfilter: add IPv4 over IPv6 tunnel
 flowtable acceleration
Message-ID: <auRTTqtCzyQAjDEe@lore-desk>
References: <20261029-flowtable-sw-accel-ip6ip-sit-v1-5-6a17c54f9fb7@oss.qualcomm.com>
 <202610301255.BRNUBmqH-lkp@intel.com>
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
	protocol="application/pgp-signature"; boundary="Bcierrnx+NloiNUP"
Content-Disposition: inline
In-Reply-To: <202610301255.BRNUBmqH-lkp@intel.com>
X-Proofpoint-GUID: 2fIhJ5ehAfMc4vw3H6b3_qWAIh7IKdsI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzMyBTYWx0ZWRfX+ooJJ++OAseQ
 rM7RyP4UJw0wKeYtlTQcP9dQ1fjyCX1Xb61MnW8dFMIx5l5X3owkerunNlIishZDrw0oldR23cr
 xPrmQnDag6Ms7AgLyhvfpBe9Z796b04=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzMyBTYWx0ZWRfX8tkelItq7FmS
 NLANVK8/IGnGzOzOfC53KE2pHBUYU4Q/wQBZWNmKdlohX4j0PP87mvmzqB6r1t5TN4tsQrH951T
 tx+xsCJLkiZhLZaVGXEP2ZouhxYgK/b5KBX2f9prcuHzU9koAFQxMU+VBRKx5Z8ZdkrQ+dV4nAX
 cy9MSn3Xjny2xxkDEJ5D9jf0E84cxlKD7AIU6QcBDS68c/zHlzy0tpqeqNJeC2tgZNIgG96SEL1
 /DXkVzkNdV3Fta6aYtrs56si4sxzVhlDmxF62YFTthI1rP7ygM4/0lVjHBpfCpCUNkOEJbz/si6
 YGQdXP0gtQzhVFc8brF8M7zjVhL2zlForfzXCj7YUcJr/esw0KNt5PLRK7U5OVGBHcIyXd9py0k
 SgZEaRWQ2t8C/pIYlkqOAtzhIDTvusYCepcWtb/b1ttaWNfWg87KCT2LWHRAZGnGKuiHs7i6iwL
 /xtBhxy9xPTI9LDKLRw==
X-Proofpoint-ORIG-GUID: 2fIhJ5ehAfMc4vw3H6b3_qWAIh7IKdsI
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae45351 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8
 a=hGUAt8QyJn-wdT-a5YkA:9 a=CjuIK1q_8ugA:10 a=FPnsdwdfccfL58mOmmoA:9
 a=a_PwQJl-kcHnX1M80qC6:22 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300033

--Bcierrnx+NloiNUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> kernel test robot noticed the following build warnings:
>=20
> [auto build test WARNING on 734bef548a96e8774d6eef5dfa2026c6edc4e80b]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/n=
et-netfilter-nf_flow_table-recognize-IPv4-IPv6-in-tunnel-proto-matching/202=
61029-143512
> base:   734bef548a96e8774d6eef5dfa2026c6edc4e80b
> patch link:    https://lore.kernel.org/r/20261029-flowtable-sw-accel-ip6i=
p-sit-v1-5-6a17c54f9fb7%40oss.qualcomm.com
> patch subject: [PATCH nf-next 5/8] net: netfilter: add IPv4 over IPv6 tun=
nel flowtable acceleration
> config: m68k-defconfig (https://download.01.org/0day-ci/archive/20261030/=
202610301255.BRNUBmqH-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 16.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20261030/202610301255.BRNUBmqH-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610301255.BRNUBmqH-lkp=
@intel.com/
>=20
> All warnings (new ones prefixed by >>):
>=20
>    net/netfilter/nf_flow_table_ip.c: In function 'nf_flow_queue_xmit4':
> >> net/netfilter/nf_flow_table_ip.c:891:35: warning: variable 'dst' set b=
ut not used [-Wunused-but-set-variable=3D]
>      891 |                 struct dst_entry *dst;
>          |                                   ^~~
>    net/netfilter/nf_flow_table_ip.c: In function 'nf_flow_queue_xmit6':
>    net/netfilter/nf_flow_table_ip.c:1237:35: warning: variable 'dst' set =
but not used [-Wunused-but-set-variable=3D]
>     1237 |                 struct dst_entry *dst;
>          |                                   ^~~

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
>=20
> vim +/dst +891 net/netfilter/nf_flow_table_ip.c
>=20
>    858=09
>    859	static int nf_flow_queue_xmit4(struct nf_flowtable_ctx *ctx,
>    860				       struct sk_buff *skb,
>    861				       struct flow_offload_tuple_rhash *tuplehash,
>    862				       const struct nf_hook_state *state)
>    863	{
>    864		struct flow_offload_tuple *other_tuple;
>    865		enum flow_offload_tuple_dir dir;
>    866		struct nf_flow_xmit xmit =3D {};
>    867		union nf_inet_addr *ip_addr;
>    868		struct flow_offload *flow;
>    869		struct neighbour *neigh;
>    870		struct rtable *rt;
>    871=09
>    872		if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_=
XFRM)) {
>    873			rt =3D dst_rtable(tuplehash->tuple.dst_cache);
>    874			memset(skb->cb, 0, sizeof(struct inet_skb_parm));
>    875			IPCB(skb)->iif =3D skb->dev->ifindex;
>    876			IPCB(skb)->flags =3D IPSKB_FORWARDED;
>    877			return nf_flow_xmit_xfrm(skb, state, &rt->dst);
>    878		}
>    879=09
>    880		dir =3D tuplehash->tuple.dir;
>    881		flow =3D container_of(tuplehash, struct flow_offload, tuplehash[d=
ir]);
>    882		other_tuple =3D &flow->tuplehash[!dir].tuple;
>    883		ip_addr =3D (union nf_inet_addr *)&other_tuple->src_v4;
>    884=09
>    885		if (nf_flow_tunnel_push(state->net, skb, other_tuple,
>    886					tuplehash->tuple.dst_cache, &ip_addr) < 0)
>    887			return NF_DROP;
>    888=09
>    889		switch (tuplehash->tuple.xmit_type) {
>    890		case FLOW_OFFLOAD_XMIT_NEIGH: {
>  > 891			struct dst_entry *dst;
>    892=09
>    893			xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tupl=
e.ifidx);
>    894			if (!xmit.outdev) {
>    895				flow_offload_teardown(flow);
>    896				return NF_DROP;
>    897			}
>    898			if (other_tuple->tun.encap_proto ?
>    899			    other_tuple->tun.encap_proto =3D=3D AF_INET6 :
>    900			    ctx->tun.inner_proto =3D=3D IPPROTO_IPV6) {
>    901				struct rt6_info *rt6;
>    902=09
>    903				rt6 =3D dst_rt6_info(tuplehash->tuple.dst_cache);
>    904				neigh =3D ip_neigh_gw6(rt6->dst.dev,
>    905						     rt6_nexthop(rt6, &ip_addr->in6));
>    906				dst =3D &rt6->dst;
>    907			} else {
>    908				rt =3D dst_rtable(tuplehash->tuple.dst_cache);
>    909				neigh =3D ip_neigh_gw4(rt->dst.dev,
>    910						     rt_nexthop(rt, ip_addr->ip));
>    911				dst =3D &rt->dst;
>    912			}
>    913			if (IS_ERR(neigh)) {
>    914				flow_offload_teardown(flow);
>    915				return NF_DROP;
>    916			}
>    917			xmit.dest =3D neigh->ha;
>    918			skb_dst_drop(skb);
>    919			skb_dst_set_noref(skb, &rt->dst);
>    920			break;
>    921		}
>    922		case FLOW_OFFLOAD_XMIT_DIRECT:
>    923			xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tupl=
e.out.ifidx);
>    924			if (!xmit.outdev) {
>    925				flow_offload_teardown(flow);
>    926				return NF_DROP;
>    927			}
>    928			xmit.dest =3D tuplehash->tuple.out.h_dest;
>    929			xmit.source =3D tuplehash->tuple.out.h_source;
>    930			break;
>    931		default:
>    932			WARN_ON_ONCE(1);
>    933			return NF_DROP;
>    934		}
>    935		xmit.tuple =3D other_tuple;
>    936		xmit.needs_gso_segment =3D tuplehash->tuple.needs_gso_segment;
>    937=09
>    938		return nf_flow_queue_xmit(state->net, skb, &xmit);
>    939	}
>    940=09
>=20
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--Bcierrnx+NloiNUP
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauRTTgAKCRA6cBh0uS2t
rNyiAP96de8d8ol5sTVxCRMFuA1Y2F1Jeg1ujGKpbilvjjArHQEA9gKtTM3eyFXo
NwZOtc15lb5dcMPPGX8LETiowFvdEA4=
=vQ0n
-----END PGP SIGNATURE-----

--Bcierrnx+NloiNUP--
