From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 13:51:34 +0100
Message-ID: <20141218125134.GA17514@salvia>
References: <20141218133524.4d6e2539@turingmachine>
 <20141218134708.3b990466@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Thalheim <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58081 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaLRMtP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:49:15 -0500
Content-Disposition: inline
In-Reply-To: <20141218134708.3b990466@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 18, 2014 at 01:47:08PM +0100, J=F6rg Thalheim wrote:
> I refactor the patch based on your feedback, however:
>  =20
>   $ nft flush ruleset
>=20
> fails with:
>=20
>   <cmdline>:1:1-13: Error: Could not process rule: Address family not=
 supported by protocol=20
>   flush ruleset
>   ^^^^^^^^^^^^^
>=20
>   $ nft --version    =20
>   nftables v0.4 (Support Edward Snowden)
>=20
>   $ uname -a
>   Linux turingmachine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32=
 UTC 2014 x86_64 GNU/Linux

That is supported starting Linux kernel 3.18 as the nftables wiki
indicates.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
