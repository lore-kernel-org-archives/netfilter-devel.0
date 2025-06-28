Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19181922DE
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Jun 2025 09:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751104063; cv=none; b=lfufwyBs28UHlKBhoDuMBuob6qIr1D19Zadfl38I4N9j+N3VtvtRpopubKqDMEAM0eH8gAVNy+40gRMikB25BpnOO19uRfEZ4lO84CC/RhYBLUzNyE3nBpGQcNxI5XUlLkMQg/TdzpHf96l+aZb+whSen4P/i8Rg87nxTLgF9PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751104063; c=relaxed/simple;
	bh=FvNANRgAUQCZOaligUivTNMC/C09uHbzbtj8UE09jRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6K9sy7MAVmhyVhM6GqXpLZUPgYX9Uwz28GWQTIZVeA4h9D5GvfNuKJQ/J6mWJSzHlOahfb+bI/mBRaYy1BzeT+RwR8JLLOoOBMCcEktIxu9zsyMJsx8HUdTeNec8GgDfhrmnymP4PeilwYnWDuv9zDBzePVZuH+TjkT5ppj3vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hC6GdpR3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hC6GdpR3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751104059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Newn7o3dJEXSCt9x7hxL+sCIMSg/cs7zXE+Q+oYj0hQ=;
	b=hC6GdpR3dsxcJrBxDr7iIgWNsVbdyoEivq8B6T0DZD1q0a2gf3RxC6dZUmE3ovpdafJHwq
	kcPdGnwDEvc+VDYKqJCJ+/0Ve2GV8nteqiPDRN+UcBLyAC1ziKZX6g9clE0PUpFqhOh4QA
	guWvgvVpAvlkpapCqx6nT0tl/YXUmhk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-KMxKrkpuP-CmCAQ_uFAdGw-1; Sat, 28 Jun 2025 05:47:35 -0400
X-MC-Unique: KMxKrkpuP-CmCAQ_uFAdGw-1
X-Mimecast-MFC-AGG-ID: KMxKrkpuP-CmCAQ_uFAdGw_1751104054
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso1854901f8f.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Jun 2025 02:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751104054; x=1751708854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Newn7o3dJEXSCt9x7hxL+sCIMSg/cs7zXE+Q+oYj0hQ=;
        b=Y6ZqqdSbvGloMJYv36veqmB4BT7Ka5ck9cUYbqb5pwdvaQoM7LtmrqrOidqXl7hSVK
         2K0Hq+OdGChKyREY0bERrpa2gJ1iYjJMolQeZWeW3UWhxI08p49AiTDPavSmBJ9YBXZg
         sJ9gYruccjt2pwtY0HdxGRio34Iofi9SRSflo/ZdxTcOZ/HrFNrQ+VDpW8bzhOEeYfYW
         KmQNtVLSHyFmGOOy1wFfTFP/Ty0sRZFHoXGTiBGAL5kbVZkoF+Re5CMXypeOql4q+cI6
         xONHTMZRDo2HbHdkfkApxkw5kMvpFuCDZZNSrMRZMMkiWRCK2HzK5BHVSmwkVDW6hNjp
         pFeg==
X-Forwarded-Encrypted: i=1; AJvYcCUFS3NsTOnanEHujchH3GSl4Mcly5rJEPXdY4CkB3azNiUBr6OZUoWFyaDDS7pXwhj1o4SOYYnfZuk061TztvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyWdNAsEmkifJACc+Q1RAwHZ8pQX2UMsIq9NPzzvnmNz+k+qzo
	kOFDNMXJhcyCHZM30+HBuZAvUvAcSbKGpXmKU5Gs+16TIZ+z79TNpGNUHurQ+FQcmKjWVnBR2DU
	hdfspQEfLQxUJt2J8fkVRDLR9bwa9xs4HDwqvoJke8h25mS3IWSvc4XppTj1c9+Azs76kZw==
X-Gm-Gg: ASbGncutgtKSGG9K1VMSQayfp5fIxYrY6KCXc0K7w/En65VGJ3NiZAriPISmisK3ZcU
	t8nPsMtf8Fs1ALSLQP2FEktTgOgU7CAXLp/Q2CGPQ8LSEBCEdhAYQORPi8FPbJcPcFJ6nSU8cNw
	6gmPQ8s+ZdkviOeuEpnQhp07YQdHa3IJA4s92jxFGqZpmFEuRjIabEpWs0M4D0hBHSmw4z0gIDc
	Ofp9U/xlF/Zph00r1mPRkTzQqd8NTRADdBuDzy/Q7d54i2pqkMZK2fmDqMvYsaDIqidN0uF1Jmd
	kBCcOokUedgZk4o3Ll40+BKvO7thjeGYQHO1oTbWuxXEOBWgDaCZeREfJ71EP8xtwDNlbQ==
X-Received: by 2002:a05:6000:ce:b0:3a3:7115:5e7a with SMTP id ffacd0b85a97d-3a917bc7ab8mr4198327f8f.42.1751104053747;
        Sat, 28 Jun 2025 02:47:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPCiFHgAK5wt7p4Rs7GA4RpWRlbpxaRtGvpYL7+8IH+T0T+ExhA+LWl94toLj7uMxCJICU3A==
X-Received: by 2002:a05:6000:ce:b0:3a3:7115:5e7a with SMTP id ffacd0b85a97d-3a917bc7ab8mr4198301f8f.42.1751104053264;
        Sat, 28 Jun 2025 02:47:33 -0700 (PDT)
