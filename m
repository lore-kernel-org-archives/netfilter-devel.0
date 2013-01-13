From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] rule: Add a function to get rule's family
Date: Sun, 13 Jan 2013 20:08:10 +0100
Message-ID: <20130113190810.GA16399@1984>
References: <1357828145-18588-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44785 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3AMTIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2013 14:08:17 -0500
Content-Disposition: inline
In-Reply-To: <1357828145-18588-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 04:29:05PM +0200, Tomasz Bursztyka wrote:
> diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
> index a944c00..310262a 100644
> --- a/include/libnftables/rule.h
> +++ b/include/libnftables/rule.h
> @@ -28,6 +28,8 @@ void *nft_rule_attr_get(struct nft_rule *r, uint16_t attr);
>  const char *nft_rule_attr_get_str(struct nft_rule *r, uint16_t attr);
>  uint64_t nft_rule_attr_get_u64(struct nft_rule *r, uint16_t attr);
>  
> +uint8_t nft_rule_get_family(struct nft_rule *r);

I have applied this with a little modification, the new interface is
nft_rule_attr_get_u8 so you can retrieve the family via
NFT_RULE_ATTR_FAMILY.
