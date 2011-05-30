From: Menyhart Zoltan <Zoltan.Menyhart@Bull.net>
Subject: Re: [netfilter-core] Cannot unload nf_conntrack
Date: Mon, 30 May 2011 17:01:28 +0200
Message-ID: <4DE3B148.9020209@Bull.net>
References: <4DC0310F.3070004@bull.net> <4DDF7152.3030405@netfilter.org> <4DDF8A65.1070900@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter-core@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51244 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1E3P21 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 11:28:27 -0400
In-Reply-To: <4DDF8A65.1070900@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
  
> Please, would you give a try to this patch?
>
> Thanks!

Have you got a patch for the 2.6.32, please, because this section does not apply:

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2e1c11f..9421fe4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -922,6 +922,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
  			ret = -ret;
  			goto out;
  		}
+		/* ICMP[v6] protocol trackers may assign one conntrack. */
+		if (skb->nfct)
+			goto out;
  	}
  
  	ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,

Thanks,

Zoltan
