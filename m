From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 8/8] nf_conntrack ipv6: unused code and sparse fix
Date: Fri, 25 Jan 2008 10:24:10 +0900 (JST)
Message-ID: <200801250124.m0P1OBt6004910@toshiba.co.jp>
References: <20080124181536.446214111@vyatta.com>
	<20080124181628.545931850@vyatta.com>
	<4798DCD6.6000906@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: shemminger@vyatta.com, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:55166 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYAYBcS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:32:18 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id m0P1WGX2004615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jan 2008 10:32:16 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id m0P1ODoE029866
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jan 2008 10:24:14 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id m0P1ODCS008217
	for netfilter-devel@vger.kernel.org; Fri, 25 Jan 2008 10:24:13 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id m0P1OD0L001599
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jan 2008 10:24:13 +0900 (JST)
In-Reply-To: <4798DCD6.6000906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 24 Jan 2008 19:45:42 +0100

> Stephen Hemminger wrote:
> 
>  > +#ifdef notused
>  >  int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
>  > {
>  > 	struct sk_buff *s, *s2;
>  > @@ -694,6 +696,7 @@ int nf_ct_frag6_kfree_frags(struct sk_bu
>  >
>  >  	return 0;
>  >  }
>  > +#endif
> 
> I'm wondering whether this is correct. I'm on the way out the
> door though, I'll look into it later. Thanks Stephen.

I'll check it, too. At least linux 2.6.15 (which is the first release
for nf_contrack) does not use the function. I try to recall the reason.

-- kozakai