Received: from localhost (net-130-25-105-15.cust.vodafonedsl.it. [130.25.105.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e61f48sm4943473f8f.93.2025.06.28.02.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 02:47:32 -0700 (PDT)
Date: Sat, 28 Jun 2025 11:47:31 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net: netfilter: Add IPIP flowtable SW
 acceleration
Message-ID: <aF-6M-4SjQgRQw1j@lore-desk>
References: <20250627-nf-flowtable-ipip-v2-0-c713003ce75b@kernel.org>
 <20250627-nf-flowtable-ipip-v2-1-c713003ce75b@kernel.org>
 <aF6ygRse7xSy949F@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hvp15xVDHhMV55GV"
Content-Disposition: inline
In-Reply-To: <aF6ygRse7xSy949F@calendula>


--hvp15xVDHhMV55GV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Jun 27, 2025 at 02:45:28PM +0200, Lorenzo Bianconi wrote:
> > Introduce SW acceleration for IPIP tunnels in the netfilter flowtable
> > infrastructure.
> > IPIP SW acceleration can be tested running the following scenario where
> > the traffic is forwarded between two NICs (eth0 and eth1) and an IPIP
> > tunnel is used to access a remote site (using eth1 as the underlay devi=
ce):
> >=20
> > ETH0 -- TUN0 <=3D=3D> ETH1 -- [IP network] -- TUN1 (192.168.100.2)
> >=20
> > $ip addr show
> > 6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state=
 UP group default qlen 1000
> >     link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
> >     inet 192.168.0.2/24 scope global eth0
> >        valid_lft forever preferred_lft forever
> > 7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state=
 UP group default qlen 1000
> >     link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
> >     inet 192.168.1.1/24 scope global eth1
> >        valid_lft forever preferred_lft forever
> > 8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue st=
ate UNKNOWN group default qlen 1000
> >     link/ipip 192.168.1.1 peer 192.168.1.2
> >     inet 192.168.100.1/24 scope global tun0
> >        valid_lft forever preferred_lft forever
> >=20
> > $ip route show
> > default via 192.168.100.2 dev tun0
> > 192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
> > 192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.1
> > 192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1
> >=20
> > $nft list ruleset
> > table inet filter {
> >         flowtable ft {
> >                 hook ingress priority filter
> >                 devices =3D { eth0, eth1 }
> >         }
> >=20
> >         chain forward {
> >                 type filter hook forward priority filter; policy accept;
> >                 meta l4proto { tcp, udp } flow add @ft
> >         }
> > }
>=20
> Is there a proof that this accelerates forwarding?

I reproduced the scenario described above using veths (something similar to
what is done in nft_flowtable.sh) and I got the following results:

- flowtable configured as above between the two router interfaces
- TCP stream between client and server going via the IPIP tunnel
- TCP stream transmitted into the IPIP tunnel:
  - net-next:				~41Gbps
  - net-next + IPIP flowtbale support:	~40Gbps
- TCP stream received from the IPIP tunnel:
  - net-next:				~35Gbps
  - net-next + IPIP flowtbale support:	~49Gbps

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/ipv4/ipip.c                  | 21 +++++++++++++++++++++
> >  net/netfilter/nf_flow_table_ip.c | 28 ++++++++++++++++++++++++++--
> >  2 files changed, 47 insertions(+), 2 deletions(-)
> >=20

[...]

> >  static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 pro=
to,
> >  				       u32 *offset)
> >  {
> >  	struct vlan_ethhdr *veth;
> >  	__be16 inner_proto;
> > +	u16 size;
> > =20
> >  	switch (skb->protocol) {
> > +	case htons(ETH_P_IP):
> > +		if (nf_flow_ip4_encap_proto(skb, &size))
> > +			*offset +=3D size;
>=20
> This is blindly skipping the outer IP header.

Do you mean we are supposed to validate the outer IP header performing the
sanity checks done in nf_flow_tuple_ip()?

Regards,
Lorenzo

>=20
> > +		return true;
> >  	case htons(ETH_P_8021Q):
> >  		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
> >  			return false;
> > @@ -310,6 +328,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
> >  			      struct flow_offload_tuple_rhash *tuplehash)
> >  {
> >  	struct vlan_hdr *vlan_hdr;
> > +	u16 size;
> >  	int i;
> > =20
> >  	for (i =3D 0; i < tuplehash->tuple.encap_num; i++) {
> > @@ -331,6 +350,12 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
> >  			break;
> >  		}
> >  	}
> > +
> > +	if (skb->protocol =3D=3D htons(ETH_P_IP) &&
> > +	    nf_flow_ip4_encap_proto(skb, &size)) {
> > +		skb_pull(skb, size);
> > +		skb_reset_network_header(skb);
> > +	}
>=20
> I have a similar patch from 2023, I think I keep somewhere in my trees.
>=20
> >  }
> > =20
> >  static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff=
 *skb,
> > @@ -357,8 +382,7 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
> >  {
> >  	struct flow_offload_tuple tuple =3D {};
> > =20
> > -	if (skb->protocol !=3D htons(ETH_P_IP) &&
> > -	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
> > +	if (!nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
> >  		return NULL;
> > =20
> >  	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
> >=20
> > --=20
> > 2.50.0
> >=20
>=20

--hvp15xVDHhMV55GV
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaF+6MwAKCRA6cBh0uS2t
rMAKAQDdLVBCjzjGwTELy9gE6FJi7/rBBB3yteHjlxdsqx575AEA7P4CVJ+rtMwc
A14JuSb+7zq7U1Bzl0zOAbgz7oglngU=
=Tb0o
-----END PGP SIGNATURE-----

--hvp15xVDHhMV55GV--

