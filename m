Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820522;
	b=0nHad4QLeCp1GmSlZmHqE1yd6vnFvk14M+EAeE0ooHdKB83usK4PjbDsWcj45HJKwiuN
	 IjOKT+DJHmST6/axISXTeW9yJ3lyHbd1ibJl2ySEzrrLjcC0bOnw6a+VCzke2ZRXr/UJ/
	 46kDPrL6oPryoaVOZtrPAJgNlbC68yrJ8RZCOsuC/WjdMLGk0WnVsCX/UT0esXJNtFmJK
	 KwkgPQ/1kQgEY2E+mxXKt9Q/olFBxfmPQuYTVcaDcxGhF1RA9gsuDE3psCTSpRt27AsNo
	 V5+em8KGf6Z4y9uL2MKlEddoICBkJo1uAvLU0HEMXqcnalvXMevcwUGx/kmqnTvYpBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820522;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=pjIvCohibLyz1h03qi9Qv1DC6mbzn2OPnOr2N1bR7h8=;
	b=lZysA4ntv9NH2CBT3feIaa7w+e3+9USXaUZwG1jBZbNXqPDfZM5vS9mFXXDE0iFknRVZ
	 g/wkEllMfIyIowrSc2NUvLpFNGz/A99we64GWPNTmcqBiizs0HmFLD7Y5byL+yKv81tSh
	 s3xN2mzGPfsiCNrR+NBa9r5QP4JrfWAF9vludVEG8U/1EXlxwid5xwBR+wtEvcPMWwbtF
	 /L8YYn1K569bjjCVgoErAJPV9i+QJqXgb6i7s8iDNlpPcGA6Z/VvufU0ZF4S+Axr2WhYy
	 ursOtSvGMuX8U9xCBJE7LJaoWP5y9r2HO0Ju9MEMffQO4WoFl9TdoN0ddbPhLwzWpCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b="AtkEOnj/";
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6296A6075244;
	Wed,  4 Nov 2026 19:28:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6296A6075244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=AtkEOnj/
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 021A721DB9;
	Wed, 04 Nov 2026 21:28:37 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=pjIvCohibLyz1h03qi9Qv1DC6mbzn2OPnOr2N1bR7h8=; b=AtkEOnj/2BlC
	S2xvHUg3Uy9Pc3lg8eXhIzpLIms9xZWXcYhdqtyMzpVqnzZtLtLuv5aT/7MqCs7Q
	8Eo+BnARlxsYxsQaAKId/R+KMDnx8GaRq2m7YoTReYyOzn17SCdHk2CCUTPXFLO2
	+u2WW69Poy4f7Wjy5fXUi3qumGSU8tmQs8BSgVtGVV5XYQpYm3/gYSBRQKEt314L
	kYcs6QoTMbEClt6o7vDEsl/11dm5PL5j0+MWyd46Y+qNBteqDjsKy8UjoDb7xwbz
	XUe+yaKs8ra4qYaUYLiahWY6+C0x2YNODZa/YvqNDbaZ00a2K3xX8R/vCSvqyowU
	3euhDJWHgiv/awUV/cV//7pa9upWm4gwxmNcQ05MM2kbagOY5TQVgwlMg4N4+Iw+
	HCx90xOgu3jka1EUQ8GASUT+BsQmstOSBsv00dSiCLW216LNHdNpE+JpgF2BAHpj
	ZYLUEXyDtk2VjxgqkgNCUff+kSAf1/KO2nkprMcJ/pNLvGQF3e8tERUAQXez+PZn
	ykkBnUjfphphOIXL+TF4SJWRnLSQKtaVvKuZ3fM7SuvVeX9kBF72psRfpKypozud
	drAu7V1OdtQ5LDME0/wuNVp/epddtDF6RjtRXOVWkoazR2eigp/vqHD0mabWK8Dk
	YAeCaC5/C7f5Kx9yhN0F/h1oIkT4nNY=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Wed, 04 Nov 2026 21:28:36 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 96DC560947;
	Wed,  4 Nov 2026 21:28:36 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6A4JSYYs138502;
	Wed, 4 Nov 2026 21:28:35 +0200
