Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794572263;
	b=CLZTohgWzm4s3svJUf64AD+9NJkHQTT4wrRETV5xqZIpgqrYThmD2gQkyHFiAiPpzSdw
	 IgZ3ElrK4Qf6JydUzALAF/OY/i5UNhWolOa0MkCqvop4NhOrzCq2/fgIrYodRT3G7XjG4
	 r4y6SXZicmynC762vGoFxYl7OcTY6n/2TR+HViwxmQRd+yrmuz8U/wiyvZF9wTulHlhwa
	 ljMA/X83/rLMVd9DeEoaVFmKPqQ5+QywFCInZIFkij4s1NPlXpyPpB7UkQcpC8azGMPE6
	 ehelJ4QOKF4IZRDLhkrlltqs3gBm3ydTKLLGGjFHV8LgDCFh/ZebXycYdpCWlJ13DaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794572263;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=0Hu6yEXQGVC3jhnTuc4uunK5c0sS5WUygC4A4ApNo5s=;
	b=e3HP8ioj4YKhVGzZD7W1NO28dcGaNUifsG8KgDF/9NWiGOIaCiXds/doGNEPPMPeS99c
	 wzDPvGyo9zOQ3+2ivgD4f5Zn63yKATvVGpeB2yy5YK91x1OU65HbGm3PFAo2dWq3LiWni
	 3QJmSCU50uaHwxytVMoyBsaZL1TqhN90Y36JXNJHmP140R3OGVN7z6aMsKNpgloMuJumC
	 CRYl0QUNIMt6kRqehU08rjawPpOLvhp41rHKoPUtX6Ixr512kNFhmJ67tEMYx9K/2in5g
	 koIc72oYYDHHk57V78mJ8oTxmJyviqut/xDF6Q/fILub4ubC6LeuyMU9DfN57HaAotA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=a0YIpmUJ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 84F3D606A323
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 12:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84F3D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=a0YIpmUJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794572260;
	bh=0Hu6yEXQGVC3jhnTuc4uunK5c0sS5WUygC4A4ApNo5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0YIpmUJG7AE2c/cynZnNTQxgf4gCnVq5kGP/Cgaz8ul7lurpudUPhXNULQVvZUEA
	 72j7/YGZ5dqRGDEnU4p7pLD9kE1oRgdqakp0pgUP9RTy+VGjt/hBINJ0rZZnIKbW4e
	 X/Gicp+n8iI9BWRTYFv+h1e9uO0egDyD9MRGokOwuwFUNA77b6UCfxrtQEHzhtYSKI
	 xQ2H6zTHA/dvnJ2faSYzogZCQs6CsT+YwbKTwn0T8/6CR1Jp7P3zbkLqldMWzfZF0F
	 fJ70YcepuWi6knxwgt4v2LGepcZkuyDWoy0IRee3UuFV610lCfb2nnANmceklZz/Md
	 h9yFU7ggB9dvw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5FF2A60056;
	Fri, 13 Nov 2026 13:17:40 +0100 (CET)
Date: Fri, 13 Nov 2026 13:17:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [netfilter-nf:for-netdev-nf-26-11-13 27/27]
 net/netfilter/ipvs/ip_vs_conn.c:1060:21: error: use of undeclared identifier
 'ip_vs_null_xmit_v6'; did you mean 'ip_vs_null_xmit'?
Message-ID: <avb_4SiTw2uefR9_@chamomile>
References: <202611131204.pFzcf1WG-lkp@intel.com>
 <e71d62ac-441c-ee4c-ed98-7216477d73ef@ssi.bg>
 <a4565204-36ef-1723-d016-a52c8144516e@ssi.bg>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a4565204-36ef-1723-d016-a52c8144516e@ssi.bg>

On Fri, Nov 13, 2026 at 02:15:33PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Fri, 13 Nov 2026, Julian Anastasov wrote:
> 
> > On Fri, 13 Nov 2026, kernel test robot wrote:
> > 
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git for-netdev-nf-26-11-13
> > > head:   937b060406a547e4d931525e600540726ea26532
> > > commit: 937b060406a547e4d931525e600540726ea26532 [27/27] ipvs: pass correct sk to update_pmtu and on tunneling
> > > config: i386-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131204.pFzcf1WG-lkp@intel.com/config)
> > > compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
> > > smatch: v0.5.0-9187-g5189e3fb
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611131204.pFzcf1WG-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202611131204.pFzcf1WG-lkp@intel.com/
> > > 
> > > All errors (new ones prefixed by >>):
> > > 
> > > >> net/netfilter/ipvs/ip_vs_conn.c:1060:21: error: use of undeclared identifier 'ip_vs_null_xmit_v6'; did you mean 'ip_vs_null_xmit'?
> > >     1060 |                 cp->packet_xmit = ip_vs_null_xmit_v6;
> > >          |                                   ^~~~~~~~~~~~~~~~~~
> > >          |                                   ip_vs_null_xmit
> > >    include/net/ip_vs.h:1992:5: note: 'ip_vs_null_xmit' declared here
> > >     1992 | int ip_vs_null_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
> > >          |     ^
> > >    1 error generated.
> > > 
> > > 
> > > vim +1060 net/netfilter/ipvs/ip_vs_conn.c
> > > 
> > >   1034	
> > >   1035	/*
> > >   1036	 *	Bind a connection entry with the corresponding packet_xmit.
> > >   1037	 *	Called by ip_vs_conn_new.
> > >   1038	 */
> > >   1039	static inline void ip_vs_bind_xmit(struct ip_vs_conn *cp)
> > >   1040	{
> > >   1041		switch (IP_VS_FWD_METHOD(cp)) {
> > >   1042		case IP_VS_CONN_F_MASQ:
> > >   1043			cp->packet_xmit = ip_vs_nat_xmit;
> > >   1044			break;
> > >   1045	
> > >   1046		case IP_VS_CONN_F_TUNNEL:
> > >   1047	#ifdef CONFIG_IP_VS_IPV6
> > >   1048			if (cp->daf == AF_INET6)
> > >   1049				cp->packet_xmit = ip_vs_tunnel_xmit_v6;
> > >   1050			else
> > >   1051	#endif
> > >   1052				cp->packet_xmit = ip_vs_tunnel_xmit;
> > >   1053			break;
> > >   1054	
> > >   1055		case IP_VS_CONN_F_DROUTE:
> > >   1056			cp->packet_xmit = ip_vs_dr_xmit;
> > >   1057			break;
> > >   1058	
> > >   1059		case IP_VS_CONN_F_LOCALNODE:
> > > > 1060			cp->packet_xmit = ip_vs_null_xmit_v6;
> > 
> > 	We were not lucky this time. The original patch was trying to
> > patch ip_vs_bind_xmit_v6() but due to the similar code in 
> > ip_vs_bind_xmit() the change after applying occured in the IPv4 function
> > which comes first.
> > 
> > 	Pablo, can some manual applying solve this or we should modify
> > somehow this hunk to not match early in the file ? In this form it
> > will do the same problem on the next tree.
> 
> 	I hopefully solved this problem by reordering some code
> for better speed, just posted v4.

Thanks a lot Julian for the quick reply.
