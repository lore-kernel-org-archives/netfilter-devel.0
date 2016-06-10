From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 libnftnl] Check memory allocations in setters
Date: Fri, 10 Jun 2016 13:15:55 +0200
Message-ID: <20160610111555.GA1194@salvia>
References: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
 <1465554054-16283-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbcFJLQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 07:16:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2C9DE493784
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 13:16:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1A6851B3266
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 13:16:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 479731B326D
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 13:15:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465554054-16283-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 10, 2016 at 12:20:54PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> When you set an object attribute the memory is copied, sometimes an
> allocations is needed and it must be checked. Before this patch all s=
etters
> method return void, so this patch makes all setters return int instea=
d void
> to communicate the error to user.
>=20
> Summary:
> 	* All setters return int instead void
> 	* All memory allocations inside setters are checked
> 	* Unsetters are used if is possible in order to consolidate
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/libnftnl/chain.h   | 16 +++++++-------
>  include/libnftnl/expr.h    | 12 +++++------
>  include/libnftnl/gen.h     |  8 +++----
>  include/libnftnl/rule.h    | 12 +++++------
>  include/libnftnl/ruleset.h |  2 +-
>  include/libnftnl/set.h     | 20 ++++++++---------
>  include/libnftnl/table.h   | 12 +++++------
>  src/chain.c                | 54 +++++++++++++++++++++++++-----------=
----------
>  src/expr.c                 | 36 ++++++++++++++++++-------------
>  src/expr/dynset.c          |  5 ++++-
>  src/expr/immediate.c       |  6 +++---
>  src/expr/log.c             |  7 ++++--
>  src/expr/lookup.c          |  5 ++++-
>  src/gen.c                  | 20 ++++++++++-------
>  src/rule.c                 | 46 ++++++++++++++++++++----------------=
---
>  src/ruleset.c              | 19 ++++++++++------
>  src/set.c                  | 40 ++++++++++++++++++----------------
>  src/set_elem.c             | 33 ++++++++++++++--------------
>  src/table.c                | 28 +++++++++++++-----------
>  19 files changed, 210 insertions(+), 171 deletions(-)
>=20
> diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
> index 954b39f..6419dee 100644
> --- a/include/libnftnl/chain.h
> +++ b/include/libnftnl/chain.h
> @@ -36,14 +36,14 @@ enum nftnl_chain_attr {
> =20
>  bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr);
>  void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr);
> -void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const voi=
d *data);
> -void nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
> -			     const void *data, uint32_t data_len);
> -void nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_=
t data);
> -void nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint3=
2_t data);
> -void nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32=
_t data);
> -void nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint6=
4_t data);
> -void nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const=
 char *str);
> +int nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void=
 *data);
> +int nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
> +			 const void *data, uint32_t data_len);
> +int nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t=
 data);
> +int nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32=
_t data);
> +int nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_=
t data);
> +int nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64=
_t data);

_set_uXX never fail, so leave them using void as this just makes this
more complicated.

Please only update _set_data() and _set_str() as in my original patch
that I handed over to you. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
