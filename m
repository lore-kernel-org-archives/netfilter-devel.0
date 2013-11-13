From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] json: Refactor of exporting and parsing
 support flags
Date: Thu, 14 Nov 2013 00:46:44 +0100
Message-ID: <20131113234643.GB28009@localhost>
References: <20131111200921.19419.32343.stgit@Ph0enix>
 <20131111200935.19419.8227.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47182 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3KMXqs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:46:48 -0500
Content-Disposition: inline
In-Reply-To: <20131111200935.19419.8227.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 11, 2013 at 09:09:35PM +0100, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Remove the different flag definition for using the snprinf
> and parsing support and create a new flags for joining in
> general flags.
>
> Now for printing or parsing tables or chains, we needed to use:
> 	NFT_TABLE_O_JSON
> 	NFT_TABLE_O_XML
> 	NFT_CHAIN_O_JSON
> 	NFT_CHAIN_O_XML
> 	NFT_CHAIN_PARSE_JSON
> 	NFT_TABLE_PARSE_JSON
> 	NFT_CHAIN_PARSE_XML
>         NFT_TABLE_PARSE_XML
>=20
> Now for exporting and parsing rules and chains, we only use:
> 	NFT_FORMAT_JSON
> 	NFT_FORMAT_XML
> 	NFT_PARSE_FORMAT_JSON
> 	NFT_PARSE_FORMAT_XML

These names are too long. I mangled your patch to use:

NFT_OUTPUT_[XML|JSON]
NFT_PARSE_[XML|JSON]

instead.

I have also reworked the patch descriptions, it says "json: " but this
is not only related to it. Fixed and applied, thanks for working on thi=
s.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
