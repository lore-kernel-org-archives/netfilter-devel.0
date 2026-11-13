Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570767;
	b=X3u2Xtp3oy92pEsWDbPkZmFeDvduK+2gccziGjKs0RliV9Qfb2SuknLhDt9LLCLESMzU
	 DwiIplkqsIf2gcrB8MLos8bKm3CQgUZTx2FRJtI+2+iQXFhXNuKMV88IVHy7MLLLBrLDy
	 fXTwHnXHBnwPS9u6aN6kbb4+/EbInaPoMH+E692L6O6bpleyw8mm6JvMis9UXDX/S3aHN
	 K9Hen+k6CHN88grXZNCv7txoKz9X+BqYsY+Wi0phPpUU4JEnOWGmVuKpXLYnIcyJ0HO/1
	 zkM5QoxRo02c9NCO1Yn6i5mo9njWYSbuTuNo9LzKxDY9p/p+vNDMI51wYnQJUSjXJig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570767;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=Fu3rA+F9N/QwUUE+wRWbX9/6h2PQamrid4NxuM52H2M=;
	b=m82XzRD5i9RoeB10jvfYLDTgvq57cgeNO1yXYv+s7jYBodGWqpMI9KAx7zAXS2t8YsSp
	 TCl19H7Ysm4A87FWMPBX7xV44dgYNeuMO/DhtIz54seHAuMN2RUu2OwBJzeobX9edUXJy
	 yIv/oJ9bhIXL9wNKTT5mdbkWS+530hdqf2xQwfu8fxAJHTKYQgTx+N3mP23NxPU3OCfoi
	 +jgYVdGWYcmI/RBQEYUzYwd+2LSHHOBjKFBfmllLgudip4hvTC6/UlNCdkDGWPcPS0hl+
	 PeUi2fIWAU8qp4Y4Jxq20oWZHS98cKHy3pz6xy87ZJ0ljEcXfiSvpaTu1+2TNttisqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=kJ3QdyIn;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B9606A321
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 11:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 091B9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=kJ3QdyIn
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id C500921423;
	Fri, 13 Nov 2026 13:52:37 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=Fu3rA+F9N/QwUUE+wRWbX9/6h2PQamrid4NxuM52H2M=; b=kJ3QdyInajEW
	zKA++aGKyabjO+wN6KTkxO9eh1/2G829JLVdFLHKg3jyoafrX7Xxt8O8FkxODiIb
	v2Wjr8/lUFCFpFlryUUJXIVej9UlmkHrQTCRutcBHpEU0fCMZ3Kf/k0Uh4XH9CsU
	RlprBhsv/LcnlqV/FyLihCAaOWsvTLJbxuPNMhzDM6i7CfhzM8o+9ZU1WdL10s/x
	+1QwUxbpMigdt+pqqwDaVx9iakexZ/7DM2y5v0W1FwEkvSn3/Dvbzlu/fhI0lgQw
	56uoTzKuJTKY4BR3Irdf2cmhWQf77SoEeERRBDvjfNE/oH8SVXiaGRG68/tnUDJv
	wgJuSC0O/ujA9yyHFHMi15ly5/2tWOa+c76p30YAubxtq3USX3/wDbEBIkS77DWm
	RRVVpxM+inuxsiJWNHpx9xQEB2dKOwI4QsteGktXJIs7qujGpyWPCBI8dRxeyRRB
	zp9Io/bI3q7H0z+hMln2WEWfOvOhbE1i7eGsqEZcyMUFAiJ/C1WHjlNxaZN3C2lH
	NkuVQKe9okETDO2wBo40Lc7tSZEIoTuhLG9fPfgUWnxjTj28LaR1Stngnnd6rR3k
	Z/n7E2QQX9kpbLx2ffBGAv3nS3qNdH6p4lNkqadZqHlX/OdDERq+jVbfDJbgXLfF
	4bmxTMFgvwAspRd+Aa5MlAqODi4TKWQ=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 13 Nov 2026 13:52:37 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 1673760B5E;
	Fri, 13 Nov 2026 13:52:37 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6ADBqROo037893;
	Fri, 13 Nov 2026 13:52:28 +0200
