From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 11/13] xtables TPROXY target
Date: Mon, 1 Oct 2007 00:07:53 +0200
Message-ID: <200710010007.53163@nessa>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205335.10969.91031.stgit@nessa.odu> <Pine.LNX.4.64.0709302339290.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:41550 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbXI3WHu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:07:50 -0400
In-Reply-To: <Pine.LNX.4.64.0709302339290.7130@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jan,

On Sunday 30 September 2007, Jan Engelhardt wrote:
> +static unsigned int
> +tproxy_target(struct sk_buff **pskb, const struct net_device *in,
> +              const struct net_device *out, unsigned int hooknum,
> +              const struct xt_target *target, const void *targinfo)
> +{
> +	const struct xt_tproxy_info *tgi = targinfo;
> +	const struct iphdr *iph = ip_hdr(*pskb);
> +	struct sk_buff *skb = *pskb;
> +	struct udphdr _hdr, *hp;
> +
> +	/* TCP/UDP only */
> +	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
> +		return NF_ACCEPT;
> +
> +	hp = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_hdr), &_hdr);
> +	if (hp == NULL)
> +		return NF_DROP;
> +
> +	skb->nf_tproxy.redirect_address = tgi->laddr ? : iph->daddr;
> +	skb->nf_tproxy.redirect_port    = tgi->lport ? : hp->dest;
> +
> +	pr_debug(KERN_DEBUG "redirecting: proto %d %08x:%d -> %08x:%d\n",
> +	         iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
> +	         ntohl(skb->nf_tproxy.redirect_address),
> +	         ntohs(skb->nf_tproxy.redirect_port));
> +
> +	return NF_ACCEPT;
> +}

I guess this is also an old version, the current one does not look like 
this. Are you sure this is really up-to-date?

-- 
 KOVACS Krisztian