Date: Wed, 4 Nov 2026 21:28:34 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 05/15] ipvs: do not create conns from packets with
 port 0
In-Reply-To: <179380256363.488856.4080152698263995983@kernel.org>
Message-ID: <66f63a84-0ae6-c173-87b8-a22f3f6007ed@ssi.bg>
References: <20261103140308.591690-7-pablo@netfilter.org> <179380256363.488856.4080152698263995983@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-871104827-1793820515=:116704"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-871104827-1793820515=:116704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

	This patch will need new version.

On Wed, 4 Nov 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 3 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The subject of this patch says IPVS should not create
>   connections from packets with port 0.
> - [Medium] udp_conn_schedule()
>   (net/netfilter/ipvs/ip_vs_proto_udp.c:55-57) now returns 1 for any UDP…
> - [Medium] The new port-0 early `return 1` in tcp_conn_schedule()
>   (ip_vs_proto_tcp.c:66-68), udp_conn_schedule()…
> 
> --
> 
> ipvs: do not create conns from packets with port 0
> 
> This commit stops the TCP, UDP and SCTP conn_schedule handlers and
> ip_vs_new_conn_out() from creating normal connections when the client
> port or virtual port is 0. Such connections can never be matched later
> because of the NO_CPORT lookup rule, so a new duplicate connection is
> created for every packet.
> 
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260925141115.16126-1-axel.mierczuk%401password.com
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 8a3c880fdb266..f3eb72e95024d 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> 
> [ ... ]
> 
> > @@ -1328,7 +1329,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
> >  	/* check pre-requisites are satisfied */
> >  	if (svc->fwmark)
> >  		return NULL;
> > -	if (!vport || !dport)
> > +	if (!vport || !dport || !cport)
> >  		return NULL;
> >  
> >  	/* for persistent service first create connection template */
> 
> [Severity: Medium]
> The FTP application helper also creates connections from packet data.
> Does it need the same port 0 check?
> 
> In ip_vs_ftp_in(), a client on an established FTP control connection
> can send "PORT a,b,c,d,0,0". The legacy branch of
> ip_vs_ftp_get_addrport() returns success with port 0:
> 
> net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_get_addrport() {
>     ...
> 		*port = get_unaligned((__be16 *) (p + 4));
> 		return 1;
>     ...
> }
> 
> ip_vs_ftp_in() then uses that value as the cport. It creates a normal
> connection without IP_VS_CONN_F_NO_CPORT:
> 
> net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_in() {
>     ...
> 		ip_vs_conn_fill_param(cp->ipvs, cp->af,
> 				      ipvsh->protocol, &to, port, &cp->vaddr,
> 				      htons(ntohs(cp->vport)-1), &p);
> 		n_cp = ip_vs_conn_in_get(&p);
> 		if (!n_cp) {
> 			n_cp = ip_vs_conn_new(&p, cp->af, &cp->daddr,
> 					      htons(ntohs(cp->dport)-1),
> 					      IP_VS_CONN_F_NFCT, cp->dest,
> 					      skb->mark);
>     ...
> }
> 
> __ip_vs_conn_in_get() only matches when this holds:
> 
> 	(!p->cport ^
> 	 (!(cp->flags & IP_VS_CONN_F_NO_CPORT)))
> 
> So a lookup with cport 0 never finds this entry.
> 
> Wouldn't every such PORT command then add another duplicate connection?
> That is the same problem the commit message describes.
> 
> The extended EPRT/EPSV branch of the same function already rejects
> port 0, so the two formats handle it differently:
> 
> 	if (s == data_limit || !hport || *s != edelim)
> 		return -1;
> 
> [ ... ]

	Port 0 in ip_vs_ftp.c is already handled with a pending patch
"ipvs: reject FTP control ports as data ports".

> 
> > diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > index fec0e8b47b716..2e55b62445c60 100644
> > --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> 
> [ ... ]
> 
> > @@ -62,6 +63,10 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
> >  		return 0;
> >  	}
> >  
> > +	/* Do not create connection for port 0, skip the packet */
> > +	if (!ports[0] || !ports[1])
> > +		return 1;
> > +
> 
> [Severity: Medium]
> Does this change where port 0 packets sent to a configured VIP:port end
> up?
> 
> This check runs before ip_vs_service_find(). Returning 1 while *cpp is
> still NULL makes ip_vs_try_to_schedule() accept the packet:
> 
> net/netfilter/ipvs/ip_vs_core.c:ip_vs_try_to_schedule() {
>     ...
> 	if (unlikely(!*cpp)) {
>     ...
> 		*verdict = NF_ACCEPT;
> 		return 0;
> 	}
>     ...
> }
> 
> Before this patch, a SYN with source port 0 to a VIP:port that has a
> service was always handled by IPVS. It was either scheduled to a real
> server or passed to ip_vs_leave(). When no destination was available,
> ip_vs_leave() did this:
> 
> 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
> 
> 	return NF_DROP;
> 
> Now the packet goes to the director's own TCP stack instead. If the
> director has a local listener on the same port (for example bound to
> the wildcard address), can a remote sender using source port 0 now
> complete a handshake with it through the VIP? IPVS used to shadow that
> listener. The local TCP receive path does not appear to reject
> th->source == 0.
> 
> udp_conn_schedule() gets the same early return, and so does
> sctp_conn_schedule() for INIT chunks.
> 
> Would dropping port 0 packets that match a service, instead of
> accepting them, avoid the duplicate connections without changing where
> this traffic goes?

	Ok, we can change it to drop the packet from port 0