Date: Fri, 13 Nov 2026 13:52:27 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: kernel test robot <lkp@intel.com>
cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-nf:for-netdev-nf-26-11-13 27/27]
 net/netfilter/ipvs/ip_vs_conn.c:1060:21: error: use of undeclared identifier
 'ip_vs_null_xmit_v6'; did you mean 'ip_vs_null_xmit'?
In-Reply-To: <202611131204.pFzcf1WG-lkp@intel.com>
Message-ID: <e71d62ac-441c-ee4c-ed98-7216477d73ef@ssi.bg>
References: <202611131204.pFzcf1WG-lkp@intel.com>
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

On Fri, 13 Nov 2026, kernel test robot wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git for-netdev-nf-26-11-13
> head:   937b060406a547e4d931525e600540726ea26532
> commit: 937b060406a547e4d931525e600540726ea26532 [27/27] ipvs: pass correct sk to update_pmtu and on tunneling
> config: i386-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131204.pFzcf1WG-lkp@intel.com/config)
> compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
> smatch: v0.5.0-9187-g5189e3fb
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611131204.pFzcf1WG-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611131204.pFzcf1WG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> net/netfilter/ipvs/ip_vs_conn.c:1060:21: error: use of undeclared identifier 'ip_vs_null_xmit_v6'; did you mean 'ip_vs_null_xmit'?
>     1060 |                 cp->packet_xmit = ip_vs_null_xmit_v6;
>          |                                   ^~~~~~~~~~~~~~~~~~
>          |                                   ip_vs_null_xmit
>    include/net/ip_vs.h:1992:5: note: 'ip_vs_null_xmit' declared here
>     1992 | int ip_vs_null_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>          |     ^
>    1 error generated.
> 
> 
> vim +1060 net/netfilter/ipvs/ip_vs_conn.c
> 
>   1034	
>   1035	/*
>   1036	 *	Bind a connection entry with the corresponding packet_xmit.
>   1037	 *	Called by ip_vs_conn_new.
>   1038	 */
>   1039	static inline void ip_vs_bind_xmit(struct ip_vs_conn *cp)
>   1040	{
>   1041		switch (IP_VS_FWD_METHOD(cp)) {
>   1042		case IP_VS_CONN_F_MASQ:
>   1043			cp->packet_xmit = ip_vs_nat_xmit;
>   1044			break;
>   1045	
>   1046		case IP_VS_CONN_F_TUNNEL:
>   1047	#ifdef CONFIG_IP_VS_IPV6
>   1048			if (cp->daf == AF_INET6)
>   1049				cp->packet_xmit = ip_vs_tunnel_xmit_v6;
>   1050			else
>   1051	#endif
>   1052				cp->packet_xmit = ip_vs_tunnel_xmit;
>   1053			break;
>   1054	
>   1055		case IP_VS_CONN_F_DROUTE:
>   1056			cp->packet_xmit = ip_vs_dr_xmit;
>   1057			break;
>   1058	
>   1059		case IP_VS_CONN_F_LOCALNODE:
> > 1060			cp->packet_xmit = ip_vs_null_xmit_v6;

	We were not lucky this time. The original patch was trying to
patch ip_vs_bind_xmit_v6() but due to the similar code in 
ip_vs_bind_xmit() the change after applying occured in the IPv4 function
which comes first.

	Pablo, can some manual applying solve this or we should modify
somehow this hunk to not match early in the file ? In this form it
will do the same problem on the next tree.

>   1061			break;
>   1062	
>   1063		case IP_VS_CONN_F_BYPASS:
>   1064			cp->packet_xmit = ip_vs_bypass_xmit;
>   1065			break;
>   1066		}
>   1067	}
>   1068	
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Regards

--
Julian Anastasov <ja@ssi.bg>

