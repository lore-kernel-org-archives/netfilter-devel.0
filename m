From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2 4/4] netfilter: bridge: rename br_parse_ip_options and
 delete unneeded code
Date: Tue, 24 Mar 2015 13:14:20 +0100
Message-ID: <20150324121420.GB1685@breakpoint.cc>
References: <20150323124322.GB6203@breakpoint.cc>
 <1427149789-1713-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47228 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbbCXMOX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 08:14:23 -0400
Content-Disposition: inline
In-Reply-To: <1427149789-1713-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> br_parse_ip_options() does not parse any IP options, it validates IP
> packets as a whole and the function name is misleading.
> 
> Rename br_parse_ip_options() and delete unneeded double assignment
> of iph variable.
> 
> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
> ---
> @@ -216,7 +216,6 @@ static int br_parse_ip_options(struct sk_buff *skb)
>  	if (!pskb_may_pull(skb, iph->ihl*4))
>  		goto inhdr_error;
>  
> -	iph = ip_hdr(skb);

pskb_may_pull() might invalidate the network header, we have to refetch
iph because of this.
