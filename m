Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794199098;
	b=cHZSiXJh8XotsrO7HqXqcPxtRPSaq5rX4JCoWYaMSF+J+ZYxf46dXHqXZpJADgqeEDzY
	 yysXp2Lj1EJB9uxa6OYlbYlBvp2H1bsQ1TXHD5/gUDPIRU+MYsu920YEHK1WKGo/t5q+Z
	 OxmL4rk22MeJFIRu+W6Uxso6T793WZiVRePS53ByeMHXHK9ldQB4r1olOIETbhR/m8IRy
	 /UA0ZCYd4oYyWkEk4mk6vU2OfTLHhRK1+zwLV9jFKRWOlodTbpEyLoqArBuaK4yLByg+e
	 hRI9QX8YAAUCf/SsfqIOFIVcdjNeoSw7NPyPs40W41fy1117SKZOjOj57q/AOszZmnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794199098;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=sSZhiuNjfR55VttT0Z24CvlmqlwmmmiPrOuLF4LeZ1Q=;
	b=E2xw7qLrJ1+IUZoWRD3Mv1nbfbWknme63wQSiN2bhFaMGEhvfs+B0YTqyUMi5LMbdYGR
	 Ga1PZ/CaLhL9x63KnvU1gsuOiShrOzu+FLuCOjdx/PK2SRMld6DSa4GCwRB5MEPi8fCL0
	 m1kNiDWNxBLNsIJw5JQXD9v+J4TUUKqZHQkn8rlAkD+BfdcMldVbxJXT6ZqDwVcc5la2F
	 iXDktxrJo5BJNEJzIs13Is9QzCRGdMHXv62z7oWOKJ4fIya438GTQMVoJpjw4rsDvONKd
	 FAX3Fnv+6SdXreRGNrdeJHklcDAkn4RsU3j7cCdv9RS/9Bqm+pMDFWAUm+HKiO40HxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DA8HzxdQ;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1C5606A31C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 04:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB1C5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DA8HzxdQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=DA8HzxdQbh7g2LP5LtjtngJH/sobgFhMe85os/hrkNL5FpoxvZ3DbtNH1M2jqpTDJUGLz5g/KvVYU
	 PaJx6nWKgeewDnsZEVM45LaMCffnVd197Trwcq7VNwxO1iBZv0C6qOncXm8ndW/H0J0VKExjdWDDkL
	 GuZppSQsU6STOJyY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16af14e34469-9c7e7;
	Mon, 09 Nov 2026 12:38:14 +0800 (CST)
X-RM-TRANSID:2ee16af14e34469-9c7e7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46af14e34c99-81682;
	Mon, 09 Nov 2026 12:38:14 +0800 (CST)
X-RM-TRANSID:2ee46af14e34c99-81682
From: xujiahao <xujiahao@cmss.chinamobile.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	xujiahao <xujiahao@cmss.chinamobile.com>
Subject: Re: [PATCH nf] netfilter: xt_nat: allow IP_CT_RELATED_REPLY in DNAT targets
Date: Mon, 09 Nov 2026 12:35:26 +0800
Message-ID: <20261109025392.reply@cmss.chinamobile.com>
In-Reply-To: <au2ClIl_C1RnEv_L@strlen.de>
References: <20261106065651.3504452-1-xujiahao@cmss.chinamobile.com>
	<au2ClIl_C1RnEv_L@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Florian,

You are right and my patch was wrong.  I am dropping the xt_nat change; the
check in xt_dnat_target_v2() should stay as it is.

I did reproduce the syzbot report in a netns: a reject rule makes
nf_send_reset() build the RST, which then goes ip_local_out() ->
nf_nat_ipv4_local_fn(), and the RST arrives with ctinfo IP_CT_RELATED_REPLY
(4).  nf_nat_inet_fn() therefore treats it as not initialized yet and runs the
nat chains for it, which is how xt_dnat_target_v2() is reached.  In my test
the conntrack was already confirmed, so nf_nat_setup_info() declined to
install a second mapping and the packet itself was not rewritten -- but the
nat chains should not be consulted for that packet at all.

Before I send a fix for nf_conntrack_attach(): it cannot tell an ICMP error
from a TCP RST on its own.  The icmp.c/icmpv6.c callers run inside a getfrag
callback, before the IP header is built, and the conntrack's L4 protocol is
the protocol of the original packet, which can well be TCP for an ICMP error.
So the packet type has to come from the call site.  Which shape do you prefer?

  a) nf_ct_attach(new, skb, bool tcp_rst) -- changes the exported symbol, or
  b) keep nf_ct_attach() as is and add a separate helper for the reject path?

Either way ICMP keeps IP_CT_RELATED/_REPLY, and only the RST built by
nf_reject_ipv4.c / nf_reject_ipv6.c would get IP_CT_ESTABLISHED/_REPLY.

Thanks,
xujiahao


