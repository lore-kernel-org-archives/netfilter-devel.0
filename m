From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 8/8] nf_conntrack ipv6: unused code and sparse fix
Date: Mon, 28 Jan 2008 11:50:31 +0900 (JST)
Message-ID: <200801280250.m0S2oWat014244@toshiba.co.jp>
References: <20080124181628.545931850@vyatta.com>
	<4798DCD6.6000906@trash.net>
	<200801250124.m0P1OBt6004910@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, shemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:36441 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166AbYA1C6i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:58:38 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id m0S2wafT015127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jan 2008 11:58:36 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id m0S2oXg8001332
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jan 2008 11:50:33 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id m0S2oXhT022483
	for netfilter-devel@vger.kernel.org; Mon, 28 Jan 2008 11:50:33 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id m0S2oXwh015055
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jan 2008 11:50:33 +0900 (JST)
In-Reply-To: <200801250124.m0P1OBt6004910@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Fri, 25 Jan 2008 10:24:10 +0900 (JST)

> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 24 Jan 2008 19:45:42 +0100
> 
> > Stephen Hemminger wrote:
> > 
> >  > +#ifdef notused
> >  >  int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
> >  > {
> >  > 	struct sk_buff *s, *s2;
> >  > @@ -694,6 +696,7 @@ int nf_ct_frag6_kfree_frags(struct sk_bu
> >  >
> >  >  	return 0;
> >  >  }
> >  > +#endif
> > 
> > I'm wondering whether this is correct. I'm on the way out the
> > door though, I'll look into it later. Thanks Stephen.
> 
> I'll check it, too. At least linux 2.6.15 (which is the first release
> for nf_contrack) does not use the function. I try to recall the reason.

I agree to remove the function.

I seemed to forget to remove it when implementing nf_conntrack based on
ip6_conntrack. The later used it to free the reassembled skb packet the
original fragments on fail of tracking. But the function became unnecessary
as result of changing data structure so that packets could be reassembled
at new hook - NF_IP6_PRI_CONNTRACK_DEFRAG.

Regards,

-- Yasuyuki Kozakai
