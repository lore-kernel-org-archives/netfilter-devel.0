From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] nf_conntrack ipv6: unused code and sparse fix
Date: Thu, 24 Jan 2008 19:45:42 +0100
Message-ID: <4798DCD6.6000906@trash.net>
References: <20080124181536.446214111@vyatta.com> <20080124181628.545931850@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49962 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbYAXSpp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:45:45 -0500
In-Reply-To: <20080124181628.545931850@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:

 > +#ifdef notused
 >  int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
 > {
 > 	struct sk_buff *s, *s2;
 > @@ -694,6 +696,7 @@ int nf_ct_frag6_kfree_frags(struct sk_bu
 >
 >  	return 0;
 >  }
 > +#endif

I'm wondering whether this is correct. I'm on the way out the
door though, I'll look into it later. Thanks Stephen.
