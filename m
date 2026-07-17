Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12643EB108;
	Fri, 17 Jul 2026 10:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784283243; cv=none; b=cwIe3vT+dKGBOErkIhzb55q3+gR9qJZ8SEuhLVFzYNZ9hy3UCcjmNMtYfwFyzTuhWXdTZzLkq7MAXGOZTAEFX1qAOxl8WRqr04NQy5AD8e7xPaR++LaSjOPwzI7qb7NeoWRfhHGJIDRVWiLfqyccluczaYkVY30Bfxhu1oJftPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784283243; c=relaxed/simple;
	bh=bAwzAuWOVBC+fwIMD4vd0Lu+amDZaNQ45B9q8WzraB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVt2XDKO6bBF9fpIcxtSR42Rp/8OT3k9sOQT3BfsTUFgqcrC1yc5foHbV1gaY/6rV3UP0Stk2Wc/H/3Z6valeE1i1Xapi1KoU6TbVs62ZASgz3ouvDk0EuElQn4joTOPJfB+7m+HJWYCwWMBkK81cUCoHEE0WKDY6W60sGhgkEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ayl4lxmf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ayl4lxmf"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A88726019C;
	Fri, 17 Jul 2026 12:13:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784283233;
	bh=b2o3c+4c75OHDsV9BWa2Q1SQLHQwwutW9hdOuH/E42E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ayl4lxmfBGms+9teirpfHa7PnMGumlRglIIu45ViHfNUtmT0W1p/I8ywTzpAiZwrM
	 y48EaPx3QObw0HyOgES9q9qkNTduDYuvmck00D7nZ+Z+RjwaJMzVCT13mH9jHOzTCC
	 2g+QCmw03MnJNMAw4ULmsHVP2w7InvekRxsmptmEZKTU8btAzeEhDyRBOjvSb/GxGs
	 n1z8FviVnK6yRR5NOg3H7cumQuGEXHU4iKnZCddxpC6Scx42I+c62JZRqFp4ll4gDg
	 cAXHUqNf2Yzoj7BLftIJHIwGE/Ixv6kCHBiqmvDAX7slGUoYt/xf9nmG+EeZMgXjz5
	 ZKI9touugoJKA==
Date: Fri, 17 Jul 2026 12:13:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	ja@ssi.bg
Subject: Re: [PATCH net 8/9] ipvs: fix more places with wrong ipv6 transport
 offsets
Message-ID: <aloAXx0xWOv77hpb@lemonverbena>
References: <20260710143733.29741-1-fw@strlen.de>
 <20260710143733.29741-9-fw@strlen.de>
 <e7ed31d3-a3aa-427a-8e82-aa65b4388368@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e7ed31d3-a3aa-427a-8e82-aa65b4388368@redhat.com>

Hi,

On Fri, Jul 17, 2026 at 11:17:15AM +0200, Paolo Abeni wrote:
> Hi,
> 
> On 7/10/26 4:37 PM, Florian Westphal wrote:
> > From: Julian Anastasov <ja@ssi.bg>
> > 
> > Sashiko reports for more incorrect IPv6 transport offsets.
> > 
> > The app code for TCP was assuming IPv4 network header
> > even after the ipvsh argument was provided. This can
> > cause problems with apps over IPv6. As for the only
> > official app in the kernel tree (FTP) this problem is
> > harmless because we use Netfilter to mangle the FTP
> > ports and we do not adjust the TCP seq numbers.
> > 
> > Also, provide correct offset of the ICMPV6 header in
> > ip_vs_out_icmp_v6() for correct checksum checks when
> > the IPv6 packet has extension headers.
> > 
> > Fixes: d12e12299a69 ("ipvs: add ipv6 support to ftp")
> > Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
> > Cc: stable@vger.kernel.org
> > Link: https://sashiko.dev/#/patchset/20260706101624.69471-1-zhaoyz24%40mails.tsinghua.edu.cn
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/ipvs/ip_vs_app.c  | 10 ++++------
> >  net/netfilter/ipvs/ip_vs_core.c |  3 +--
> >  2 files changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
> > index d54d7da58334..b0e00be85cb1 100644
> > --- a/net/netfilter/ipvs/ip_vs_app.c
> > +++ b/net/netfilter/ipvs/ip_vs_app.c
> > @@ -361,14 +361,13 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
> >  				  struct ip_vs_iphdr *ipvsh)
> >  {
> >  	int diff;
> > -	const unsigned int tcp_offset = ip_hdrlen(skb);
> >  	struct tcphdr *th;
> >  	__u32 seq;
> >  
> > -	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
> > +	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
> >  		return 0;
> >  
> > -	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
> > +	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
> 
> Beyond the usual set of pre-existing issues, sashiko-gemini noted this
> patch may need a follow-up:
> 
> https://sashiko.dev/#/patchset/20260710143733.29741-2-fw%40strlen.de

Cc'ing Julian, it seems he is not on Cc, in case he can help us with this.
