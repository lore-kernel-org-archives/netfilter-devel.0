From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 2/3] nft: Generalize nft_rule_list()
 against current family
Date: Wed, 7 Aug 2013 11:00:54 +0200
Message-ID: <20130807090054.GB6935@localhost>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1375864297-9347-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3HGJA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:00:58 -0400
Content-Disposition: inline
In-Reply-To: <1375864297-9347-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 11:31:36AM +0300, Tomasz Bursztyka wrote:
> Now, firewall rule printing is done through nft_family_ops
> .print_firewall function. This moves generic part for ipv4 and ipv6 i=
nto
> nft-shared.c, and enables reusing nft_rule_list() for other family su=
ch
> as ARP which will be useful for arptables compatibility tool.

Applied with one nitpick, thanks Tomasz.

> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index c0ee4c8..ad3e675 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -277,6 +281,59 @@ void parse_meta(struct nft_rule_expr *e, uint8_t=
 key, char *iniface,
>  	}
>  }
> =20
> +const char *nft_parse_target(struct nft_rule *r, const void **targin=
fo,
> +			     size_t *target_len)
> +{
> +	struct nft_rule_expr_iter *iter;
> +	struct nft_rule_expr *expr;
> +	const char *targname;

Need targname =3D NULL, otherwise:

nft-shared.c: In function =E2=80=98nft_parse_target=E2=80=99:
nft-shared.c:289:14: warning: =E2=80=98targname=E2=80=99 may be used un=
initialized in
this function [-Wmaybe-uninitialized
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
