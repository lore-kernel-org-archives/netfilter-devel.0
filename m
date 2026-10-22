Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792697496;
	b=VEnX1u6UbXMvhE41knkm6B33K7jGYCFHYeI3ahlB6EnekXLFdJIRFAdsced1BHtTOoQJ
	 gVqexi+AOXnsFEhrr6ThkzBI69QLzGazEfACloM6+U1Ik1SJjOuJQXiF4ofQkNB1tJ16Q
	 8jeAX+TlS606/ADW25RANIaU/x1G41KlOCjPpE599t7lMcWAEXD9CzQ6n0jUiGkjn2L/N
	 1wrlmlQjE3GcNghtBf9B4Q9fIiNvg2nay/VCPUACV9AKxQYeuetGw9y7d6hb8STdigCA0
	 VX/Na494HAAmbFiOBn8tlEMftbZe3olagvgVaC1EM+Xw7/6VHtpDrFOqRwKq57OwF3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697496;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=qYBPZ3SZLlfY19VtG4EmjCceeTZrdIaqFf8AausLtMU=;
	b=NRcEwaa9WTeWfv/ox3I5hLhHn5fT7pCoPMtJe6LeixRxUGKgx8RWMP4+gxT9brVLpY1F
	 Xo+olGLhssTM2uUJhJmTH/rYhIdli1SG0sXC3lxNAtPTdUrfWujYMU+61cr3bmgmGHLZQ
	 oNolyqd6ZLUy2h+htrn6njnRD2JxYhBJW4XD+ZSu8AhpBNcfMbP0/JqJLjUt4AT/qFK63
	 B5iw9EvU+PV8r/JZuqHvBI//ME8Av8uhY4+VAZuRKqvxVS7XbVg3HhXxW4m/wQ27ePvHc
	 WirVD52evwd0MYmNfB206IQ4kzFhu6Tx+32jGxK9m4v6bkRr+nA2T3ZoSVXiODZS9Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.51
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E9606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 19:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA2E9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4j9bqg3dfPz7s7wW;
	Thu, 22 Oct 2026 21:31:27 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id lFBH9iMy4JEu; Thu, 22 Oct 2026 21:31:25 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C26FC.nat.pool.telekom.hu [37.76.38.252])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4j9bqc51Vrz7s7wV;
	Thu, 22 Oct 2026 21:31:23 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 6650C140529; Thu, 22 Oct 2026 21:31:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 63B62140207;
	Thu, 22 Oct 2026 21:31:23 +0200 (CEST)
Date: Thu, 22 Oct 2026 21:31:23 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Zhiling Zou <zhilinz@nebusec.ai>
cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
    Florian Westphal <fw@strlen.de>, phil@nwl.cc, 
    oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] ipset: ignore port ranges for portless
 protocols
In-Reply-To: <ab8bb46b65a7666885cd5fe0fccdb0e39e279674.1792609477.git.zhilinz@nebusec.ai>
Message-ID: <b2f622c5-8461-0e8e-f3d5-eaecea818a0f@netfilter.org>
References: <cover.1792609477.git.zhilinz@nebusec.ai> <ab8bb46b65a7666885cd5fe0fccdb0e39e279674.1792609477.git.zhilinz@nebusec.ai>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hello,

On Thu, 22 Oct 2026, Zhiling Zou wrote:

> hash_netportnet4_uadt() canonicalizes the port to zero for protocols
> without ports and clears with_ports. The range path nevertheless reads
> IPSET_ATTR_PORT_TO and iterates the supplied port range. A request with
> an address range and a portless protocol can therefore add keys that
> packet-side matching never generates, consuming maxelem or evicting
> valid entries when forceadd is enabled.
> 
> Only expand the port dimension when the protocol supports ports. Address
> ranges continue to be processed with the canonical zero port.

Please resend your patch so that it fixes ip_set_hash_ipportnet.c and
ip_set_hash_netport.c too, which have got the same issue as far as I see.

Best regards,
Jozsef

> Fixes: 7c3ad056ef79 ("netfilter: ipset: Add hash:net,port,net module to kernel.")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Link: https://bugtracker.nebusec.ai/f/12359
> Assisted-by: LLM
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> ---
>  net/netfilter/ipset/ip_set_hash_netportnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
> index 61af1ce271279..dd6cf8c36ba07 100644
> --- a/net/netfilter/ipset/ip_set_hash_netportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
> @@ -278,7 +278,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	}
>  
>  	port_to = port = ntohs(e.port);
> -	if (tb[IPSET_ATTR_PORT_TO]) {
> +	if (with_ports) {
>  		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
>  		if (port > port_to)
>  			swap(port, port_to);
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