> 
> >  	/* No !th->ack check to allow scheduling on SYN+ACK for Active FTP */
> >  
> >  	if (likely(!ip_vs_iph_inverse(iph)))
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
> > index f32785682402d..92c0b76c1a021 100644
> > --- a/net/netfilter/ipvs/ip_vs_proto_udp.c
> > +++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
> > @@ -52,6 +52,10 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
> >  		return 0;
> >  	}
> >  
> > +	/* Do not create connection for port 0, skip the packet */
> > +	if (!ports[0] || !ports[1])
> > +		return 1;
> > +
> 
> [Severity: Medium]
> Does this check also need to cover one-packet scheduling (OPS) UDP
> services?
> 
> It runs before the service lookup, so it also applies to services with
> IP_VS_SVC_F_ONEPACKET. ip_vs_schedule() sets IP_VS_CONN_F_ONE_PACKET
> on those connections:
> 
> 	flags = (svc->flags & IP_VS_SVC_F_ONEPACKET
> 		 && iph->protocol == IPPROTO_UDP) ?
> 		IP_VS_CONN_F_ONE_PACKET : 0;
> 
> ip_vs_conn_hash() never inserts such connections into the table:
> 
> net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_hash() {
>     ...
> 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
> 		return 0;
>     ...
> }
> 
> So they cannot cause the duplicate hashed connections this patch
> targets.
> 
> Before this patch, an OPS service forwarded UDP datagrams with source
> port 0 to a real server. RFC 768 allows source port 0 when no reply is
> expected, which is the one-way traffic OPS is meant for.
> 
> With this change, ip_vs_try_to_schedule() returns NF_ACCEPT for these
> datagrams. They go to the director's local stack and are no longer load
> balanced. Could ONE_PACKET UDP services be exempted from this check?

	Too complex to do, the ONE_PACKET flag may be set in 
dest->conn_flags, not just in svc->flags, so after matching the service
and selecting a destination, i.e. while creating connection.

> 
> >  	if (likely(!ip_vs_iph_inverse(iph)))
> >  		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
> >  					 &iph->daddr, ports[1]);
> 

pw-bot: cr

> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-871104827-1793820515=:116704--

