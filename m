From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Addrtype match extension: limit addrtype check on
 the packet's interface
Date: Thu, 18 Oct 2007 11:16:49 +0200
Message-ID: <47172481.601@trash.net>
References: <470F7EB1.2080309@balabit.hu> <11921980402340-git-send-email-panther@balabit.hu> <11921980402033-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761884AbXJRJRN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:17:13 -0400
In-Reply-To: <11921980402033-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> +static bool match_v1(const struct sk_buff *skb,
>  		  const struct net_device *in, const struct net_device *out,
>  		  const struct xt_match *match, const void *matchinfo,
>  		  int offset, unsigned int protoff, bool *hotdrop)
>  {
>  	const struct ipt_addrtype_info *info = matchinfo;
>  	const struct iphdr *iph = ip_hdr(skb);
> +	const struct net_device *limit_dev = (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) ? in : NULL;


The match can be used on any hook, using the incoming interface
is a bit unflexible. How about using the incoming interface for
src-address and outgoing interface for destination address matches?
Alternatively add two flags to specify which device to use. You'll
need to add proper checks of course to make sure the interface is
valid for the hook the match is used in.
